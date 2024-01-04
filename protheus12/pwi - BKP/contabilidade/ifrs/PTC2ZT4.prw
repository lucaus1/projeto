#Include "TopConn.ch"

User Function PTC2ZT4()
	Private cReg := ""
	Private cCadastro := "Cadastro de Roteiro IFRS"
	Private aRotina := { {"Pesquisar" ,"AxPesqui"     ,0,1} ,;
	             		 {"Visualizar","U_PTCADZT4(2)",0,2} ,;
			             {"Incluir"   ,"U_PTCADZT4(3)",0,3} ,;
	    		         {"Alterar"   ,"U_PTCADZT4(4)",0,4} ,;
	            		 {"Excluir"   ,"U_PTCADZT4(5)",0,5} }
	
	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	
	Private cString := "ZT4"
	
	dbSelectArea("ZT4")
	dbSetOrder(1)
	
	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString)
RETURN

User Function PTCADZT4(nArg)
	cOpcao := ""
	
	Do Case
		Case nArg == 2;	cOpcao := "VISUALIZAR"
		Case nArg == 3;	cOpcao := "INCLUIR"
		Case nArg == 4;	cOpcao := "ALTERAR"
		Case nArg == 5;	cOpcao := "EXCLUIR"
	End Do
	
	Do Case
		Case cOpcao=="INCLUIR";    nOpcE:=3 ; nOpcG:=3
		Case cOpcao=="ALTERAR";    nOpcE:=3 ; nOpcG:=3
		Case cOpcao=="VISUALIZAR"; nOpcE:=2 ; nOpcG:=2
		Case cOpcao=="EXCLUIR";    nOpcE:=2 ; nOpcG:=2
	EndCase
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria variaveis M->????? da Enchoice                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegToMemory("ZT4",(cOpcao=="INCLUIR"))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria aHeader e aCols da GetDados                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek("ZT5")
	aHeader := {}
	While !Eof() .And. (x3_arquivo=="ZT5")
		If x3_BROWSE == "N"
			dbSkip()
			Loop
		Endif
		
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			nUsado:=nUsado+1
			Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal,"AllwaysTrue()",;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
		dbSkip()
	End
	
	If cOpcao=="INCLUIR"
		aCols:={Array(nUsado+1)}
		aCols[1,nUsado+1]:=.F.
		For _ni:=1 to nUsado
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Next
		
		M->ZT4_FILIAL := xFilial("ZT4")
		M->ZT4_TIPO   := Space(1)
		M->ZT4_GRUPO  := Space(10)
	Else
		aCols:={}
		dbSelectArea("ZT5")
		dbSetOrder(1)
		dbSeek(xFilial()+M->ZT4_GRUPO)
		While !eof() .and. ZT5_GRUPO == M->ZT4_GRUPO
			AADD(aCols,Array(nUsado+1))
			For _ni:=1 to nUsado
				aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
			Next
			aCols[Len(aCols),nUsado+1]:=.F.
			dbSkip()
		End
		
		cReg := ZT4->ZT4_GRUPO
	Endif
	
	If Len(aCols) > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa a Modelo 3                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cTitulo := "Cadastro de Roteiro IFRS"
		cAliasEnchoice := "ZT4"
		cAliasGetD := "ZT5"
		cLinOk := "AllwaysTrue()"
		cTudOk := "AllwaysTrue()"
		cFieldOk := "AllwaysTrue()"
		aCpoEnchoice := {"ZT4_GRUPO"}
		
		_lRet := Modelo3(cTitulo, cAliasEnchoice, cAliasGetD, aCpoEnchoice, cLinOk, cTudOk, nOpcE, nOpcG, cFieldOk)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executar processamento                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If _lRet
			GravaDados(nArg, aCols)
		Endif
	Endif
Return

