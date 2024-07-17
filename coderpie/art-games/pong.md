---
title: Pong
---

![](pong.png)

We will be making a version of the classic game "Pong".

## 1. Animation

Animation fundamentals tutorial: <https://happycoding.io/tutorials/p5js/animation>

> Note: Middle click (click with the scroll wheel on the mouse) or right click and then select "Open in new tab" can be used to open links without losing this page.

1. Open up the `p5.js` code editor (<https://editor.p5js.org/>).
2. Log in, if you are not already
	- If you need to log in, click "Log In" in the top right corner.
	- On the next page, click the log in with **Google** button
1. Rename your project to "animation (\<YOUR NAME HERE\>)"
2. Save your project (File > Save, or Control+s).
	- Make sure to save every few minutes or so, so that your code doesn't get lost.

Now read and work through the animation tutorial. Raise your hand / get my attention if you have a question or want help.

### Exercises
See the "Homework" section at the bottom of the animation tutorial.

1. Complete the gravity exercise

### (optional) Cool things to try
- Leave an after-image trail of the ball: change the background call to be: `background(32, 20)`
	- The first argument (32) is the color, the second argument (20) is the transparency value, which ranges from 0 to 255.
	- Each repaint of the background covers up a little bit more of the old frames.
	- `background(32, 255)` has the same behavior as `background(32)`

## 2. Pong

TODO (for Jeffrey):
- [ ] Starter code
	- [ ] Include function for detecting collision between rectangle and circle

### Exercises

- Draw a line down the middle of the screen, to visually divide the sides.
	- Use the `p5.js` [line()](https://p5js.org/reference/p5/line/) function.
	- Hint: While you can always look at the size of the canvas in `createCanvas()` and calculate the middle by hand, the variables `height` and `width` contain the canvas dimensions, so you can use those to calculate the middle regardless of how big the canvas is.
	- Hint: Division can be done with `/` (forward slash). Example: `10 / 5` means "10 divided by 5".
- Add a second paddle and score count to make it a two-player game.