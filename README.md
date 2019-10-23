# Processing BOIDS

created by Austin Poor

Implementation of the [BOIDS flocking simulation](https://en.wikipedia.org/wiki/Boids), originally developed by Craig Reynolds. Also based on the [Coding Train example](https://thecodingtrain.com/CodingChallenges/124-flocking-boids.html).

Using the general boid flock simulation as a base, I adjusted the relative weights and values for settings (like relative weights for separation, alignment, and cohesion, simulation scale, number of boids in the scene, or the boids' sight radius) to create a few different fun simulations. Here are 4 examples…

![Four BOID Simulations](gif_renders/boids_4x4.gif)

And here are two larger scale simulations…

![Two Larger BOID Simulations](gif_renders/boids_2x.gif)

It's really interesting to see how the boids interact on a bit of a larger scale. In the simulation above, on the right, it can be hard to see individual boids (especially in a GIF format) _but_ when a large number of boids cluster together they become more visible and can form cool, unique noise patterns.

