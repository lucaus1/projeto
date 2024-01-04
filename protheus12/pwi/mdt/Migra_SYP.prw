#Include "rwmake.ch"
#Include "topconn.ch"

User Function MigraSYP()
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função para Migração de Cadastro.
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa irá realizar a leitura do arquivo referente ")
Local cDesc2  := OemToAnsi("aos dados a serem imputados nas tabelas SYP")
Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de Migração")
Private lEnd      := .F.
Private NomeProg  := "MIGRASYP"
Private lCopia    := .F.
//Private cPerg     := "FOX006"
Private cArq := "\potencial\SQ3030-MDT-SYP.CSV"
Private nRadio := 1
private aReadTxt := {}
private aCols := {}
private aHeader := {}
private cLineRead
private nCont1 := 0
private nCont2 := 0
private nCont3 := 0
private nCont4 := 0
private nCont5 := 0
private nCont6 := 0
private nCont7 := 0

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, Space(80))
aAdd( aSay, Space(80))
aAdd( aSay, Space(80))
aAdd( aSay, cDesc3 )

aAdd(aButton, { 5,.T.,{||  cArq := ValidPerg() } } )
aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( Titulo, aSay, aButton )
	
If nOpcao == 1
	Processa({|| MIGRASYP_01() }, "Aguarde...", "Processando informações...", .T. )
Endif                     	
	
Return
	
*--------------------------*
Static Function MIGRASYP_01()
*--------------------------*
Local cTexto, lGravou := .F.
Local nAscii := 65
	
SYP->(dbSetOrder(1))
	
fT_fUse(cArq)
fT_fGotop()

If fT_fEof()
	ALERT("ATENCAO, ARQUIVO 01 VAZIO OU NAO EXISTENTE")
	Return()
Endif
acols := {}
nCont1 := 1
While ( !fT_fEof() )
	cLineRead := fT_fReadLn()
	// aReadTxt := strtokarr(cLineRead,",")
     
	 /*
	 cChave  :=substr(cLineread,2,6)
	 cSeq    :=substr(cLineread,11,3)
	 cTexto1 :=substr(cLineRead,17,80)
	 cTexto2 :=substr(cLineRead,98,80)
	 cTexto3 :=substr(cLineRead,179,80)
	 cTexto4 :=substr(cLineRead,259,80)
	 cTexto5 :=substr(cLineRead,339,80)
	 */
	 cChave  :=substr(cLineread,1,6)
	 cSeq    :=substr(cLineread,8,3)
	 cTexto1 :=substr(cLineRead,12,80)
	 cTexto2 :=substr(cLineRead,93,80)
	 cTexto3 :=substr(cLineRead,174,80)
	 cTexto4 :=substr(cLineRead,255,80)
	 cTexto5 :=substr(cLineRead,336,80)
	
	if ncont1 <= 10
       Alert("valor cLineread:"+cLineRead)
	   Alert("valores cChave:"+cChave)
	   Alert("valor cTexto:"+cTexto1+cTexto2+cTexto3+cTexto4+cTexto5)
	   // alert("tamanho areadtxt"+STR(len(areadtxt)))
    endif 
	if ncont1 > 1
	nseq:= 1
	if !Empty(cTexto2)
      nseq  := 2
	Endif
    if !Empty(cTexto3)
      nseq  := 3
	Endif
	if !Empty(cTexto4)
      nseq  := 4
	Endif
	if !Empty(cTexto5)
      nseq  := 5
	Endif
    // Alert("valor de nseq:"+STR(nseq))

	Do Case 
       case nseq==1 
	     aAdd(aCols, {cChave,"001",cTexto1})
	   case nseq==2 
	     aAdd(aCols, {cChave,"001",cTexto1})
	     aAdd(aCols, {cChave,"002",cTexto2})
       case nseq==3
	     aAdd(aCols, {cChave,"001",cTexto1})
	     aAdd(aCols, {cChave,"002",cTexto2})
		 aAdd(aCols, {cChave,"003",cTexto3})
       case nseq==4
	     aAdd(aCols, {cChave,"001",cTexto1})
	     aAdd(aCols, {cChave,"002",cTexto2})
		 aAdd(aCols, {cChave,"003",cTexto3})
	     aAdd(aCols, {cChave,"004",cTexto4})
       case nseq==5
	     aAdd(aCols, {cChave,"001",cTexto1})
	     aAdd(aCols, {cChave,"002",cTexto2})
		 aAdd(aCols, {cChave,"003",cTexto3})
	     aAdd(aCols, {cChave,"004",cTexto4})
	     aAdd(aCols, {cChave,"005",cTexto5})
	EndCase  
	// Alert("tamanho acols:"+STR(len(acols)))
	EndIf
    ncont1++
	fT_fSkip()
