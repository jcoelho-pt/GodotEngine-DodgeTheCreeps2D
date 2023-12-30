## Organizing the project
In this project, we will make 3 independent scenes: `Player`, `Mob`, and `HUD`, which we will combine into the game's Main scene.

## Creating the Player Scene
As a general rule, a scene's root node should reflect the object's desired functionality - what the object is. 

With Area2D node we can detect objects that overlap or run into the player.

The AnimatedSprite2D will handle the appearance and animations for our player. Notice that there is a warning symbol next to the node. 
An AnimatedSprite2D requires a SpriteFrames resource, which is a list of the animations it can display.

Then we define two Animations: "up" and "walk" and add two images for each one 

Finally, add a CollisionShape2D as a child of Player. This will determine the player's "hitbox", or the bounds of its collision area. 
For this character, a CapsuleShape2D node gives the best fit, so next to "Shape" in the Inspector, click "[empty]" -> "New CapsuleShape2D".
