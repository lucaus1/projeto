#Include "rwmake.ch"

User Function CADIFR()
	dbSelectArea("ZT1")
	dbSetOrder(1)
	
	AxCadastro("ZT1", "Cadastro de Contas IFRS")
Return