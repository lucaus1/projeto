#include "rwmake.ch"
#include "TOPCONN.CH"

User Function PWBP007()

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Funcao    :  PWBP007  | Autor : Claudenilson Dias    | Data : 03.08.06   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Descricao : FECHA DATA DA CONTABILIDADE                                  ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±Uso       : TODAS AS ROTINAS                                             ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

_cAreexp    := Alias()
_nRecexp    := Recno()
_cIndexp    := IndexOrd()

_dDataDe   := GetMV("MV_DATADE")
_dDataAte  := GetMV("MV_DATAATE")

_cMsg1  := "Este programa tem a finalidade de BLOQUEAR as movimentacoes     "
_cMsg2  := "da Contabilidade para evitar movimentos.                        "
_cMsg3  := "So alterar data final com conhecimento do CPD                   "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha a tela de processamento..........                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 000,00 TO 200,360 DIALOG oDlg TITLE "Bloqueia Contabiliade"

@ 020,010 Say _cMsg1
@ 030,010 Say _cMsg2
@ 040,010 Say _cMsg3

@ 060,010 Say "Data Liberada"
@ 060,060 get _dDatade  size 40,12
@ 060,105 Say "a"
@ 060,115 get _dDataAte size 40,12

@ 010,005 TO 080,175

@ 080,110 BmpButton Type 01  ACTION OkProc()
@ 080,140 BmpButton Type 02  ACTION Close(oDlg)


ACTIVATE DIALOG oDlg CENTERED

IF LastKey() == 27
	Close(oDlg)
ENDIF


dbselectarea(_cAreexp)
dbsetorder(_cIndexp)
dbgoto(_nRecexp)

Return nil

//************************************
Static Function OkProc()
//************************************

dbSelectArea("SX6")
dbgotop()
dbSeek("  MV_DATADE")

IF RecLock("SX6")
	SX6->X6_CONTEUD := DTOC(_dDataDe)
	MsUnLock()
End

dbgotop()
dbSeek("  MV_DATAATE")

IF RecLock("SX6")
	SX6->X6_CONTEUD := DTOC(_dDataAte)
	MsUnLock()
End

Close(oDlg)

Return(nil)