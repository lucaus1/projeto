#include "Totvs.CH"
#include "rwmake.ch"  
#include "font.CH"
#include 'topconn.ch'                          
#INCLUDE "JPEG.CH"
#include "VKEY.CH"

/*
ROTINA PARA CADASTRO DE ARVORES 

TABELAS A SEREM UTILIZADAS:
                                
ZT8 
ZU5 

ZT8_UPA - C 5
ZT8_BLOCO - C 8
ZT8_CODUT - C 3
ZT8_CODEQP - C 3
ZT8_ADINV - DATA 8

Itens de Cadastro de Árvores
ZU5_FILA - NUMÉRICO 3
ZU5_AESP - CARACTER 20
ZU5_ANUM - NUMÉRICO 4
ZU5_DAP - NUMÉRICO 3
ZU5_VOLUME - NUMÉRICO 7
ZU5_QUAL - CARACTER 3
ZU5_UPA - CARACTER 5
ZU5_BLOCO - CARACTER 8
ZU5_CODUT - CARACTER 3
ZU5_ADINV - DATA 8
ZU5_AEAST - NUMÉRICO 13
ZU5_ANORTH - NUMÉRICO 14
ZU5_ACESSO -  Lógico (1)

VOLUME DE INVENTÁRIO
=(0,001602*(DAP)^1,90)




*/

User Function CADZT8ZU5()   
Private c       := 0
Private cUPA    := Space(06)    // UPA
Private cBLOCO  := Space(08)  // Bloco UTM
Private cCODUT   := Space(03)  // Codigo UT
Private cCODEQP := Space(03)  // Codigo Equipe 
Private dADINV := dDataBase //  - DATA do Inventário

Private oUPA   // Objeto UPA
Private oBLOCO // Objeto Bloco UTM
Private oCODUT  // Objeto Codigo UT
Private oCODEQP := Space(03)  // Objeto Codigo Equipe 
Private oADINV  := dDataBase //  Objeto data do Inventário



// Itens de Cadastro de Árvores
Private nFila   := 0 
Private cANUM   := Space(06) 
Private cAESP   := Space(04)
Private nDAP    := 00000 // - NUMÉRICO 7
Private nVOLUME := 00000 //  - NUMÉRICO 7
Private cQUAL   := Space(03)
Private cAcesso := "V" 


Private oFila 
Private oANUM 
Private oAESP
Private nDAP    := 000 // - NUMÉRICO 7
Private nVOLUME := 0 //  - NUMÉRICO 7
Private cQUAL   := Space(03)
Private oAcesso 



Public oOK := LoadBitmap(GetResources(),'br_verde')
Public oNO := LoadBitmap(GetResources(),'br_vermelho')  

