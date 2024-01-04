/*
+-----------+------------+--------------+----------------+------+------------+
| Programa	| XMLTOSC5 Incluido por	| Fanciney Alves  | Data	| 16/08/2018 |
+-----------+------------+--------------+----------------+------+------------+
| Uso		| Modulo Faturamento: Inclusao de pedido de vendaspor arquivo XML|
+-----------+----------------------------------------------------------------+
| Descricao	| Importar XML da pasta C:\Protheus\Protheus_Data\temp e apos    |
|           | validar se documento ja existe e gerar pedido de vendas        |
+-----------+----------------------------------------------------------------+
*/
#include "tbiconn.ch"
#include "protheus.ch"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"                                                                        

User Function XMLTOSC5()
Local aTipo:={'N','B','D'}
Local nQtd := 0, nValor := 0 
Local cFile := Space(10)
Private CPERG   :="NOTAXML"
Private Caminho := "temp\"
// Prepara a Pergunta ---                                                      
Validperg()

While .T.

	pergunte(CPERG,.T.)    

	cFile:= cGetFile( "Arquivo NFe (*.xml) | *.xml", "Selecione o Arquivo de Nota Fiscal XML",,Caminho,.T., )  
	Compara=RetFileName(cFile)  
	Caminho=Substr(cFile,1,Len(cFile) - (Len(Compara)+4))

	aDirectory=Directory(caminho+"*.*")
	nProcura:=aScan(aDirectory,{|x| lower(x[1]) ==lower(compara)+'.xml'})
	Private nHdl    := fOpen(cFile)

	aCamposPE:={}

	If nHdl == -1
		If !Empty(cFile)
			MsgAlert("O arquivo de nome "+cFile+" nao pode ser aberto! Verifique os parametros.","Atencao!")
		Endif 	
		Return
	Endif
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	fClose(nHdl)

	cAviso := ""
	cErro  := ""
	oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)					
	Private oNF

	If Type("oNFe:_NfeProc")<> "U"
		oNF := oNFe:_NFeProc:_NFe
	Else
		oNF := oNFe:_NFe
	Endif     
	Private oEmitente  := oNF:_InfNfe:_Emit
	Private oIdent     := oNF:_InfNfe:_IDE
	Private oDestino   := oNF:_InfNfe:_Dest
	Private oTotal     := oNF:_InfNfe:_Total
	Private oTransp    := oNF:_InfNfe:_Transp
	Private oDet       := oNF:_InfNfe:_Det
	Private oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)  
	Private cEdit1	 := Space(15)
	Private _DESCdigit :=space(55)
	Private _NCMdigit  :=space(8)

	oDet := IIf(ValType(oDet)=="O",{oDet},oDet) 
    cCGC := GetAdvFVal("SA1","A1_CGC",XFilial("SA1")+mv_par02+mv_par03,1,"")
	_cnpj:= SM0->M0_CGC     
	cFli := SA1->A1_LOJA
				 
	// Validacoes -------------------------------
	// -- CNPJ da NOTA = CNPJ do CLIENTE ? oEmitente:_CNPJ          
	If mv_par01=1
		_cnpj:= SM0->M0_CGC
		cCGC := GetAdvFVal("SA1","A1_CGC",XFilial("SA1")+mv_par02+mv_par03,1,"")
		cFli := SA1->A1_LOJA
	Else
		_cnpj:= GetAdvFVal("SA2","A2_CGC",XFilial("SA2")+mv_par02+mv_par03,1,"") 		
		cCGC := SM0->M0_CGC
		cFli := SM0->M0_FILIAL
	EndIf  
              
	If _cnpj!=oEmitente:_CNPJ:TEXT
		If !MsgStop ("CNPJ do Client/Fornec. digitado ("+mv_par02+"/"+mv_par03+") é diferente do CNPJ do XML("+oEmitente:_CNPJ:TEXT+").Selecione Cliente Correto !!!")
			Return Nil
		Endif 
	Endif
    
    IF Type("oDestino:_CNPJ:TEXT")#"U"
	 If  cCGC!=oDestino:_CNPJ:TEXT
		If !MsgStop ("Este XML é da Filial:   ("+  oDestino:_enderDest:_xBairro:TEXT  +")  CNPJ:  ("+  oDestino:_CNPJ:TEXT  +"),  Só e Permitido Importar XML da Filial  (" +cFli+ ")  CNPJ: (" +cCGC+ ")")
			Return Nil
		Endif
	 Endif                   
    Else 
      Alert("Nota de exportação para:"+oDestino:_xNome:TEXT+"-"+oDestino:_enderDest:_xLgr:TEXT+" - "+oDestino:_enderDest:_xPais:TEXT)
      
    Endif
	
