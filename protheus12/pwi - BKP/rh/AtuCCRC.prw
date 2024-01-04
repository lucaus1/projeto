#include "rwmake.ch"
User Function AtuCCRC     

cPerg := "PWP001"
criaperg(cPerg)

IF pergunte(cPerg,.t.)              
    _cAnoRef := mv_par01
    _cMesRef := mv_par02
	_cCodEmp := "07"
    cArqFech := "RC"+_cCodEmp+substr(_cAnoRef,3,2)+_cMesRef
    if verarq()
    	Processa( {|| RunProc() } )
	Endif
Endif

Return nil

Static Function RunProc()
   Alert("Processando transf de CC da Tabela "+cArqFech)	 
	DbSelectArea("SRA") 
	dbgotop()
    procregua(reccount())
    dbgotop()
	Do While !EOF()    
	  DbSelectArea(cArqFech)  
      DbSeek(xFilial("SRC")+SRA->RA_MAT) // Transferir somente de Jan/2007 ate março
	   Do While RC_MAT == SRA->RA_MAT 
	       Replace RC_CC with SRA->RA_CC
	       DbSkip()	
	   Enddo     
	DbSelectArea("SRA")     
	DbSkip()
	incproc("Transferindo CC...")
	Enddo
Alert("Fim da Atualização dos CC em "+cArqFech)
	
Return



Static Function VerArq()
 IF Select(cArqFech)==0
  DbUseArea(.T.,__cRDD,cArqFech,cArqFech,.F.,.F.)              
  // "DBF/CDX"
  // cFiltro := "RC_MAT == cMatde"
  if Select(cArqFech)==0
   Alert("Verificar arquivo de fechamento")
   Return(.f.)
  Endif
  cFiltro := ""
  _cindex := CriaTrab(nil,.f.)
  IndRegua(cArqFech,_cindex,"RC_FILIAL+RC_MAT+RC_PD",,cFiltro,"Criando Indice Temporario")
 Elseif Select(cArqFech)<>0         
   // cFiltro := "RC_MAT == cMatde"
   cFiltro := ""
  _cindex := CriaTrab(nil,.f.)
  IndRegua(cArqFech,_cindex,"RC_FILIAL+RC_MAT+RC_PD",,cFiltro,"Criando Indice Temporario")
 Endif  
Return(.T.)


Static Function CriaPerg(cPerg)
Local _sAlias := Alias()
Local aRegs := {}
Local i,j
dbSelectArea("SX1")
dbSetOrder(1)
// Grupo Ordem Pergunta                          /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//                                                                              1                                                                      2                                                   3                                              4
//          1     2     3                       4    5    6         7    8   9  0  1    2   3           4            5    6    7    8    9             0   1   2   3   4          5   6   7   8   9        0   1   2   3   4       5   6   7   8      9   0   1   2
AADD(aRegs,{cPerg,"01", "Ano  Referencia    ?", ".", ".", "mv_ch1", "C", 04, 0, 0, "G", "", "mv_par01", ""         , "" , "" , "" , "" , ""          , "", "", "", "", ""       , "", "", "", "", ""     , "", "", "", "", ""    , "", "", "", ""   , "", "", "", "" })
AADD(aRegs,{cPerg,"02", "Mes referencia     ?", ".", ".", "mv_ch2", "C", 02, 0, 0, "G", "", "mv_par02", ""         , "" , "" , "" , "" , "   "       , "", "", "", "", "       ", "", "", "", "", "    " , "", "", "", "", "    ", "", "", "", ""   , "", "", "", "" })

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return nil


