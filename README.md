# musical-life
Simple implementation of Conway's Game of Life in Ruby which generates text output and various Sonic Pi loops that run based on that output.

## text-conway
This script is the foundation of this project. It uses a cell class and a board class to play Conway's Game of Life in terminal, no GUI or extra windows needed. The board takes two parameters, size and character. The character input determines what a cell will display when it is living. Dead cells will always display `.`. Size determines how many rows and columns the board will have. Initiating a new board will automatically populate the board with cells, however neighbors will need to be set seperately by calling `setCellNeighbors`. The board class includes built in glider and r-pentomino patterns. Patterns other than those two can be drawn manually using `setCellState`. Rows and columns are both zero-indexed, with the top left corner of the board being `rows[0][0]`. 

The function `interactiveSetup` will set up the board and run a given number of iterations, but the file also includes an example manual setup. Only `silentConway` will return a copy of the board that can be exported as a`.txt` file useful for other files in this project. To use `silentConway` during `interactiveSetup`, respond "final" when asked how you want the game displayed. The function `noisyConway` will print each iteration of the board, which is useful for identifying interesting iterations to use in other parts of this file.

## electro-organ-loops
Although this file has a `.rb` extension, it must be run in [Sonic Pi](https://sonic-pi.net/). You will also need to insert the correct path to the board you want to use, which must be a `.txt` file.

The loop `:orgB` provides a continuous loop of bass chords. It isn't dependent on the file input. The loop `:orgT` runs through each cell in the board and calls `notechoice` on it before looping back to the begining of the board. The function `notechoice` takes a single character as an input and plays either a note or a chord. If the cell passed to `notechoice` is dead, it will randomly select from an array of notes. If the cell is alive, it will play that array as a chord. The notes in `orgB` and `notechoice`, as well as the synths and bpm, can be tweaked easily to create very different sounding pieces of music. 

## life-chords
Although this file has a `.rb` extension, it must be run in [Sonic Pi](https://sonic-pi.net/). You will also need to insert the correct path to the board you want to use, which must be a `.txt` file.

This file will "play" an iteration of `text-conway` row-by-row from top to bottom. As the chosen board is read in, a hash of columns and corresponding notes is also constructed. As the board is traversed, each row's live cells are noted and the corresponding notes are played in a chord before the next row is checked. Because of note spacing, boards larger than 20x20 shouldn't be used.