cCNPJEmit:=oEmitente:_CNPJ:TEXT
// ALERT("CNPJ Emitente:"+cCNPJEmit) 
cNumNF:=oIdent:_nNF:TEXT
// Alert("Numero da Nota:"+cNumNF)                          

cNomePais:=oDestino:_enderDest:_xPais:TEXT
// Alert("Nome Pais:"+cNomePais)  

nValorProd:=oTotal:_ICMSTot:_vProd:TEXT
// Alert("Valor do Produto:"+nValorProd)  

if Type("oTransp:_transporta:_CNPJ:TEXT")#"U"
 cCNPJTransp:= oTransp:_transporta:_CNPJ:TEXT      
 // Alert("CNPJ Transp:"+cCNPJTransp)
Else 
  cCNPJTransp:= oTransp:_transporta:_CPF:TEXT  
Endif 
cPlaca :=""

if Type("oTransp:_veicTransp:_placa:TEXT")#"U"
cPlaca:= oTransp:_veicTransp:_placa:TEXT
DbSelectArea("DA3")
DbSetOrder(3)
DbSeek(xFilial("DA3")+cPlaca) 
Endif 

cPesol:= oTransp:_vol:_pesol:TEXT
// Alert("Pesol L:"+cPesol) 

cPesoB :=  oTransp:_vol:_pesob:TEXT
// Alert("Peso Bruto:"+cPesob)

// oDet                           
alert("analisando tag de cobrança")

IF Type("oNF:_InfNfe:_Cobr")#"U"
  cFatura:= oFatura:_fat:_nFat:TEXT
 // Alert("Numera Fatura:"+cFatura)
Endif 

cInfCpl:= oNF:_InfNfe:_InfAdic:_InfCpl:TEXT     
// Alert("Inf Compl:"+cInfCpl) 

