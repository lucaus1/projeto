#Include "rwmake.ch"

User Function MOVOLS()
	dbSelectArea("ZT2")
	dbSetOrder(1)
	
	
	AxCadastro("ZT2", "Movimento de Ajustes e Eliminações")
Return