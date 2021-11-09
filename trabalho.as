;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_READ         EQU     FFFFh
WRITE        	EQU     FFFEh
IO_STATUS       EQU     FFFDh
INITIAL_SP      EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT		EQU		FFFFh
ATIVAR_TIMER	EQU		FFF7h
CONFIG_TIMER	EQU		FFF6h
ROW_POSITION	EQU		0d
COL_POSITION	EQU		0d
ROW_SHIFT		EQU		8d
COLUMN_SHIFT	EQU		8d


LINE_END		EQU		31d
RIGHTWALL_END	EQU		17d
FLOOR_END		EQU		9d
LEFTWALL_END	EQU		2d
C_DOTS_END		EQU		29d
R_OBSTACLE_END	EQU		16d
C_DOTS_INIT 	EQU		10d
OBS_END1		EQU		16d
OBS_END2		EQU		27d
OBSMID_END1		EQU		16d
OBSMID_END2		EQU		22d
OBSMID_END3		EQU		27d
COUNTER			EQU		9d
COLUMN_INIT		EQU		10d
DIR_PARADO		EQU		5d
DIR_CIMA		EQU		0d
DIR_BAIXO		EQU		1d
DIR_ESQ			EQU		2d
DIR_DIR			EQU		3d
PARADO			EQU		0d
MOVIMENTO		EQU		1d
STOP			EQU		10d
INIT_VIDAS		EQU 	2d
INIT_POINT		EQU		4d
POINT_END		EQU		24d
ZEROASCII		EQU		48d
;PONTUACAO: 123
;digito mais sig.:1+0ascii = 49



; padrao de bits para geracao de numero aleatorio
RND_MASK	EQU	8016h	; 1000 0000 0001 0110b
LSB_MASK	EQU	0001h	; Mascara para testar o bit menos significativo do Random_Var


;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
RowIndex		WORD	3d
ColumnIndex		WORD	10d
ObstacleRow		WORD	5d
ObstacleColumn	WORD	11d
Counter 		WORD	0d
Contador 		WORD	1d
Random_Var		WORD	A5A5h
LinhaCount 		WORD 	8179h
LinhaAuxCount	WORD 	803Eh
TimerAtivado 	WORD 	1d



lives			STR		'VIDAS: <3  <3  <3'
limpa_vidas 	STR 	'                 '
Contador_Vidas	WORD	3d
Vidas_End 		WORD 	27d

poinst			STR		'PONTUACAO: 000'
Pontos			WORD	ZEROASCII
PontosDezena	WORD 	ZEROASCII
PontosCentena	WORD 	ZEROASCII
Pontos_aux		WORD	0d
;MAX = 146


game_over 		STR 	'GAME OVER'


						;012345678901234567890
linha_0			STR		'#####################'
linha_1			STR		'#...................#'
linha_2			STR		'#.#####..#.#..#####.#'
linha_3			STR		'#.#.M.#..#.#..#.M.#.#'
linha_4			STR		'#.#.#.#..#.#..#.#.#.#'
linha_5			STR		'#...................#'
linha_6			STR		'#...................#'
linha_7			STR		'##.####.#####.####.##'
linha_8			STR		'##.####.#####.####.##'
linha_9			STR		'#...................#'
linha_10		STR		'#.#.#.#..#.#..#.#.#.#'
linha_11		STR		'#.#.M.#..#.#..#.M.#.#'
linha_12		STR		'#.#####..#.#..#####.#'
linha_13		STR		'#...................#'
linha_14		STR		'#####################'
LineCounter		WORD	3d
ContadorPosicao	WORD	0d

Direcao_Pacman	WORD	DIR_PARADO
Mov_Pacman		WORD	PARADO
Linha_pacman	WORD	9d
Colum_Pacman	WORD	20d

Direcao_Monstro1 WORD	DIR_PARADO
Direcao_Monstro2 WORD	DIR_PARADO
Direcao_Monstro3 WORD	DIR_PARADO
Direcao_Monstro4 WORD	DIR_PARADO
Mov_Monstro		WORD	PARADO
Linha_Monstro1	WORD	6d 
Column_Monstro1	WORD	26d
Linha_Monstro2	WORD	14d
Column_Monstro2	WORD	14d
Linha_Monstro3	WORD	6d 
Column_Monstro3	WORD	14d
Linha_Monstro4	WORD	14d 
Column_Monstro4	WORD	26d
ConteudoAnt1 	WORD 	46d
ConteudoAnt2	WORD 	46d
ConteudoAnt3 	WORD 	46d
ConteudoAnt4 	WORD 	46d
ConteudoAux 	WORD 	46d

;------------------------------------------------------------------------------
; ZONA II: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    MovEsquerdaInt
INT1			WORD	MovDireitaInt
INT3			WORD	MovCimaInt
INT4			WORD	MovBaixoInt
				ORIG	FE0Fh
INT15			WORD	Timer

;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main

;------------------------------------------------------------------------------
; FUNCTION PrintString
;------------------------------------------------------------------------------

PrintString:	RET









;------------------------------------------------------------------------------
; FUNCTION Vidas
;------------------------------------------------------------------------------

Vidas: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop16:			MOV		R1, M[ INIT_VIDAS ]
				CMP		R2,	27d
				JMP.Z	ContinuaVida
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + limpa_vidas ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop16



ContinuaVida:	MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]

Loop17:			MOV		R1, M[ INIT_VIDAS ]
				CMP		R2,	M[ Vidas_End ]
				JMP.Z	End17
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + lives ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop17

End17:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				RET			

;------------------------------------------------------------------------------
; FUNCTION Pontuacao
;------------------------------------------------------------------------------

Pontuacao:		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH	R7
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				MOV		R5, M[ Pontos ]
				

Loop15:			MOV		R1, M[ INIT_POINT ]
				CMP		R2,	POINT_END
				JMP.Z	End15
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				CMP		R4, 11d
				JMP.Z 	Centena
				CMP		R4, 12d
				JMP.Z	Dezena ;TODO
				CMP		R4, 13d
				JMP.Z 	Unidade ;TODO
				MOV		R3, M[ R4 + poinst ]

ContinuaPontuacao:MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop15
				


Unidade:		CMP		R5, 58d
				JMP.Z 	IncrementaDezena
				MOV 	R3, R5
				JMP 	ContinuaPontuacao

IncrementaDezena:MOV 	R6, 48d
				 MOV 	M[ Pontos ], R6
				 INC 	M[ PontosDezena ]
				 MOV 	R6, M[ PontosDezena ]
				 CMP 	R6, 58d
				 JMP.Z 	IncrementaCentena
				 MOV 	R5, M[ Pontos ]
				 MOV 	R3, R5
				 JMP 	ContinuaPontuacao

IncrementaCentena:MOV 	R6, 48d
				 MOV 	M[ PontosDezena ], R6
				 INC 	M[ PontosCentena ]
				 MOV 	R5, M[ Pontos ]
				 MOV 	R3, R5 
				 JMP 	ContinuaPontuacao

Dezena:			MOV 	R3, M[ PontosDezena ]
				JMP		ContinuaPontuacao

Centena:		MOV 	R3, M[ PontosCentena ]
				JMP		ContinuaPontuacao



End15:			POP		R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP 	R1
				RET


;------------------------------------------------------------------------------
; FUNCTION Line0
;------------------------------------------------------------------------------

Line0: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop0:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End0
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_0 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop0

End0:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET



;------------------------------------------------------------------------------
; FUNCTION Line1
;------------------------------------------------------------------------------

Line1: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop1:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End1
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_1 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop1

End1:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET
				

;------------------------------------------------------------------------------
; FUNCTION Line2
;------------------------------------------------------------------------------

Line2: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop2:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End2
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_2 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop2

End2:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line3
;------------------------------------------------------------------------------

Line3: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop3:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End3
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_3 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop3

End3:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line4
;------------------------------------------------------------------------------

Line4: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop4:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End4
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_4 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop4

End4:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line5
;------------------------------------------------------------------------------

Line5: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop5:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End5
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_5 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop5

End5:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET



;------------------------------------------------------------------------------
; FUNCTION Line6
;------------------------------------------------------------------------------

Line6: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop6:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End6
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_6 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop6

End6:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line7
;------------------------------------------------------------------------------

Line7: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop7:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End7
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_7 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop7

End7:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line8
;------------------------------------------------------------------------------

Line8: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop8:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End8
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_8 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop8

End8:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line9
;------------------------------------------------------------------------------

Line9: 			PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop9:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End9
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_9 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop9

End9:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line10
;------------------------------------------------------------------------------

Line10: 		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop10:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End10
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_10 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop10

End10:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line11
;------------------------------------------------------------------------------

Line11: 		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop11:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End7
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_11 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop11

End11:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line12
;------------------------------------------------------------------------------

Line12: 		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop12:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End7
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_12 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop12

End12:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line13
;------------------------------------------------------------------------------

Line13: 		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop13:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End13
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_13 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop13

End13:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION Line14
;------------------------------------------------------------------------------

Line14: 		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				MOV		R4, M[ ContadorPosicao ]
				MOV		R2, M[ COLUMN_INIT ]
				

Loop14:			MOV		R1, M[ LineCounter ]
				CMP		R2, LINE_END
				JMP.Z	End14
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + linha_14 ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop14

End14:			POP		R4
				POP		R3
				POP		R2
				POP 	R1
				INC		M[ LineCounter ]
				RET


;------------------------------------------------------------------------------
; FUNCTION MovEsquerdaInt
;------------------------------------------------------------------------------

MovEsquerdaInt:	PUSH	R1

				MOV		R1, DIR_ESQ
				MOV		M[ Direcao_Pacman ], R1


				POP		R1

				RTI



;------------------------------------------------------------------------------
; FUNCTION MovDireitaInt
;------------------------------------------------------------------------------

MovDireitaInt:	PUSH	R1

				MOV		R1, DIR_DIR
				MOV		M[ Direcao_Pacman ], R1


				POP		R1

				RTI



;------------------------------------------------------------------------------
; FUNCTION MovCimaInt
;------------------------------------------------------------------------------

MovCimaInt:		PUSH	R1

				MOV		R1, DIR_CIMA
				MOV		M[ Direcao_Pacman ], R1


				POP		R1

				RTI


;------------------------------------------------------------------------------
; FUNCTION MovBaixoInt
;------------------------------------------------------------------------------

MovBaixoInt:	PUSH	R1

				MOV		R1, DIR_BAIXO
				MOV		M[ Direcao_Pacman ], R1


				POP		R1

				RTI



;------------------------------------------------------------------------------
; FUNCTION PerdeVida
;------------------------------------------------------------------------------


