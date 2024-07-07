; File: main.asm
;
; This file contains the main game loop and system calls for a Tic Tac Toe game.
; It includes procedures for initializing the game, getting player input, updating the board, checking for a winner, and switching players.
;
; Procedures:
; - _start: The entry point of the program. Initializes the game and starts the main game loop.
; - main_loop: The main game loop. Gets player input, updates the board, checks for a winner, and switches players.
; - exit_game: Prints the winner and exits the program.
; - draw: Prints a draw message and jumps to end_game.
; - player1_wins: Prints a player 1 wins message and jumps to end_game.
; - player2_wins: Prints a player 2 wins message.
; - end_game: Exits the program.
;
; External Procedures:
; - init_board: Initializes the game board.
; - print_board: Prints the current state of the game board.
; - get_player_input: Gets the player's input.
; - update_board: Updates the game board with the player's move.
; - switch_player: Switches to the other player.
; - check_winner: Checks if there is a winner.
;
; Data:
; - player1: The symbol for player 1.
; - player2: The symbol for player 2.
; - current_player: The symbol for the current player.
; - newline: A newline character for output.
; - prompt: The input prompt.
; - draw_message: The message to print when the game is a draw.
; - player1_wins_message: The message to print when player 1 wins.
; - player2_wins_message: The message to print when player 2 wins.
;
; BSS:
; - board: The game board, represented as a 3x3 array.
; - input_buffer: Buffer for storing the player's input.


section .data
    player1 db 'X'               ; Player 1 symbol
    player2 db 'O'               ; Player 2 symbol
    current_player db 'X'        ; Current player symbol
    newline db 10                ; Newline character for output
    prompt db 'Enter row (0-2) and column (0-2): ', 0 ; Input prompt
    draw_message db 'The game is a draw.', 0
    draw_message_len equ $ - draw_message
    player1_wins_message db 'Player 1 (X) wins!', 0
    player1_wins_message_len equ $ - player1_wins_message
    player2_wins_message db 'Player 2 (O) wins!', 0
    player2_wins_message_len equ $ - player2_wins_message

section .bss
    global board
    board resb 9                 ; 3x3 game board
    input_buffer resb 2          ; Buffer to store player input

section .text
    global player1, player2, current_player, newline, prompt, input_buffer
    extern init_board, print_board, get_player_input, update_board, switch_player, check_winner
    global _start

_start:
    ; Initialize the game board
    call init_board

    ; Print the initial game board
    call print_board

main_loop:
    ; Get the player input
    call get_player_input

    ; Update the game board with player input
    call update_board

    ; Print the updated game board
    call print_board

    ; Check if there is a winner
    call check_winner
    cmp eax, 1
    je exit_game

    ; Switch to the other player
    call switch_player

    ; Repeat the game loop
    jmp main_loop

exit_game:
    ; Print the winner
    mov eax, 4                   ; sys_write system call
    mov ebx, 1                   ; File descriptor 1 is stdout
    cmp byte [current_player], 'D' ; Check if the game is a draw
    je draw
    cmp byte [current_player], 'X' ; Check if player 1 is the winner
    je player1_wins
    jmp player2_wins             ; If not, player 2 is the winner

draw:
    mov ecx, draw_message        ; Message to print
    mov edx, draw_message_len    ; Length of the message
    int 0x80                     ; Call the kernel
    jmp end_game                 ; Jump to end_game

player1_wins:
    mov ecx, player1_wins_message ; Message to print
    mov edx, player1_wins_message_len ; Length of the message
    int 0x80                     ; Call the kernel
    jmp end_game                 ; Jump to end_game

player2_wins:
    mov ecx, player2_wins_message ; Message to print
    mov edx, player2_wins_message_len ; Length of the message
    int 0x80                     ; Call the kernel

end_game:
    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80