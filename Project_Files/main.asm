INCLUDE Irvine32.inc
.DATA
BoardSize EQU 81
filename BYTE "file.txt",0
FileBufferSize Dword 97
ArrayReadFile byte 97 dup(?)
Board byte 81 dup(?)
counter1 Dword 0
.code
main PROC
	
	call ReadMyFile
	mov esi , OFFSET Board
	mov edx , offset ArrayReadFile
	mov al , [esi+80]
	call WriteChar
	exit
main ENDP

ReadMyFile PROC  
	mov edx, OFFSET filename
	call OpenInputFile 
	mov ecx, FileBufferSize
	mov edx, OFFSET ArrayReadFile
	call ReadFromFile
	mov esi, OFFSET Board
	mov edx, OFFSET ArrayReadFile
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