PerdeVida:		PUSH	R1
				PUSH 	R2
				PUSH 	R3
				PUSH 	R4
				MOV 	R1, 0d
				;MOV 	R3, 21d
				;MOV 	R4, 82B4h
				;MOV 	R2, 5d
				;MOV 	M[ Direcao_Pacman ], R2
				;MOV 	R2, 9d
				;MOV 	M[ Linha_pacman ], R2
				;MOV 	R2, 20d
				;MOV 	M[ Colum_Pacman ], R2
				;MOV 	R2, 5d
				;MOV 	M[ Direcao_Monstro1 ], R2
				;MOV 	M[ Direcao_Monstro2 ], R2
				;MOV 	R2, 6d
				;MOV 	M[ Linha_Monstro1 ], R2
				;MOV 	R2, 26d
				;MOV 	M[ Column_Monstro1 ], R2
				;MOV 	R2, 14d
				;MOV 	M[ Linha_Monstro2 ], R2
				;MOV 	M[ Column_Monstro2 ], R2

;loop18:			CMP 	R1, 20d
;				JMP.Z 	IncrementaLinha
;				MOV 	R2, M[ R1 + LinhaAuxCount ]
;				MOV 	M[R1 + LinhaCount], R2
;				INC 	R1 
;				JMP 	loop18


;IncrementaLinha:CMP 	M[ LinhaCount ], R4
;				JMP.Z 	SegueVida
;				ADD 	M[ LinhaCount ], R3
;				ADD 	M[ LinhaAuxCount ], R3
;				MOV 	R1, 0d
;				JMP 	loop18

				MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]

				MOV		R3, -1d


Decrementa10Vid1:INC	R3
				CMP		R3, STOP
				JMP.Z 	ContinuaMons1
				DEC		R2
				JMP		Decrementa10Vid1


ContinuaMons1:	CMP		R1, 4d 
				JMP.Z	VidaL1
				CMP		R1, 5d 
				JMP.Z	VidaL2
				CMP		R1, 6d 
				JMP.Z	VidaL3
				CMP		R1, 7d 
				JMP.Z	VidaL4
				CMP		R1, 8d 
				JMP.Z	VidaL5
				CMP		R1, 9d 
				JMP.Z	VidaL6
				CMP		R1, 10d 
				JMP.Z	VidaL7
				CMP		R1, 11d 
				JMP.Z	VidaL8
				CMP		R1, 12d 
				JMP.Z	VidaL9
				CMP		R1, 13d 
				JMP.Z	VidaL10
				CMP		R1, 14d 
				JMP.Z	VidaL11
				CMP		R1, 15d 
				JMP.Z	VidaL12
				CMP		R1, 16d 
				JMP.Z	VidaL13

VidaL1:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_1 ], R4 
				JMP 	SegueMons
VidaL2:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_2 ], R4 
				JMP 	SegueMons
VidaL3:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_3 ], R4 
				JMP 	SegueMons
VidaL4:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_4 ], R4 
				JMP 	SegueMons
VidaL5:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_5 ], R4 
				JMP 	SegueMons
VidaL6:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_6 ], R4 
				JMP 	SegueMons
VidaL7:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_7 ], R4 
				JMP 	SegueMons
VidaL8:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_8 ], R4 
				JMP 	SegueMons
VidaL9:			MOV 	R4, '.'
				MOV 	M[ R2 + linha_9 ], R4 
				JMP 	SegueMons
VidaL10:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_10 ], R4 
				JMP 	SegueMons
VidaL11:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_11 ], R4 
				JMP 	SegueMons
VidaL12:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_12 ], R4 
				JMP 	SegueMons
VidaL13:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_13 ], R4 
				JMP 	SegueMons



SegueMons:		MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]

				MOV		R3, -1d

Decrementa10Vid2:INC	R3
				CMP		R3, STOP
				JMP.Z 	ContinuaMons2
				DEC		R2
				JMP		Decrementa10Vid2



ContinuaMons2:	CMP		R1, 4d 
				JMP.Z	Vida1L1
				CMP		R1, 5d 
				JMP.Z	Vida1L2
				CMP		R1, 6d 
				JMP.Z	Vida1L3
				CMP		R1, 7d 
				JMP.Z	Vida1L4
				CMP		R1, 8d 
				JMP.Z	Vida1L5
				CMP		R1, 9d 
				JMP.Z	Vida1L6
				CMP		R1, 10d 
				JMP.Z	Vida1L7
				CMP		R1, 11d 
				JMP.Z	Vida1L8
				CMP		R1, 12d 
				JMP.Z	Vida1L9
				CMP		R1, 13d 
				JMP.Z	Vida1L10
				CMP		R1, 14d 
				JMP.Z	Vida1L11
				CMP		R1, 15d 
				JMP.Z	Vida1L12
				CMP		R1, 16d 
				JMP.Z	Vida1L13





Vida1L1:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_1 ], R4 
				JMP 	SegueMons1
Vida1L2:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_2 ], R4 
				JMP 	SegueMons1
Vida1L3:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_3 ], R4 
				JMP 	SegueMons1
Vida1L4:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_4 ], R4 
				JMP 	SegueMons1
Vida1L5:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_5 ], R4 
				JMP 	SegueMons1
Vida1L6:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_6 ], R4 
				JMP 	SegueMons1
Vida1L7:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_7 ], R4 
				JMP 	SegueMons1
Vida1L8:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_8 ], R4 
				JMP 	SegueMons1
Vida1L9:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_9 ], R4 
				JMP 	SegueMons1
Vida1L10:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_10 ], R4 
				JMP 	SegueMons1
Vida1L11:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_11 ], R4 
				JMP 	SegueMons1
Vida1L12:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_12 ], R4 
				JMP		SegueMons1
Vida1L13:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_13 ], R4 
				JMP 	SegueMons1




SegueMons1:		MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]

				MOV		R3, -1d

Decrementa10Vid3:INC	R3
				CMP		R3, STOP
				JMP.Z 	ContinuaMons3
				DEC		R2
				JMP		Decrementa10Vid3



ContinuaMons3:	CMP		R1, 4d 
				JMP.Z	Vida2L1
				CMP		R1, 5d 
				JMP.Z	Vida2L2
				CMP		R1, 6d 
				JMP.Z	Vida2L3
				CMP		R1, 7d 
				JMP.Z	Vida2L4
				CMP		R1, 8d 
				JMP.Z	Vida2L5
				CMP		R1, 9d 
				JMP.Z	Vida2L6
				CMP		R1, 10d 
				JMP.Z	Vida2L7
				CMP		R1, 11d 
				JMP.Z	Vida2L8
				CMP		R1, 12d 
				JMP.Z	Vida2L9
				CMP		R1, 13d 
				JMP.Z	Vida2L10
				CMP		R1, 14d 
				JMP.Z	Vida2L11
				CMP		R1, 15d 
				JMP.Z	Vida2L12
				CMP		R1, 16d 
				JMP.Z	Vida2L13





Vida2L1:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_1 ], R4 
				JMP 	SegueMons2
Vida2L2:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_2 ], R4 
				JMP 	SegueMons2
Vida2L3:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_3 ], R4 
				JMP 	SegueMons2
Vida2L4:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_4 ], R4 
				JMP 	SegueMons2
Vida2L5:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_5 ], R4 
				JMP 	SegueMons2
Vida2L6:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_6 ], R4 
				JMP 	SegueMons2
Vida2L7:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_7 ], R4 
				JMP 	SegueMons2
Vida2L8:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_8 ], R4 
				JMP 	SegueMons2
Vida2L9:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_9 ], R4 
				JMP 	SegueMons2
Vida2L10:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_10 ], R4 
				JMP 	SegueMons2
Vida2L11:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_11 ], R4 
				JMP 	SegueMons2
Vida2L12:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_12 ], R4 
				JMP		SegueMons2
Vida2L13:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_13 ], R4 
				JMP 	SegueMons2







SegueMons2:		MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]

				MOV		R3, -1d

Decrementa10Vid4:INC	R3
				CMP		R3, STOP
				JMP.Z 	ContinuaMons4
				DEC		R2
				JMP		Decrementa10Vid4



ContinuaMons4:	CMP		R1, 4d 
				JMP.Z	Vida3L1
				CMP		R1, 5d 
				JMP.Z	Vida3L2
				CMP		R1, 6d 
				JMP.Z	Vida3L3
				CMP		R1, 7d 
				JMP.Z	Vida3L4
				CMP		R1, 8d 
				JMP.Z	Vida3L5
				CMP		R1, 9d 
				JMP.Z	Vida3L6
				CMP		R1, 10d 
				JMP.Z	Vida3L7
				CMP		R1, 11d 
				JMP.Z	Vida3L8
				CMP		R1, 12d 
				JMP.Z	Vida3L9
				CMP		R1, 13d 
				JMP.Z	Vida3L10
				CMP		R1, 14d 
				JMP.Z	Vida3L11
				CMP		R1, 15d 
				JMP.Z	Vida3L12
				CMP		R1, 16d 
				JMP.Z	Vida3L13





Vida3L1:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_1 ], R4 
				JMP 	Seguefuncao
Vida3L2:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_2 ], R4 
				JMP 	Seguefuncao
Vida3L3:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_3 ], R4 
				JMP 	Seguefuncao
Vida3L4:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_4 ], R4 
				JMP 	Seguefuncao
Vida3L5:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_5 ], R4 
				JMP 	Seguefuncao
Vida3L6:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_6 ], R4 
				JMP 	Seguefuncao
Vida3L7:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_7 ], R4 
				JMP 	Seguefuncao
Vida3L8:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_8 ], R4 
				JMP 	Seguefuncao
Vida3L9:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_9 ], R4 
				JMP 	Seguefuncao
Vida3L10:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_10 ], R4 
				JMP 	Seguefuncao
Vida3L11:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_11 ], R4 
				JMP 	Seguefuncao
Vida3L12:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_12 ], R4 
				JMP		Seguefuncao
Vida3L13:		MOV 	R4, '.'
				MOV 	M[ R2 + linha_13 ], R4 
				JMP 	Seguefuncao











