boolean save_frames = false;
int start_frame = 0; // Start at frame 0
int end_frame = 24*30; // Stop after 30 seconds @ 24fps
String filename = "boid_save6/#####.png"; // #s will be replaced w/ frame num

int flock_size = 500; // How many boids to have in the scene
Boid[] flock;

void setup() {
  size(500, 500);
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
  if (save_frames && (frameCount >= start_frame && frameCount <= end_frame)) {
    saveFrame(filename);
  }
}