// Fim de analise de TAGs

	
	// -- Nota Fiscal já existe na base ? 
	If SF2->(DbSeek(XFilial("SF2")+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+Padr(OIdent:_serie:TEXT,3)+mv_par02+mv_par03)) 
		MsgAlert("Nota No.: "+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+"/"+OIdent:_serie:TEXT+" do Cliente/Fornec. "+mv_par02+"/"+mv_par03+" Ja Existe. A Importacao sera interrompida")
		Return Nil   
	Endif
  
	If  alltrim(mv_par04) <> Alltrim((OIdent:_nNF:TEXT))
		Alert("Nota Informada"+mv_par04+" Nao confere com XML Selecionado"+OIdent:_nNF:TEXT) 
		Return Nil    
	EndIf   
	
	
	
    // Obtendo numero do pedido              
    // GETSXENUM( <alias>, <campo>, <aliasSXE>, <ordem> )
   
    //cNumPed := STRZERO((Val(GetSxeNum("SC5","C5_NUM"))+1),6) 
    // ALERT("NUMERO DO PEDIDO: "+cNumPed)
    /*/
	C5_TRANSP- está em branco A1_TRANSP
	C5_PBRUTO- peso bruto valor incorreto. <pesoB>21100.000</pesoB>
	C5_VOLUME1- valor incorreto <qVol>26</qVol>
	C5_VOLUME2- em branco <nVol>20.332</nVol>
	C5_ESPECI1- nome diferente – aumentar tamnho do campo
	C5_ESPECI2- em branco - <marca>MIL BRASIL</marca>
    C5_MENPAD- incorreta
    C5_MENNOTA- incorreta – é o que ta no XML, neste caso vai ter que pedir para colocarem de forma correta na origem no caso o sistema BRFLOW
    C6_QTDAM- em branco	-
    C6_PRUNIT- em branco-<vUnCom>1530.2200</vUnCom>
    C6_DESCRI- incorreto- SB1_DESC TA puxando do cadastro do TOTVS, 
	tag do XML <xProd>15000-PCS 20mmX38mm MAD. SERRADA BRUTA FAS RS AD EXPORT. SARRAFO TAUARI-VERMELHO - Cariniana micrantha</xProd>

	/*/


	aCabec := {}
	aItens := {}
    // aadd(aCabec,{"C5_FILIAL" ,xFilial("SC5"),Nil,Nil})    
   	// aadd(aCabec,{"C5_NUM"    ,cNumPed,Nil,Nil})
	aadd(aCabec,{"C5_TIPO"   ,"N",Nil,Nil})
	aadd(aCabec,{"C5_CLIENTE",mv_par02,Nil,Nil})
	aadd(aCabec,{"C5_LOJACLI",mv_par03,Nil,Nil})
	aadd(aCabec,{"C5_CLIENT" ,mv_par02,Nil,Nil})
	aadd(aCabec,{"C5_LOJAENT",mv_par03,Nil,Nil})       
	aadd(aCabec,{"C5_TIPOCLI",SA1->A1_TIPO,Nil,Nil})
	aadd(aCabec,{"C5_CONDPAG",if(SA1->A1_TIPO=="F",'015','030'),Nil,Nil})
	aadd(aCabec,{"C5_MOEDA"  ,if(SA1->A1_TIPO=="X",1,1),Nil,Nil})
	aadd(aCabec,{"C5_PESOL"  ,Val(oTransp:_vol:_pesol:TEXT),Nil,Nil})
	aadd(aCabec,{"C5_PBRUTO" ,Val(oTransp:_vol:_pesob:TEXT) ,Nil,Nil})
	// amaggi nao tem qvol 
	if Type("oTransp:_vol:_qvol:TEXT")#"U"
	   aadd(aCabec,{"C5_VOLUME1",Val(oTransp:_vol:_qvol:TEXT),Nil,Nil})
    endif 
	if Type("oTransp:_vol:_nvol:TEXT")#"U"
	   aadd(aCabec,{"C5_VOLUME2",Val(oTransp:_vol:_nvol:TEXT),Nil,Nil})
	endif
	if Type("oTransp:_vol:_esp:TEXT")#"U"
       aadd(aCabec,{"C5_ESPECI1",oTransp:_vol:_esp:TEXT ,Nil,Nil})
    endif 
	if Type("oTransp:_vol:_marca:TEXT")#"U"
	aadd(aCabec,{"C5_ESPECI2",oTransp:_vol:_marca:TEXT ,Nil,Nil})
	endif
	aadd(aCabec,{"C5_MENNOTA",oNF:_InfNfe:_InfAdic:_InfCpl:TEXT ,Nil,Nil})
	aadd(aCabec,{"C5_MENPAD" ,'001' ,Nil,Nil})
    aadd(aCabec,{"C5_TIPLIB" ,'1',Nil,Nil})
	aadd(aCabec,{"C5_TXMOEDA",if(SA1->A1_TIPO<>"X",1,4.3396),Nil,Nil})
	aadd(aCabec,{"C5_DESCONT",Val(oTotal:_ICMSTot:_vDesc:TEXT),Nil,Nil})
	aadd(aCabec,{"C5_TPCARGA",'2',Nil,Nil})
	aadd(aCabec,{"C5_TRANSP",SA1->A1_TRANSP,Nil,Nil})	    
	aadd(aCabec,{"C5_VEICULO",DA3->DA3_COD,Nil,Nil})	    
	aadd(aCabec,{"C5_SITUACA",'0',Nil,Nil})

	cData:=Alltrim(OIdent:_dhEmi:TEXT)
	dData:=CTOD(cData) // '/'+Substr(cData,6,2)+'/'+Left(cData,4))
	aadd(aCabec,{"C5_EMISSAO",dDatabase,Nil,Nil})                   
    Alert("Data Emissão:"+cData)

	DbSelectArea("DA3")
	DbSetOrder(1)
	
	
   	For nX := 1 To Len(oDet)
		// Validacao: Produto Existe no SB1 ? 
		// Se não existir, abrir janela c/ codigo da NF e descricao para digitacao do cod. substituicao. 
		// Deixar opção para cancelar o processamento //  Descricao: oDet[nX]:_Prod:_xProd:TEXT
  
		aLinha := {}
		cProduto:=Left(oDet[nX]:_Prod:_cProd:TEXT+space(15),15)
        cDescProd := oDet[nX]:_Prod:_xProd:TEXT 
		cNCM:=IIF(Type("oDet[nX]:_Prod:_NCM")=="U",space(12),oDet[nX]:_Prod:_NCM:TEXT)
		Chkproc=.F.

		   // POTENCIAL                             
		   DbSelectArea("SB1") 
		   DbSetOrder(1) 
		   if DbSeek(xFilial("SB1")+cPRODUTO) 
			If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM) .and. cNCM != '00000000'
				RecLock("SB1",.F.)
				Replace B1_POSIPI with cNCM
				MSUnLock()
			Endif
			/*
			if cDescProd <> SB1->B1_DESC
				Alert("Descricao do Produto no XML:"+cDescProd+"  <> diferente do cadastro!"+SB1->B1_DESC)
		        RecLock("SB1",.F.)
				Replace B1_DESC with cDescProd
				MSUnLock()
			endif 
			*/


		   Else 
		    Alert("Produto não encontrada:"+cProduto)
		   Endif        
	    // aadd(aLinha,{"C6_FILIAL",xFilial("SC6"),Nil,Nil})
		// aadd(aLinha,{"C6_NUM",cNumPed,Nil,Nil})
		aadd(aLinha,{"C6_ITEM",STRZERO(Nx,2),Nil,Nil})
		aadd(aLinha,{"C6_PRODUTO",SB1->B1_COD,Nil,Nil})
		If Val(oDet[nX]:_Prod:_qTrib:TEXT) != 0 
			nQtd := Val(oDet[nX]:_Prod:_qTrib:TEXT)
		Else
			nQtd := Val(oDet[nX]:_Prod:_qCom:TEXT)
		Endif

		nValor := Val(oDet[nX]:_Prod:_vUnCom:TEXT)
		
		/*
		cTpConv := If(SB1->B1_TIPCONV == 'M','D','M')
		If cTpConv == 'M'
			nQtd := nQtd*SB1->B1_CONV
			nValor := nValor*SB1->B1_CONV
		Else
			nQtd := nQtd/SB1->B1_CONV
			nValor := nValor/SB1->B1_CONV
		EndIf
		*/ 
		aadd(aLinha,{"C6_DESCRI",cDescProd,Nil,Nil})
		aadd(aLinha,{"C6_QTDVEN",nQtd,Nil,Nil})
		aadd(aLinha,{"C6_PRCVEN",nValor,Nil,Nil})
		aadd(aLinha,{"C6_VALOR",Val(oDet[nX]:_Prod:_vProd:TEXT),Nil,Nil})
		aadd(aLinha,{"C6_LOCAL",SB1->B1_LOCPAD,Nil,Nil})
		_cfop:=oDet[nX]:_Prod:_CFOP:TEXT
        aadd(aLinha,{"C6_TES",if(SA1->A1_TIPO=="X",'701','501'),Nil,Nil})
        aadd(aLinha,{"C6_CF",_cfop,Nil,Nil})
		If Type("oDet[nX]:_Prod:_vDesc")<> "U"
		  aadd(aLinha,{"C6_VALDESC",Val(oDet[nX]:_Prod:_vDesc:TEXT),Nil,Nil})
		Endif                      
		aadd(aItens,aLinha)
	Next nX
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Inclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cx=1                         
	// - Executa a Ultima Nota
	If Len(aItens) > 0
		lMsErroAuto:=.f.
		lMsHelpAuto:=.T.
		ROLLBACKSXE()
		//MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3) //Nota
		Alert("GERANDO PV  !!!")  
	   	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabec,aItens,3) //Pedido de Vendas
		IF lMsErroAuto
			MSGALERT("ERRO NO PROCESSO")
			MostraErro()
		ELSE
			ConfirmSX8()
			MSGALERT("GERADO PV:"+SC5->C5_NUM)
		ENDIF
	Endif		