Seguefuncao:	MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, '.'
				MOV		M[ WRITE ], R3

				MOV 	R1, 6d
				MOV 	R2, 26d
				MOV		M[ Linha_Monstro1 ], R1
				MOV		M[ Column_Monstro1 ], R2
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, 'M'
				MOV		M[ WRITE ], R3
				MOV 	R1, DIR_PARADO
				MOV 	M[ Direcao_Monstro1 ], R1
				

				MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, '.'
				MOV		M[ WRITE ], R3

				MOV 	R1, 14d
				MOV 	R2, 14d
				MOV		M[ Linha_Monstro2 ], R1
				MOV		M[ Column_Monstro2 ], R2
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, 'M'
				MOV		M[ WRITE ], R3
				MOV 	R1, DIR_PARADO
				MOV 	M[ Direcao_Monstro2 ], R1



				MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, '.'
				MOV		M[ WRITE ], R3

				MOV 	R1, 6d
				MOV 	R2, 14d
				MOV		M[ Linha_Monstro3 ], R1
				MOV		M[ Column_Monstro3 ], R2
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, 'M'
				MOV		M[ WRITE ], R3
				MOV 	R1, DIR_PARADO
				MOV 	M[ Direcao_Monstro3 ], R1



				MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, '.'
				MOV		M[ WRITE ], R3

				MOV 	R1, 14d
				MOV 	R2, 26d
				MOV		M[ Linha_Monstro4 ], R1
				MOV		M[ Column_Monstro4 ], R2
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, 'M'
				MOV		M[ WRITE ], R3
				MOV 	R1, DIR_PARADO
				MOV 	M[ Direcao_Monstro4 ], R1





				MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, '.'
				MOV		M[ WRITE ], R3

				MOV 	R1, 9d
				MOV 	R2, 20d
				MOV		M[ Linha_pacman ], R1
				MOV		M[ Colum_Pacman ], R2
				SHL 	R1, 8
				OR 		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, '@'
				MOV		M[ WRITE ], R3
				MOV 	R1, DIR_PARADO
				MOV 	M[ Direcao_Pacman ], R1



SegueVida:		MOV 	R1, 2d
				CMP 	M[ Contador_Vidas ], R1 
				JMP.Z 	DuasVidas
				MOV 	R1, 1d
				CMP 	M[ Contador_Vidas ], R1
				JMP.Z 	UmaVida
				MOV 	R1, 0d
				CMP 	M[ Contador_Vidas ], R1
				JMP.Z 	ZeroVidas

DuasVidas:		MOV 	R1, 23d
				MOV 	M[ Vidas_End ], R1 
				;CALL 	Mapa
				JMP 	EndPerdeVida

UmaVida:		MOV 	R1, 19d
				MOV 	M[ Vidas_End ], R1 
				;CALL 	Mapa
				JMP 	EndPerdeVida

ZeroVidas:		MOV 	R1, 16d
				MOV 	M[ Vidas_End ], R1 
				;CALL 	Mapa
				MOV 	R1, 0d
				MOV 	M[ TimerAtivado ], R1
				MOV 	R2, 35d
				MOV 	R4, 0d

Loop19:			MOV		R1, 9d
				CMP		R2, 44d
				JMP.Z	EndPerdeVida
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		R3, M[ R4 + game_over ]
				MOV		M[ WRITE ], R3
				INC		R2
				INC		R4
				JMP		Loop19


				
				
EndPerdeVida:	POP 	R4
				POP 	R3
				POP 	R2
				POP 	R1
				RET



;------------------------------------------------------------------------------
; FUNCTION MovEsquerda
;------------------------------------------------------------------------------

MovEsquerda:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH	R7


LoopMovEsq:		MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				JMP		CompareEsq

FicarParadoEsq:	MOV		R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Pacman ], R1
				JMP		EndMovEsq



VoltaEsq:		MOV		R3, ' '
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Colum_Pacman ]
				MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				MOV		R3, '@'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3


EndMovEsq:		POP		R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET





;------------------------------------------------------------------------------
; FUNCTION CompareEsq
;------------------------------------------------------------------------------

CompareEsq:		MOV		R4, M[ Colum_Pacman ]
				MOV		R5, '#'
				MOV		R7, '.'
				MOV		R6, -2d


Decrementa10Esq:INC		R6
				CMP		R6, STOP
				JMP.Z 	ContinuaEsq
				DEC		R4
				JMP		Decrementa10Esq
			


ContinuaEsq:	CMP		R1, 3d 
				JMP.Z	CompareEsqL0
				CMP		R1, 4d 
				JMP.Z	CompareEsqL1
				CMP		R1, 5d 
				JMP.Z	CompareEsqL2
				CMP		R1, 6d 
				JMP.Z	CompareEsqL3
				CMP		R1, 7d 
				JMP.Z	CompareEsqL4
				CMP		R1, 8d 
				JMP.Z	CompareEsqL5
				CMP		R1, 9d 
				JMP.Z	CompareEsqL6
				CMP		R1, 10d 
				JMP.Z	CompareEsqL7
				CMP		R1, 11d 
				JMP.Z	CompareEsqL8
				CMP		R1, 12d 
				JMP.Z	CompareEsqL9
				CMP		R1, 13d 
				JMP.Z	CompareEsqL10
				CMP		R1, 14d 
				JMP.Z	CompareEsqL11
				CMP		R1, 15d 
				JMP.Z	CompareEsqL12
				CMP		R1, 16d 
				JMP.Z	CompareEsqL13
				CMP		R1, 17d 
				JMP.Z	CompareEsqL14

CompareEsqL0:	CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_0 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_0 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_0 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL1:	CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_1 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_1 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_1 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL2:	CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_2 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_2 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_2 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL3:	CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_3 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_3 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_3 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL4:	CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_4 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_4 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_4 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL5:	CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_5 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_5 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_5 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL6:	CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_6 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_6 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_6 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL7:	CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_7 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_7 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_7 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL8:	CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_8 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_8 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_8 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL9:	CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_9 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_9 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_9 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL10:	CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_10 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_10 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_10 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL11:	CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_11 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_11 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_11 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL12:	CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_12 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_12 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_12 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL13:	CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_13 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_13 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_13 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq
CompareEsqL14:	CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoEsq
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_14 ]
				JMP.Z 	PerdeVidaEsq

				MOV		R6, ' '
				INC		R4
				MOV		M[ R4 + linha_14 ], R6
				DEC		R4 
				CMP		R7, M[ R4 + linha_14 ]
				JMP.Z 	IncrementaPonto1
				JMP		VoltaEsq

IncrementaPonto1:INC	M[ Pontos ]
				JMP		VoltaEsq

PerdeVidaEsq:	DEC 	M[ Contador_Vidas ]
				CALL 	PerdeVida 
				JMP 	EndMovEsq



;------------------------------------------------------------------------------
; FUNCTION MovDireita
;------------------------------------------------------------------------------

MovDireita:		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH	R7


LoopMovDir:		MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				JMP		CompareDir

FicarParadoDir:	MOV		R1, DIR_PARADO
				MOV		M[ Direcao_Pacman ], R1
				JMP		EndMovDir

VoltaDir:		MOV		R3, ' '
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Colum_Pacman ]
				MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				MOV		R3, '@'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovDir:		POP		R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareDir
;------------------------------------------------------------------------------

CompareDir:		MOV		R4, M[ Colum_Pacman ]
				MOV		R5, '#'
				MOV		R7, '.'
				MOV		R6, 0d


Decrementa10Dir:INC		R6
				CMP		R6, STOP
				JMP.Z 	ContinuaDir
				DEC		R4
				JMP		Decrementa10Dir
			


ContinuaDir:	CMP		R1, 3d 
				JMP.Z	CompareDirL0
				CMP		R1, 4d 
				JMP.Z	CompareDirL1
				CMP		R1, 5d 
				JMP.Z	CompareDirL2
				CMP		R1, 6d 
				JMP.Z	CompareDirL3
				CMP		R1, 7d 
				JMP.Z	CompareDirL4
				CMP		R1, 8d 
				JMP.Z	CompareDirL5
				CMP		R1, 9d 
				JMP.Z	CompareDirL6
				CMP		R1, 10d 
				JMP.Z	CompareDirL7
				CMP		R1, 11d 
				JMP.Z	CompareDirL8
				CMP		R1, 12d 
				JMP.Z	CompareDirL9
				CMP		R1, 13d 
				JMP.Z	CompareDirL10
				CMP		R1, 14d 
				JMP.Z	CompareDirL11
				CMP		R1, 15d 
				JMP.Z	CompareDirL12
				CMP		R1, 16d 
				JMP.Z	CompareDirL13
				CMP		R1, 17d 
				JMP.Z	CompareDirL14

CompareDirL0:	CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_0 ]
				JMP.Z 	PerdeVidaDir


				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_0 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_0 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL1:	CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_1 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_1 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_1 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL2:	CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_2 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_2 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_2 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL3:	CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_3 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_3 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_3 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL4:	CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_4 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_4 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_4 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL5:	CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_5 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_5 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_5 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL6:	CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_6 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_6 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_6 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL7:	CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_7 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_7 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_7 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL8:	CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_8 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_8 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_8 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL9:	CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_9 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_9 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_9 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL10:	CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_10 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_10 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_10 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL11:	CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_11 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_11 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_11 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL12:	CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_12 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_12 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_12 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL13:	CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoDir
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_13 ]
				JMP.Z 	PerdeVidaDir

				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_13 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_13 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir
CompareDirL14:	CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoDir
				MOV		R6, ' '
				DEC		R4
				MOV		M[ R4 + linha_0 ], R6
				INC		R4 
				CMP		R7, M[ R4 + linha_0 ]
				JMP.Z 	IncrementaPonto2
				JMP		VoltaDir

IncrementaPonto2:INC	M[ Pontos ]
				JMP		VoltaDir

PerdeVidaDir:	DEC 	M[ Contador_Vidas ]
				CALL 	PerdeVida 
				JMP 	EndMovDir


;------------------------------------------------------------------------------
; FUNCTION MovCima
;------------------------------------------------------------------------------

MovCima:		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH	R7


LoopMovCima:	MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				JMP		CompareCima

FicarParadoCima:MOV		R1, DIR_PARADO
				MOV		M[ Direcao_Pacman ], R1
				JMP		EndMovCima

VoltaCima:		MOV		R3, ' '
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Linha_pacman ]
				MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				MOV		R3, '@'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovCima:		POP		R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareCima
;------------------------------------------------------------------------------

CompareCima:	MOV		R4, M[ Colum_Pacman ]
				MOV		R5, '#'
				MOV		R7, '.'
				MOV		R6, -1d


Decrementa10Cim:INC		R6
				CMP		R6, STOP
				JMP.Z 	ContinuaCima
				DEC		R4
				JMP		Decrementa10Cim
			


