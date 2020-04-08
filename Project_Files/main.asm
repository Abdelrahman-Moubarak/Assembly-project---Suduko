INCLUDE Irvine32.inc
.DATA

BoardSize EQU 81
BUFFER_SIZE EQU 97
ArrayReadFile byte 97 dup(?)
ArraySaveToFile byte 97 dup(?)

BoardFile_easy1 BYTE "board_easy1.txt",0
BoardFile_easy1_Sol BYTE "board_easy1_sol.txt",0

BoardFile_easy2 BYTE "board_easy2.txt",0
BoardFile_easy2_Sol BYTE "board_easy2_sol.txt",0

BoardFile_easy3 BYTE "board_easy3.txt",0
BoardFile_easy3_Sol BYTE "board_easy3_sol.txt",0

BoardFile_Progress byte "Progress_File.txt",0
ColorFile_Progress byte "ColorArray.txt",0

Color_Board Dword 81 dup(white) 
Board byte 81 dup(?)
Board_sol byte 81 dup(?)

SpaceCounter Dword 0
counter1 Dword 0
CellRow dword ?
CellCol dword ?
CellIndexFinal dword ?
wrongrowcol byte "Out Of Range Index!",0
Answer byte ?
Answerdword dword ?
ColCounter dword 9
EnterNum byte "Enter a number between 1 & 9 : ",0
InputCellNum byte "Enter row then column : ",0
WrongAnswer byte "Wrong Number !! :( ",0
RightAnswer byte "Right Answer :)",0
GameState byte 0
GameLevelMsg1 byte "1.Easy",0
GameLevelMsg2 byte "2.Medium",0
GameLevelMsg3 byte "3.Hard",0
GameEnterLevel byte "Enter your choice : ",0
PlayMsg byte "1.Edit a cell     2.Print finished board     3.Save & Exit",0	
WinMsg byte "You Win !",0


.code

main PROC
	
	call Game
	exit
main ENDP

ReadMyFile PROC  USES eax ebx ecx edx esi
	
	call OpenInputFile 
	mov ecx, BUFFER_SIZE
	mov edx, ebx
	call ReadFromFile
	call CloseFile

	mov edx, ebx
	mov ecx , BUFFER_SIZE
	mov eax ,0
	mov counter1 , eax
	CopyArray:
		inc counter1
		mov eax, counter1
		cmp eax , 9
		je IsNull
			mov al, [edx]
			mov [esi] , al
			inc esi
			inc edx
			cmp al, "0"
			jne cont
			inc SpaceCounter
			jmp cont
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

SaveToFile PROC uses eax ebx ecx edx esi

	mov esi, OFFSET Board
	mov edx,OFFSET BoardFile_Progress
	call CreateOutputFile
	mov edx , OFFSET ArraySaveToFile
	mov ecx , BUFFER_SIZE
	mov ebx , 0
	mov counter1 , ebx
	CopyArray2:
		inc counter1
		mov ebx , counter1
		cmp ebx , 9
		je AddNewline 
		mov ebx , [esi]
		mov [edx] , ebx
		inc esi
		inc edx
		Jmp cont2
	AddNewline :
	    mov ebx, [esi]
		mov [edx] , ebx
        mov ebx ,0
		mov counter1 , ebx
		inc edx 
		mov ebx, 13
		mov [edx] , ebx
		inc edx 
		mov ebx, 10
		mov [edx] , ebx
		inc edx
		inc esi
	cont2:
	loop CopyArray2 
	mov ecx , BUFFER_SIZE
	mov edx , OFFSET ArraySaveToFile
	call WriteToFile

	mov edx,OFFSET ColorFile_Progress
	call CreateOutputFile
	mov ecx , BoardSize
	imul ecx , 4
	mov edx , OFFSET Color_Board
	call WriteToFile
	call CloseFile
	ret
SaveToFile ENDP

ReadColorArray PROC
	mov edx, OFFSET ColorFile_Progress
	mov ecx , BoardSize
	imul ecx , 4
	mov edx , OFFSET Color_Board
	call ReadFromFile
	call CloseFile
ReadColorArray ENDP