Public oBrowse                
Public cMiltiGet := ""                    
Public aBrowse, aHeader,oMultiGe1
Private oFont06 := TFont():New('Arial',9,06,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont10 	    := TFont():New('Arial',9,10,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont11 	    := TFont():New('Arial',9,11,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont12 	    := TFont():New('Arial',9,12,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont13 	    := TFont():New('Arial',9,13,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont14 	    := TFont():New('Arial',9,14,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont17 	    := TFont():New('Arial',9,17,.T.,.T.,5,.T.,5,.T.,.F.),;
oFont20 	    := TFont():New('Arial',9,20,.T.,.T.,5,.T.,5,.T.,.F.)


 n1 := 0
 // n1 := if(ValType(n)=="N",n,0)
 aBrowse1 := {}
 aBrowse1 := if(ValType(aBrowse)=="A",aBrowse,{})	
 aBrowse   := {} 
 aHeader1 := {}
 aHeader1 := if(ValType(aHeader)=="A",aHeader,{})
 aHeader := {}          

nUsado := 8
nRegistro := 1             
AADD(aHeader,{ "Fila "   , "ZU5_FILA"        ,"@999"             ,09,0, ".T." 		,"","C","ZU5"} )
AADD(aHeader,{ "Árvore"  , "ZU5_ANUM"	     ,"@999999"			 ,06,0, ".T." 		,"","C","ZU5"} )
AADD(aHeader,{ "Especie" , "ZU5_AESP"        ,"@!"				 ,04,0, ".T." 		,"","C","ZU5"} )
AADD(aHeader,{ "DAP"     , "ZU5_DAP"         ,"@999"			 ,03,0, ".T." 		,"","C","ZU5"} )
AADD(aHeader,{ "Volume"  , "ZU5_VOLUME"      ,"@999.999"		 ,07,3, ".T." 		,"","C","ZU5"} )
AADD(aHeader,{ "Quality" , "ZU5_QUAL"        ,"@!"				 ,01,0, ".T." 		,"","C","ZU5"} )
AADD(aHeader,{ "Acesso"  , "ZU5_Acesso"      ,"@!"				 ,01,0, ".T." 		,"","C","ZU5"} )

nRegistro := 1
nCnt := 1
// Array(nRegistro,Len(aHeader)+2)

DbSelectArea("ZT8")
DbSetOrder(1) 

Alert("Rotina Customizada em fase de Validação") 

MTela()

// Reset:
/*
SetKey(VK_F4, Nil)
SetKey(VK_F5, Nil)              
SetKey(VK_F6, Nil)              
SetKey(VK_F7, Nil)              
*/

Return

	


/***********************************************/
Static Function MTela()
Local cVar     := Nil
Local oGet     := Nil                             
Local nAt      := 1
// Local oOK := LoadBitmap(GetResources(),'br_verde')
// Local oNO := LoadBitmap(GetResources(),'br_vermelho')  


DEFINE MSDIALOG oDlg TITLE "Cadastro de Árvores " From 10,40 TO 50,150 

                                                                                         
@ 010,010 Say "UPA :"         SIZE 50,7 PIXEL PIXEL OF oDlg
@ 025,010 Say "BLOCO :"       SIZE 10,7 PIXEL OF oDlg
@ 040,010 Say "Cod. UT : "    SIZE 50,7 PIXEL OF oDlg
@ 055,010 Say "Equipe: "      SIZE 50,7 PIXEL OF oDlg
@ 070,010 Say "Data Inv: "    SIZE 50,7 PIXEL OF oDlg


@ 010,060 MSGET oUPA    Var cUPA    SIZE 50,7 PIXEL   OF oDlg  
@ 025,060 MSGET oBloco  var cBloco  SIZE 50,7 PIXEL   OF oDlg 
@ 040,060 MSGET oCodUT  var cCODUT  SIZE 50,7 PIXEL   OF oDlg Valid !Empty(cCodUT)
@ 055,060 MSGET oCODEQP var cCODEQP SIZE 50,7 PIXEL   OF oDlg 
@ 075,060 MSGET oAdinv  Var dAdinv  SIZE 105,7 PIXEL  OF oDlg  


@ 100,010 SAY "Itens a serem gravados:"

@ 120,010 SAY "FILA :"       SIZE 50,7 PIXEL OF oDlg
@ 140,010 SAY "Numero:"      SIZE 50,7 PIXEL OF oDlg
@ 160,010 SAY "Especie:"     SIZE 50,7 PIXEL OF oDlg
@ 180,010 SAY "DAP:"         SIZE 50,7 PIXEL OF oDlg
@ 200,010 SAY "Qualidade :"  SIZE 50,7 PIXEL OF oDlg
@ 220,010 SAY "Acesso : "    SIZE 20,7 PIXEL OF oDlg

@ 120,060 MSGET oFila Var nFila  SIZE 50,7 PIXEL  OF oDlg  
@ 140,060 MSGET oAnum Var cAnum  SIZE 50,7 PIXEL  OF oDlg  
@ 160,060 MSGET oAESP Var cAESP  SIZE 50,7 F3 "Z00" PIXEL  OF oDlg  
@ 180,060 MSGET oDAP  Var nDAP  PICTURE "@E 999 "  SIZE 50,7 PIXEL  OF oDlg 
  
@ 200,060 MSGET oQual Var cQual  SIZE 50,7 F3 "ZV1" PIXEL  OF oDlg  
@ 220,060 MSGET oAcesso Var cAcesso SIZE 20,7 PIXEL OF oDlg




// 

oBrowse:= TWBrowse():New( 150,150,200,070,,{'','FILA','NUMERO','ESPECIE', 'DAP','VOLUME','QUALIDADE','ACESSO'},{10,20,40,40,40,40,40,10},;
		  oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )    
//             1    2    3   4    5    6   7   8
aBrowse := { {.T.,"  ","  ","  ",  0,  0," ",.T.}} 
          
oBrowse:SetArray( aBrowse )
oBrowse:bLine := {||{If(aBrowse[oBrowse:nAt,01],oOK,oNO),aBrowse[oBrowse:nAt,02],;                      
aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05],aBrowse[oBrowse:nAt,06],aBrowse[oBrowse:nAt,07],aBrowse[oBrowse:nAt,08] } }    
// Troca a imagem no duplo click do mouse    
oBrowse:bLDblClick := {|| aBrowse[oBrowse:nAt][1] := !aBrowse[oBrowse:nAt][1],;                               
oBrowse:DrawSelect()}  


// Ajusta alinhamento do TWBrowse para pegar o dialogo inteiro
// oLbx:Align 	:= CONTROL_ALIGN_ALLCLIENT


@ 250,010 BUTTON "Valida Árvore " SIZE 45,12 ACTION ValidTree() 
@ 250,080 BUTTON "Grava Apto" SIZE 45,12 ACTION GravaTree() 
@ 250,150 BUTTON "Fechar" SIZE 45,12 ACTION oDlg:End()

SetKey(VK_F4   ,{ || oDlg:End()})                  
SetKey(VK_F5   ,{ || GravaTree()})     
SetKey(VK_F6   ,{ || fotoProduto() })     
SetKey(VK_F7   ,{ || ValidTree()})     


ACTIVATE DIALOG oDlg CENTERED



Return 



Static Function ValidTree()
Local lRet := .T.

// If Len(AllTrim(cLot))  < 10
//  Alert('Data Inválida !!!  Ex: 01/01/2004')
//  lRet := .F. 
//Endif 

Return lRet
                                                                          
    
Static Function VerProd()
Local lRet :=.t.
cProduto := " "   
oProduto :Refresh()
cDescProd := " "
oDescProd :Refresh()

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+cProduto) 
    oProduto :Refresh()
	cDescProd := SB1->B1_DESC
	oDescProd :Refresh()
Endif	
Atuacols()

Return lRet	  
     
              
Static Function GravaTree()
// Alert("Isso não é Erro apenas Aviso que estamos Gravando dados nas tabela ZT8 e ZU5 ") 

      
/*
ZT8
UPA , BLOCO , CODIGO UT , DATA INV
ZT8_FILIAL+ZT8_UPA+ZT8_BLOCO+ZT8_CODUT+DTOS(ZT8_ADINV)                                                                                                          

ZU5
Numero
ZU5_FILIAL+ZU5_ANUM

2 - UPA, BLOCO UTM, UC (UT)
ZU5_FILIAL+ZU5_UPA+ZU5_BLOCO+ZU5_CODUT

ZT8_UPA - C 5
ZT8_BLOCO - C 8
ZT8_CODUT - C 3
ZT8_CODEQP - C 3
ZT8_ADINV - DATA 8

Itens de Cadastro de Árvores

*/  

  // Pesquisa e Grava Cabeçalho da Arvore  
  DbSelectArea("ZT8") 
  DbSetOrder(1) // ZT8_FILIAL+ZT8_UPA+ZT8_BLOCO+ZT8_CODUT+DTOS(ZT8_ADINV)                                                                                                          
  IF !DbSeek(xFilial("ZT8")+cUPA+cBloco+cCODUT+Dtos(dAdinv))
    Reclock("ZT8",.T.) 
	ZT8_FILIAL := xFilial("ZT8") 
    ZT8_UPA    :=  cUPA
    ZT8_BLOCO  :=  cBloco
	ZT8_CODUT  :=  cCODUT
    ZT8_CODEQP :=  cCODEQP
    ZT8_ADINV  :=  dAdinv        
  Else
    Alert("Chave já encontrada reveja dados "+xFilial("ZT8")+cUPA+cBloco+cCODUT+Dtos(dAdinv))   
  Endif
  Msunlock()              


  // Pesquisa e Grava Itens da Arvore  
  DbSelectArea("ZU5") 
  DbSetOrder(2) // ZU5_FILIAL+ZU5_UPA+ZU5_BLOCO+ZU5_CODUT
  
  IF !DbSeek(xFilial("ZU5")+cUPA+cBloco+cCODUT+Dtos(dAdinv))
    Reclock("ZU5",.T.) 
	ZU5_FILIAL :=  xFilial("ZU5")
	ZU5_FILA   :=  nFila
	ZU5_AESP   :=  cAESP
	ZU5_ANUM   :=  cAnum
	ZU5_DAP    :=  nDAP
	ZU5_VOLUME :=  (0.001602*((nDAP)**1.90)) 
	ZU5_QUAL   :=  cQual            
    ZU5_ACESSO :=  cAcesso
	ZU5_UPA    :=  cUPA
	ZU5_BLOCO  :=  cBloco
	ZU5_CODUT  :=  cCODUT
	ZU5_ADINV  :=  dAdinv
	ZU5_AEAST  :=  0 // Lucas e Galvao
	ZU5_ANORTH :=  0 // Lucas e Galvao 
  Else
    Reclock("ZU5",.F.) 
	ZU5_FILA   :=  nFila
	ZU5_AESP   :=  cAESP
	ZU5_ANUM   :=  cAnum
	ZU5_DAP    :=  nDAP
	ZU5_VOLUME :=  (0.001602*((nDAP)**1.90)) 
	ZU5_QUAL   :=  cQual            
    ZU5_ACESSO :=  cAcesso
	ZU5_AEAST  :=  0 // Lucas e Galvao
	ZU5_ANORTH :=  0 // Lucas e Galvao 
  
  
  Endif
  Msunlock()         
  
  Alert("Gravou com sucesso verificar tabelas ZT8 e ZU5 ") 
       

  Atuacols()
Return

Static Function Atuacols()

ALERT("POSICIONANDO PARA ATUALIZAR VETOR ACOLS "+cUPA+cBloco+cCODUT+Dtos(dAdinv)) 

DbSelectArea("ZU5")
DbSetOrder(2)
IF DbSeek(xFilial("ZU5")+cUPA+cBloco+cCODUT+Dtos(dAdinv))
 
 Do While ZU5_UPA+ZU5_BLOCO+ZU5_CODUT+DTOS(ZU5_ADINV) == cUPA+cBloco+cCODUT+Dtos(dAdinv) .AND.!EOF()

    Alert("Dentro do Loop na ZU5 Chave UPA+BLOCO+UT+DATA :"+ZU5_UPA+ZU5_BLOCO+ZU5_CODUT+DTOS(ZU5_ADINV)) 
    Alert("1- Tamanho do vetor abrowse: "+STR(Len(aBrowse)))
    if nCnt > len(aBrowse) 
        //  1   2      3         4         5     6         7          8
        //{'','FILA','NUMERO','ESPECIE', 'DAP','VOLUME','QUALIDADE','ACESSO'}
        //  	ZU5_FILA; ZU5_AESP; ZU5_ANUM; ZU5_DAP; ZU5_VOLUME; ZU5_QUAL ; ZU5_ACESSO; ZU5_UPA; 	ZU5_BLOCO ; ZU5_CODUT ;ZU5_ADINV ;ZU5_AEAST ;ZU5_ANORTH 

		aAdd(aBrowse, {.T., ZU5->ZU5_FILA, ZU5->ZU5_ANUM,ZU5->ZU5_AESP,ZU5->ZU5_DAP,ZU5->ZU5_VOLUME,ZU5->ZU5_QUAL,ZU5->ZU5_ACESSO } )
		
	Else
		aBrowse[nCnt, 1]:= .T.
		aBrowse[nCnt, 2]:= ZU5->ZU5_FILA
		aBrowse[nCnt, 3]:= ZU5->ZU5_ANUM
		aBrowse[nCnt, 4]:= ZU5->ZU5_AESP
		aBrowse[nCnt, 5]:= ZU5->ZU5_DAP
		aBrowse[nCnt, 6]:= ZU5->ZU5_VOLUME
		aBrowse[nCnt, 7]:= ZU5->ZU5_QUAL
		aBrowse[nCnt, 8]:= ZU5->ZU5_ACESSO
		                                                               
	Endif
	nCnt++

   DbSkip()                                        
       Alert("2- Tamanho do vetor abrowse:"+STR(Len(aBrowse)))
 Enddo   
Else 
   
Endif

oBrowse :Refresh()

Return


     



*------------------------------------------------------------------------------------------*
Static Function Inverter(nPos,aBrowse,oBrowse)
*------------------------------------------------------------------------------------------*
/*---------------------------------------------------------------------------------------------------------------------------------------------------
Função chamada marca e desmarcar no List Box
OBJETIVO 1:  Marca e Desmarca o item no ListBox
-----------------------------------------------------------------------------------------------------------------------------------------------------/*/

aBrowse[nPos][1] := !aBrowse[nPos][1]

If aBrowse[nPos][1]
	
	Atualiza() // Atualiza os valores das GETS da Tela
	
EndIf

oBrowse:Refresh()

Return
                 
  
*----------------------------------------------------------------------------------------------*
Static Function Atualiza()
*----------------------------------------------------------------------------------------------*

Local lReturn 	:= .T.
lAtualiza 		:= .T.

Atuacols()                            

oBrowse  :Refresh()


Return lReturn

  