ContinuaCima:	CMP		R1, 3d 
				JMP.Z	CompareCimaL0
				CMP		R1, 4d 
				JMP.Z	CompareCimaL1
				CMP		R1, 5d 
				JMP.Z	CompareCimaL2
				CMP		R1, 6d 
				JMP.Z	CompareCimaL3
				CMP		R1, 7d 
				JMP.Z	CompareCimaL4
				CMP		R1, 8d 
				JMP.Z	CompareCimaL5
				CMP		R1, 9d 
				JMP.Z	CompareCimaL6
				CMP		R1, 10d 
				JMP.Z	CompareCimaL7
				CMP		R1, 11d 
				JMP.Z	CompareCimaL8
				CMP		R1, 12d 
				JMP.Z	CompareCimaL9
				CMP		R1, 13d 
				JMP.Z	CompareCimaL10
				CMP		R1, 14d 
				JMP.Z	CompareCimaL11
				CMP		R1, 15d 
				JMP.Z	CompareCimaL12
				CMP		R1, 16d 
				JMP.Z	CompareCimaL13
				CMP		R1, 17d 
				JMP.Z	CompareCimaL14

CompareCimaL0:	CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_0 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_0 ]
				MOV		M[ R4 + linha_0 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL1:	CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_0 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_0 ]
				MOV		M[ R4 + linha_1 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL2:	CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_1 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_1 ]
				MOV		M[ R4 + linha_1 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL3:	CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_2 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_2 ]
				MOV		M[ R4 + linha_2 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL4:	CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_3 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_3 ]
				MOV		M[ R4 + linha_3 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL5:	CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_4 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_4 ]
				MOV		M[ R4 + linha_4 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL6:	CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_5 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_5 ]
				MOV		M[ R4 + linha_5 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL7:	CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_6 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_6 ]
				MOV		M[ R4 + linha_6 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL8:	CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_7 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_7 ]
				MOV		M[ R4 + linha_7 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL9:	CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_8 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_8 ]
				MOV		M[ R4 + linha_8 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL10:	CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_9 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_9 ]
				MOV		M[ R4 + linha_9 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL11:	CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_10 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_10 ]
				MOV		M[ R4 + linha_10 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL12:	CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_11 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_11 ]
				MOV		M[ R4 + linha_11 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL13:	CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoCima
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_12 ]
				JMP.Z 	PerdeVidaCima

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_12 ]
				MOV		M[ R4 + linha_12 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima
CompareCimaL14:	CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCima
				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_0 ]
				MOV		M[ R4 + linha_0 ], R6
				JMP.Z 	IncrementaPonto3
				JMP		VoltaCima

IncrementaPonto3:INC	M[ Pontos ]
				JMP		VoltaCima


PerdeVidaCima:	DEC 	M[ Contador_Vidas ]
				CALL 	PerdeVida 
				JMP 	EndMovCima



;------------------------------------------------------------------------------
; FUNCTION MovBaixo
;------------------------------------------------------------------------------

MovBaixo:		PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH	R7


LoopMovBaixo:	MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				JMP		CompareBaixo

FicarParadoBaixo:MOV	R1, DIR_PARADO
				MOV		M[ Direcao_Pacman ], R1
				JMP		EndMovBaixo

VoltaBaixo:		MOV		R3, ' '
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Linha_pacman ]
				MOV 	R1, M[ Linha_pacman ]
				MOV 	R2, M[ Colum_Pacman ]
				MOV		R3, '@'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovBaixo:	POP		R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareBaixo
;------------------------------------------------------------------------------

CompareBaixo:	MOV		R4, M[ Colum_Pacman ]
				MOV		R5, '#'
				MOV		R7, '.'
				MOV		R6, -1d


Decrementa10Bai:INC		R6
				CMP		R6, STOP
				JMP.Z 	ContinuaBaixo
				DEC		R4
				JMP		Decrementa10Bai
			


ContinuaBaixo:	CMP		R1, 3d 
				JMP.Z	CompareBaixoL0
				CMP		R1, 4d 
				JMP.Z	CompareBaixoL1
				CMP		R1, 5d 
				JMP.Z	CompareBaixoL2
				CMP		R1, 6d 
				JMP.Z	CompareBaixoL3
				CMP		R1, 7d 
				JMP.Z	CompareBaixoL4
				CMP		R1, 8d 
				JMP.Z	CompareBaixoL5
				CMP		R1, 9d 
				JMP.Z	CompareBaixoL6
				CMP		R1, 10d 
				JMP.Z	CompareBaixoL7
				CMP		R1, 11d 
				JMP.Z	CompareBaixoL8
				CMP		R1, 12d 
				JMP.Z	CompareBaixoL9
				CMP		R1, 13d 
				JMP.Z	CompareBaixoL10
				CMP		R1, 14d 
				JMP.Z	CompareBaixoL11
				CMP		R1, 15d 
				JMP.Z	CompareBaixoL12
				CMP		R1, 16d 
				JMP.Z	CompareBaixoL13
				CMP		R1, 17d 
				JMP.Z	CompareBaixoL14

CompareBaixoL0:	CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_0 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_0 ]
				MOV		M[ R4 + linha_0 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL1:	CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_2 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_2 ]
				MOV		M[ R4 + linha_2 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL2:	CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_3 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_3 ]
				MOV		M[ R4 + linha_3 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL3:	CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_4 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_4 ]
				MOV		M[ R4 + linha_4 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL4:	CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_5 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_5 ]
				MOV		M[ R4 + linha_5 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL5:	CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_6 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_6 ]
				MOV		M[ R4 + linha_6 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL6:	CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_7 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_7 ]
				MOV		M[ R4 + linha_7 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL7:	CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_8 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_8 ]
				MOV		M[ R4 + linha_8 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL8:	CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_9 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_9 ]
				MOV		M[ R4 + linha_9 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL9:	CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_10 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_10 ]
				MOV		M[ R4 + linha_10 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL10:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_11 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_11 ]
				MOV		M[ R4 + linha_11 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL11:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_12 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_12 ]
				MOV		M[ R4 + linha_12 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL12:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_13 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_13 ]
				MOV		M[ R4 + linha_13 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL13:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixo
				MOV 	R6, 'M'
				CMP 	R6, M[ R4 + linha_14 ]
				JMP.Z 	PerdeVidaBaixo

				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_14 ]
				MOV		M[ R4 + linha_13 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo
CompareBaixoL14:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoBaixo
				MOV		R6, ' '
				CMP		R7, M[ R4 + linha_0 ]
				MOV		M[ R4 + linha_0 ], R6
				JMP.Z 	IncrementaPonto4
				JMP		VoltaBaixo


IncrementaPonto4:INC	M[ Pontos ]
				JMP		VoltaBaixo


PerdeVidaBaixo:	DEC 	M[ Contador_Vidas ]
				CALL 	PerdeVida 
				JMP 	EndMovBaixo



;------------------------------------------------------------------------------
; FUNCTION MovMonstroEsq1
;------------------------------------------------------------------------------

MovMonstroEsq1:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovEsqMon1:	MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				JMP		CompareEsqMonstro1

FicarParadoEsqMon1:MOV	R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Monstro1 ], R1
				JMP		EndMovEsqMonstro1



VoltaEsqMon1:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons1esq
Retornaesq1:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Column_Monstro1]
				MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3


EndMovEsqMonstro1:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareEsqMonstro1
;------------------------------------------------------------------------------

CompareEsqMonstro1:MOV	R4, M[ Column_Monstro1 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -2d


Decrementa10EsqMon1:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaEsqMon1
				DEC		R4
				JMP		Decrementa10EsqMon1
			


ContinuaEsqMon1:	CMP		R1, 3d 
				JMP.Z	CompareEsqMon1L0
				CMP		R1, 4d 
				JMP.Z	CompareEsqMon1L1
				CMP		R1, 5d 
				JMP.Z	CompareEsqMon1L2
				CMP		R1, 6d 
				JMP.Z	CompareEsqMon1L3
				CMP		R1, 7d 
				JMP.Z	CompareEsqMon1L4
				CMP		R1, 8d 
				JMP.Z	CompareEsqMon1L5
				CMP		R1, 9d 
				JMP.Z	CompareEsqMon1L6
				CMP		R1, 10d 
				JMP.Z	CompareEsqMon1L7
				CMP		R1, 11d 
				JMP.Z	CompareEsqMon1L8
				CMP		R1, 12d 
				JMP.Z	CompareEsqMon1L9
				CMP		R1, 13d 
				JMP.Z	CompareEsqMon1L10
				CMP		R1, 14d 
				JMP.Z	CompareEsqMon1L11
				CMP		R1, 15d 
				JMP.Z	CompareEsqMon1L12
				CMP		R1, 16d 
				JMP.Z	CompareEsqMon1L13
				CMP		R1, 17d 
				JMP.Z	CompareEsqMon1L14

CompareEsqMon1L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				INC 	R4 
				MOV 	M[ R4 + linha_0 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_0 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L1:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
RetornatrocaR6:INC 	R4 
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L2:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L3:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L4:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L5:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L6:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L7:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L8:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L9:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L10:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L11:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L12:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L13:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4  
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaEsqMon1
CompareEsqMon1L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6
				INC 	R4
				MOV 	R6, '.'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaEsqMon1


Mons1esq: 		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornaesq1


;------------------------------------------------------------------------------
; FUNCTION trocaR6
;------------------------------------------------------------------------------


trocaR6:		MOV 	R6, '.'
				RET






;------------------------------------------------------------------------------
; FUNCTION MovMonstroDir1
;------------------------------------------------------------------------------

MovMonstroDir1:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovDirMon1:	MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				JMP		CompareDirMonstro1

FicarParadoDirMon1:MOV	R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Monstro1 ], R1
				JMP		EndMovDirMonstro1

VoltaDirMon1:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons1dir
Retornadir1:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Column_Monstro1 ]
				MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovDirMonstro1:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareDirMonstro1
;------------------------------------------------------------------------------

