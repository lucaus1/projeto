#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZ00     � Autor � Potencial Tecnologia  Data �30/10/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Especies conforme Padrao IBAMA                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�����������������������������������������������������������������������������
/*/

User Function CADZ00
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z00"

dbSelectArea("Z00")
dbSetOrder(1)
AxCadastro(cString,"Cadastro de Esp�cies",cVldExc,cVldAlt)
Return
