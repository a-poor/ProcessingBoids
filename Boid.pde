class Boid {
  PVector pos, vel, accel;
  float d = 5;
  float sight_radius = 10;
  float max_force = 1;
  float max_speed = 4;
  float accel_delta = 0.85;
  
  float sep_mult = 1;
  float align_mult = 1;
  float coh_mult = 0;

  Boid(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.fromAngle(random(2 * PI));
    accel = new PVector(0, 0);
  }

  void show() {
    // Just outline…
    noFill();
    stroke(255);
    strokeWeight(1);
    // Just fill…
    //noStroke();
    //fill(255);
    //Draw as triangle…
    push();
    translate(pos.x, pos.y);
    rotate(vel.heading() + HALF_PI);
    triangle(
      0, -d/2, 
      -d/2+1, d/2, 
      d/2-1, d/2
      );
    pop();
    
    //Draw as point…
    //noFill();
    //stroke(255);
    //point(pos.x, pos.y);
  }

  void update(Boid[] flock) {
    // Get the 3 values
    PVector separation = sep(flock);
    PVector alignment = ali(flock);
    PVector cohesion = coh(flock);

    // Multiply them by their scaling factor
    separation.mult(sep_mult);
    alignment.mult(align_mult);
    cohesion.mult(coh_mult);

    // Add them to the accelleration
    accel.add(separation);
    accel.add(alignment);
    accel.add(cohesion);
    
    accel.mult(accel_delta);

    // Update velocity, position, clear acceleration
    vel.add(accel);
    //vel.setMag(max_speed);
    pos.add(vel);
    accel.mult(0);

    if (pos.x < 0) pos.x = width;
    else if (pos.x >= width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    else if (pos.y >= height) pos.y = 0;
  }

  PVector sep(Boid[] flock) {
    PVector movement = new PVector(0, 0);
    int n = 0;
    for (int i = 0; i < flock.length; i++) {
      float dist = pos.dist(flock[i].pos);
      if (flock[i] != this && dist <= sight_radius) {
        PVector diff = PVector.sub(pos, flock[i].pos);
        diff.div(dist*dist);
        movement.add(diff);
        n++;
      }
    }
    if (n > 0) {
      movement.div(n);
      movement.setMag(max_speed);
      movement.sub(vel);
      movement.limit(max_force);
    }
    return movement;
  }

  PVector ali(Boid[] flock) {
    PVector avg_vel = new PVector(0, 0);
    int n = 0;
    for (int i = 0; i < flock.length; i++) {
      float dist = pos.dist(flock[i].pos);
      if (flock[i] != this && dist <= sight_radius) {
        avg_vel.add(flock[i].vel);
        n++;
      }
    }
    if (n > 0) {
      avg_vel.div(n);
      avg_vel.setMag(max_speed);
      avg_vel.sub(vel);
      avg_vel.limit(max_force);
    }
    return avg_vel;
  }

  PVector coh(Boid[] flock) {
    PVector avg_pos = new PVector(0, 0);
    int n = 0;
    for (int i = 0; i < flock.length; i++) {
      float dist = pos.dist(flock[i].pos);
      if (flock[i] != this && dist <= sight_radius) {
        avg_pos.add(flock[i].pos);
        n++;
      }
    }
    if (n > 0) {
      avg_pos.div(n);
      avg_pos.setMag(max_speed);
      avg_pos.sub(vel);
      avg_pos.limit(max_force);
    }
    return avg_pos;
  }
}