CompareDirMonstro1:MOV	R4, M[ Column_Monstro1 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, 0d


Decrementa10DirMon1:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaDirMon1
				DEC		R4
				JMP		Decrementa10DirMon1
			


ContinuaDirMon1:CMP		R1, 3d 
				JMP.Z	CompareDirMon1L0
				CMP		R1, 4d 
				JMP.Z	CompareDirMon1L1
				CMP		R1, 5d 
				JMP.Z	CompareDirMon1L2
				CMP		R1, 6d 
				JMP.Z	CompareDirMon1L3
				CMP		R1, 7d 
				JMP.Z	CompareDirMon1L4
				CMP		R1, 8d 
				JMP.Z	CompareDirMon1L5
				CMP		R1, 9d 
				JMP.Z	CompareDirMon1L6
				CMP		R1, 10d 
				JMP.Z	CompareDirMon1L7
				CMP		R1, 11d 
				JMP.Z	CompareDirMon1L8
				CMP		R1, 12d 
				JMP.Z	CompareDirMon1L9
				CMP		R1, 13d 
				JMP.Z	CompareDirMon1L10
				CMP		R1, 14d 
				JMP.Z	CompareDirMon1L11
				CMP		R1, 15d 
				JMP.Z	CompareDirMon1L12
				CMP		R1, 16d 
				JMP.Z	CompareDirMon1L13
				CMP		R1, 17d 
				JMP.Z	CompareDirMon1L14

CompareDirMon1L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_0 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_0 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L1:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L2:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L3:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L4:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L5:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L6:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L7:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L8:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L9:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L10:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L11:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L12:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L13:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaDirMon1
CompareDirMon1L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6
				DEC 	R4
				MOV 	R6, '.'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaDirMon1

Mons1dir:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornadir1





;------------------------------------------------------------------------------
; FUNCTION MovMonstroCima1
;------------------------------------------------------------------------------

MovMonstroCima1:PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovCimaMon1:	MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				JMP		CompareCimaMonstro1

FicarParadoCimaMon1:MOV		R1, DIR_PARADO
				MOV		M[ Direcao_Monstro1 ], R1
				JMP		EndMovCimaMonstro1

VoltaCimaMon1:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons1cima
Retornacima1:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Linha_Monstro1 ]
				MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovCimaMonstro1:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareCimaMonstro1
;------------------------------------------------------------------------------

CompareCimaMonstro1:MOV	R4, M[ Column_Monstro1 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -1d


Decrementa10CimMon1:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaCimaMon1
				DEC		R4
				JMP		Decrementa10CimMon1
			


ContinuaCimaMon1:CMP		R1, 3d 
				JMP.Z	CompareCimaMon1L0
				CMP		R1, 4d 
				JMP.Z	CompareCimaMon1L1
				CMP		R1, 5d 
				JMP.Z	CompareCimaMon1L2
				CMP		R1, 6d 
				JMP.Z	CompareCimaMon1L3
				CMP		R1, 7d 
				JMP.Z	CompareCimaMon1L4
				CMP		R1, 8d 
				JMP.Z	CompareCimaMon1L5
				CMP		R1, 9d 
				JMP.Z	CompareCimaMon1L6
				CMP		R1, 10d 
				JMP.Z	CompareCimaMon1L7
				CMP		R1, 11d 
				JMP.Z	CompareCimaMon1L8
				CMP		R1, 12d 
				JMP.Z	CompareCimaMon1L9
				CMP		R1, 13d 
				JMP.Z	CompareCimaMon1L10
				CMP		R1, 14d 
				JMP.Z	CompareCimaMon1L11
				CMP		R1, 15d 
				JMP.Z	CompareCimaMon1L12
				CMP		R1, 16d 
				JMP.Z	CompareCimaMon1L13
				CMP		R1, 17d 
				JMP.Z	CompareCimaMon1L14

CompareCimaMon1L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L1:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L2:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L3:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L4:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L5:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L6:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L7:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L8:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L9:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L10:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L11:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L12:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L13:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaCimaMon1
CompareCimaMon1L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaCimaMon1


Mons1cima:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7 
				JMP 	Retornacima1




;------------------------------------------------------------------------------
; FUNCTION MovMonstroBaixo1
;------------------------------------------------------------------------------

MovMonstroBaixo1:PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovBaixoMon1:MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				JMP		CompareBaixoMonstro1

FicarParadoBaixoMon1:MOV	R1, DIR_PARADO
				MOV		M[ Direcao_Monstro1 ], R1
				JMP		EndMovBaixoMonstro1

VoltaBaixoMon1:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons1baixo
Retornabaixo1:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Linha_Monstro1 ]
				MOV 	R1, M[ Linha_Monstro1 ]
				MOV 	R2, M[ Column_Monstro1 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovBaixoMonstro1:POP R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareBaixoMonstro1
;------------------------------------------------------------------------------

CompareBaixoMonstro1:MOV	R4, M[ Column_Monstro1 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -1d


Decrementa10BaiMon1:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaBaixoMon1
				DEC		R4
				JMP		Decrementa10BaiMon1
			


ContinuaBaixoMon1:CMP	R1, 3d 
				JMP.Z	CompareBaixoMon1L0
				CMP		R1, 4d 
				JMP.Z	CompareBaixoMon1L1
				CMP		R1, 5d 
				JMP.Z	CompareBaixoMon1L2
				CMP		R1, 6d 
				JMP.Z	CompareBaixoMon1L3
				CMP		R1, 7d 
				JMP.Z	CompareBaixoMon1L4
				CMP		R1, 8d 
				JMP.Z	CompareBaixoMon1L5
				CMP		R1, 9d 
				JMP.Z	CompareBaixoMon1L6
				CMP		R1, 10d 
				JMP.Z	CompareBaixoMon1L7
				CMP		R1, 11d 
				JMP.Z	CompareBaixoMon1L8
				CMP		R1, 12d 
				JMP.Z	CompareBaixoMon1L9
				CMP		R1, 13d 
				JMP.Z	CompareBaixoMon1L10
				CMP		R1, 14d 
				JMP.Z	CompareBaixoMon1L11
				CMP		R1, 15d 
				JMP.Z	CompareBaixoMon1L12
				CMP		R1, 16d 
				JMP.Z	CompareBaixoMon1L13
				CMP		R1, 17d 
				JMP.Z	CompareBaixoMon1L14

CompareBaixoMon1L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L1:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L2:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L3:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L4:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L5:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L6:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L7:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L8:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L9:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L10:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L11:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L12:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt1 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L13:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaBaixoMon1
CompareBaixoMon1L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaBaixoMon1


Mons1baixo: 	MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornabaixo1




;------------------------------------------------------------------------------
; FUNCTION MovMonstroEsq2
;------------------------------------------------------------------------------

MovMonstroEsq2:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovEsqMon2:	MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				JMP		CompareEsqMonstro2

FicarParadoEsqMon2:MOV	R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Monstro2 ], R1
				JMP		EndMovEsqMonstro2



VoltaEsqMon2:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons2esq
Retornaesq2:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Column_Monstro2]
				MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3


EndMovEsqMonstro2:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareEsqMonstro2
;------------------------------------------------------------------------------

CompareEsqMonstro2:MOV	R4, M[ Column_Monstro2 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -2d


Decrementa10EsqMon2:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaEsqMon2
				DEC		R4
				JMP		Decrementa10EsqMon2
			


ContinuaEsqMon2:	CMP		R1, 3d 
				JMP.Z	CompareEsqMon2L0
				CMP		R1, 4d 
				JMP.Z	CompareEsqMon2L1
				CMP		R1, 5d 
				JMP.Z	CompareEsqMon2L2
				CMP		R1, 6d 
				JMP.Z	CompareEsqMon2L3
				CMP		R1, 7d 
				JMP.Z	CompareEsqMon2L4
				CMP		R1, 8d 
				JMP.Z	CompareEsqMon2L5
				CMP		R1, 9d 
				JMP.Z	CompareEsqMon2L6
				CMP		R1, 10d 
				JMP.Z	CompareEsqMon2L7
				CMP		R1, 11d 
				JMP.Z	CompareEsqMon2L8
				CMP		R1, 12d 
				JMP.Z	CompareEsqMon2L9
				CMP		R1, 13d 
				JMP.Z	CompareEsqMon2L10
				CMP		R1, 14d 
				JMP.Z	CompareEsqMon2L11
				CMP		R1, 15d 
				JMP.Z	CompareEsqMon2L12
				CMP		R1, 16d 
				JMP.Z	CompareEsqMon2L13
				CMP		R1, 17d 
				JMP.Z	CompareEsqMon2L14

CompareEsqMon2L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_0 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_0 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L1:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L2:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L3:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L4:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L5:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L6:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L7:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L8:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L9:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L10:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L11:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L12:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L13:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaEsqMon2
CompareEsqMon2L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoEsqMon2
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaEsqMon2


Mons2esq: 		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornaesq2






;------------------------------------------------------------------------------
; FUNCTION MovMonstroDir2
;------------------------------------------------------------------------------

MovMonstroDir2:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovDirMon2:	MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				JMP		CompareDirMonstro2

FicarParadoDirMon2:MOV	R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Monstro2 ], R1
				JMP		EndMovDirMonstro2

VoltaDirMon2:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons2dir
Retornadir2:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Column_Monstro2 ]
				MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovDirMonstro2:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareDirMonstro2
;------------------------------------------------------------------------------

CompareDirMonstro2:MOV	R4, M[ Column_Monstro2 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, 0d


Decrementa10DirMon2:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaDirMon2
				DEC		R4
				JMP		Decrementa10DirMon2
			


ContinuaDirMon2:CMP		R1, 3d 
				JMP.Z	CompareDirMon2L0
				CMP		R1, 4d 
				JMP.Z	CompareDirMon2L1
				CMP		R1, 5d 
				JMP.Z	CompareDirMon2L2
				CMP		R1, 6d 
				JMP.Z	CompareDirMon2L3
				CMP		R1, 7d 
				JMP.Z	CompareDirMon2L4
				CMP		R1, 8d 
				JMP.Z	CompareDirMon2L5
				CMP		R1, 9d 
				JMP.Z	CompareDirMon2L6
				CMP		R1, 10d 
				JMP.Z	CompareDirMon2L7
				CMP		R1, 11d 
				JMP.Z	CompareDirMon2L8
				CMP		R1, 12d 
				JMP.Z	CompareDirMon2L9
				CMP		R1, 13d 
				JMP.Z	CompareDirMon2L10
				CMP		R1, 14d 
				JMP.Z	CompareDirMon2L11
				CMP		R1, 15d 
				JMP.Z	CompareDirMon2L12
				CMP		R1, 16d 
				JMP.Z	CompareDirMon2L13
				CMP		R1, 17d 
				JMP.Z	CompareDirMon2L14

CompareDirMon2L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_0 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_0 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L1:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L2:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L3:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L4:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L5:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L6:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L7:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L8:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L9:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L10:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L11:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L12:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L13:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaDirMon2
CompareDirMon2L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoDirMon2
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaDirMon2



Mons2dir: 		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornadir2




;------------------------------------------------------------------------------
; FUNCTION MovMonstroCima2
;------------------------------------------------------------------------------

MovMonstroCima2:PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovCimaMon2:	MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				JMP		CompareCimaMonstro2

FicarParadoCimaMon2:MOV		R1, DIR_PARADO
				MOV		M[ Direcao_Monstro2 ], R1
				JMP		EndMovCimaMonstro2

VoltaCimaMon2:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons2cima
Retornacima2:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Linha_Monstro2 ]
				MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovCimaMonstro2:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareCimaMonstro2
