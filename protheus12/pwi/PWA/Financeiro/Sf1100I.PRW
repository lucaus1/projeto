#include "rwmake.ch"        

User Function Sf1100I()       

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CAREA,NREC,CIND,_CHIST,CKEY,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컫컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � MATA100 쿌utor�                          � Data � 17.07.00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컨컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Gravar historico no titulo a pagar                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Na inclusao da Nota Fiscal de Entrada - Ponto de Entrada   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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