End

Return 

Static Function ValidPerg()
//
PRIVATE APERG := {},AALIASSX1:=GETAREA()

//-- Preencho com espaços, senão o Dbseek nao funciona 
CPERG=Left(CPERG+Space(10),10)

//     "X1_GRUPO" ,"X1_ORDEM","X1_PERGUNT"    		,"X1_PERSPA"		,"X1_PERENG"		,"X1_VARIAVL","X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"	,"X1_VAR01"	,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"		,"X1_DEFSPA2"		,"X1_DEFENG2"		,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5","X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"
AADD(APERG,{CPERG ,"01"		,"Tipo de Nota ?"		,"Nota Fiscal de?"	,"Nota Fiscal de?"	,"mv_ch1"	,"N"		,1				,0				,1				,"C"		,""			,"mv_par01"	,"Normal"   ,"Normal"		,"Normal"		,""			,""			,"Beneficiamento","Beneficiamento"	,"Beneficiamento"	,""			,""			,"Devolucao","Devolucao"	,"Devolucao"	,""			,""			,""			,""				,""				,""			,""			,""			,""			,""				,""			,"" 		,"S"		,""				,""})
AADD(APERG,{CPERG ,"02"		,"Cliente/Fornec ?"	,"Cliente/Fornec ?"	,"Cliente/Fornec ?"	,"mv_ch2"	,"C"		,6				,0				,0				,"C"		,""			,"mv_par02"	,""			,""				,""				,""			,""			,""				,""					,""					,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""			,""				,""			,"CLI" 		,"S"		,""			,""})
AADD(APERG,{CPERG ,"03"		,"Loja ?"				,"Loja ?"			   ,"Loja ?"			   ,"mv_ch3"	,"C"		,2				,0				,0				,"G"		,""			,"mv_par03"	,""			,""				,""				,""			,""			,""				,""					,""					,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""			,""				,""			,"" 		,"S"		,""				,""})
AADD(APERG,{CPERG ,"04"		,"Nota ?"				,"Nota ?"			   ,"Nota ?"			   ,"mv_ch4"	,"C"		,9 			,0				,0				,"C"		,""			,"mv_par04"	,""			,""				,""				,""			,""			,""				,""					,""					,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""			,""				,""			,"" 		,"S"		,""				,""})

