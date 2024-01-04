#Include "rwmake.ch"

User Function CADOLS()
	dbSelectArea("ZT1")
	dbSetOrder(1)
	
	AxCadastro("ZT1", "Cadastro de Contas IFRS")
Return