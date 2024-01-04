#include "rwmake.ch"
User Function AtuCCSRD     
cPerg := "PWP001"
criaperg(cPerg)

IF pergunte(cPerg,.t.)              
    _cAnoRef := mv_par01
    _cMesRef := mv_par02
   	Processa( {|| RunProc() } )

Endif

Return nil

Static Function RunProc()
   Alert("Processando transf de CC da Tabela SRD")
	// _cTabfech := "RC"+_cCodEmp+substr(_cAnoRef,3,2)+_cMesRef
	DbSelectArea("SRA")
	Do While !EOF()    
	  DbSelectArea("SRD")  
	  DbSetOrder(1)         
	   DbSeek(xFilial("SRD")+SRA->RA_MAT+_cAnoRef+_cMesRef) // Transferir somente de Jan/2007 ate março
	   Do While SRD->RD_MAT == SRA->RA_MAT .AND. SRD->RD_DATARQ == _cAnoRef+_cMesRef
    	   RecLock("SRD",.f.)
	       Replace RD_CC with SRA->RA_CC
	       MsUnlock()
	       DbSkip()	
	   Enddo     
	DbSelectArea("SRA")     
	DbSkip()
	Enddo
	Alert("Fim da Atualização dos CC em SRD")
	
Return

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


