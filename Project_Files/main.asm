INCLUDE Irvine32.inc
.DATA

BoardSize EQU 81
BUFFER_SIZE EQU 97

ArrayReadFile byte 97 dup(?)
ArraySaveToFile byte 97 dup(?)
ColorArraySaveToFile Dword 81 dup(?)
CounterArray Dword 3 dup(?)

BoardFile_easy1 BYTE "board_easy1.txt",0
BoardFile_easy1_Sol BYTE "board_easy1_sol.txt",0

BoardFile_easy2 BYTE "board_easy2.txt",0
BoardFile_easy2_Sol BYTE "board_easy2_sol.txt",0

BoardFile_easy3 BYTE "board_easy3.txt",0
BoardFile_easy3_Sol BYTE "board_easy3_sol.txt",0

BoardFile_medium1 BYTE "board_medium1.txt",0
BoardFile_medium1_Sol BYTE "board_medium1_sol.txt",0

BoardFile_medium2 BYTE "board_medium2.txt",0
BoardFile_medium2_Sol BYTE "board_medium2_sol.txt",0

BoardFile_medium3 BYTE "board_medium3.txt",0
BoardFile_medium3_Sol BYTE "board_medium3_sol.txt",0

BoardFile_hard1 BYTE "board_hard1.txt",0
BoardFile_hard1_Sol BYTE "board_hard1_sol.txt",0

BoardFile_hard2 BYTE "board_hard2.txt",0
BoardFile_hard2_Sol BYTE "board_hard2_sol.txt",0

BoardFile_hard3 BYTE "board_hard3.txt",0
BoardFile_hard3_Sol BYTE "board_hard3_sol.txt",0


BoardFile_Progress byte "Progress_File.txt",0
BoardFile_Progress_sol byte "Progress_File_sol.txt",0
BoardFile_Progress2 byte "Progress_File2.txt",0
BoardFile_Progress_sol2 byte "Progress_File_sol2.txt",0
ProgressCounter Dword 2
ProgressCounterSaver Dword ?

ColorFile_Progress byte "ColorArray.txt",0
ColorFile_Progress2 byte "ColorArray2.txt",0
CounterFile_Progress Byte "Counters.txt",0

Color_Board Dword 81 dup(white) 
Board byte 81 dup(?)
Board_sol byte 81 dup(?)
RightWrongIndexes Byte 81 dup(0)

SpaceCounter Dword 0
StartTime Dword ?
TotalTime Dword ?
counter1 Dword 0
CellRow dword ?
CellCol dword ?
CellIndexFinal dword ?
Answer byte ?
Answerdword dword ?
ColCounter dword 9
GameState byte 0
RightAnswerCounter Dword 0
WrongAnswerCounter Dword 1

wrongrowcol byte "Out Of Range Index!",0
EnterNum byte "Enter a number between 1 & 9 : ",0
InputCellNum byte "Enter row then column : ",0
WrongAnswer byte "Wrong Number !! :( ",0
RightAnswer byte "Right Answer :)",0
GameLevelMsg1 byte "1.Easy",0
GameLevelMsg2 byte "2.Medium",0
GameLevelMsg3 byte "3.Hard",0
ChoiceMsg byte "Enter your choice : ",0
PlayMsg byte "1.Edit a cell     2.Print finished board     3.Save & Exit",0	
WinMsg byte "You Win !",0
RightCounterMsg byte "Number of Right answers : ",0
WrongCounterMsg byte "Number of Wrong Answers : ",0
StepsRemainingMsg byte "Steps Remaining To win : ",0
TotalTimeMsg byte "Total time to complete the intire board : ",0 
StartNewMsg byte "1.New Game ",0
ContinueMsg byte "2.Continue ",0
ExitMsg byte "3.Exit ",0
Thanks byte "Thanks For Playing.... ",0
filehandle handle ?

.code