;------------------------------------------------------------------------------

CompareCimaMonstro2:MOV	R4, M[ Column_Monstro2 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -1d


Decrementa10CimMon2:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaCimaMon2
				DEC		R4
				JMP		Decrementa10CimMon2
			


ContinuaCimaMon2:CMP		R1, 3d 
				JMP.Z	CompareCimaMon2L0
				CMP		R1, 4d 
				JMP.Z	CompareCimaMon2L1
				CMP		R1, 5d 
				JMP.Z	CompareCimaMon2L2
				CMP		R1, 6d 
				JMP.Z	CompareCimaMon2L3
				CMP		R1, 7d 
				JMP.Z	CompareCimaMon2L4
				CMP		R1, 8d 
				JMP.Z	CompareCimaMon2L5
				CMP		R1, 9d 
				JMP.Z	CompareCimaMon2L6
				CMP		R1, 10d 
				JMP.Z	CompareCimaMon2L7
				CMP		R1, 11d 
				JMP.Z	CompareCimaMon2L8
				CMP		R1, 12d 
				JMP.Z	CompareCimaMon2L9
				CMP		R1, 13d 
				JMP.Z	CompareCimaMon2L10
				CMP		R1, 14d 
				JMP.Z	CompareCimaMon2L11
				CMP		R1, 15d 
				JMP.Z	CompareCimaMon2L12
				CMP		R1, 16d 
				JMP.Z	CompareCimaMon2L13
				CMP		R1, 17d 
				JMP.Z	CompareCimaMon2L14

CompareCimaMon2L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L1:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L2:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L3:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L4:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L5:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L6:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L7:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L8:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L9:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L10:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L11:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L12:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L13:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaCimaMon2
CompareCimaMon2L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoCimaMon2
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaCimaMon2



Mons2cima:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornacima2







;------------------------------------------------------------------------------
; FUNCTION MovMonstroBaixo2
;------------------------------------------------------------------------------

MovMonstroBaixo2:PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7



LoopMovBaixoMon2:MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				JMP		CompareBaixoMonstro2

FicarParadoBaixoMon2:MOV	R1, DIR_PARADO
				MOV		M[ Direcao_Monstro2 ], R1
				JMP		EndMovBaixoMonstro2

VoltaBaixoMon2:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons2baixo
Retornabaixo2:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Linha_Monstro2 ]
				MOV 	R1, M[ Linha_Monstro2 ]
				MOV 	R2, M[ Column_Monstro2 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovBaixoMonstro2:POP R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareBaixoMonstro2
;------------------------------------------------------------------------------

CompareBaixoMonstro2:MOV	R4, M[ Column_Monstro2 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -1d


Decrementa10BaiMon2:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaBaixoMon2
				DEC		R4
				JMP		Decrementa10BaiMon2
			


ContinuaBaixoMon2:CMP	R1, 3d 
				JMP.Z	CompareBaixoMon2L0
				CMP		R1, 4d 
				JMP.Z	CompareBaixoMon2L1
				CMP		R1, 5d 
				JMP.Z	CompareBaixoMon2L2
				CMP		R1, 6d 
				JMP.Z	CompareBaixoMon2L3
				CMP		R1, 7d 
				JMP.Z	CompareBaixoMon2L4
				CMP		R1, 8d 
				JMP.Z	CompareBaixoMon2L5
				CMP		R1, 9d 
				JMP.Z	CompareBaixoMon2L6
				CMP		R1, 10d 
				JMP.Z	CompareBaixoMon2L7
				CMP		R1, 11d 
				JMP.Z	CompareBaixoMon2L8
				CMP		R1, 12d 
				JMP.Z	CompareBaixoMon2L9
				CMP		R1, 13d 
				JMP.Z	CompareBaixoMon2L10
				CMP		R1, 14d 
				JMP.Z	CompareBaixoMon2L11
				CMP		R1, 15d 
				JMP.Z	CompareBaixoMon2L12
				CMP		R1, 16d 
				JMP.Z	CompareBaixoMon2L13
				CMP		R1, 17d 
				JMP.Z	CompareBaixoMon2L14

CompareBaixoMon2L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L1:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L2:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L3:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L4:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L5:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L6:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L7:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L8:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L9:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L10:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L11:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L12:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, M[ ConteudoAnt2 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt2 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L13:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaBaixoMon2
CompareBaixoMon2L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixoMon2
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaBaixoMon2

				

Mons2baixo:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornabaixo2






;------------------------------------------------------------------------------
; FUNCTION MovMonstroEsq3
;------------------------------------------------------------------------------

MovMonstroEsq3:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovEsqMon3:	MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				JMP		CompareEsqMonstro3

FicarParadoEsqMon3:MOV	R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Monstro3 ], R1
				JMP		EndMovEsqMonstro3



VoltaEsqMon3:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons3esq
Retornaesq3:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Column_Monstro3]
				MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3


EndMovEsqMonstro3:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareEsqMonstro3
;------------------------------------------------------------------------------

CompareEsqMonstro3:MOV	R4, M[ Column_Monstro3 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -2d


Decrementa10EsqMon3:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaEsqMon3
				DEC		R4
				JMP		Decrementa10EsqMon3
			


ContinuaEsqMon3:	CMP		R1, 3d 
				JMP.Z	CompareEsqMon3L0
				CMP		R1, 4d 
				JMP.Z	CompareEsqMon3L1
				CMP		R1, 5d 
				JMP.Z	CompareEsqMon3L2
				CMP		R1, 6d 
				JMP.Z	CompareEsqMon3L3
				CMP		R1, 7d 
				JMP.Z	CompareEsqMon3L4
				CMP		R1, 8d 
				JMP.Z	CompareEsqMon3L5
				CMP		R1, 9d 
				JMP.Z	CompareEsqMon3L6
				CMP		R1, 10d 
				JMP.Z	CompareEsqMon3L7
				CMP		R1, 11d 
				JMP.Z	CompareEsqMon3L8
				CMP		R1, 12d 
				JMP.Z	CompareEsqMon3L9
				CMP		R1, 13d 
				JMP.Z	CompareEsqMon3L10
				CMP		R1, 14d 
				JMP.Z	CompareEsqMon3L11
				CMP		R1, 15d 
				JMP.Z	CompareEsqMon3L12
				CMP		R1, 16d 
				JMP.Z	CompareEsqMon3L13
				CMP		R1, 17d 
				JMP.Z	CompareEsqMon3L14

CompareEsqMon3L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_0 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_0 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L1:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L2:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L3:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L4:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L5:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L6:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L7:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L8:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L9:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L10:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L11:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L12:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L13:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoEsqMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaEsqMon3
CompareEsqMon3L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6
				INC 	R4
				MOV 	R6, '.'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaEsqMon3



Mons3esq:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7 
				JMP 	Retornaesq3






;------------------------------------------------------------------------------
; FUNCTION MovMonstroDir3
;------------------------------------------------------------------------------

MovMonstroDir3:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovDirMon3:	MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				JMP		CompareDirMonstro3

FicarParadoDirMon3:MOV	R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Monstro3 ], R1
				JMP		EndMovDirMonstro3

VoltaDirMon3:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons3dir
Retornadir3:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Column_Monstro3 ]
				MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovDirMonstro3:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareDirMonstro3
;------------------------------------------------------------------------------

CompareDirMonstro3:MOV	R4, M[ Column_Monstro3 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, 0d


Decrementa10DirMon3:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaDirMon3
				DEC		R4
				JMP		Decrementa10DirMon3
			


ContinuaDirMon3:CMP		R1, 3d 
				JMP.Z	CompareDirMon3L0
				CMP		R1, 4d 
				JMP.Z	CompareDirMon3L1
				CMP		R1, 5d 
				JMP.Z	CompareDirMon3L2
				CMP		R1, 6d 
				JMP.Z	CompareDirMon3L3
				CMP		R1, 7d 
				JMP.Z	CompareDirMon3L4
				CMP		R1, 8d 
				JMP.Z	CompareDirMon3L5
				CMP		R1, 9d 
				JMP.Z	CompareDirMon3L6
				CMP		R1, 10d 
				JMP.Z	CompareDirMon3L7
				CMP		R1, 11d 
				JMP.Z	CompareDirMon3L8
				CMP		R1, 12d 
				JMP.Z	CompareDirMon3L9
				CMP		R1, 13d 
				JMP.Z	CompareDirMon3L10
				CMP		R1, 14d 
				JMP.Z	CompareDirMon3L11
				CMP		R1, 15d 
				JMP.Z	CompareDirMon3L12
				CMP		R1, 16d 
				JMP.Z	CompareDirMon3L13
				CMP		R1, 17d 
				JMP.Z	CompareDirMon3L14

CompareDirMon3L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_0 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_0 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L1:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L2:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L3:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L4:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L5:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L6:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L7:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L8:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L9:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L10:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L11:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L12:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L13:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoDirMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaDirMon3
CompareDirMon3L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6
				DEC 	R4
				MOV 	R6, '.'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaDirMon3



Mons3dir:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornadir3





;------------------------------------------------------------------------------
; FUNCTION MovMonstroCima3
;------------------------------------------------------------------------------

MovMonstroCima3:PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovCimaMon3:MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				JMP		CompareCimaMonstro3

FicarParadoCimaMon3:MOV		R1, DIR_PARADO
				MOV		M[ Direcao_Monstro3 ], R1
				JMP		EndMovCimaMonstro3

VoltaCimaMon3:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons3cima
Retornacima3:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Linha_Monstro3 ]
				MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovCimaMonstro3:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareCimaMonstro3
;------------------------------------------------------------------------------

