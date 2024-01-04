#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GDBProv º Autor ³ Potencial Tenologia Franciney Data 29/05/07±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera diferença da Baixa de provisao via aviso previo indeniº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GDBProv
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Private cString := "SRC"
Private cPerg   := "GDBPRV"
Private aPerg 	:= {}


Validperg()
Pergunte(cPerg,.f.)
Pergunte(cPerg,.T.)
dbSelectArea("SRC")
dbSetOrder(1)                   
DbGotop()
Alert("Inicio de Processamento")
Do While !eof()                                           
      
  /*
  Eventos 023/057/304/305 – Férias em rescisão – existe a interferência da contabilização de parte destes lctos manual.
  Eventos 045/065 – 13º Salário em Rescisão – existe a interferência da contabilização de parte destes lctos manual.
  */

  If SRC->RC_PD $ "023/057/304/305/045/065"
      // Relacionamentos de verbas de rescisao x provisao
      // 023 -> Ferias proporcionais 		   id.calculo: 087 x 921 baixa prov ferias rescisao id.calculo: 262    -> 949 dif prov ferias rescisao
      // 057 -> 1/3 DE FERIAS RESCIS          id.calculo: 125 x 923 baixa 1/3 prov ferias rescisao id.calculo: 264 -> 951 dif 1/3 prov ferias rescisao
      // 304 -> MEDIA FER PROP RESC           id.calculo: 249 x 922 baixa adicionais prov ferias id.calculo: 263  -> 950 dif adic prov ferias rescisao
      // 305 -> MEDIA FERIAS VENCIDAS RESCISAOid.calculo: 248 x 922 
      // 045 -> 13O SAL.RESCISAO              id.calculo: 114 x 929 baixa prov 13 rescisao id.calculo: 274         -> 953  // dif prov 13
      // 065 -> 13O SALARIO INDENIZA          id.calculo: 115 x 930 baixa adic prov 13 rescisao id.calculo: 275    -> 954  // dif adic prov 13 
      // relacionamento entre valores das verbas rescisao x provisao
       // 023 -> Ferias proporcionais 		  x  921 baixa prov ferias rescisao id.calculo: 262    -> 949 dif prov ferias rescisao
      // 057 -> 1/3 DE FERIAS RESCIS          id.calculo: 125 x 923 baixa 1/3 prov ferias rescisao id.calculo: 264 -> 951 dif 1/3 prov ferias rescisao
      // 304 -> MEDIA FER PROP RESC           id.calculo: 249 x 922 baixa adicionais prov ferias id.calculo: 263  -> 950 dif adic prov ferias rescisao
      // 305 -> MEDIA FERIAS VENCIDAS RESCISAOid.calculo: 248 x 922 
      // 045 -> 13O SAL.RESCISAO              id.calculo: 114 x 929 baixa prov 13 rescisao id.calculo: 274         -> 953  // dif prov 13
      // 065 -> 13O SALARIO INDENIZA          id.calculo: 115 x 930 baixa adic prov 13 rescisao id.calculo: 275    -> 954  // dif adic prov 13 
      nReg := Recno()
      cMatDif := SRC->RC_MAT
      cCCDif  := SRC->RC_CC      
      dDataPg := SRC->RC_DATA       
      cPdDif  := Space(3)

      DbSelectArea("SRT")   // ACUMULADO DE PROVISAO
      DbSetOrder(1) // mat + cc+ dt calculo + prov + verba            
      Do Case 
       Case SRC->RC_PD == "023"
        IF DbSeek(xFilial("SRT")+SRC->RC_MAT+SRC->RC_CC+Dtos(mv_par01)+"1"+"921")
          nValDif := SRC->RC_VALOR - SRT->RT_VALOR
          cPdDif := "949"
        Endif
        If !Empty(cPdDif)
         DbSelectArea("SRC")       
         RecLock("SRC",.T.)
         Replace RC_FILIAL with xFilial("SRC")
         Replace RC_MAT with cMatDif  
         Replace RC_CC with cCCDif
         Replace RC_PD with cPdDif
         Replace RC_VALOR with nValDif
         Replace RC_TIPO1 with "V"
         Replace RC_TIPO2 with "G"
         Replace RC_DATA with dDataPg
         MsUnlock()
         DbGoto(nReg)       
        Endif  
      EndCase
   
  Endif
   dbSelectArea("SRC")
   DbSkip()

Enddo
Alert("Fim de Processamento")
Return

Static Function ValidPerg()
dbSelectArea("SX1")
dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Data da Ultima Provisao     ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})

  	 
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

Return