main PROC
	MainLabel:
		mov dl , 35
	mov dh , 7
	call Gotoxy
	mov edx, OFFSET StartNewMsg
	call writeString

	mov dl , 35
	mov dh , 10
	call Gotoxy
	mov edx, OFFSET ContinueMsg
	call writeString

	mov dl , 35
	mov dh , 13
	call Gotoxy
	mov edx, OFFSET ExitMsg
	call writeString

	mov dl , 29
	mov dh , 16
	call Gotoxy
	mov edx, OFFSET ChoiceMsg
	call writeString
		call ReadDec
		cmp eax , 3
		je ExitMyGame
		dec eax
		call game 
		call clrscr
		jmp MainLabel
;		exit
	ExitMyGame:
		call clrscr
		mov dl , 29
		mov dh , 10
		call Gotoxy
		mov edx, OFFSET Thanks
		call WriteString
		mov dl , 29
		mov dh , 20
		call Gotoxy
		call WaitMsg
	exit
main ENDP

ReadMyFile PROC  USES eax ebx ecx edx esi
	
	call OpenInputFile 
	mov ecx, BUFFER_SIZE
	mov edx, ebx
	call ReadFromFile
	call closeFile
	mov edx, ebx
	mov ecx , BUFFER_SIZE
	mov eax ,0
	mov counter1 , eax
	CopyArray:
		inc counter1
		mov eax, counter1
		cmp eax , 9
		je IsNull
			mov eax, [edx]
			mov [esi] , eax
			inc esi
			inc edx
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
	call CreateOutputFile
	mov filehandle,eax
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

	mov esi, OFFSET Board_sol
	mov edx,OFFSET BoardFile_Progress_sol
	call CreateOutputFile
	mov edx , OFFSET ArraySaveToFile
	mov ecx , BUFFER_SIZE
	mov ebx , 0
	mov counter1 , ebx
	CopyArray3:
		inc counter1
		mov ebx , counter1
		cmp ebx , 9
		je AddNewline1 
		mov ebx , [esi]
		mov [edx] , ebx
		inc esi
		inc edx
		Jmp cont3
	AddNewline1 :
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
	cont3:
	loop CopyArray3
	mov ecx , BUFFER_SIZE
	mov edx , OFFSET ArraySaveToFile
	call WriteToFile
	mov eax,filehandle
	call closefile
	ret
SaveToFile ENDP

ReadRightWrongArray PROC Uses eax edx ecx
	call OpenInputFile
	mov ecx , BoardSize
	mov edx , OFFSET RightWrongIndexes
	call ReadFromFile
	
	call closeFile
	ret
ReadRightWrongArray ENDP

SaveRightWrongArray PROC USES eax ecx edx 
	call CreateOutputFile
	mov filehandle,eax
	mov ecx , BoardSize
	mov edx , OFFSET RightWrongIndexes
	call WriteToFile
	mov eax,filehandle
	call closeFile
	ret
SaveRightWrongArray ENDP

ReadRightWrongCounters PROC USES ecx edx eax
	mov edx, OFFSET CounterFile_Progress
	call OpenInputFile
	push eax
	mov ecx , 12
	mov edx , OFFSET CounterArray
	call ReadFromFile
	mov eax , counterArray[0]
	mov RightAnswerCounter , eax
	mov eax, counterArray[4]
	mov WrongAnswerCounter, eax
	mov eax , CounterArray[8]
	mov ProgressCounter , eax
	pop eax
	call closeFile
	ret
ReadRightWrongCounters ENDP

SaveRightWrongCounters PROC Uses eax edx ecx
	mov eax , RightAnswerCounter
	mov counterArray[0] , eax
	mov eax , WrongAnswerCounter
	mov counterArray[4] , eax
	mov eax , ProgressCounter
	mov counterArray[8] , eax
	mov edx,OFFSET CounterFile_Progress
	call CreateOutputFile
	mov filehandle,eax
	mov ecx , 12
	mov edx , OFFSET counterArray
	call WriteToFile
	mov eax,filehandle
	call closeFile

	ret
