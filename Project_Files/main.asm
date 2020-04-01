INCLUDE Irvine32.inc
.DATA
BoardSize EQU 81
filename BYTE "file.txt",0
FileBufferSize EQU 97
ArrayReadFile byte 97 dup(?)
Board byte 81 dup(?)
counter1 Dword 0
.code
main PROC
	mov edx, OFFSET filename
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board
	call ReadMyFile
	mov esi , OFFSET Board
	mov edx , OFFSET ArrayReadFile
	mov al , [esi+80]
	call WriteChar
	exit
main ENDP

ReadMyFile PROC  USES eax ebx ecx edx esi
	
	call OpenInputFile 
	mov ecx, FileBufferSize
	mov edx, ebx
	call ReadFromFile
	mov edx, ebx
	mov ecx , FileBufferSize
	CopyArray:
		inc counter1
		mov eax, counter1
		cmp eax , 9
		je IsNull
			mov eax, [edx]
			mov [esi] , eax
			inc esi
			inc edx
			Jmp cont
		IsNull:
			mov eax, [edx]
			mov [esi] , eax
			mov eax ,0
			mov counter1 , eax
			add edx,3
			inc esi
		cont:
	loop CopyArray
	ret
ReadMyFile ENDP

END main