DrawBoard PROC uses eax ebx ecx edx esi edi
	
	call Clrscr
	mov edi , OFFSET Color_Board
	mov ecx , BoardSize
	mov ebx , 0 
	mov counter1 , ebx
	mov dh , 2
	mov dl , 25
	call gotoxy
	DrawNumbers:
		inc counter1
		mov eax , [edi]
		call SetTextColor
		mov al , [esi]
		cmp al , "0"
		je ISzero
			call WriteChar
			jmp cont3
		ISzero:
			mov al , 0
			call WriteChar
		cont3:
		add dl , 4
		mov ebx , counter1
		cmp ebx , 9
		je Move_Y
		jmp cont4
		Move_Y :
		add dh ,2
		mov dl ,25
		mov ebx , 0
		mov counter1 , ebx
		cont4:
		inc esi 
		add edi ,4
		call gotoxy
	loop DrawNumbers 

	mov eax , 15
	call SetTextColor

	mov ecx, 2
	mov dh , 7
	mov dl , 24
	call gotoxy
	DrawHorizontal:
		push ecx
		mov ecx , 35
		Drawlines1:
			mov al , 196
			call WriteChar
		loop Drawlines1
		pop ecx
		add dh, 6
		call gotoxy
	loop DrawHorizontal

	mov ecx , 17
	mov dh , 2
	mov dl , 35
	call gotoxy
	Drawlines2:
		mov al , 179
		call WriteChar
		inc dh
		call gotoxy
	loop Drawlines2

	mov ecx , 17
	mov dh , 2
	mov dl , 47
	call gotoxy
	Drawlines3:
		mov al , 179
		call WriteChar
		inc dh
		call gotoxy
	loop Drawlines3

	mov dh , 20
	mov dl , 23
	call gotoxy 
	ret
DrawBoard ENDP


;------------------CheckIfEqual proc
InputAndCheck Proc uses eax ecx esi ebx edx
	call clrscr
	Call InputRowCol
	call CalcIndex 
	mov esi, CellIndexFinal
	cmp Board[esi], "0"
	je ifUnknown
	
	jmp endoffn

	ifUnknown:
	call InputAns
	mov esi, CellIndexFinal
	mov bl, Answer
	cmp Board_sol[esi], bl
	jz ifEqual
	;if not equal
	call crlf
	mov eax , lightRed
	call SetTextColor
	mov edx , OFFSET WrongAnswer
	call WriteString
	mov eax ,lightgray
	call SetTextColor
	mov Color_Board[esi] , lightRed
	call WaitMsg
	jmp endoffn

	ifEqual: ; if equal
	dec SpaceCounter
	mov edx , OFFSET RightAnswer
	call crlf
	mov eax , green
	call SetTextColor
	call WriteString
	call crlf
	mov eax ,lightgray
	call SetTextColor
	call WaitMsg
	mov esi, CellIndexFinal
	mov bl, Answer
	mov Board[esi], bl
	imul esi ,4
	mov Color_Board[esi] , lightblue
	endoffn:
	mov esi , OFFSET Board
	call DrawBoard
	ret
InputAndCheck ENDP
;------------------End of CheckIfEqual proc

;-------------------CalcIndex Proc
CalcIndex Proc uses eax ebx ecx

	mov eax, CellRow
	mul ColCounter
	add eax, CellCol
	mov CellIndexFinal, eax
	ret
CalcIndex ENDP
;-------------------End of CalcIndex Proc

;-------------------InputRowCol Proc
InputRowCol PROC uses eax edx
	
	GetInput:
	mov edx , OFFSET InputCellNum 
	call WriteString
	call Readdec
	mov CellRow, eax
	call Readdec
	mov CellCol, eax
	mov eax , CellRow
	cmp eax , 1
	jae CheckBE9

	mov edx , OFFSET wrongrowcol
	call WriteString
	jmp GetInput

	CheckBE9:
	cmp eax , 9
	jbe CheckY

	mov edx , OFFSET wrongrowcol
	call WriteString
	jmp GetInput

	CheckY:
	mov eax , CellCol
	cmp eax , 1
	jae CheckBE9Y

	mov edx , OFFSET wrongrowcol
	call WriteString
	jmp GetInput

	CheckBE9Y:
	cmp eax , 9
	jbe InRange

	mov edx , OFFSET wrongrowcol
	call WriteString
	jmp GetInput

	InRange:
	dec CellRow
	dec CellCol
	
	ret
InputRowCol ENDP
;-------------------End of InputRowCol Proc

;-------------------InputAns Proc
InputAns Proc uses eax edx
	
	GetInputNum:
	mov edx , OFFSET EnterNum
	call WriteString
	call ReadChar
	call WriteChar
	cmp al , 31h
	jae CheckBounds
	jmp GetInputNum
	CheckBounds:
	cmp al , 39h
	jbe IsCorrect
	jmp GetInputNum
	ISCorrect :
	mov answer,al
	ret
