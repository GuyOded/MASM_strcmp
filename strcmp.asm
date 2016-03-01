.486
.model flat
option casemap: none

include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
	
	Strcmp PROTO NEAR32 C
TERMINATION equ 00h
.data
string1 db "abc", TERMINATION
string2 db "abcd", TERMINATION
.code
_start:
	call main
	invoke ExitProcess, 0

main proc
	push OFFSET [string2]
	push OFFSET [string1]
	call Strcmp
	add esp, 8
	
	ret
main endp

;----------Strcmp(ref s1:DWORD, ref s2:DWORD) cdecl----------;
;compares the two strings s1 and s2
;eax > 0 if s1 > s2 | eax < 0 is s1 < s2 | eax = 0 if s1 = s2
Strcmp proc NEAR32 C
	push ebp
	mov ebp, esp
	;preserves values of registers
	push esi
	push ebx
	;initialize registers
	mov ebx, [ebp + 8];ebx = offset s1
	mov esi, [ebp + 12];esi = offset s2
	mov ecx, 64h;max length
	xor eax, eax;set eax to 0
	;compare strings char by char
CompareChars:
	mov al, byte ptr [ebx];copy char of s1 to al
	cmp al, byte ptr [esi];compare by subbing
	jne Return
	cmp al, TERMINATION;if null termination (00h) string encountered exit
	je Return
	inc ebx
	inc esi
	loop CompareChars;loop back to the start

Return:
	sub al, byte ptr [esi]
	;convert al to eax: movsx eax, al
	neg al
	neg eax
	;pop preserved registers
	pop ebx
	pop esi
	pop ebp
	
	ret

Strcmp endp
	
END _start