CompareCimaMonstro3:MOV	R4, M[ Column_Monstro3 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -1d


Decrementa10CimMon3:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaCimaMon3
				DEC		R4
				JMP		Decrementa10CimMon3
			


ContinuaCimaMon3:CMP		R1, 3d 
				JMP.Z	CompareCimaMon3L0
				CMP		R1, 4d 
				JMP.Z	CompareCimaMon3L1
				CMP		R1, 5d 
				JMP.Z	CompareCimaMon3L2
				CMP		R1, 6d 
				JMP.Z	CompareCimaMon3L3
				CMP		R1, 7d 
				JMP.Z	CompareCimaMon3L4
				CMP		R1, 8d 
				JMP.Z	CompareCimaMon3L5
				CMP		R1, 9d 
				JMP.Z	CompareCimaMon3L6
				CMP		R1, 10d 
				JMP.Z	CompareCimaMon3L7
				CMP		R1, 11d 
				JMP.Z	CompareCimaMon3L8
				CMP		R1, 12d 
				JMP.Z	CompareCimaMon3L9
				CMP		R1, 13d 
				JMP.Z	CompareCimaMon3L10
				CMP		R1, 14d 
				JMP.Z	CompareCimaMon3L11
				CMP		R1, 15d 
				JMP.Z	CompareCimaMon3L12
				CMP		R1, 16d 
				JMP.Z	CompareCimaMon3L13
				CMP		R1, 17d 
				JMP.Z	CompareCimaMon3L14

CompareCimaMon3L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L1:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L2:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L3:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L4:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L5:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L6:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L7:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L8:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L9:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L10:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L11:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L12:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L13:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoCimaMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaCimaMon3
CompareCimaMon3L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaCimaMon3


Mons3cima:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornacima3





;------------------------------------------------------------------------------
; FUNCTION MovMonstroBaixo3
;------------------------------------------------------------------------------

MovMonstroBaixo3:PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovBaixoMon3:MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				JMP		CompareBaixoMonstro3

FicarParadoBaixoMon3:MOV	R1, DIR_PARADO
				MOV		M[ Direcao_Monstro3 ], R1
				JMP		EndMovBaixoMonstro3

VoltaBaixoMon3:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons3baixo
Retornabaixo3:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Linha_Monstro3 ]
				MOV 	R1, M[ Linha_Monstro3 ]
				MOV 	R2, M[ Column_Monstro3 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovBaixoMonstro3:POP R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareBaixoMonstro3
;------------------------------------------------------------------------------

CompareBaixoMonstro3:MOV	R4, M[ Column_Monstro3 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -1d


Decrementa10BaiMon3:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaBaixoMon3
				DEC		R4
				JMP		Decrementa10BaiMon3
			


ContinuaBaixoMon3:CMP	R1, 3d 
				JMP.Z	CompareBaixoMon3L0
				CMP		R1, 4d 
				JMP.Z	CompareBaixoMon3L1
				CMP		R1, 5d 
				JMP.Z	CompareBaixoMon3L2
				CMP		R1, 6d 
				JMP.Z	CompareBaixoMon3L3
				CMP		R1, 7d 
				JMP.Z	CompareBaixoMon3L4
				CMP		R1, 8d 
				JMP.Z	CompareBaixoMon3L5
				CMP		R1, 9d 
				JMP.Z	CompareBaixoMon3L6
				CMP		R1, 10d 
				JMP.Z	CompareBaixoMon3L7
				CMP		R1, 11d 
				JMP.Z	CompareBaixoMon3L8
				CMP		R1, 12d 
				JMP.Z	CompareBaixoMon3L9
				CMP		R1, 13d 
				JMP.Z	CompareBaixoMon3L10
				CMP		R1, 14d 
				JMP.Z	CompareBaixoMon3L11
				CMP		R1, 15d 
				JMP.Z	CompareBaixoMon3L12
				CMP		R1, 16d 
				JMP.Z	CompareBaixoMon3L13
				CMP		R1, 17d 
				JMP.Z	CompareBaixoMon3L14

CompareBaixoMon3L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L1:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L2:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L3:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L4:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L5:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L6:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L7:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L8:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L9:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L10:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L11:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L12:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoBaixoMon3
				MOV 	R6, M[ ConteudoAnt3 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt3 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L13:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaBaixoMon3
CompareBaixoMon3L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixoMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaBaixoMon3



Mons3baixo:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornabaixo3



;------------------------------------------------------------------------------
; FUNCTION MovMonstroEsq4
;------------------------------------------------------------------------------

MovMonstroEsq4:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovEsqMon4:	MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				JMP		CompareEsqMonstro4

FicarParadoEsqMon4:MOV	R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Monstro4 ], R1
				JMP		EndMovEsqMonstro4



VoltaEsqMon4:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons4esq
Retornaesq4:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Column_Monstro4]
				MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3


EndMovEsqMonstro4:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareEsqMonstro4
;------------------------------------------------------------------------------

CompareEsqMonstro4:MOV	R4, M[ Column_Monstro4 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -2d


Decrementa10EsqMon4:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaEsqMon4
				DEC		R4
				JMP		Decrementa10EsqMon4
			


ContinuaEsqMon4:	CMP		R1, 3d 
				JMP.Z	CompareEsqMon4L0
				CMP		R1, 4d 
				JMP.Z	CompareEsqMon4L1
				CMP		R1, 5d 
				JMP.Z	CompareEsqMon4L2
				CMP		R1, 6d 
				JMP.Z	CompareEsqMon4L3
				CMP		R1, 7d 
				JMP.Z	CompareEsqMon4L4
				CMP		R1, 8d 
				JMP.Z	CompareEsqMon4L5
				CMP		R1, 9d 
				JMP.Z	CompareEsqMon4L6
				CMP		R1, 10d 
				JMP.Z	CompareEsqMon4L7
				CMP		R1, 11d 
				JMP.Z	CompareEsqMon4L8
				CMP		R1, 12d 
				JMP.Z	CompareEsqMon4L9
				CMP		R1, 13d 
				JMP.Z	CompareEsqMon4L10
				CMP		R1, 14d 
				JMP.Z	CompareEsqMon4L11
				CMP		R1, 15d 
				JMP.Z	CompareEsqMon4L12
				CMP		R1, 16d 
				JMP.Z	CompareEsqMon4L13
				CMP		R1, 17d 
				JMP.Z	CompareEsqMon4L14

CompareEsqMon4L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_0 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_0 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L1:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L2:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L3:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L4:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L5:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L6:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L7:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L8:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L9:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L10:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L11:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L12:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt1 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L13:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoEsqMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				INC 	R4 
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				DEC 	R4
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaEsqMon4
CompareEsqMon4L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoEsqMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6
				INC 	R4
				MOV 	R6, '.'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaEsqMon4



Mons4esq:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornaesq4



;------------------------------------------------------------------------------
; FUNCTION MovMonstroDir4
;------------------------------------------------------------------------------

MovMonstroDir4:	PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovDirMon4:	MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				JMP		CompareDirMonstro4

FicarParadoDirMon4:MOV	R1, M[ DIR_PARADO ]
				MOV		M[ Direcao_Monstro1 ], R1
				JMP		EndMovDirMonstro4

VoltaDirMon4:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons4dir
Retornadir4:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Column_Monstro4 ]
				MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovDirMonstro4:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareDirMonstro4
;------------------------------------------------------------------------------

CompareDirMonstro4:MOV	R4, M[ Column_Monstro4 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, 0d


Decrementa10DirMon4:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaDirMon4
				DEC		R4
				JMP		Decrementa10DirMon4
			


ContinuaDirMon4:CMP		R1, 3d 
				JMP.Z	CompareDirMon4L0
				CMP		R1, 4d 
				JMP.Z	CompareDirMon4L1
				CMP		R1, 5d 
				JMP.Z	CompareDirMon4L2
				CMP		R1, 6d 
				JMP.Z	CompareDirMon4L3
				CMP		R1, 7d 
				JMP.Z	CompareDirMon4L4
				CMP		R1, 8d 
				JMP.Z	CompareDirMon4L5
				CMP		R1, 9d 
				JMP.Z	CompareDirMon4L6
				CMP		R1, 10d 
				JMP.Z	CompareDirMon4L7
				CMP		R1, 11d 
				JMP.Z	CompareDirMon4L8
				CMP		R1, 12d 
				JMP.Z	CompareDirMon4L9
				CMP		R1, 13d 
				JMP.Z	CompareDirMon4L10
				CMP		R1, 14d 
				JMP.Z	CompareDirMon4L11
				CMP		R1, 15d 
				JMP.Z	CompareDirMon4L12
				CMP		R1, 16d 
				JMP.Z	CompareDirMon4L13
				CMP		R1, 17d 
				JMP.Z	CompareDirMon4L14

CompareDirMon4L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_0 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_0 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L1:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L2:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L3:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L4:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L5:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L6:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L7:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L8:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L9:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L10:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L11:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L12:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L13:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoDirMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				DEC 	R4 
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				INC 	R4
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaDirMon4
CompareDirMon4L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoDirMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6
				DEC 	R4
				MOV 	R6, '.'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaDirMon4


Mons4dir:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornadir4




;------------------------------------------------------------------------------
; FUNCTION MovMonstroCima4
;------------------------------------------------------------------------------

MovMonstroCima4:PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovCimaMon4:	MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				JMP		CompareCimaMonstro4

FicarParadoCimaMon4:MOV		R1, DIR_PARADO
				MOV		M[ Direcao_Monstro4 ], R1
				JMP		EndMovCimaMonstro4

VoltaCimaMon4:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons4cima
Retornacima4:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				DEC		M[ Linha_Monstro4 ]
				MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovCimaMonstro4:POP 	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareCimaMonstro4
;------------------------------------------------------------------------------

CompareCimaMonstro4:MOV	R4, M[ Column_Monstro4 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -1d


Decrementa10CimMon4:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaCimaMon4
				DEC		R4
				JMP		Decrementa10CimMon4
			


ContinuaCimaMon4:CMP		R1, 3d 
				JMP.Z	CompareCimaMon4L0
				CMP		R1, 4d 
				JMP.Z	CompareCimaMon4L1
				CMP		R1, 5d 
				JMP.Z	CompareCimaMon4L2
				CMP		R1, 6d 
				JMP.Z	CompareCimaMon4L3
				CMP		R1, 7d 
				JMP.Z	CompareCimaMon4L4
				CMP		R1, 8d 
				JMP.Z	CompareCimaMon4L5
				CMP		R1, 9d 
				JMP.Z	CompareCimaMon4L6
				CMP		R1, 10d 
				JMP.Z	CompareCimaMon4L7
				CMP		R1, 11d 
				JMP.Z	CompareCimaMon4L8
				CMP		R1, 12d 
				JMP.Z	CompareCimaMon4L9
				CMP		R1, 13d 
				JMP.Z	CompareCimaMon4L10
				CMP		R1, 14d 
				JMP.Z	CompareCimaMon4L11
				CMP		R1, 15d 
				JMP.Z	CompareCimaMon4L12
				CMP		R1, 16d 
				JMP.Z	CompareCimaMon4L13
				CMP		R1, 17d 
				JMP.Z	CompareCimaMon4L14

CompareCimaMon4L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L1:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L2:CMP 	R5, M[ R4 + linha_1 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_1 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_1 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L3:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L4:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L5:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L6:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L7:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L8:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L9:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L10:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L11:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L12:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L13:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoCimaMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_13 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaCimaMon4
CompareCimaMon4L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoCimaMon1
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaCimaMon4



Mons4cima:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornacima4




;------------------------------------------------------------------------------
; FUNCTION MovMonstroBaixo4
;------------------------------------------------------------------------------

MovMonstroBaixo4:PUSH	R1
				PUSH	R2
				PUSH	R3
				PUSH	R4
				PUSH	R5
				PUSH	R6
				PUSH 	R7


LoopMovBaixoMon4:MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				JMP		CompareBaixoMonstro4

FicarParadoBaixoMon4:MOV	R1, DIR_PARADO
				MOV		M[ Direcao_Monstro4 ], R1
				JMP		EndMovBaixoMonstro4

VoltaBaixoMon4:	CMP 	R7, M[ ConteudoAux ]
				JMP.Z 	Mons4baixo
Retornabaixo4:	MOV		R3, M[ ConteudoAux ]
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3
				INC		M[ Linha_Monstro4 ]
				MOV 	R1, M[ Linha_Monstro4 ]
				MOV 	R2, M[ Column_Monstro4 ]
				MOV		R3, 'M'
				SHL		R1, 8
				OR		R1, R2
				MOV		M[ CURSOR ], R1
				MOV		M[ WRITE ], R3

EndMovBaixoMonstro4:POP	R7
				POP		R6
				POP		R5
				POP		R4
				POP		R3
				POP		R2
				POP		R1
				RET


;------------------------------------------------------------------------------
; FUNCTION CompareBaixoMonstro4
;------------------------------------------------------------------------------

CompareBaixoMonstro4:MOV	R4, M[ Column_Monstro4 ]
				MOV		R5, '#'
				MOV 	R7, 'M'
				MOV		R6, -1d


Decrementa10BaiMon4:INC	R6
				CMP		R6, STOP
				JMP.Z 	ContinuaBaixoMon4
				DEC		R4
				JMP		Decrementa10BaiMon4
			


ContinuaBaixoMon4:CMP	R1, 3d 
				JMP.Z	CompareBaixoMon4L0
				CMP		R1, 4d 
				JMP.Z	CompareBaixoMon4L1
				CMP		R1, 5d 
				JMP.Z	CompareBaixoMon4L2
				CMP		R1, 6d 
				JMP.Z	CompareBaixoMon4L3
				CMP		R1, 7d 
				JMP.Z	CompareBaixoMon4L4
				CMP		R1, 8d 
				JMP.Z	CompareBaixoMon4L5
				CMP		R1, 9d 
				JMP.Z	CompareBaixoMon4L6
				CMP		R1, 10d 
				JMP.Z	CompareBaixoMon4L7
				CMP		R1, 11d 
				JMP.Z	CompareBaixoMon4L8
				CMP		R1, 12d 
				JMP.Z	CompareBaixoMon4L9
				CMP		R1, 13d 
				JMP.Z	CompareBaixoMon4L10
				CMP		R1, 14d 
				JMP.Z	CompareBaixoMon4L11
				CMP		R1, 15d 
				JMP.Z	CompareBaixoMon4L12
				CMP		R1, 16d 
				JMP.Z	CompareBaixoMon4L13
				CMP		R1, 17d 
				JMP.Z	CompareBaixoMon4L14

CompareBaixoMon4L0:CMP 	R5, M[ R4 + linha_0 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_0 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L1:CMP 	R5, M[ R4 + linha_2 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_1 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_2 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_2 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L2:CMP 	R5, M[ R4 + linha_3 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_2 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_3 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_3 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L3:CMP 	R5, M[ R4 + linha_4 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_3 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_4 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_4 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L4:CMP 	R5, M[ R4 + linha_5 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_4 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_5 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_5 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L5:CMP 	R5, M[ R4 + linha_6 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_5 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_6 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_6 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L6:CMP 	R5, M[ R4 + linha_7 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_6 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_7 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_7 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L7:CMP 	R5, M[ R4 + linha_8 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_7 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_8 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_8 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L8:CMP 	R5, M[ R4 + linha_9 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_8 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_9 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_9 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L9:CMP 	R5, M[ R4 + linha_10 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_9 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_10 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_10 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L10:CMP 	R5, M[ R4 + linha_11 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_10 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_11 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_11 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L11:CMP 	R5, M[ R4 + linha_12 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_11 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_12 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_12 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L12:CMP 	R5, M[ R4 + linha_13 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, M[ ConteudoAnt4 ]
				CMP 	R6, 'M'
				CALL.Z 	trocaR6
				MOV 	M[ R4 + linha_12 ], R6
				MOV 	M[ ConteudoAux ], R6
				MOV		R6, M[ R4 + linha_13 ]
				MOV 	M[ ConteudoAnt4 ], R6
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_13 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L13:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaBaixoMon4
CompareBaixoMon4L14:CMP 	R5, M[ R4 + linha_14 ]
				JMP.Z 	FicarParadoBaixoMon4
				MOV 	R6, 'M'
				MOV 	M[ R4 + linha_14 ], R6

				JMP		VoltaBaixoMon4



Mons4baixo:		MOV 	R7, '.'
				MOV 	M[ ConteudoAux ], R7
				JMP 	Retornabaixo4







;------------------------------------------------------------------------------
; FUNCTION MovimentaPacman
;------------------------------------------------------------------------------


MovimentaPacman:PUSH	R7

				MOV		R7, M[ Direcao_Pacman ]

				CMP		R7, DIR_ESQ
				CALL.Z	MovEsquerda

				CMP		R7, DIR_DIR
				CALL.Z	MovDireita

				CMP		R7, DIR_CIMA
				CALL.Z	MovCima

				CMP		R7, DIR_BAIXO
				CALL.Z	MovBaixo


EndMovPacman:	POP		R7

				RET



;------------------------------------------------------------------------------
; FUNCTION MovimentaMonstro1
;------------------------------------------------------------------------------

MovimentaMonstro1:	PUSH	R7

					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK

					JMP.P 	MovMonstro1X
					JMP.NP  MovMonstro1Y

MovMonstro1X:		CALL Random
					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK
					CALL.P	MovMonstroEsq1
					CALL.NP	MovMonstroDir1
					JMP		EndMovMonstro1

MovMonstro1Y:		CALL Random
					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK
					CALL.P 	MovMonstroCima1
					CALL.NP	MovMonstroBaixo1
					JMP		EndMovMonstro1

EndMovMonstro1:		POP R7

					RET




;------------------------------------------------------------------------------
; FUNCTION MovimentaMonstro2
;------------------------------------------------------------------------------

MovimentaMonstro2:	PUSH	R7

					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK

					JMP.P 	MovMonstro2X
					JMP.NP  MovMonstro2Y

MovMonstro2X:		CALL Random
					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK
					CALL.P	MovMonstroEsq2
					CALL.NP	MovMonstroDir2
					JMP		EndMovMonstro2

MovMonstro2Y:		CALL Random
					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK
					CALL.P 	MovMonstroCima2
					CALL.NP	MovMonstroBaixo2
					JMP		EndMovMonstro2

EndMovMonstro2:		POP R7

					RET





;------------------------------------------------------------------------------
; FUNCTION MovimentaMonstro3
;------------------------------------------------------------------------------

MovimentaMonstro3:	PUSH	R7

					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK

					JMP.P 	MovMonstro3X
					JMP.NP  MovMonstro3Y

MovMonstro3X:		CALL Random
					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK
					CALL.P	MovMonstroEsq3
					CALL.NP	MovMonstroDir3
					JMP		EndMovMonstro3

MovMonstro3Y:		CALL Random
					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK
					CALL.P 	MovMonstroCima3
					CALL.NP	MovMonstroBaixo3
					JMP		EndMovMonstro3

EndMovMonstro3:		POP R7

					RET







;------------------------------------------------------------------------------
; FUNCTION MovimentaMonstro4
;------------------------------------------------------------------------------

MovimentaMonstro4:	PUSH	R7

					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK

					JMP.P 	MovMonstro4X
					JMP.NP  MovMonstro4Y

MovMonstro4X:		CALL Random
					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK
					CALL.P	MovMonstroEsq4
					CALL.NP	MovMonstroDir4
					JMP		EndMovMonstro4

MovMonstro4Y:		CALL Random
					MOV		R7, M[ Random_Var ]
					CMP		R7, RND_MASK
					CALL.P 	MovMonstroCima4
					CALL.NP	MovMonstroBaixo4
					JMP		EndMovMonstro4

EndMovMonstro4:		POP R7

					RET








;------------------------------------------------------------------------------
; FUNCTION Timer
;------------------------------------------------------------------------------


Timer:			PUSH	R1

				CALL	Pontuacao
				CALL 	Vidas
				CALL	MovimentaPacman
				CALL 	Random

				;CALL	Mapa
				;MOV 	R1, 3d
				;MOV 	M[ LineCounter ], R1

				CALL 	MovimentaMonstro1
				CALL	MovimentaMonstro2
				CALL 	MovimentaMonstro3
				CALL 	MovimentaMonstro4


				MOV		R1, 2d
				MOV		M[ CONFIG_TIMER ], R1
				MOV		R1, M[ TimerAtivado ]
				MOV		M[ ATIVAR_TIMER ], R1

				POP		R1

				RTI



;------------------------------------------------------------------------------
; FUNCTION Random
;------------------------------------------------------------------------------

; Random: Rotina que gera um valor aleatório - guardado em M[Random_Var]
; Entradas: M[Random_Var]
; Saidas:   M[Random_Var]

Random:	PUSH	R1
		MOV	R1, LSB_MASK
		AND	R1, M[Random_Var] ; R1 = bit menos significativo de M[Random_Var]
		BR.Z	Rnd_Rotate
		MOV	R1, RND_MASK
		XOR	M[Random_Var], R1
Rnd_Rotate:	ROR	M[Random_Var], 1


		POP	R1

		RET



;------------------------------------------------------------------------------
; FUNCTION Mapa
;------------------------------------------------------------------------------

Mapa:			CALL Line0
				CALL Line1
				CALL Line2
				CALL Line3
				CALL Line4
				CALL Line5
				CALL Line6
				CALL Line7
				CALL Line8
				CALL Line9
				CALL Line10
				CALL Line11
				CALL Line12
				CALL Line13
				CALL Line14

				RET




Main:			ENI
				MOV		R1, INITIAL_SP
				MOV		SP, R1		 		; We need to initialize the stack
				MOV		R1, CURSOR_INIT		; We need to initialize the cursor
				MOV		M[ CURSOR ], R1		; with value CURSOR_INIT

				CALL	Mapa

				MOV		R1, 2d
				MOV		M[ CONFIG_TIMER ], R1
				MOV		R1, 1d 
				MOV		M[ ATIVAR_TIMER ], R1

Cycle: 			BR		Cycle
Halt:           BR		Halt