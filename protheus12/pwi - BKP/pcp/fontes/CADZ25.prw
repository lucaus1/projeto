#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZ25     � Autor � Potencial Tecnologia  Data �30/10/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Controle de atividades florestais		                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�����������������������������������������������������������������������������
/*/

User Function CADZ25
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z25"

dbSelectArea("Z25")
dbSetOrder(1)
AxCadastro(cString,"Controle de Atividades florestais",cVldExc,cVldAlt)
Return
