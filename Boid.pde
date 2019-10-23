class Boid {
  PVector pos, vel, accel;
  float d = 5; // Radius of the boid
  float sight_radius = 10; // Radius for boids to be affected by other boids
  float max_force = 1; // Max force that can be applied by sep/align/coh
  float max_speed = 4; // Max speed for the boid
  float accel_delta = 0.85; // Extra scalar to modify the boid acceleration
  
  // Relative weights for the boid separation,
  // alignment, and cohesion
  float sep_mult = 1;
  float align_mult = 1;
  float coh_mult = 0;

  Boid(float x, float y) {
    pos = new PVector(x, y);
    vel = PVector.fromAngle(random(2 * PI));
    accel = new PVector(0, 0);
  }

  void show() {
    // Settings for how the boids look:
    // FILL vs STROKE
    // Just outline…
    noFill();
    stroke(255);
    strokeWeight(1);
    // Just fill…
    //noStroke();
    //fill(255);
    
    // SHAPE
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

    // Update velocity, position, then reset acceleration
    vel.add(accel);
     //vel.setMag(max_speed); // Always move at max speed?
    vel.limit(max_speed);   // Clamp velocity to max speed
    pos.add(vel);
    accel.mult(0);

    // If the boid goes off-screen, wrap
    // around to the other side
    if (pos.x < 0) pos.x = width;
    else if (pos.x >= width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    else if (pos.y >= height) pos.y = 0;
  }

  PVector sep(Boid[] flock) {
    // Calculate the separation
    // Avoid crowding local flockmates
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
    // Calculate the alignment
    // Steer towards the average
    // direction of local flockmates
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
    // Calculate the cohesion
    // Steer towards the average
    // position of local flockmates
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
