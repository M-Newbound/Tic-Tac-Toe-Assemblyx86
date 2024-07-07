; File: board.asm
;
; This file contains the assembly code for managing the game board in a Tic Tac Toe game.
; It includes procedures for initializing the board, printing the board, and updating the board with the player's move.
;
; Procedures:
; - init_board: Initializes the game board with empty spaces.
; - print_board: Prints the current state of the game board to the console.
; - update_board: Updates the game board with the current player's move.
;
; External Variables:
; - newline: A newline character for formatting the board output.
; - input_buffer: Buffer for storing the player's input.
; - current_player: The symbol of the current player (X or O).
; - board: The game board, represented as a 3x3 array.
;
; Date: 2024


extern newline
extern input_buffer
extern current_player
extern board


section .text
    global init_board, print_board, update_board

; Initialize the game board with empty spaces
init_board:
    mov ecx, 9                  ; Number of cells
    mov edi, board              ; Destination address
    mov al, ' '                 ; Empty space character
    rep stosb                   ; Fill the board with empty spaces
    ret

; Print the game board to the console
print_board:
    mov ecx, 3                  ; Number of rows
    mov edi, board              ; Base address of the board

print_row:
    push ecx                    ; Save row counter
    mov ecx, 3                  ; Number of columns

print_cell:
    mov eax, 4                  ; Syscall number (sys_write)
    mov ebx, 1                  ; File descriptor (stdout)
    mov edx, 1                  ; Number of bytes to write
    lea esi, [edi]              ; Calculate address of the cell
    push ecx                    ; Save column counter
    mov ecx, esi                ; Move pointer to ECX
    int 0x80                    ; Invoke syscall
    pop ecx                     ; Restore column counter
    add edi, 1                  ; Move to the next cell
    loop print_cell             ; Loop through columns

    ; Print newline character
    mov eax, 4                  ; Syscall number (sys_write)
    mov ebx, 1                  ; File descriptor (stdout)
    lea ecx, [newline]          ; Pointer to newline character
    mov edx, 1                  ; Number of bytes to write
    int 0x80                    ; Invoke syscall

    pop ecx                     ; Restore row counter
    test ecx, ecx               ; Test if ecx is zero
    jz end_print                ; If ecx is zero, jump to end_print
    loop print_row              ; Loop through rows

end_print:
    ret

; Update the game board with the current player's move
update_board:
    movzx eax, byte [input_buffer]  ; Get row input
    sub eax, '0'                   ; Convert ASCII to integer
    mov ebx, eax                   ; Store row in ebx
    movzx eax, byte [input_buffer + 1] ; Get column input
    sub eax, '0'                   ; Convert ASCII to integer
    imul ebx, 3                    ; Multiply row by 3 (number of columns)
    add ebx, eax                   ; Add column to get cell index
    mov al, [current_player]       ; Get current player symbol
    mov [board + ebx], al          ; Update the board cell
    ret
