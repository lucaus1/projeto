#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZ11     � Autor � Potencial Tecnologia  Data �30/10/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Classifica��o de item serraria			                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�����������������������������������������������������������������������������
/*/

User Function CADZ11
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z11"

dbSelectArea("Z11")
dbSetOrder(1)
AxCadastro(cString,"Classifica��o de item Serraria",cVldExc,cVldAlt)
Return