SaveRightWrongCounters ENDP

RightWrongCheck PROC
	mov esi , OFFSET RightWrongIndexes
	mov edx , OFFSET Board
	mov ecx , BoardSize
	CheckBoardSpaces:
		mov al , [edx]
		cmp al , "0"
		jne NotEmpty
		mov [esi] , al
		jmp increments
		NotEmpty:
			mov al , "1"
			mov [esi] , al
			jmp increments
		increments:
		 inc esi
		 inc edx
	loop CheckBoardSpaces
RightWrongCheck ENDP

MoveColor PROC Uses eax ebx ecx edx esi
	mov edx , OFFSET Color_Board
	Mov esi , OFFSET RightWrongIndexes
	mov ecx , BoardSize
	CopyColor:
		mov al , [esi]
		cmp al , "2"
		jne If3
		mov ebx , LightBlue
		mov [edx] , ebx
		jmp OffsetInc
		If3:
			cmp al , "3"
			jne OffsetInc
			mov ebx , LightRed
			mov [edx] , ebx
		OffsetInc:
			inc esi
			add edx , 4
	loop CopyColor
	ret
MoveColor ENDP

DrawBoard PROC uses eax ebx ecx edx esi edi
	
	call Clrscr
	mov edi , OFFSET Color_Board
	mov ecx , BoardSize
	mov ebx , 0
	mov SpaceCounter , ebx
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
			inc SpaceCounter
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

