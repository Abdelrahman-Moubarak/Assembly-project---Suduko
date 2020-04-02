INCLUDE Irvine32.inc
.DATA
BoardSize EQU 81
filename BYTE "file.txt",0
filenameofunsolved BYTE "fileUnsolved.txt",0
FileBufferSize EQU 97
ArrayReadFile byte 97 dup(?)
Board byte 81 dup(?)
BoardUser byte 81 dup(?)
counter1 Dword 0
CellRow dword ?
CellCol dword ?
CellIndexFinal dword ?
wrongrowcol byte "Out Of Range Index!",0
Answer byte ?
Answerdword dword ?
.code
main PROC
	mov edx, OFFSET filename
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board
	call ReadMyFile
	call InputUnsolvedBoard
	mov esi , OFFSET Board
	mov edx , OFFSET ArrayReadFile
	mov al , [esi+71] ; helloo

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

InputUnsolvedBoard proc uses edx ebx esi
	mov edx, OFFSET filenameofUnsolved
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET BoardUser
InputUnsolvedBoard ENDP

;------------------CheckIfEqual proc
InputAndCheck Proc uses esi ebx edx
	
	call InputRowCol
	call CalcIndex
	cmp CellIndexFinal, 80
	
	ja OutOfRange
	
	jmp InRange

	OutOfRange:
	mov edx, offset wrongrowcol
	call writestring
	call InputAndCheck

	InRange:
	mov esi, CellIndexFinal
	cmp boardUser[esi], 0
	
	je ifUnknown
	
	jmp endoffn
	ifUnknown:
	call InputAns
	mov esi, CellIndexFinal
	mov bl, Answer
	cmp board[esi], bl
	jz ifEqual
	;if not equal
	
	jmp endoffn

	ifEqual: ; if equal
	mov esi, CellIndexFinal
	mov bl, Answer
	mov BoardUser[esi], bl
	endoffn:
	;call displayBoard
	ret
InputAndCheck ENDP
;------------------End of CheckIfEqual proc

;-------------------CalcIndex Proc
CalcIndex Proc uses eax ebx ecx
	mov ebx, CellRow
	mov ecx, 8
	RowLoop:
	add ebx, CellRow
	Loop RowLoop

	mov CellRow, ebx
	mov eax, CellRow
	add eax, CellCol
	mov CellIndexFinal, eax
	ret
CalcIndex ENDP
;-------------------End of CalcIndex Proc

;-------------------InputRowCol Proc
InputRowCol PROC uses eax
	call Readdec
	mov CellRow, eax
	call Readdec
	mov CellCol, eax
	ret
InputRowCol ENDP
;-------------------End of InputRowCol Proc

;-------------------InputAns Proc
InputAns Proc uses eax esi ebx
	call Readdec
	mov answerdword, eax
	mov esi, offset answerdword
	mov bl, byte ptr[esi]
	mov answer,bl
	ret
InputAns ENDP
;-------------------End of InputAns Proc

END main