End While
Alert("tamanho acols:"+STR(len(acols)))
fT_fUse()
    If nRadio = 1
	  for i := 1 to len(aCols)	
	    //RDY - MEMO RH 
	    dbSelectArea("SYP")
	    dbSetOrder(1)
	    dbGoTop()
        cChave := Alltrim(aCols[i,1])+Alltrim(acols[i,2])
			IncProc("Incluindo: "+cChave)
			If !SYP->(dbSeek(xFilial("SYP")+cChave))
				RecLock("SYP",.T.)
				SYP->YP_FILIAL  := xFilial("SYP")
				SYP->YP_CHAVE   := Alltrim(acols[i,1])
				SYP->YP_SEQ     := Alltrim(aCols[i, 2])
                SYP->YP_TEXTO   := Alltrim(aCols[i, 3])
                SYP->YP_CAMPO   := "Q3_DESCDET"
				SYP->(MsUnlock())
			Endif
		dbSelectArea("RDY")
	    dbSetOrder(1)
	    dbGoTop()	
			If !RDY->(dbSeek(xFilial("RDY")+cChave))
				RecLock("RDY",.T.)
				RDY->RDY_FILIAL  := xFilial("RDY")
				RDY->RDY_CHAVE   := Alltrim(acols[i,1])
				RDY->RDY_SEQ     := Alltrim(aCols[i, 2])
                RDY->RDY_TEXTO   := Alltrim(aCols[i, 3])
                RDY->RDY_CAMPO   := "Q3_DESCDET"
				RDY->(MsUnlock())
			Endif
		
      Next
	EndIf
Return
	
	//+-------------------------------------------------------------------------------------------------
	//| Programa..: ValidPerg()
	//+-------------------------------------------------------------------------------------------------
	//+-------------------------------------------------------------------------------------------------
	//| Descricao.: Criação de tela para realizar coleta de informação do arquivo a ser lido
	//+-------------------------------------------------------------------------------------------------
	
	***********************************
	Static Function ValidPerg()
	***********************************
	Local cExt := "Arquivos CSV | *.CSV"
	Local aRadio := {"Cadastros"}//,"Cod. Barras"}
	Local cAux := ""
	
	
	@ 000, 000 To 310,300 Dialog oTela Title OemToAnsi("Parametros ")
	
	@ 010, 010 To 120,140 Title "Arquivo"
	@ 025, 025 Radio aRadio Var nRadio
	@ 100, 015 Say "Arquivo : "
	@ 100, 040 Get cArq Size 80,010 Picture "@!"
	@ 100, 120 Button "..." Size 10,10 ;
	Action If(Empty(cAux:=AllTrim(cGetFile(cExt,cExt,,,.T.,1))),;
	Nil, cArq:=Left(cAux+Space(50),50))
	
	
	@ 130, 020 BmpButton Type 01 Action If(ValidaArq(@cArq),(nOpc := 1,oTela:End()),)
	@ 130, 050 BmpButton Type 02 Action oTela:End()
	
	Activate Dialog oTela Centered
	
	Return cArq
	
	*-------------------------------*
	Static Function ValidaArq(cArq)
	*-------------------------------*
	Local cAux := cArq
	Local lTem := .T.
	
	If !Empty(cAux)
		cAux := Upper(AllTrim(cAux))
		If !("." $ cAux)
			cAux += ".CSV"
			If !(lTem := File(cAux))
				cAux := StrTran(cAux,".CSV",".DBF")
				lTem := File(cAux)
			Endif
		Else
			lTem := File(cAux)
		Endif
		
		If !lTem
			Alert("Arquivo de Origem não existe !")
			Return .F.
		Endif
		
		cArq := cAux
	Endif
	Return .T.
	
	
	

	
	
	
	
	
	
