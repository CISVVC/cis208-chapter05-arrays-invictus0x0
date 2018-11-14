; file: asm_main.asm
;Write an assembly language function that will do the following:
 
;1.   provide a function that will take 3 parameters:
;The base address of a word (16 bit) array
;The length of the array
;An integer -- a scalar
;The function will iterate over the array and will multiply the scalar by each element in the array.  Each element of the array will then be changed to the scalar multiple.  This is an example
;a1:  dw  1,2,3,4,5
;This looks like:
;a1[0]   a1[1]   a1[2]   a1[3]   a1[4]
;1           2        3        4         5
; 
;if the function is called with the above array and a scalar of 5 then the result would be:
;a1[0]   a1[1]   a1[2]     a1[3]       a1[4]
;5           10        15        20        2 5

%include "asm_io.inc"

%define array_size DWORD 5
%define scalar 5

segment .data

array1: dw 1,2,3,4,5,6,7,8,9,10

        syswrite: equ 4
        stdout: equ 1
        exit: equ 1
        SUCCESS: equ 0
        kernelcall: equ 80h

; uninitialized data is put in the .bss segment
segment .bss

; code is put in the .text segment
segment .text
        global  asm_main

asm_main:

        enter   0,0               ; setup routine
        pusha

	mov	eax,array1
        push 	array_size
        push 	eax
        call 	print_array
        add 	esp,8
        call 	print_nl

        push 	scalar 
        push 	array_size
        push 	eax
        call 	scalar_mult
        add 	esp, 12

        push 	array_size
        push 	eax
        call 	print_array
        add 	esp,8
        call	print_nl

        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret

scalar_mult:

        enter   0,0
        pusha

	XOR 	ecx, ecx
	XOR 	eax, eax
	mov 	ebx, DWORD[ebp+8]
for:
    	cmp 	ecx, DWORD[ebp+12]
    	jge 	done
    	mov 	ax, word[ebx + 2 * ecx]
    	mul 	word[ebp+16]
    	mov 	word[ebx+2 *ecx], ax
    	inc 	ecx
    	jmp 	short for
done:
	popa
	leave
	ret ;Returning back
	
        popa
	leave
	ret

print_array:

	enter 	0,0
	pusha
	mov 	ecx, DWORD[ebp+12]
	XOR 	eax, eax
	mov 	ebx, [ebp+8]
	mov 	edx, 0
for_b:
	mov 	ax, WORD[ebx + 2 * edx]
	movzx 	eax, ax
	push 	eax
	call 	print_int
	add 	esp, 4
	inc 	edx
	loop 	for_b
	popa

	leave
	ret ;Returning back
