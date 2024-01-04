#Include "TopConn.ch"
#Include "PROTHEUS.CH"


User Function MAPCMP()
	Local cString        := "SC1"
	Local Tamanho        := "P"
	Local wnRel          := "MAPCMP"
	Local cDesc1         := ""
	Local cDesc2         := ""
	Local cDesc3         := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private nTipo        := 15
	Private limite       := 132
	Private aReturn      := {"Zebrado", 1,"Administracao", 1, 2,"LPT2", "", 1}
	Private aLinha       := {}
	Private aPerg        := {}
	Private nLastKey     := 0
	Private Titulo       := "MAPA DE COTAÇÃO"
	Private n_Endereco   := ""
	Private n_Empresa    := ""
	Private n_Separacao  := Replicate("-", 137)
	Private n_Situacao   := ""
	Private NomeProg     := "MAPCMP"
	Private cPerg        := "MAPCMP"
	Private	_cQuant      := 0
	Private	_cPrcUn      := 0
	Private	_cPrcTo      := 0
	Private _cValZp1     := ""
	                     
	dbSelectArea("SX1")
	dbSetOrder(1)
	//- Defindo grupo de perguntas
	aadd(aPerg,{cPerg, "01", "Orçamento  de?:    ","mv_ch1","C",06,0,1,"G","","mv_par01","","SC1","","","","","","","","","","","","",""})
	aadd(aPerg,{cPerg, "02", "Orçamento Ate?:   ","mv_ch2","C",06,0,1,"G","","mv_par02","","SC1","","","","","","","","","","","","",""})
	
	//- Gravando grupo de perguntas
	For nA:= 1 To Len(aPerg)
		If !(dbSeek(cPerg+aPerg[nA,2]))
			RecLock("SX1",.t.)
			Replace X1_GRUPO    with aPerg[nA][1]
			Replace X1_ORDEM    with aPerg[nA][2]
			Replace X1_PERGUNT  with aPerg[nA][3]
			Replace X1_PERSPA   with aPerg[nA][3]
			Replace X1_PERENG   with aPerg[nA][3]
			Replace X1_VARIAVL  with aPerg[nA][4]
			Replace X1_TIPO     with aPerg[nA][5]
			Replace X1_TAMANHO  with aPerg[nA][6]
			Replace X1_GSC      with aPerg[nA][9]
			Replace X1_DECIMAL  with aPerg[nA][7]
			Replace X1_PRESEL   with aPerg[nA][8]
			Replace X1_DEF01    with aPerg[nA][12]
			Replace X1_F3       with aPerg[nA][13]
			Replace X1_DEF02    with aPerg[nA][15]
			Replace X1_DEFSPA1  with aPerg[nA][12]
			Replace X1_DEFSPA2  with aPerg[nA][15]
			Replace X1_DEFENG1  with aPerg[nA][12]
			Replace X1_DEFENG2  with aPerg[nA][15]
			MsUnlock()
		Endif
	Next
		
	Pergunte(cPerg,.F.)
	wnrel:="MAPCMP" //- Nome Default do relatorio em Disco
	
	
	wnrel:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.,,,,,"LPT1")
	
	If nLastKey = 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey = 27
		Return
	Endif
	RptStatus({|lEnd| MAPCMPImp(@lEnd, wnRel, cString)}, titulo)
Return