InputAns ENDP
;-------------------End of InputAns Proc

Game PROC USES eax ebx ecx edx esi edi ebp
	
	GetLevel:
		call clrscr
		mov al , GameState
		cmp al , 0
		jne ContinueGame
		mov dl, 35
		mov dh, 7
		call gotoxy
		mov edx , OFFSET GameLevelMsg1
		call WriteString

		mov dl, 35
		mov dh, 10
		call gotoxy
		mov edx , OFFSET GameLevelMsg2
		call WriteString

		mov dl, 35
		mov dh, 13
		call gotoxy
		mov edx , OFFSET GameLevelMsg3
		call WriteString

		mov dl, 29
		mov dh, 16
		call gotoxy
		mov edx , OFFSET GameEnterLevel
		call WriteString
		call ReadDec

		cmp eax ,1
		jne CheckMedium
		call RandomEasyBoard
		jmp DisplayGame

		CheckMedium:
			cmp eax ,2
			jne CheckHard
			call RandomMediumBoard
			jmp DisplayGame

		CheckHard:
			call RandomHardBoard



	ContinueGame:


	DisplayGame:
		mov esi, OFFSET board
		call DrawBoard
		mov dl, 10
		mov dh, 22
		call gotoxy
		mov edx , OFFSET PlayMsg
		call writeString
		mov dl, 29
		mov dh, 24
		call gotoxy
		mov edx, OFFSET GameEnterLevel
		call writeString
		call ReadDec
		cmp eax ,2
		je checkDFBoard
		cmp eax ,3
		je DoSave
		cmp eax ,1
		jne DisplayGame
		call InputAndCheck
		mov eax , SpaceCounter
		cmp eax ,0
		je YouWin
		jmp DisplayGame

	CheckDFBoard:


	DoSave:

	YouWin:
		call clrscr
		mov dl ,32
		mov dh ,15
		call gotoxy
		mov eax , green
		call SetTextColor
		mov edx , OFFSET WinMsg
		call WriteString
		mov eax , lightGray
		call SetTextColor
		mov dl ,32
		mov dh ,20
		call Gotoxy

	ret
Game ENDP

RandomEasyBoard PROC
	mov eax ,3
	call RandomRange
	cmp eax , 0
	jne CheckotherE1
	mov edx, OFFSET BoardFile_easy1
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board
	call ReadMyFile
	
	mov edx, OFFSET BoardFile_easy1_sol
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board_sol
	call ReadMyFile
	jmp cont

	CheckotherE1:
		cmp eax , 1
		jne CheckotherE2
		mov edx, OFFSET BoardFile_easy2
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_easy2_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
		jmp cont

	CheckotherE2:
		mov edx, OFFSET BoardFile_easy3
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_easy3_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
	
	cont:
	ret
RandomEasyBoard ENDP

RandomMediumBoard PROC
	mov eax ,3
	call RandomRange
	cmp eax , 0
	jne CheckotherM1
	mov edx, OFFSET BoardFile_easy1
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board
	call ReadMyFile
	
	mov edx, OFFSET BoardFile_easy1_sol
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board_sol
	call ReadMyFile
	jmp cont1

	CheckotherM1:
		cmp eax , 1
		jne CheckotherM2
		mov edx, OFFSET BoardFile_easy2
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_easy2_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
		jmp cont1

	CheckotherM2:
		mov edx, OFFSET BoardFile_easy3
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_easy3_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
	
	cont1:
	ret
RandomMediumBoard ENDP

RandomHardBoard PROC
	mov eax ,3
	call RandomRange
	cmp eax , 0
	jne CheckotherH1
	mov edx, OFFSET BoardFile_easy1
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board
	call ReadMyFile
	
	mov edx, OFFSET BoardFile_easy1_sol
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board_sol
	call ReadMyFile
	jmp cont2

	CheckotherH1:
		cmp eax , 1
		jne CheckotherH2
		mov edx, OFFSET BoardFile_easy2
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_easy2_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
		jmp cont2

	CheckotherH2:
		mov edx, OFFSET BoardFile_easy3
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_easy3_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
	
	cont2:
	ret
RandomHardBoard ENDP

END main







;mov edx, OFFSET BoardFile_easy1
;mov ebx, OFFSET ArrayReadFile
;mov esi, OFFSET Board
;call ReadMyFile

;mov edx, OFFSET BoardFile_easy1_sol
;mov ebx, OFFSET ArrayReadFile
;mov esi, OFFSET Board_sol
;call ReadMyFile