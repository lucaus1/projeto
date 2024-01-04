#include "rwmake.ch"        

User Function Sf1100I()       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CAREA,NREC,CIND,_CHIST,CKEY,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA100 ³Autor³                          ³ Data ³ 17.07.00 ³±±
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

IF SF4->F4_DUPLIC == "S"
   //Inicializa variavel de Historico
   _cHist := Space(40)
   //Montagem da tela para digitacao da natureza
   @ 00,00 to 190,380 Dialog tela2 Title "HISTORICO FINANCEIRO"
   @ 24,05 Say "HISTORICO: "
   @ 24,60 Get _cHist Picture "@!" SIZE 70,10
   @ 061,130 BmpButton Type 01 Action Relat()
   Activate Dialog Tela2 Centered

Endif

dbSelectArea(cArea)
dbSetOrder(cInd)
dbGoto(nRec)

Return(nil)        

Static Function Relat()
   //Fechamento da tela de Dialogo
   Close(Tela2)

   //Seleciona Contas a Pagar e adiciona historico em todas as parcelas.
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


