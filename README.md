# Assembly Tic Tac Toe

This is a simple implementation of the classic game Tic Tac Toe, written in assembly language.

## How to Run

To assemble and run the game, use the following commands on the linux operating system:

```bash
make
./build/tic_tac_toe
```

## Game Rules

The game is played on a 3x3 grid. Players take turns marking a cell of the grid with their symbol (X or O). The first player to get three of their symbols in a row (horizontally, vertically, or diagonally) is the winner. If all cells are filled and there's no winner, the game is a draw.

A player must enter their target square using row (0-2) and column (0-2) indicies. Eg, "12" is row 1 column 2. 

## License

This project is licensed under the MIT License.

