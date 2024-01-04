#include "rwmake.ch"        

User Function sf1100i()       

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("carea,nrec,cind,_chist,ckey")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA100 �Autor�                          � Data � 17.07.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gravar historico no titulo a pagar                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Na inclusao da Nota Fiscal de Entrada - Ponto de Entrada   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//Guarda arquivo, indice e registro atual
carea     := Alias()
nrec      := Recno()
cind      := IndexOrd()

IF SF4->F4_DUPLIC == "S"
   //Inicializa variavel de Historico
   _chist := Space(40)
   //Montagem da tela para digitacao da natureza
   @ 00,00 to 190,380 Dialog tela2 Title "HISTORICO FINANCEIRO"
   @ 24,05 Say "HISTORICO: "
   @ 24,60 Get _cHist Picture "@!" SIZE 70,10
   @ 061,130 BmpButton Type 01 Action Relat()
   Activate Dialog Tela2 Centered

Endif

dbSelectArea(carea)
dbSetOrder(cind)
dbGoto(nrec)

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
      Replace E2_HIST with _chist
      MsUnlock()
      DbSkip()
   enddo
   dbSelectArea("SE2")
   DbSetOrdeR(1)
   
Return(.t.)