DrawFinishedBoard PROC Uses eax ebx ecx edx esi edi
	mov esi , OFFSET Board_sol
	mov edi , OFFSET RightWrongIndexes
	mov ecx , BoardSize
	mov ebx , 0
	mov counter1 , ebx
	mov dh , 2
	mov dl , 25
	call gotoxy
	DrawNumbers:
		inc counter1
		mov al , [edi]
		cmp al , "0"
		jne CheckIfWhite
		mov eax , Yellow
		jmp SetColor
		CheckIfWhite:
			cmp al ,"1"
			jne CheckIfBlue
			mov eax , White
			jmp SetColor
		CheckIfBlue:
			cmp al , "2"
			jne CheckIfRed
			mov eax , lightBlue
			jmp SetColor
		CheckIfRed:
			mov eax , lightRed
			jmp SetColor

		SetColor:
		call SetTextColor
		mov al , [esi]
		call WriteChar
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
		inc edi
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
DrawFinishedBoard ENDP


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
	inc WrongAnswerCounter
	mov eax , lightRed
	call SetTextColor
	mov dl, 24
	mov dh ,11
	call gotoxy
	mov edx , OFFSET WrongAnswer
	call WriteString
	mov eax ,lightgray
	call SetTextColor
	mov RightWrongIndexes[esi] , "3"
	imul esi ,4
	mov Color_Board[esi] , lightRed
	mov dl, 24
	mov dh ,13
	call gotoxy
	call WaitMsg
	jmp endoffn

	ifEqual: ; if equal
	inc RightAnswerCounter
	dec SpaceCounter
	mov dl, 24
	mov dh ,11
	call gotoxy
	mov edx , OFFSET RightAnswer
	mov eax , green
	call SetTextColor
	call WriteString
	call crlf
	mov eax ,lightgray
	call SetTextColor
	mov dl, 24
	mov dh ,13
	call gotoxy
	call WaitMsg
	mov esi, CellIndexFinal
	mov bl, Answer
	mov Board[esi], bl
	mov RightWrongIndexes[esi] , "2"
	imul esi ,4
	mov Color_Board[esi] , LightBlue
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
	mov dl, 24
	mov dh ,5
	call gotoxy
	mov edx , OFFSET InputCellNum 
	call WriteString
	mov dl, 48
	mov dh ,5
	call gotoxy
	call Readdec
	mov CellRow, eax
	mov dl, 50
	mov dh ,5
	call gotoxy
	call Readdec
	mov CellCol, eax
	mov eax , CellRow
	cmp eax , 1
	jae CheckBE9

	mov dl, 24
	mov dh ,7
	call gotoxy
	mov edx , OFFSET wrongrowcol
	call WriteString
	jmp GetInput

	CheckBE9:
	cmp eax , 9
	jbe CheckY

	mov dl, 24
	mov dh ,7
	call gotoxy
	mov edx , OFFSET wrongrowcol
	call WriteString
	jmp GetInput

	CheckY:
	mov eax , CellCol
	cmp eax , 1
	jae CheckBE9Y

	mov dl, 24
	mov dh ,7
	call gotoxy
	mov edx , OFFSET wrongrowcol
	call WriteString
	jmp GetInput

	CheckBE9Y:
	cmp eax , 9
	jbe InRange

	mov dl, 24
	mov dh ,7
	call gotoxy
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
	mov dl, 24
	mov dh ,9
	call gotoxy
	mov edx , OFFSET EnterNum
	call WriteString
	mov dl, 55
	mov dh ,9
	call gotoxy
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
	mov GameState,al
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
		mov edx , OFFSET ChoiceMsg
		call WriteString
		call ReadDec

		cmp eax ,1
		jne CheckMedium
		call RandomEasyBoard
		call GetMseconds
		mov StartTime , eax
		jmp DisplayGame

		CheckMedium:
			cmp eax ,2
			jne CheckHard
			call RandomMediumBoard
			call GetMseconds
			mov StartTime , eax
			jmp DisplayGame

		CheckHard:
			call RandomHardBoard
			call GetMseconds
			mov StartTime , eax
			jmp DisplayGame


	ContinueGame:

		call ReadRightWrongCounters

		mov eax , ProgressCounter
		cmp eax , 3
		jne GetAlternativeFiles

		mov edx, OFFSET BoardFile_Progress
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		call RightWrongCheck
		
		mov edx, OFFSET BoardFile_Progress_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile

		mov edx,OFFSET ColorFile_Progress
		call ReadRightWrongArray

		call MoveColor

		jmp StartGame

		GetAlternativeFiles:

			mov edx, OFFSET BoardFile_Progress2
			mov ebx, OFFSET ArrayReadFile
			mov esi, OFFSET Board
			call ReadMyFile

			call RightWrongCheck
		
			mov edx, OFFSET BoardFile_Progress_sol
			mov ebx, OFFSET ArrayReadFile
			mov esi, OFFSET Board_sol
			call ReadMyFile

			mov edx,OFFSET ColorFile_Progress2
			call ReadRightWrongArray

			call MoveColor

		StartGame:
			call GetMseconds
			mov StartTime , eax

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
		mov edx, OFFSET ChoiceMsg
		call writeString
		call ReadDec
		cmp eax ,2
		je checkDFBoard

		cmp eax ,3
		jne l2
		mov eax ,ProgressCounter
		cmp eax , 2
		je SaveFirstTime
		jmp DoSave
		
		l2:
		cmp eax ,1
		jne DisplayGame
		call InputAndCheck
		mov eax , SpaceCounter
		cmp eax ,0
		je YouWin
		jmp DisplayGame

	CheckDFBoard:
		call clrscr
		call DrawFinishedBoard
		mov dl ,26
		mov dh ,20
		call Gotoxy
		mov edx , OFFSET StepsRemainingMsg
		call WriteString
		mov eax , LightBlue
		call SetTextColor
		mov eax , SpaceCounter
		call WriteDec
		mov eax , White
		call SetTextColor
		mov dl ,26
		mov dh ,22
		call Gotoxy
		call waitMsg
		jmp EndGame

	SaveFirstTime:
		inc ProgressCounter
		mov eax , ProgressCounter
		mov ProgressCounterSaver , eax
		mov edx,OFFSET BoardFile_Progress
		
		call SaveToFile
		
		call SaveRightWrongCounters
		mov edx,OFFSET ColorFile_Progress
		
		call SaveRightWrongArray
		
		jmp EndGame

	DoSave:
		mov eax , ProgressCounter
		cmp eax , 3
		jne SaveToAlternativeFiles
		mov edx,OFFSET BoardFile_Progress2
		call SaveToFile
		inc ProgressCounter
		call SaveRightWrongCounters
		mov edx,OFFSET ColorFile_Progress2
		call SaveRightWrongArray
		jmp EndGame

		SaveToAlternativeFiles:
			mov edx,OFFSET BoardFile_Progress
			call SaveToFile
			mov edx,OFFSET ColorFile_Progress
			call SaveRightWrongArray
			dec ProgressCounter
			call SaveRightWrongCounters
		jmp EndGame

	YouWin:
		call clrscr
		mov dl ,26
		mov dh ,10
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
		call WaitMsg

	EndGame:
		call clrscr
		call GetMseconds 
		sub  eax,StartTime
		mov TotalTime , eax

		mov dl ,26
		mov dh ,5
		call Gotoxy
		mov edx , OFFSET RightCounterMsg
		call WriteString
		mov eax , Green 
		call SetTextColor
		mov eax , RightAnswerCounter
		call WriteDec

		mov eax , White
		call SetTextColor

		mov dl ,26
		mov dh ,7
		call Gotoxy
		mov edx , OFFSET WrongCounterMsg
		call WriteString
		mov eax , LightRed
		call SetTextColor
		mov eax , WrongAnswerCounter
		dec eax
		call WriteDec

		mov eax , White
		call SetTextColor

		mov dl ,26
		mov dh ,9
		call Gotoxy
		mov edx , OFFSET TotalTimeMsg
		call WriteString
		mov eax , yellow
		call SetTextColor
		mov edx , 0
		mov eax , TotalTime
		mov ebx , 1000
		div ebx
		call WriteDec

		mov eax , White
		call SetTextColor
		
		mov dl ,18
		mov dh ,20
		call Gotoxy
		call WaitMsg
		
	ret