Static Function MAPCMPImp(lEnd, wnRel, cString)
	Local Tamanho     := "P"
	Local Limite      := 132
	Local lContinua   := .t.,n_Tipo,n_Total
	Local Nomeprog    := "MAPCMP"
	Local _cSit       := ""
	Private _cQuery1  := ""
    Private ContHor   := 0
    Private _cTotNC   := 0
    Private _cIDDia   := 0    
    Private _cMTDia   := 0    
    Private _cTotPro  := 0 
    Private _cTotPla  := 0   
    Private _cTotPer  := 0    
    Private _cTTroca  := 0 
    Private _cPMHor   := 0     
    Private ll        := 0
    Private _cTempo   := 0
    Private	_cPrcPre1 := 0
	Private	_cPrcNeg1 := 0
	Private	_cPrcPre2 := 0
	Private	_cPrcNeg2 := 0
	Private	_cPrcPre3 := 0
	Private	_cPrcNeg3 := 0
	Private	_cPrcPre4 := 0
	Private	_cPrcNeg4 := 0
	Private	_cPrcPre5 := 0
	Private	_cPrcNeg5 := 0
	Private	_cDatEnt  := ""
	Private	_cFlag    := .T.
	Private _cVenc    := ""

	SetPrvt("nComp, nNorm, p_negrit_l, p_reset, p_negrit_d")

	p_negrit_l:= "E"
	p_reset   := "@"
	p_negrit_d:= "F"
	
	m_pag := 1
	li    := 1
	
	nOrdem  := 0
	n_Status:= ""

	_cQuery1 := " SELECT TOP 1 C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_CC,C1_CODCOMP,C1_USER,C1_OBS,C1_CODF1,C1_CODF2,C1_CODF3,C1_CODF4,C1_CODF5,C1_CONDPAG, "
	_cQuery1 += " (SELECT Y1_NOME FROM SY1010 WHERE Y1_USER=SC1010.C1_USER)AS NOME "
	_cQuery1 += " FROM SC1010 "
	_cQuery1 += " WHERE C1_QUANT > C1_QUJE AND D_E_L_E_T_<>'*' AND C1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery1 += " GROUP BY C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_CC,C1_CODCOMP,C1_USER,C1_OBS,C1_CODF1,C1_CODF2,C1_CODF3,C1_CODF4,C1_CODF5,C1_CONDPAG "
	_cQuery1 += " ORDER BY C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_CC,C1_CODCOMP,C1_USER,C1_OBS,C1_CODF1,C1_CODF2,C1_CODF3,C1_CODF4,C1_CODF5,C1_CONDPAG "

	TcQuery _cQuery1 New Alias qCabec

	qCabec->(DbGotop())

	//Inicio da Impressão
	pg := 0
	_cContItem := 0
	li := 65
	_cData:=DtoC(DDatabase)
	SetRegua(qCabec->(RecCount()))

	Do while !qCabec->(Eof())
		If lEnd        
			@Prow() + 1, 001 PSay OemToAnsi("Cancelado pelo operador")
			lContinua := .F.
			Exit
		Endif		                
                     //0        10        20        30        40        50        60        70        80        90       100       120       130       140       150       160       170       180       190       200       210       220
                     //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	   @ll++,003 PSay "+-------------------------------------------------------------------------------------------------+---------------------+---------------------+---------------------+---------------------+---------------------+"
	   @ll++,002 PSay "|                    MAPA DE COTACAO DE COMPRAS - PRECIOUS WOODS AMAZON                           |          1          |         2           |         3           |         4           |         5           |"
	   @ll++,002 PSay "+-------------------------------------------------------------------------------------------------+---------------------+---------------------+---------------------+---------------------+---------------------+"
	   @ll++,002 PSay "|                     |                                                                           |Fornecedor:          |Fornecedor:          |Fornecedor:          |Fornecedor:          |Fornecedor:          |"
	   @ll++,002 PSay "|   DATA: "+DTOC(STOD(qCabec->C1_EMISSAO))+"    |           REQUISICAO DE MATERIAL E SERVICO No:  "+qCabec->C1_NUM+"                    |Codigo: "+PADR(qCabec->C1_CODF1,6)+"       |Codigo: "+PADR(qCabec->C1_CODF2,6)+"       |Codigo: "+PADR(qCabec->C1_CODF3,6)+"       |Codigo: "+PADR(qCabec->C1_CODF4,6)+"       |Codigo: "+PADR(qCabec->C1_CODF5,6)+"       |"
	   @ll++,002 PSay "|                     |                                                                           |Nome: "+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF1),"PADR(A2_NOME,14)")+" |Nome: "+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF2),"PADR(A2_NOME,14)")+" |Nome: "+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF3),"PADR(A2_NOME,14)")+" |Nome: "+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF4),"PADR(A2_NOME,14)")+" |Nome: "+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF5),"PADR(A2_NOME,14)")+" |"
	   @ll++,002 PSay "+---------------------+---------------------------------------------------------------------------+---------------------+---------------------+---------------------+---------------------+---------------------+"
	   @ll++,002 PSay "|Solicitante:         |Centro de Custo:                                                           |Fone:                |Fone:                |Fone:                |Fone:                |Fone:                |"
	   @ll++,002 PSay "|    "+PADR(qCabec->C1_SOLICIT,16)+" | "+qCabec->C1_CC+" - "+Posicione("SI3", 1, xFilial("SI3")+Alltrim(qCabec->C1_CC),"PADR(I3_DESC,59)")+"   |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF1),"PADR(A2_TEL,13)")+"        |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF2),"PADR(A2_TEL,13)")+"        |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF3),"PADR(A2_TEL,13)")+"        |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF4),"PADR(A2_TEL,13)")+"        |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF5),"PADR(A2_TEL,13)")+"        |"
	   @ll++,002 PSay "+---------------------+------------------------------------+--------------------------------------+---------------------+---------------------+---------------------+---------------------+---------------------+"
	   @ll++,002 PSay "|Aplicacao:                                                |Comprador:                            |Contato:             |Contato:             |Contato:             |Contato:             |Contato:             |"
	   @ll++,002 PSay "|     "+PADR(qCabec->C1_OBS,52)+" |"+qCabec->C1_USER+" - "+PADR(qCabec->NOME,25)+"    |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF1),"PADR(A2_CONTATO,20)")+" |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF2),"PADR(A2_CONTATO,20)")+" |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF3),"PADR(A2_CONTATO,20)")+" |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF4),"PADR(A2_CONTATO,20)")+" |"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qCabec->C1_CODF5),"PADR(A2_CONTATO,20)")+" |"
	   @ll++,002 PSay "+-----------------------------------------------------+-------------------------------------------+---------------------+---------------------+---------------------+---------------------+---------------------+"
	   @ll++,002 PSay "|    |    |     |                                     | D T.DA | QTD.DA |  VLR.DA  |              |  Valor   |  Valor   |   Valor  |  Valor   |  Valor   |  Valor   |   Valor  |  Valor   |  Valor   |  Valor   |"
	   @ll++,002 PSay "|ITEM| UN | QTD |        DESCRICAO DO MATERIAL        | ULTIMA | ULTIMA |  ULTIMA  |  FORNECEDOR  | Proposto |Negociado | Proposto |Negociado | Proposto |Negociado | Proposto |Negociado | Proposto |Negociado |"
	   @ll++,002 PSay "|    |    |     |                                     | COMPRA | COMPRA |  COMPRA  |              |          |          |          |          |          |          |          |          |          |          |VNC"
	   @ll++,002 PSay "+-----------------------------------------------------+--------+--------+----------+--------------+----------+----------+----------+----------|----------+----------+----------+----------|----------+----------+---+"

		_cQuery2 := " SELECT (C1_PRODUTO) AS PRODUTO,C1_ITEM, "
	    _cQuery2 += " (SELECT TOP 1 MAX(D1_DTDIGIT) FROM SD1010 WHERE D1_COD=SC1010.C1_PRODUTO) AS MAXDATA "
	    _cQuery2 += " FROM SC1010 "
	    _cQuery2 += " WHERE C1_QUANT > C1_QUJE AND D_E_L_E_T_<>'*' AND LTRIM(C1_NUM)='"+qCabec->C1_NUM+"' "
   	    _cQuery2 += " ORDER BY C1_ITEM,C1_PRODUTO "
		TcQuery _cQuery2 New Alias qItens1
	 	qItens1->(DbGotop())
		 Do while !qItens1->(Eof())
			    _cQuery3 := " SELECT *, "
			    _cQuery3 += " (SELECT TOP 1 D1_FORNECE FROM SD1010 WHERE D1_DTDIGIT ='"+qItens1->MAXDATA+"' AND D1_COD='"+qItens1->PRODUTO+"' AND D_E_L_E_T_<>'*' ) AS MAXFOR, "
			    _cQuery3 += " (SELECT TOP 1 D1_QUANT   FROM SD1010 WHERE D1_DTDIGIT ='"+qItens1->MAXDATA+"' AND D1_COD='"+qItens1->PRODUTO+"' AND D_E_L_E_T_<>'*' ) AS MAXQTD, "
			    _cQuery3 += " (SELECT TOP 1 D1_VUNIT   FROM SD1010 WHERE D1_DTDIGIT ='"+qItens1->MAXDATA+"' AND D1_COD='"+qItens1->PRODUTO+"' AND D_E_L_E_T_<>'*' ) AS MAXVAL "
				_cQuery3 += " FROM SC1010 "
				_cQuery3 += " WHERE C1_QUANT > C1_QUJE AND D_E_L_E_T_<>'*' AND C1_NUM = '"+qCabec->C1_NUM+"' AND C1_ITEM='"+qItens1->C1_ITEM+"' AND C1_PRODUTO='"+qItens1->PRODUTO+"' "
				_cQuery3 += " ORDER BY C1_ITEM,C1_NUM,C1_DATPRF "
				TcQuery _cQuery3 New Alias qItens2
			    qItens2->(DbGotop())
     		    Do while !qItens2->(Eof())

		           	_cVenc := IIF(qItens2->C1_PTFORVE=qCabec->C1_CODF1,"1",IIF(qItens2->C1_PTFORVE=qCabec->C1_CODF2,"2",IIF(qItens2->C1_PTFORVE=qCabec->C1_CODF3,"3",IIF(qItens2->C1_PTFORVE=qCabec->C1_CODF4,"4",IIF(qItens2->C1_PTFORVE=qCabec->C1_CODF5,"5","")))))		            
		           	_cContItem += 1
			        
			        @ll++,002 PSay "|"+PADR(qItens2->C1_ITEM,4)+"| "+PADR(qItens2->C1_UM,2)+" |"+PADR(Transform(qItens2->C1_QUANT,"@E 99999"),5)+"|"+PADR(qItens2->C1_PRODUTO,8)+"-"+PADR(qItens2->C1_DESCRI,28)+"|"+DTOC(STOD(qItens1->MAXDATA))+"| "+PADR(Transform(qItens2->MAXQTD,"@E 99999"),5)+"  |"+PADR(Transform(qItens2->MAXVAL,"@E 999,999.99"),10)+"|"+Posicione("SA2", 1, xFilial("SA2")+Alltrim(qItens2->MAXFOR),"PADR(A2_NOME,14)")+"|"+PADR(Transform(qItens2->C1_VLPRF1,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLNEF1,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLPRF2,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLNEF2,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLPRF3,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLNEF3,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLPRF4,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLNEF4,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLPRF5,"@E 999,999.99"),10)+"|"+PADR(Transform(qItens2->C1_VLNEF5,"@E 999,999.99"),10)+"| "+Padr(_cVenc,1)+" |"  

			     	_cPrcPre1 += qItens2->C1_VLPRF1
			     	_cPrcNeg1 += qItens2->C1_VLNEF1
			     	_cPrcPre2 += qItens2->C1_VLPRF2
			     	_cPrcNeg2 += qItens2->C1_VLNEF2
			     	_cPrcPre3 += qItens2->C1_VLPRF3
			     	_cPrcNeg3 += qItens2->C1_VLNEF3
			     	_cPrcPre4 += qItens2->C1_VLPRF4
			     	_cPrcNeg4 += qItens2->C1_VLNEF4		     		
			     	_cPrcPre5 += qItens2->C1_VLPRF5
			     	_cPrcNeg5 += qItens2->C1_VLNEF5

			     	If _cFlag
				     	_cDatEnt  := qItens2->C1_DATPRF
				     	_cFlag    := .F.
			     	Endif
			     	
		     	qItens2->(dbSkip())
             	Enddo          
     			qItens2->(dbCloseArea())
	     qItens1->(dbSkip())
	     Enddo
	     qItens1->(dbCloseArea())

	   @ll++,002 PSay "+-----------------------------------------------------+--------+--------+----------+--------------+----------+----------+----------+----------|----------+----------+----------+----------|----------+----------+---+"
	   @ll++,002 PSay "+----------------------------------------------------------------------------------+--------------+---------------------+---------------------+---------------------+---------------------+---------------------+"
	   @ll++,002 PSay "|                                 OBSERVACAO                                       |Cond.Pagto    |"+PADR(qCabec->C1_CONDPAG,3)+" - "+Posicione("SE4", 1, xFilial("SE4")+Alltrim(qCabec->C1_CONDPAG),"PADR(E4_DESCRI,14)")+"                                                                                         |"
	   @ll++,002 PSay "+----------------------------------------------------------------------------------+--------------+---------------------+---------------------+---------------------+---------------------+---------------------+"
	   @ll++,002 PSay "| "+PADR(qCabec->C1_OBS,50)+"                               |Total Geral   |"+PADR(Transform(_cPrcPre1,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcNeg1,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcPre2,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcNeg2,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcPre3,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcNeg3,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcPre4,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcNeg4,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcPre5,"@E 999,999.99"),10)+"|"+PADR(Transform(_cPrcNeg5,"@E 999,999.99"),10)+"|"
	   @ll++,002 PSay "|                                                                                  +--------------+----------+----------+----------+----------|----------+----------+----------+----------|----------+----------+"
	   @ll++,002 PSay "|                                                                                  |Desconto      |     "+PADR(Transform(_cPrcPre1-_cPrcNeg1,"@E 999,999.99"),10)+"      |     "+PADR(Transform(_cPrcPre2-_cPrcNeg2,"@E 999,999.99"),10)+"      |     "+PADR(Transform(_cPrcPre3-_cPrcNeg3,"@E 999,999.99"),10)+"      |     "+PADR(Transform(_cPrcPre4-_cPrcNeg4,"@E 999,999.99"),10)+"      |     "+PADR(Transform(_cPrcPre5-_cPrcNeg5,"@E 999,999.99"),10)+"      |"
	   @ll++,002 PSay "|                                                                                  |Total Liquido |     "+PADR(Transform(_cPrcPre1-(_cPrcPre1-_cPrcNeg1),"@E 999,999.99"),10)+"      |     "+PADR(Transform(_cPrcPre2-(_cPrcPre2-_cPrcNeg2),"@E 999,999.99"),10)+"      |     "+PADR(Transform(_cPrcPre3-(_cPrcPre3-_cPrcNeg3),"@E 999,999.99"),10)+"      |     "+PADR(Transform(_cPrcPre4-(_cPrcPre4-_cPrcNeg4),"@E 999,999.99"),10)+"      |     "+PADR(Transform(_cPrcPre5-(_cPrcPre5-_cPrcNeg5),"@E 999,999.99"),10)+"      |"
	   @ll++,002 PSay "|                                                                                  |Prazo Entrega |       "+DTOC(STOD(_cdatEnt))+"      |       "+DTOC(STOD(_cdatEnt))+"      |       "+DTOC(STOD(_cdatEnt))+"      |       "+DTOC(STOD(_cdatEnt))+"      |       "+DTOC(STOD(_cdatEnt))+"      |"
	   @ll++,002 PSay "|                                                                                  |Frete         |          00.00      |          00.00      |          00.00      |          00.00      |          00.00      |"
	   @ll++,002 PSay "+----------------------------------------------------------------------------------+--------------+---------------------+---------------------+---------------------+---------------------+---------------------+"
	   @ll++,002 PSay "| Powered by Potencial Tecnologia                                                                                                                                                                               |"
	   @ll++,002 PSay "+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"

		IncRegua()
		qCabec->(dbSkip())
			_cPrcPre1 := 0
			_cPrcNeg1 := 0
			_cPrcPre2 := 0
			_cPrcNeg2 := 0
			_cPrcPre3 := 0
			_cPrcNeg3 := 0
			_cPrcPre4 := 0
			_cPrcNeg4 := 0
			_cPrcPre5 := 0
			_cPrcNeg5 := 0
			_cFlag    := .T.
	Enddo
	qCabec->(dbCloseArea())
	Set Device to Screen
	
	
	If aReturn[5] = 1
		Set Printer To
		Commit
		Ourspool(wnrel)
	Endif
	
	MS_FLUSH()
Return