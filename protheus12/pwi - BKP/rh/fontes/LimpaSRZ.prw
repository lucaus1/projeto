#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LIMPASRZ     � Autor � FRANCINEY ALVES � Data �  09/08/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Limpeza da tabela SRZ para contabilizar                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 Vitello                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LimpaSRZ
Private cString := "SRZ"
Alert("Limpando tabela SRZ Total Registros "+STR(Reccount()))
Processa({|| RunCont() },"Deletando registros da SRZ - Resumo da Folha para Contabiliza��o ..")
Return


Static Function RunCont
dbSelectArea("SRZ")
dbSetOrder(1)
ProcRegua(RecCount()) // Numero de registros a processar

DbGotop()

Do While !Eof()
  RecLock("SRZ",.F.)
   dele 
  MsUnlock()
     DbSkip()
     IncProc()
     
Enddo                                                       

Alert(" Fim de Limpeza da SRZ " +STR(Reccount())) 


Return
