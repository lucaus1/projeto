#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZT6     � Autor � Potencial Tecnologia  Data �30/10/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Controle de combust�vel					                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�����������������������������������������������������������������������������
/*/

User Function CADZT6
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZT6"

dbSelectArea("ZT6")
dbSetOrder(1)
AxCadastro(cString,"Controle de combust�vel",cVldExc,cVldAlt)
Return
