#INCLUDE "rwmake.ch"
#include "Topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PTSRT     � Autor � Franciney Alves    � Data �  18/12/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de analise de provisoes Corrente x Anterior.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PTRSRT


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Provis�es Corrente x Anteriores "
Local cPict          := ""
Local titulo       	 := "Relatorio de Provis�es Corrente x Anteriores "
Local nLin         	 := 80

Local Cabec1       := "Relat�rio de Acumulados"                                                                           
//																														  1	        1         1         1         1         1         1         1         1
// 						        1         2         3         4         5         6         7         8         9         0		    1         2         3         4         5         6         7         8
//                     123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec2       := "RT_FIL   RT_CC         RT_MAT   RA_NOME                            Verba   RV_DESC                           MCOR              MANT                  DIF               RT_DATACAL"
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "G"
Private nomeprog     := "PTRSRT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey	 := 0
Private aPerg 	:= {}
Private cPerg   := "PTRSRT"
Private cbtxt   := Space(10)
Private cbcont  := 00
Private CONTFL  := 01
Private m_pag   := 01
Private wnrel   := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SRT"

dbSelectArea("SX1")
dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Data Calc Referenc?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Data Calc Anterior?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Centro de Custo de ?","mv_ch3","C",09,0,1,"G","","mv_par03","","SI3","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Centro de Custo Ate?","mv_ch4","C",09,0,1,"G","","mv_par04","","SI3","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "05", "Matricula de ?","mv_ch5","C",06,0,1,"G","","mv_par05","","SRA","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "06", "Matricula Ate?","mv_ch6","C",06,0,1,"G","","mv_par06","","SRA","","","","","","","","","","","","",""})

  	 
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
			Replace X1_DEF02    with aPerg[nA][15]
			Replace X1_DEFSPA1  with aPerg[nA][12]
			Replace X1_DEFSPA2  with aPerg[nA][15]
			Replace X1_DEFENG1  with aPerg[nA][12]
			Replace X1_F3       with aPerg[nA][13]
			Replace X1_DEFENG2  with aPerg[nA][15]
			MsUnlock()
		Endif
	Next


dbSelectArea("SRT")
dbSetOrder(1)


pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif
                     

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  01/09/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)
		_cQuery1 := " SELECT RT_FILIAL,RT_CC,RT_MAT,RT_DATACAL,RT_VERBA,RT_TIPPROV,SUM(RT_VALOR) AS MCOR, "
	    _cQuery1 += " (SELECT SUM(RT_VALOR) FROM SRT010 WHERE RT_MAT=A.RT_MAT AND RT_FILIAL=A.RT_FILIAL AND "
		_cQuery1 += " RT_DATACAL ='" + Dtos(MV_PAR01) + "' AND RT_VERBA=A.RT_VERBA AND RT_TIPPROV=A.RT_TIPPROV) AS MANT,"
		_cQuery1 += "(SUM(RT_VALOR) - (SELECT SUM(RT_VALOR) FROM SRT010 WHERE RT_MAT=A.RT_MAT "
		_cQuery1 += " AND RT_FILIAL=A.RT_FILIAL AND "
		_cQuery1 += " RT_DATACAL='"+ Dtos(MV_PAR01) + "'AND RT_VERBA=A.RT_VERBA AND RT_TIPPROV=A.RT_TIPPROV)) AS DIF"
		_cQuery1 += " FROM SRT010 AS A WHERE D_E_L_E_T_<>'*' AND RT_FILIAL='01' AND RT_DATACAL='" + Dtos(MV_PAR02) + "' AND RT_MAT BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "    
		_cQuery1 += " AND RT_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
		_cQuery1 += " GROUP BY RT_FILIAL,RT_CC,RT_MAT,RT_DATACAL,RT_VERBA,RT_TIPPROV HAVING (SUM(RT_VALOR) - (SELECT SUM(RT_VALOR) FROM SRT010 WHERE RT_MAT=A.RT_MAT "
		_cQuery1 += " AND RT_FILIAL=A.RT_FILIAL AND RT_DATACAL='"+ Dtos(MV_PAR01) + "' AND RT_VERBA=A.RT_VERBA AND RT_TIPPROV=A.RT_TIPPROV)) > 0 "
		_cQuery1 += " ORDER BY RT_FILIAL,RT_CC,RT_MAT,RT_DATACAL,RT_VERBA,RT_TIPPROV "
	
    /*
		_cQuery1 := " select RT_CC, RT_MAT, RT_PD, RT_DATARQ, RT_DATPGT, RT_TIPO1, RT_HORAS, RT_VALOR "
	    _cQuery1 += " FROM SRT010   WHERE SRT010.D_E_L_E_T_<>'*' AND RT_DATARQ BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
   	    _cQuery1 += " AND RT_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
    	_cQuery1 += " AND RT_MAT BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	    _cQuery1 += " ORDER BY RT_DATARQ, RT_CC, RT_MAT ASC "
	 Else
	 	_cQuery1 := " select RT_CC, RT_MAT, RT_PD, RT_DATARQ, RT_DATPGT, RT_TIPO1, RT_HORAS, RT_VALOR "
	    _cQuery1 += " FROM SRT010   WHERE SRT010.D_E_L_E_T_<>'*' AND RT_DATARQ BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
   	    _cQuery1 += " AND RT_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
    	_cQuery1 += " AND RT_MAT BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
  	    _cQuery1 += " AND RT_PD IN (" + ALLTRIM(MV_PAR07)+ ")"
	    _cQuery1 += " ORDER BY RT_DATARQ, RT_CC, RT_MAT ASC "	  
	 Endif	
	*/
	
	TcQuery _cQuery1 Alias "qRegSRT" new


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
DbSelectArea("qRegSRT")
SetRegua(RecCount())

dbGoTop()
While !EOF()                                       
    // FUNCIONARIOS
    DbSelectArea("SRA")
	DbSetOrder(1)
    DbSeek(xFilial()+qRegSRT->RT_MAT)                        
	// VERBAS
	DbSelectArea("SRV")
	DbSetOrder(1)
    DbSeek(xFilial()+qRegSRT->RT_VERBA)                        
    // CENTRO DE CUSTOS
    DbSelectArea("SI3")
    DbSetOrder(1)
    DbSeek(xFilial()+SRA->RA_CC)
    DbSelectArea("qRegSRT")						

   If lAbortPrint                                  
	  @0, 000 PSay Avalimp(132)
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
//																														  1	        1         1         1         1         1         1         1         1
// 						        1         2         3         4         5         6         7         8         9         0		    1         2         3         4         5         6         7         8
//                     123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//    Cabec2       := "RT_FIL   RT_CC         RT_MAT   RA_NOME                            Verba   RV_DESC                           MCOR              MANT 					DIF 			  RT_DATACAL"

	@nLin,001 PSAY	qRegSRT->RT_FILIAL
	@nLin,010 PSAY	qRegSRT->RT_CC
	@nLin,024 PSAY	qRegSRT->RT_MAT
	@nLin,033 PSAY	SRA->RA_NOME
	@nLin,068 PSAY	qRegSRT->RT_VERBA
	@nLin,076 PSAY	SRV->RV_DESC
	@nLin,110 PSAY	Transform(qRegSRT->MCOR, "@E 999,999,999.99")
	@nLin,128 PSAY	Transform(qRegSRT->MANT, "@E 999,999,999.99")
	@nLin,150 PSAY	Transform(qRegSRT->DIF,  "@E 999,999,999.99")	
	@nLin,168 PSAY	qRegSRT->RT_DATACAL
	nLin ++
    qRegSRT->(dbSkip())
   	                
    IncProc()         

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN    
qRegSRT->(dbCloseArea())

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
