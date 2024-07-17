---
title: Paint
---
## Project Specification

Goals:
- draw shapes at mouse location
	- only draw when user clicks left mouse button
- rainbow: change the color over time
- randomize the radius

Extra goals:
- mess with it however you want
	- draw different shapes

### Project process

If you feel ready to jump in, go ahead. If you're making progress, keep going. But, when you get stuck (maybe you won't get stuck on this project, but getting stuck is part of any skill), it's helpful to have a process. This is a suggested process.

1. Step away from coding, and start by writing stuff down (on paper, or type it)
2. Write down what you are trying to do
3. Write down what problem you are stuck on
4. If the problem is:
	- Don't know how to code your solution to the problem
		- Then, write down in regular language what you're trying to do.
		- And then try to break it down into simpler language, or into bullet points of a step-by-step process.
	- Don't know the solution to the problem
		- Then, write down or look at your "givens". What tools do you have in general? What variables? What functions? What programming language features?
		- Which of the givens might help with solving the problem?
	- Don't know where to start
		- Then, rewrite the original goals / problem statement in your own words. Break it down, identify which parts you understand and which parts you don't understand.
5. Ask for help

### Useful features and functions

- Documentation: <https://p5js.org/reference/>
- Documentation for JavaScript core features (like if statements): <https://p5js.org/reference/#Foundation>

Curated list:

- [mouseX](https://p5js.org/reference/p5/mouseX/), [mouseY](https://p5js.org/reference/p5/mouseY/) variables -- Store the current x and y position of the mouse cursor
- [circle()](https://p5js.org/reference/p5/circle/) -- Draw a circle
	- Template: `circle(x, y, radius)`
	- Example:
		- `circle(100, 35, 40)` -- draw a circle at (100, 35) with radius 40
		- `circle(middleX, middleY, 40)` -- draw a circle of radius 40, at a position based on the current value of the variables `middleX` and `middleY`.
- [random()](https://p5js.org/reference/p5/random/) -- Function to generate a random value
	- Template: `random(minimum, maximum)`
	- Examples:
		- `random(0, 5)` -- Gives a random decimal number in range \[0, 5) (not including 5).
			- Examples of numbers it can generate: 0, 1, 2, 3, 4, 3.2, 4.99, 0.4
- [fill()](https://p5js.org/reference/p5/fill/) -- Set the current color
	- Exact behavior depends on the current [colorMode()](https://p5js.org/reference/p5/colorMode/). For this project we are using HSB color mode, so I'll use that in the examples.
	- Templates:
		- `fill(hue, saturation, brightness)`
			- Saturation and brightness range from 0 to 100, they are percentages.
		- `fill(colorname)`
	- Can be confusing that doesn't always take the same number of arguments.
	- Examples:
		- `fill('blue')` -- If you're using a specific color or color name, make sure it is in quotation marks.
		- `fill(60, 100, 100)` -- hue 60, maximum saturation and brightness
- Defining new variables:
	- Docs: <https://p5js.org/reference/p5/let/>
	- Template: `let <variable name> = <initial value>`
	- Example: `let radius = 50`
- Variable assignment (changing the value of a variable):
	- Template: `<variable name> = <new value>`
	- Examples:
		- `radius = 1`
		- `radius = radius + 5`
		- `radius = 5 + radius`
- If-else conditional statements
	- Docs: <https://p5js.org/reference/p5/if-else/>