DBSELECTAREA("SX1")
DBSETORDER(1)
//
FOR I := 1 TO LEN(APERG)
	IF  !DBSEEK(CPERG+APERG[I,2])
		RECLOCK("SX1",.T.)
		FOR J := 1 TO FCOUNT()
			IF  j <= LEN(APERG[I])
				FIELDPUT(J,APERG[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
RESTAREA(AALIASSX1)
//
RETURN()

Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
	nTam *= 0.8                                                                
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
	nTam *= 1                                                                  
Else	// Resolucao 1024x768 e acima                                           
	nTam *= 1.28                                                               
EndIf                                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
//³Tratamento para tema "Flat"³                                               
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
If "MP8" $ oApp:cVersion                                                      
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
		nTam *= 0.90                                                            
	EndIf                                                                      
EndIf                                                                         
Return Int(nTam)                                                                

Static Function ValProd()
_DESCdigit=Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))
_NCMdigit=GetAdvFVal("SB1","B1_POSIPI",XFilial("SB1")+cEdit1,1,"")
Return 	ExistCpo("SB1")                                                                               

Static Function Troca()  

Chkproc=.T.      
/*
cProduto=cEdit1
If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM) .and. cNCM != '00000000'
	RecLock("SB1",.F.)
	Replace B1_POSIPI with cNCM
  	MSUnLock()
Endif 
_oDlg:End()
*/

Return

/*---------+------------+-------+------------------+------+---------------¦
¦ Função   ¦ RetCodFil  ¦ Autor ¦ UJ               ¦ Data ¦ 16/07/2012    ¦
+----------+------------+-------+------------------+------+---------------+
¦ Descriçäo¦ Retorna o código da filial baseado no CNPJ.                  ¦
+----------+--------------------------------------------------------------*/
Static Function RetCodFil(__xCnpj)
Local __cFil := ""
Local nSM0Recno := SM0->(Recno())

SM0->(dbGoTop())
While !SM0->(Eof())
	If SM0->M0_CGC == __xCnpj
		__cFil := SM0->M0_CODFIL
		Exit
	EndIf
	SM0->(dbSkip())
End

SM0->(dbGoTo(nSM0Recno))

Return __cFil
