; File: player.asm
;
; This file contains the assembly code for managing player interactions in a Tic Tac Toe game.
; It includes procedures for getting player input, switching players, and checking for a winner.
;
; Procedures:
; - get_player_input: Gets input from the current player.
; - switch_player: Switches to the other player.
; - check_winner: Checks if there is a winner.
;
; External Variables:
; - input_buffer: Buffer for storing the player's input.
; - current_player: The symbol of the current player (X or O).
; - board: The game board, represented as a 3x3 array.
;
; Data:
; - prompt: The input prompt.
; - newline: A newline character for output.


extern input_buffer
extern current_player
extern board

section .data
    prompt db 'Enter row (0-2) and column (0-2): ', 0 ; Input prompt
    newline db 10                ; Newline character for output

section .text
    global get_player_input, switch_player, check_winner

; Get input from the current player
get_player_input:
    mov eax, 4                  ; Syscall number (sys_write)
    mov ebx, 1                  ; File descriptor (stdout)
    lea ecx, prompt             ; Pointer to input prompt
    mov edx, 32                 ; Number of bytes to write
    int 0x80                    ; Invoke syscall

get_input_loop:
    mov eax, 3                  ; Syscall number (sys_read)
    mov ebx, 0                  ; File descriptor (stdin)
    lea ecx, input_buffer       ; Pointer to input buffer
    mov edx, 2                  ; Number of bytes to read
    int 0x80                    ; Invoke syscall

    ; Check if the input is valid
    movzx eax, byte [input_buffer]      ; Get row input
    sub eax, '0'                       ; Convert ASCII to integer
    cmp eax, 2                         ; Check if row is in range 0-2
    ja get_input_loop                  ; If not, get input again

    movzx eax, byte [input_buffer + 1]  ; Get column input
    sub eax, '0'                       ; Convert ASCII to integer
    cmp eax, 2                         ; Check if column is in range 0-2
    ja get_input_loop                  ; If not, get input again

    ret

; Switch to the other player
switch_player:
    mov al, [current_player]    ; Get current player symbol
    cmp al, 'X'                 ; Check if current player is 'X'
    je set_o                    ; If yes, set to 'O'
    mov byte [current_player], 'X'   ; Otherwise, set to 'X'
    ret
set_o:
    mov byte [current_player], 'O'   ; Set current player to 'O'
    ret

; Check if there is a winner
check_winner:
    ; Check rows
    mov ecx, 3                  ; Number of rows
    mov edi, board              ; Base address of the board

check_row:
    mov al, [edi]               ; Get the first cell of the row
    cmp al, ' '                 ; Check if the cell is empty
    je next_row                 ; If the cell is empty, go to the next row
    cmp al, [edi + 1]           ; Compare the first cell with the second cell
    jne next_row                ; If they are not the same, go to the next row
    cmp al, [edi + 2]           ; Compare the first cell with the third cell
    jne next_row                ; If they are not the same, go to the next row
    mov [current_player], al    ; Set the current player to the winning player
    mov eax, 1                  ; Set return value to 1
    ret                         ; Return

next_row:
    add edi, 3                  ; Move to the next row
    loop check_row              ; Loop through rows

    ; Check columns
    mov ecx, 3                  ; Number of columns
    mov edi, board              ; Base address of the board

check_column:
    mov al, [edi]               ; Get the first cell of the column
    cmp al, ' '                 ; Check if the cell is empty
    je next_column              ; If the cell is empty, go to the next column
    cmp al, [edi + 3]           ; Compare the first cell with the second cell
    jne next_column             ; If they are not the same, go to the next column
    cmp al, [edi + 6]           ; Compare the first cell with the third cell
    jne next_column             ; If they are not the same, go to the next column
    mov [current_player], al    ; Set the current player to the winning player
    mov eax, 1                  ; Set return value to 1
    ret                         ; Return

next_column:
    add edi, 1                  ; Move to the next column
    loop check_column           ; Loop through columns

    ; Check diagonals
    mov al, [board]             ; Get the first cell of the first diagonal
    cmp al, ' '                 ; Check if the cell is empty
    jne check_first_diagonal    ; If the cell is not empty, check the first diagonal
    mov al, [board + 2]         ; Get the first cell of the second diagonal
    cmp al, ' '                 ; Check if the cell is empty
    jne check_second_diagonal   ; If the cell is not empty, check the second diagonal
    jmp check_draw              ; If both cells are empty, check for a draw

check_first_diagonal:
    cmp al, [board + 4]         ; Compare the first cell with the second cell
    jne check_second_diagonal   ; If they are not the same, check the second diagonal
    cmp al, [board + 8]         ; Compare the first cell with the third cell
    jne check_second_diagonal   ; If they are not the same, check the second diagonal
    mov [current_player], al    ; Set the current player to the winning player
    mov eax, 1                  ; Set return value to 1
    ret                         ; Return

check_second_diagonal:
    cmp al, [board + 4]         ; Compare the first cell with the second cell
    jne check_draw              ; If they are not the same, check for a draw
    cmp al, [board + 6]         ; Compare the first cell with the third cell
    jne check_draw              ; If they are not the same, check for a draw
    mov [current_player], al    ; Set the current player to the winning player
    mov eax, 1                  ; Set return value to 1
    ret                         ; Return

check_draw:
    mov ecx, 9                  ; Number of cells
    mov edi, board              ; Base address of the board

check_cell:
    mov al, [edi]               ; Get the cell
    cmp al, ' '                 ; Check if the cell is empty
    je end_check                ; If the cell is empty, end the check
    add edi, 1                  ; Move to the next cell
    loop check_cell             ; Loop through cells

    ; If all cells are filled and there's no winner, it's a draw
    mov al, 'D'                 ; Symbol for draw
    mov [current_player], al    ; Set the current player to 'D'
    mov eax, 1                  ; Set return value to 1
    ret                         ; Return

end_check:
    mov eax, 0                  ; Set return value to 0
    ret                         ; Return