#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZ22     � Autor � Potencial Tecnologia  Data �30/10/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Base inventario 100%						                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�����������������������������������������������������������������������������
/*/

User Function CADZ22
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z22"

dbSelectArea("Z22")
dbSetOrder(1)
AxCadastro(cString,"Base Inventario 100%",cVldExc,cVldAlt)
Return
