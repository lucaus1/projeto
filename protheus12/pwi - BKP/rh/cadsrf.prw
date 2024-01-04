#INCLUDE "Protheus.ch"

user function CADSRF()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SRF"

dbSelectArea("SRF")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Programação de Férias. . .",cVldExc,cVldAlt)

Return
