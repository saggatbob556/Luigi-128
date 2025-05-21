;init
JMP INIT_TMS9918
WRITE_VDP_REG:	   
MOV B,A
ORI 80h
ADD C
OUT 99h
MOV A,B
OUT 98h
RET

INIT_TMS9918:
MVI A, 80h
MVI C, 00h
CALL WRITE_VDP_REG

MVI A, 42h
MVI C, 01h
CALL WRITE_VDP_REG

MVI A, 20h
MVI C, 03h
CALL WRITE_VDP_REG

MVI A, 36h
MVI C, 06h
CALL WRITE_VDP_REG

MVI A, 00h
MVI C, 07h
CALL WRITE_VDP_REG

LXI H, 22h; random setup stuff for testing
SHLD 4000h
LXI H, 35h
SHLD 4001h
LXI H, 55h
SHLD 4002h
LXI H, 4000h
SHLD 0000h
JMP loop

getChar:
LHLD 00h; current place in keyboard buffer
XCHG; exchange d&e pair with h&l pair
MVI B, 00h

;ffffh (add into the ROM to select peripheral memory)

LDAX D; load the content of the keyboard buffer specified by the d&e register pair
CMP B; checks if there something in the buffer
JC movChar ;if there is a character in the keyboard buffer
JMP loop

movChar:
STA 0001h; where the current key press is stored (for now until the VDP code is ready)
MVI A, 0000h; clears accumulator
STAX D; clears the specific place in the keyboard buffer
XCHG
INX H; increments for next keyboard buffer location
SHLD 0000h; stores it back in the memory location
MVI B, 00h

;ffffh (add into the ROM to select peripheral memory)

XCHG
LDAX D; load the content of the keyboard buffer specified by the d&e register pair
CMP B; checks if there something in the buffer
JZ reset; resets the current keyboard buffer location
JMP onScreen; goes back to main loop

reset: ; resets the memory location that stores the current memory location of the keyboard buffer
LXI H, 4000h
SHLD 0000h
JMP loop

onScreen:
LXI H, 0000h
LXI D, 0000h
LXI B, 0000h
MVI A, 0000h

MVI A, 00h
OUT 99h
MVI A, 18h
ORI 40h
OUT 99h

LDA 0001h
CPI 00h
OUT 98h
MVI A, 0000h
STA 0001h
JMP loop

loop:
LXI H, 0000h
LXI D, 0000h
LXI B, 0000h
MVI A, 0000h
JMP getChar
