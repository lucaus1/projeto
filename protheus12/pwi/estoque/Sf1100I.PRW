#include "rwmake.ch"

User Function Sf1100I()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CAREA,NREC,CIND,_CHIST,_COBS1,_COBS2,CKEY,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA100 ³Potencial Tecnologia³             Data ³ 25.01.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravar historico no titulo a pagar                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Na inclusao da Nota Fiscal de Entrada - Ponto de Entrada   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//Guarda arquivo, indice e registro atual
cArea     := Alias()
nRec      := Recno()
cInd      := IndexOrd()



If CTIPO != "D"
	
	IF SF4->F4_DUPLIC == "S"
		//Inicializa variavel de Historico
		_cHist := Space(25)
		//Montagem da tela para digitacao da natureza
		@ 00,00 to 190,380 Dialog tela2 Title "HISTORICO FINANCEIRO"
		@ 24,05 Say "HISTORICO: "
		@ 24,60 Get _cHist Picture "@!" SIZE 80,10
		@ 061,130 BmpButton Type 01 Action Relat()
		Activate Dialog Tela2 Centered
		
	Endif
	
Endif


If Alltrim(cFormul) == "S"
		_cObs1 := SF4->F4_YOBS
		_cObs2 := SF4->F4_YOBS2
		@ 00,00 to 170,550 Dialog tela3 Title "OBSERVAÇÃO DA NOTA"
		@ 05,20 Say "Observar nos campos abaixo os dados Padrões definidos no cadastro da TES alem de preencher"		
		@ 14,25 Say "dados complementares especificos da NF:(Ex:I.I,Nro CONTAINER, Taxa SISCOMEX,etc.)"		
		@ 24,05 Say "OBS1: "
		@ 24,30 Get _cObs1 Picture "@S100" SIZE 220,10
		@ 44,05 Say "OBS2: "
		@ 44,30 Get _cObs2 Picture "@S100" SIZE 220,10
		@ 61,120 BmpButton Type 01 Action Relat2()
		Activate Dialog Tela3 Centered
Endif


dbSelectArea(cArea)
dbSetOrder(cInd)
dbGoto(nRec)



Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00


Static Function Relat()
Close(Tela2)

dbSelectArea("SE2")
cKey := E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM
DbSetOrdeR(6)
DbSeek(xFilial("SE2")+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
while cKey == E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM
	While !RecLock("SE2")
		Loop
	End
	Replace E2_HIST with _cHist
	MsUnlock()
	DbSkip()
enddo

Return(.t.)


Static Function Relat2()
Close(Tela3)  
	dbSelectArea("SF1")
	Reclock("SF1",.F.)
		Replace F1_YOBS with _cObs1
		Replace F1_YOBS2 with _cObs2
	MsUnlock()
Return(.t.)