Game ENDP

RandomEasyBoard PROC Uses eax edx ebx esi
	call Randomize
	mov eax, 3
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
		call RightWrongCheck
	ret
RandomEasyBoard ENDP

RandomMediumBoard PROC Uses eax edx ebx esi
	call Randomize
	mov eax ,3
	call RandomRange
	cmp eax , 0
	jne CheckotherM1
	mov edx, OFFSET BoardFile_medium1
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board
	call ReadMyFile
	
	mov edx, OFFSET BoardFile_medium1_sol
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board_sol
	call ReadMyFile
	jmp cont1

	CheckotherM1:
		cmp eax , 1
		jne CheckotherM2
		mov edx, OFFSET BoardFile_medium2
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_medium2_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
		jmp cont1

	CheckotherM2:
		mov edx, OFFSET BoardFile_medium3
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_medium3_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
		
	
	cont1:
		call RightWrongCheck
	ret
RandomMediumBoard ENDP

RandomHardBoard PROC Uses eax edx ebx esi
	call Randomize
	mov eax ,3
	call RandomRange
	cmp eax , 0
	jne CheckotherH1
	mov edx, OFFSET BoardFile_hard1
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board
	call ReadMyFile
	
	mov edx, OFFSET BoardFile_hard1_sol
	mov ebx, OFFSET ArrayReadFile
	mov esi, OFFSET Board_sol
	call ReadMyFile
	jmp cont2

	CheckotherH1:
		cmp eax , 1
		jne CheckotherH2
		mov edx, OFFSET BoardFile_hard2
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_hard2_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
		jmp cont2

	CheckotherH2:
		mov edx, OFFSET BoardFile_hard3
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board
		call ReadMyFile

		mov edx, OFFSET BoardFile_hard3_sol
		mov ebx, OFFSET ArrayReadFile
		mov esi, OFFSET Board_sol
		call ReadMyFile
		
	
	cont2:
		call RightWrongCheck
	ret
RandomHardBoard ENDP

END main