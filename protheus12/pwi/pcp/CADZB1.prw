#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADZB1     � Autor � Potencial Tecnologia  Data �18/08/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Especies conforme Padrao IBAMA                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�����������������������������������������������������������������������������
/*/

User Function CADZB1
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZB1"

dbSelectArea("ZB1")
dbSetOrder(1)
AxCadastro(cString,"Cadastro de Esp�cies",cVldExc,cVldAlt)
Return