Static Function GravaDados(nArg, aCols)
	lReg := .F.
	_cQuery := ""
	
	// Rotina de Inclusao
	if nArg == 3
		if Alltrim(M->ZT4_TIPO) == ""
			Alert( "Tipo de Conta Invalido" )
			return .f.
		Endif
		
		if U_PTVALGRUP()
			For nLin := 1 to Len(aCols)
				if AllTrim(aCols[nLin, 2]) != ""
					RecLock("ZT5",.T.)
						ZT5->ZT5_FILIAL := xFilial("ZT5")
						ZT5->ZT5_GRUPO  := M->ZT4_GRUPO
						ZT5->ZT5_CONTA  := aCols[nLin, 1]
						ZT5->ZT5_DESC   := aCols[nLin, 2]
					msUnlock()
					
					lReg := .T.
				EndIf
			Next

			if lReg
				RecLock("ZT4", .T.)
					ZT4->ZT4_FILIAL := xFilial("ZT4")
					ZT4->ZT4_CLAS   := M->ZT4_CLAS
					ZT4->ZT4_SEQ    := M->ZT4_SEQ
					ZT4->ZT4_GRUPO  := M->ZT4_GRUPO
					ZT4->ZT4_DESC   := M->ZT4_DESC
					ZT4->ZT4_TIPO   := M->ZT4_TIPO
				msUnlock()
			Else
				Alert( "Cadastro sem nenhum Item!!!" )
				return .f.
			EndIf
		EndIf
	EndIf

	// Rotina de Alteracao
	if nArg == 4
		if Alltrim(M->ZT4_TIPO) == ""
			Alert( "Tipo de Conta Invalido" )
			return .f.
		Endif
		
		if Alltrim(M->ZT4_GRUPO) == ""
			Alert( "Grupo Invalido" )
			return .f.
		Endif

		For nLin := 1 to Len(aCols)
			if !aCols[nLin, 3]
				if AllTrim(aCols[nLin, 2]) != ""
					lReg := .T.
				EndIf
			EndIf
		Next

		if lReg
			_cQuery := " DELETE FROM ZT5060 WHERE ZT5_GRUPO = '"+ cReg +"' "
			TCSQLExec( _cQuery )
			
			dbSelectArea("ZT4")
			dbSetOrder(2)
			dbSeek( xFilial("ZT4") + cReg )
			if Found()
				RecLock("ZT4", .F.)
					ZT4->ZT4_FILIAL := xFilial("ZT4")
					ZT4->ZT4_CLAS   := M->ZT4_CLAS					
					ZT4->ZT4_SEQ    := M->ZT4_SEQ
					ZT4->ZT4_GRUPO  := M->ZT4_GRUPO
					ZT4->ZT4_DESC   := M->ZT4_DESC
					ZT4->ZT4_TIPO   := M->ZT4_TIPO
				msUnlock()
			EndIf
	
			For nLin := 1 to Len(aCols)
				if !aCols[nLin, 3] 
					if AllTrim(aCols[nLin, 2]) != ""
						RecLock("ZT5",.T.)
							ZT5->ZT5_FILIAL := xFilial("ZT5")
							ZT5->ZT5_GRUPO  := M->ZT4_GRUPO
							ZT5->ZT5_CONTA  := aCols[nLin, 1]
							ZT5->ZT5_DESC   := aCols[nLin, 2]
						msUnlock()
					EndIf
				EndIf
			Next

		Else
			Alert( "Cadastro sem nenhum Item!!!" )
			return .f.
		EndIf
	EndIf

	// Rotina de Exclusao
	if nArg == 5
		_cQuery := " DELETE FROM ZT5060 WHERE ZT5_GRUPO = '"+ cReg +"' "
		TCSQLExec( _cQuery )

		_cQuery := " DELETE FROM ZT4060 WHERE ZT4_GRUPO = '"+ cReg +"' "
		TCSQLExec( _cQuery )
	EndIf
Return

User Function PTVALGRUP()
	lRet := .T.
	
	If Val(M->ZT4_GRUPO) == 0
		lRet := .F.
	End If
	
	/*
	dbSelectArea("ZT4")
	dbSetOrder(2)
	dbSeek( xFilial("ZT4") + M->ZT4_GRUPO )
	If Found()
		lRet := .F.
	EndIf
	*/
	
	dbSelectArea("ZT1")
	dbSetOrder(1)
	dbSeek( xFilial("ZT1") + M->ZT4_GRUPO )
	If !Found()
		lRet := .F.
	EndIf		
Return lRet