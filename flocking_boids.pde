int flock_size = 1000;
Boid[] flock;

void setup() {
  size(960, 960);
  frameRate(24);
  flock = new Boid[flock_size];
  for (int i = 0; i < flock.length; i++) {
    flock[i] = new Boid(random(width), random(height));
  }
}
void draw() {
  background(0);
  for (int i = 0; i < flock.length; i++) {
    flock[i].update(flock);
    flock[i].show();
  }
  if (frameCount < 24*30) {
    //saveFrame("boid_save6/#####.png");
  }
}
