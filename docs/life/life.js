/*
MIT License

Copyright (c) 2021 Jeffrey Fisher

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/*
  This program is written using the p5.js library <https://p5js.org>. p5.js is
  available under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation, version 2.1.
*/

/*
  Implementation of Conway's Game of Life.

  Limitations:
  - There are "walls", the grid size is finite with no wrap-around.
*/

rows = 50;
columns = 50;

cell_w = 15;
WIDTH = cell_w * columns;
HEIGHT = cell_w * rows;

running = false;

board = Array(rows).fill(false).map(x => Array(columns).fill(false));

function countNeighbors(x, y) {
  let count = 0;
  let a = x - 1;
  let b = y - 1;
  //top
  for (; a <= x + 1; a++) {
    if ((b >= 0 && a >= 0) && board[b][a] === true) {
      count++;
    }
  }
  //sides
  if (board[y][x - 1] === true) count++;
  if (board[y][x + 1] === true) count++;
  //bottom
  a = x - 1;
  b = y + 1;
  for (; a <= x + 1; a++) {
    if ((b < board.length && a < board[0].length) && board[b][a] === true) {
      count++;
    }
  }
  return count;
}

function copyBoard(board) {
  let copy = [];
  for (let r = 0; r < board.length; r++) {
    copy[r] = [];
    for (let c = 0; c < board[0].length; c++) {
      copy[r][c] = board[r][c];
    }
  }
  return copy;
}

function step() {
  let newBoard = copyBoard(board);
  for (let y = 0; y < rows; y++) {
    for (let x = 0; x < columns; x++) {
      let cell = board[y][x];
      let count = countNeighbors(x, y);
      if (cell === false && count === 3) { //reproduction
        newBoard[y][x] = true;
      }
      if (cell === true) {
        if (count === 2 || count === 3) { //survives
          newBoard[y][x] = true;
        } else { //dies by under- or over-population
          newBoard[y][x] = false;
        }
      }
    }
  }
  board = newBoard;
}

function run() {
  if (running) {
    step();
    draw();
  }
  //note: relying on parseFloat's behavior of stopping when it encounters a non-digit because I appended " seconds" to the span element
  setTimeout(run, parseFloat(span.elt.innerHTML) * 1000);
}

function setup() {
  createCanvas(WIDTH, HEIGHT);
  btnStart = createButton("Start").parent("buttonContainer");
  btnStart.mousePressed(() => {running = true;});
  // btnStart.elt.style.backgroundColor = "green";
  btnStop = createButton("Stop").parent("buttonContainer");
  btnStop.mousePressed(() => {running = false;});
  btnStep = createButton("Step").parent("buttonContainer");
  btnStep.mousePressed(() => {step();draw();});
  slider = createSlider(0.01, 1.0, 0.1, 0.01).parent("buttonContainer");
  span = createSpan(slider.value() + " seconds").parent("buttonContainer");
  noLoop();
  run(); //infinite recursive loop
}

function draw() {
  strokeWeight(1);
  fill(255);
  for (let y = 0; y < rows; y++) {
    for (let x = 0; x < columns; x++) {
      if (board[y][x] === true) {
        fill(x / columns * 255, 0, y / rows * 255);
      } else {
        fill(255);
      }
      square(x * cell_w, y * cell_w, cell_w);
    }
  }
}

function mousePressed(event) {
  span.elt.innerHTML = slider.value() + " seconds";
  if (mouseX > WIDTH || mouseY > HEIGHT || running) {
    return;
  }
  //convert mouse position to board position
  let r = Math.floor(mouseY / 15);
  let c = Math.floor(mouseX / 15);
  board[r][c] = !board[r][c];
  draw();
}

function mouseDragged(event) {
  span.elt.innerHTML = slider.value() + " seconds";
  if (mouseX > WIDTH || mouseY > HEIGHT || running) {
    return;
  }
  //convert mouse position to board position
  let r = Math.floor(mouseY / 15);
  let c = Math.floor(mouseX / 15);
  board[r][c] = true;
  draw();
}
