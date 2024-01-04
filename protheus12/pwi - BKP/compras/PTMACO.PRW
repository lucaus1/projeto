#Include "TopConn.ch"   
#include "rwmake.ch"    
#include "jpeg.ch"
#include "vkey.ch"
/*
Tempo de desenvolvimento

22/09/2006 das 10:00 as 12:30
22/09/2006 das 13:30 as 17:10
25/09/2006 das 09:30 as 19:00 
26/09/2006 das 11:30 as 15:00 - rotina analise de preï¿½os, criaï¿½ï¿½o de campos C1_PTFORVE - Fornecedor vencedor
06/10/2006 das 10:00 as 17:00  
ok 1) Trazer descriï¿½ï¿½o de centro de custo; - estava configurado para CTT, e alterado para SI3;
ok 2) Trazer descriï¿½ï¿½o do Nome do Fornecedor;
em 07/10/2006 
ok 3) Criar Botï¿½es ï¿½ Imprimir Mapa, Gerar Pedido, 
ok 4) Ordenar Campos Cï¿½d, Prc proposto , Prc negociado;
em 09/10/2006
   5) Rotina para Gerar SC7  - criaï¿½ï¿½o de ordem 8 em SC1 para gravar pedidos conforme fornecedores, 1 para cada fornecedor;
   6) Troca do campo x3_browse pelo x3_pyme, para evitar conflito com a rotina padrï¿½o da solicitaï¿½ï¿½o de compras, no browse de pesquisa inicial.
   
em 17/10/2006 - sc1->c1_quje para receber c1_quant para mudar o status da solicitacao de compras
gravar em sc7 o numero e item da sc
criada opï¿½Ao para liberar SC, limpando numero do pedido e c1_quje

18/07/2008
Flag e controle para nao gravar com saldo ja atendido 


*/

User Function PTMACO()  // MAPA DE COTAï¿½ï¿½O
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Mapa de Cotação","u_MapaCota",0,4} ,;            
             {"Altera Solicitação","AxAltera",0,4} ,;            
             {"Libera Solicitação","u_LibSC1",0,4} ,;            
             {"Excluir","AxDeleta",0,5} }

Private aCampos := { {"No Solic","C1_NUM",""} ,;
           {"Item","C1_ITEM",""} ,;
           {"Produto","C1_PRODUTO",""} ,;
           {"Unid Med","C1_UM",""} ,;           
           {"Quantidade","C1_QUANT",""} ,;
			  {"Solicitante","C1_SOLICIT",""} ,;           
           {"Centro de Custo","C1_CC",""} ,;
           {"Pedido Gerado","C1_PEDIDO",""} ,;
           {"Descricao Prod ","C1_DESCRI",""} }

Private cCadastro := "Cadastro de Solicitaï¿½ï¿½es"
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SC1"
Private aSema   := { {"u_clVerdeSC1()"     ,"BR_VERDE"   },;
	                {"u_clAzulSC1()"      ,"BR_AZUL"    },;
         	       {"u_clRedSC1()"    ,"BR_VERMELHO"}}

dbSelectArea("SC1")
dbSetOrder(1)


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,aCampos,,"20",,,aSema)
Return

User Function LibSC1
  dbSelectArea("SC1")
  Reclock("SC1",.F.)
    SC1->C1_QUJE := 0
    SC1->C1_PEDIDO := " "  
  MsUnlock()
Return


User Function MapaCota
PUBLIC cSolicitante,nPosQPed, nPosItem, nPosComprador, oNomeCC, cNomeCC, oNomeComprad, oSolicitante
PUBLIC aCols_ini,aHeader_ini, aCols, aHeader, onVlPrF1, onVlNeF1 , onVlPrF2, onVlNeF2, onVlPrF3
PUBLIC onVlNeF3, onVlPrF4, onVlNeF4, onVlPrF5, onVlNeF5, nItens
PUBLIC nposNUM, nposITEM , nposPTFORVE, nPosCodF1, nPosCodF2, nPosCodF3, nPosCodF4, nPosCodF5
PUBLIC nPosVLPRF1, nPosVLNEF1, nPosVLPRF2, nPosVLNEF2, nPosVLPRF3, nPosVLNEF3, nPosVLPRF4 , nPosVLNEF4
PUBLIC nPosVLPRF5, nPosVLNEF5, nPosOBS, oCombo, nPosVunit,nRegSC1,nRegSC1a, nPosCONDPAG
PUBLIC cForn1,cForn2,cForn3,cForn4,cForn5

cNumCotacao  := space(6)  // Numero da cotaï¿½ï¿½o
cSolicitante := space(14) // C1_SOLICIT
cComprador   := Space(3)  // C1_CODCOMP -> SY1
cCentroCusto := space(9)  // C1_CC     
cNomeCC      := space(30) // CTT_NOME
cNomeComprad := Space(40) // Y1_NOME 
nItens       := 0
cForn1		 := "Fornecedor 1"
cForn2		 := "Fornecedor 2"
cForn3		 := "Fornecedor 3"
cForn4		 := "Fornecedor 4"
cForn5		 := "Fornecedor 5"
cNumCotacao  := SC1->C1_NUM      // Numero da cotaï¿½ï¿½o
cSolicitante := SC1->C1_SOLICIT  // C1_SOLICIT
nRegSC1a := Recno()
cCentroCusto := SC1->C1_CC // C1_CC     
DbSelectArea("SI3")
SET FILTER TO EMPTY(SI3->I3_CONTA)
DbSetOrder(1)
DbSeek(xFilial("SI3")+SC1->C1_CC)
cNomeCC := SI3->I3_DESC
set filter to
DbSelectArea("SC1")
if !empty(SC1->C1_CODCOMP)
  DbSelectArea("SY1")
  DbSetOrder(1)
  DbSeek(xFilial("SY1")+SC1->C1_CODCOMP)
  cComprador   := SC1->C1_CODCOMP
  cNomeComprad := SY1->Y1_NOME
Endif


DbSelectArea("SC1")
// Codigos do fornecedores de 1 a 5 
cCODF1 	:= cCODF2 	:= cCODF3	:= 	cCODF4 	:= 	cCODF5	:= 	space(6)
// Valores Totais propostos e negociados para os fornecedores para use em refresh 
nVLPRF1 := nVLNEF1 	:= nVLPRF2 	:= 	nVLNEF2 := 	nVLPRF3 := 	nVLNEF3 := nVLPRF4 := nVLNEF4 := nVLPRF5 := nVLNEF5 := 0
cAplicacao   := space(30) 	// C1_obs -> usaremos o campo de observaï¿½ï¿½o
lRetorno     := .F.
dDataProd    := dDataBase
cCodigo      := Space(15)
cDescricao   := Space(60)
nPosITEM     := 0
nPosPRODUT   := 0

@ 240,178 To 800,1150 Dialog oWindow Title PADC("MAPA DE COTACAO                      By Potencial Tecnologia Ltda - Suporte 24H suporte@potencial.inf.br  ",200)
@ 001,001 JPEG SIZE 70,180 FILE "\SIGAADV\preciouswoods.jpg"

@ 010,080 SAY "Numero da Cotação"
@ 010,140 GET cNumCotacao PICTURE "@!" SIZE 45,12 object oNumCotacao

@ 025,080 SAY "SOLICITANTE:"
@ 025,140 GET cSolicitante PICTURE "@!"  object oSolicitante

@ 025,200 SAY "Centro de Custo "
@ 025,260 GET cCentroCusto PICTURE "@!" object oCentroCusto;
          VALID ExecBlock("Pesqmaco",.f.,.f.,{"xFilial('SI3')+cCentroCusto","SI3",1,"Centro de Custo nao Cadastrado!","","","",oWindow})  F3 "SI3"

@ 025,300 GET cNomeCC PICTURE "@!" Object oNomeCC

@ 040,080 SAY "Comprador "
@ 040,140 GET cComprador PICTURE "@!" object oComprador ;
          VALID ExecBlock("Pesqmaco",.f.,.f.,{"xFilial('SY1')+cComprador","SY1",1,"Comprador nao Cadastrado!","","","",oWindow})  F3 "SY1" SIZE 45,12
          
@ 040,190 GET cNomeComprad PICTURE "@!" object oNomeComprad

oNumCotacao:disable()
oSolicitante:disable()
oCentroCusto:disable()
oNomeCC:disable()
// oComprador:disable()
oNomeComprad:disable()

SetKey(VK_F4   ,{ || fsalva()})                  
SetKey(VK_F5   ,{ || DescProd()})     
SetKey(VK_F6   ,{ || fotoprod() })     
SetKey(VK_F7   ,{ || infGerCmp() })     
SetKey(VK_F8   ,{ || AnalCotacao() })     
cLinFuncoes := "  F4-Salvar Cotação         "
cLinFuncoes += "  F5-Descrição Produto     "
cLinFuncoes += "  F6-Foto do Produto       "
cLinFuncoes += "  F7-Inf.Gerenciais Compras  "
cLinFuncoes += "  F8-Analisa Cotação       "

@ 060,080 SAY  cLinFuncoes
  cAlias:="SC1"
  nUsado := 0
  aHeader := {}
  DbSelectArea("SX2")
  dBSeek(cAlias)
  DbSelectArea("SX3")
  DbSetOrder(1) 
  if Dbseek(cAlias)
   nUsado := 0
   While !EOF() .And. SX3->X3_ARQUIVO == cAlias
	 // Alert("Entrou SX3") 
	 
	 IF x3_context <> "V" .and. x3_usado != " " .and. cNivel >= X3_NIVEL .And. x3_pyme == "S"
        nUsado := nUsado + 1
		AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,;
			X3_TAMANHO, X3_DECIMAL, X3_VALID,;
			X3_USADO, X3_TIPO, X3_ARQUIVO } )			
		Do Case
           Case ALLTRIM(SX3->X3_CAMPO) == "C1_NUM"
			  	  nposNUM      := nUsado
           Case ALLTRIM(SX3->X3_CAMPO) == "C1_ITEM"
				  nposITEM     := nUsado
           Case ALLTRIM(SX3->X3_CAMPO) == "C1_PRODUTO"
				  nPosPRODUT   := nUsado                 
           Case ALLTRIM(SX3->X3_CAMPO) == "C1_VUNIT"
				  nPosVunit    := nUsado             
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_QUJE"
		 		  nPosQPed:= nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_PTFORVE"
				  nposPTFORVE  := nUsado              
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_CONDPAG"
				  nposCONDPAG  := nUsado              
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_CODF1"
				  nPosCodF1    := nUsado
  		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_CODF2"
				  nPosCodF2    := nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_CODF3"
				  nPosCodF3    := nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_CODF4"
				  nPosCodF4    := nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_CODF5"
				  nPosCodF5    := nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLPRF1"
				  nPosVLPRF1 	:= nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLNEF1"
				  nPosVLNEF1 	:= nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLPRF2"
				  nPosVLPRF2 	:= nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLNEF2"
				  nPosVLNEF2 	:= nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLPRF3"
				  nPosVLPRF3 	:= nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLNEF3"
				  nPosVLNEF3 	:= nUsado
  		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLPRF4"
				  nPosVLPRF4 	:= nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLNEF4"
				  nPosVLNEF4 	:= nUsado
  		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLPRF5"
				  nPosVLPRF5 	:= nUsado
		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_VLNEF5"
				  nPosVLNEF5 	:= nUsado              				  
  		   Case ALLTRIM(SX3->X3_CAMPO) == "C1_OBS"
				  nPosOBS 		:= nUsado
		EndCase
	 EndIf
	Skip
   EndDo
  Else 
    Alert("Não posicionado em SX3") 
     
  Endif
  dbSelectArea(cAlias )
  nRegistro := RecCount()
  IF nUsado==0
   Alert("Nenhum campo Indicado para browse, favor analisar Dic.de dados,campo Browse")
  Endif
  dbGoTo(nRegistro+1)
  nCnt := 1
  aCOLS := Array(nCnt,nUsado+1)
  nUsado:=0
  dbSelectArea(cAlias)
  Select SX3
  Seek cAlias
  While !EOF() .And. X3_ARQUIVO == cAlias
	  If x3_usado != " " .And. cNivel >= X3_NIVEL.And.x3_pyme="S".And.x3_context <> "V"
           nUsado := nUsado+1
           aCOLS[nCnt][nUsado]:= &(cAlias+"->"+x3_campo)
	  EndIf	  
	  Skip                                           	
  EndDo   
  aCOLS[nCnt][nUsado+1]:= .F.
  Asort(aCols,,,{ |x,y| x[1] < y[1]}) 
  aCols_ini   := aCols   
  aHeader_ini := aHeader 
  nCnt := 0                        
  DbSelectArea("SC1")
  DbSetOrder(1)
  DbSeek(xfilial("SC1")+cNumCotacao)
  While !eof() .and. SC1->C1_NUM == cNumCotacao
     nCnt := nCnt + 1
     if nCnt > 1
   	AADD(aCols,Array(nUsado+1))     
     Endif	
   	For _ni:=1 to nUsado
	   	aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
	   Next
   	aCols[Len(aCols),nUsado+1]:=.F.  
 		dbSkip()
  End  	        
  nItens := len(aCols)       
//  Asort(aCols,,,{ |x,y| x[1] < y[1]}) 
  @ 080,005 To 210,480 Multiline MODIFY DELETE FREEZE 6 VALID fLineOk() 
 
  @ 235, 010 SAY "Total Proposto ->"
  @ 245, 010 SAY "Tot Negociado ->"

@ 225, 060 GET cForn1 size 50,12 object oForn1
@ 225, 110 GET cForn2 size 50,12 object oForn2
@ 225, 160 GET cForn3 size 50,12 object oForn3
@ 225, 210 GET cForn4 size 50,12 object oForn4
@ 225, 260 GET cForn5 size 50,12 object oForn5

@ 235, 060 Get nVLPRF1 PICTURE "@R 9,999.9999" SIZE 50,12  object onVlPrF1 Valid .T.
@ 245, 060 Get nVLNEF1  PICTURE "@R 9,999.9999" SIZE 50,12  object onVlNeF1 Valid .T.
@ 235, 110 Get nVLPRF2 PICTURE "@R 9,999.9999" SIZE 50,12  object onVlPrF2 Valid .T.
@ 245, 110 Get nVLNEF2  PICTURE "@R 9,999.9999" SIZE 50,12  object onVlNeF2 Valid .T.
@ 235, 160 Get nVLPRF3 PICTURE "@R 9,999.9999" SIZE 50,12  object onVlPrF3 Valid .T.
@ 245, 160 Get nVLNEF3  PICTURE "@R 9,999.9999" SIZE 50,12  object onVlNeF3 Valid .T.
@ 235, 210 Get nVLPRF4 PICTURE "@R 9,999.9999" SIZE 50,12  object onVlPrF4 Valid .T.
@ 245, 210 Get nVLNEF4  PICTURE "@R 9,999.9999" SIZE 50,12  object onVlNeF4 Valid .T.
@ 235, 260 Get nVLPRF5 PICTURE "@R 9,999.9999" SIZE 50,12  object onVlPrF5 Valid .T.
@ 245, 260 Get nVLNEF5  PICTURE "@R 9,999.9999" SIZE 50,12  object onVlNeF5 Valid .T.

@ 260,030 BUTTON "Salvar Cotacao" SIZE 50,15 ACTION fSalva()
@ 260,100 BUTTON "Imp.MapaCota" SIZE 50,15 ACTION U_MAPCMP()
@ 260,170 BUTTON "Gerar Pedido" SIZE 50,15 ACTION GeraSC7()
@ 260,240 BUTTON "Vis Ped Comp" SIZE 50,15 ACTION MATA121()
@ 260,310 BUTTON "Lib PC " SIZE 30,15 ACTION MATA097()
@ 260,350 BUTTON "Posic Fornec" SIZE 50,15 ACTION FINC030()
@ 260,420 BUTTON "Fechar" SIZE 50,15 ACTION fFecha()      

/*
MATA121 - pedidos de compra
MATA097 - Liberacao de PC
FINC030 - Posicao Fornecedor

*/
// Totalmaco()           

onVlPrF1:disable()                             
onVlNeF1:disable()

onVlPrF2:disable()                             
onVlNeF2:disable()

onVlPrF3:disable()                             
onVlNeF3:disable()

onVlPrF4:disable()                             
onVlNeF4:disable()

onVlPrF5:disable()                             
onVlNeF5:disable()


Activate Dialog oWindow Centered
DbGoto(nRegSC1a)

Return



Static Function fLineok()
   lRetorno:=.T.
   IF Empty(aCols[n] [nposITEM]) .or. n > nItens
      lRetorno := .F.
   Endif   
   If aCols[n][(len(aHeader)+1)]
         lRetorno := .T.
   EndIf  
   Totalmaco()   
   If !lRetorno 
      MsgBox("Não é permitida inclusao de itens na Cotaçãoo.", "Atencao", "INFO")
   Endif
Return lRetorno


Static Function fSalva()
    lGrava := .F.
    If Len(aCols) # 0
       lGrava := .T.
    EndIf
    If Len(aCols) == 1
       If !aCols[1][(len(aHeader)+1)]
          lGrava := .T.
       EndIf
    EndIf
    If !lGrava
       Alert("Nada foi Salvo!")
    Endif
    IF lGrava
      For nLin := 1 to Len(aCols)
        DbSelectArea("SC1")
        DbSetOrder(1) // C1_FILIAL+C1_NUM+C1_ITEM 
        IF DbSeek(xFilial("SC1")+cNumCotacao+aCols[nLin, nPosITEM])
         RecLock("SC1",.F.)
          REPLACE C1_CODCOMP with cComprador
          REPLACE C1_VUNIT   with acols[nLin,nPosVunit]
          REPLACE C1_QUJE    WITH acols[nLin,nPosQPed]
          REPLACE C1_PTFORVE with acols[nLin,nposPTFORVE]
          REPLACE C1_FORNECE with acols[nLin,nposPTFORVE]
          REPLACE C1_VUNIT   with acols[nLin,nPosVUNIT]
          REPLACE C1_CONDPAG with acols[nLin,nposCONDPAG]
          REPLACE C1_CODF1   with acols[nLin,nPosCodf1]
          REPLACE C1_CODF2   with acols[nLin,nPosCodf2]
          REPLACE C1_CODF3   with acols[nLin,nPosCodf3]
          REPLACE C1_CODF4   with acols[nLin,nPosCodf4]
          REPLACE C1_CODF5   with acols[nLin,nPosCodf5]
          REPLACE C1_VLPRF1  with acols[nLin,nPosVLPRF1]
          REPLACE C1_VLNEF1  with acols[nLin,nPosVLNEF1]
          REPLACE C1_VLPRF2  with acols[nLin,nPosVLPRF2]
          REPLACE C1_VLNEF2  with acols[nLin,nPosVLNEF2]
          REPLACE C1_VLPRF3  with acols[nLin,nPosVLPRF3]
          REPLACE C1_VLNEF3  with acols[nLin,nPosVLNEF3]
          REPLACE C1_VLPRF4  with acols[nLin,nPosVLPRF4]
          REPLACE C1_VLNEF4  with acols[nLin,nPosVLNEF4]
          REPLACE C1_VLPRF5  with acols[nLin,nPosVLPRF5]
          REPLACE C1_VLNEF5  with acols[nLin,nPosVLNEF5]
          REPLACE C1_OBS 	  with acols[nLin, nPosOBS]
         MsUnlock()
        Endif        
      Next        
    ENDIF
Return

Static function infGerCmp()
   cAlias := Alias()                             
   nEstoque := 0
   nSalSolP := 0
   dbSelectArea("SB2")
   dbSetOrder(1)
   DbSeek(xFilial("SB2")+aCols[n, nPosPRODUT])
   Do While !eof().and.aCols[n, nPosPRODUT]== SB2->B2_COD
     nEstoque := nEstoque + SB2->B2_QATU    
     nSalSolP := nSalSolP + SB2->B2_SALPEDI
    DbSkip()    
   Enddo
   
   dbSelectArea("SB1")
   DbSeek(xFilial("SB1")+aCols[n, nPosPRODUT])
	@ 240,178 To 400,850 Dialog oWinInfGer  Title "Informações Gerenciais            By Potencial Tecnologia Ltda - Suporte 24H  suporte@potencial.inf.br "
	@ 010,010 SAY "Descrição do Produto   : "+SB1->B1_DESC
	@ 025,010 SAY "Data da ultima compra  : "+DTOC(SB1->B1_UCOM)
   @ 040,010 SAY "Valor da ultima compra : "+STR(B1_UPRC,14,2)	
   @ 055,010 SAY "Saldo em Estoque 		  : "+STR(nEstoque,14,2)
   @ 070,010 SAY "Saldo em Solic/Pedidos : "+STR(nSalSolP,14,2)   
	Activate Dialog oWinInfGer Centered
   DbSelectArea(cAlias)
Return


Static Function FotoProd()
@ 100,400 To 400,1000 Dialog oFoto Title "Foto do Produto em \sigaadv\imagens\produtos\"
IF !EMPTY(aCols[n,nPosPRODUT])
  @ 001,001 JPEG SIZE 300,300 FILE "\SIGAADV\IMAGENS\PRODUTOS\"+aCols[n,nPosPRODUT]+".jpg"
ENDIF  
@ 200,100 BUTTON "Fechar" SIZE 45,12 ACTION Close(oFoto)
Activate Dialog oFoto
Return


Return

Static Function DescProd()          
cAlias := Alias()
dbSelectArea("SB1")
DbSeek(xFilial("SB1")+aCols[n, nPosPRODUT])
Msgbox(Alltrim(SB1->B1_DESC),"INFO")
DbSelectArea(cAlias)
Return



Static Function fFecha()
  If msgbox("Deseja Realmente Sair da Rotina e Salvou o apontamento ?","Responda","YESNO") 
    SetKey(VK_F4, Nil)
    SetKey(VK_F5, Nil)
    SetKey(VK_F6, Nil)
    SetKey(VK_F7, Nil)
    SetKey(VK_F8, Nil)
    SetKey(VK_F9, Nil)
    SetKey(VK_F10, Nil)
    SetKey(VK_F11, Nil)
    SetKey(VK_F12, Nil)
    SetKey(19, Nil)
    Close(oWindow)
  Endif
Return    

Static Function TotalMaco()
   nVLPRF1 := nVLNEF1 := nVLPRF2	:= nVLNEF2 := nVLPRF3 := 0
   nVLNEF3 := nVLPRF4 := nVLNEF4 := nVLPRF5 := nVLNEF5 := 0
   For x:=1 to Len(acols)
    // alert("Totalizando Mapa ")
     nVLPRF1 := nVLPRF1 + acols[x,nPosVLPRF1 ]
     nVLNEF1 := nVLNEF1 + acols[x,nPosVLNEF1 ]
     nVLPRF2 := nVLPRF2 + acols[x,nPosVLPRF2 ]
     nVLNEF2 := nVLNEF2 + acols[x,nPosVLNEF2 ]	
     nVLPRF3 := nVLPRF3 + acols[x,nPosVLPRF3 ]
     nVLNEF3 := nVLNEF3 + acols[x,nPosVLNEF3 ]
     nVLPRF4 := nVLPRF4 + acols[x,nPosVLPRF4 ]
     nVLNEF4 := nVLNEF4 + acols[x,nPosVLNEF4 ]
     nVLPRF5 := nVLPRF5 + acols[x,nPosVLPRF5 ]
     nVLNEF5 := nVLNEF5 + acols[x,nPosVLNEF5 ]
   Next
	onVlPrF1:refresh()
	onVlNeF1:refresh()
	onVlPrF2:refresh()
	onVlNeF2:refresh()
	onVlPrF3:refresh()
	onVlNeF3:refresh()
	onVlPrF4:refresh()
	onVlNeF4:refresh()
	onVlPrF5:refresh()
	onVlNeF5:refresh()

   	dBselectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+acols[1,nPosCODF1])
	cForn1 := SA2->A2_NOME         
	oForn1:refresh()
	
	DbSeek(xFilial("SA2")+acols[1,nPosCODF2])
	cForn2 := SA2->A2_NOME         
	oForn2:refresh()
          
	DbSeek(xFilial("SA2")+acols[1,nPosCODF3])
	cForn3 := SA2->A2_NOME         
	oForn3:refresh()
	
	DbSeek(xFilial("SA2")+acols[1,nPosCODF4])
	cForn4 := SA2->A2_NOME         
	oForn4:refresh()

	DbSeek(xFilial("SA2")+acols[1,nPosCODF5])
	cForn5 := SA2->A2_NOME         
	oForn5:refresh()

	dBselectArea("SC1")
Return

Static Function AnalCotacao()         
/*
Analise de cotaï¿½ï¿½o com base nos valores cotados
*/
   aForVal := {}
   For x:=1 to Len(acols)      
      aCols[x,nposPTFORVE] := "SemVen" 
      If aCols[x,nPosVLNEF1 ] # 0 .AND. !EMPTY(aCols[x,nPosCodF1])
	      aAdd(aForVal,{aCols[x,nPosCodF1],aCols[x,nPosVLNEF1 ]})
	   Endif                      
	   If aCols[x,nPosVLNEF2 ] # 0 .AND. !EMPTY(aCols[x,nPosCodF2])
	      aAdd(aForVal,{aCols[x,nPosCodF2],aCols[x,nPosVLNEF2 ]})
	   Endif
	   If aCols[x,nPosVLNEF3 ] # 0 .AND. !EMPTY(aCols[x,nPosCodF3])
	      aAdd(aForVal,{aCols[x,nPosCodF3],aCols[x,nPosVLNEF3 ]})
	   Endif
	   If aCols[x,nPosVLNEF4 ] # 0 .AND. !EMPTY(aCols[x,nPosCodF4])
	      aAdd(aForVal,{aCols[x,nPosCodF4],aCols[x,nPosVLNEF4 ]})
	   Endif
	   If aCols[x,nPosVLNEF5 ] # 0 .AND. !EMPTY(aCols[x,nPosCodF5])
	      aAdd(aForVal,{aCols[x,nPosCodF5],aCols[x,nPosVLNEF5 ]})
	   Endif   
      Asort(aForVal,,,{ |x,y| x[2] < y[2]})           
      if Len(aForVal) >= 1
        if len(aForVal) > 1
         if aForVal[1,2] == aForVal[2,2] .or. aForVal[1,2] == iif(len(aForVal)>=3,aForVal[3,2],aForVal[2,2])
         // se houver 2 ou mais fornecedores com o mesmo preï¿½o
          Alert(" 2 ou mais fornecedores com o mesmo preï¿½o !")                   
          aCombo := {"001","002"}
          
          if aForVal[1,2] == aForVal[2,2]
            aCombo := {aForVal[1,1],aForVal[2,1]}
          Endif
          
          if len(aForVal) = 3
           if   aForVal[1,2] == aForVal[3,2]
             aCombo := {aForVal[1,1],aForVal[2,1],aForVal[3,1]}
           Endif
          Endif              
          
          if len(aForVal) = 4
           if aForVal[1,2] == aForVal[4,2]
             aCombo := {aForVal[1,1],aForVal[2,1],aForVal[3,1],aForVal[4,1]}
           Endif
          Endif 
          if len(aForVal) = 5
	          if aForVal[1,2] == aForVal[5,2]
   	         aCombo := {aForVal[1,1],aForVal[2,1],aForVal[3,1],aForVal[4,1],aForVal[5,1]}
      	    Endif
      	 Endif             
          @ 000,000 To 100,250 Dialog oEscolha Title "Preços Iguais"  
          @ 010,010 Say "Fornecedores com preços iguais Escolha um :"
          @ 010,090 Combobox oCombo items aCombo Size 040,010
			 Activate Dialog oEscolha Centered 
          aCols[x,nposPTFORVE] := ocombo        
          aCols[x,nPosVUNIT]   := aForVal[1,2]
         Else
            aCols[x,nposPTFORVE] := aForVal[1,1]
            aCols[x,nPosVUNIT]   := aForVal[1,2]
         Endif
        Else                                    
          aCols[x,nposPTFORVE] := aForVal[1,1]  
          aCols[x,nPosVUNIT]   := aForVal[1,2]
        Endif 
      Else
         aCols[x,nposPTFORVE] := "SemFor"
      Endif
		aForVal := {}
   Next      
   Totalmaco()           
Return



User Function pesqmaco()
_Alias := Select()
_Ordem := DbSetOrder()
_Reg   := Recno()

aParam := {}
aParam := ParamIxb

cChave    := aParam[1]
cAlias    := aParam[2]
cOrdem    := aParam[3]
cAlerta   := aParam[4]

lRetPESQ  := .T.

DbSelectArea( cAlias )
DbSetOrder( cOrdem )

If !DbSeek( &cChave )
    Msgbox( cAlerta, "Atencao", "INFO" )
    lRetPesq := .F.

Else
   if cAlias $ "SI3" 
     cNomeCC := SI3->I3_DESC
     oNomeCC :refresh()         
   Endif                 
   if cAlias $ "SY1"          
    cNomeComprad := SY1->Y1_NOME
    oNomeComprad:refresh()
   endif 
Endif
DbSelectArea( _Alias )
DbSetOrder( _Ordem )
DbGoto( _Reg )
// Substituido pelo assistente de conversao do AP5 IDE em 19/12/00 ==> __Return(lRetPesq)
Return(lRetPesq)        // incluido pelo assistente de conversao do AP5 IDE em 19/12/00


User Function clVerdeSC1()
	_lRetorno := .F.
   // Em aberto 
	If sc1->c1_quje == 0
		_lRetorno := .T.
	EndIf
Return _lRetorno                                                     		

User Function clAzulSC1()
   // Baixa Parcial
	_lRetorno := .F.
	If sc1->c1_quje > 0 .and. sc1->c1_quje <  sc1->c1_quant
		_lRetorno := .T.
	EndIf
Return _lRetorno                                                     		

User Function clRedSC1()
   // Baixado Total
	_lRetorno := .F.
	If sc1->c1_quje >=  sc1->c1_quant 
		_lRetorno := .T.
	EndIf
Return _lRetorno                                                     		


static function SQLCons()

	_cQuery1 := " SELECT C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_CC,C1_CODCOMP,C1_USER,C1_OBS, "
	_cQuery1 += " (SELECT Y1_NOME FROM SY1010 WHERE Y1_USER=SC1010.C1_USER)AS NOME "
	_cQuery1 += " FROM SC1010 "
	_cQuery1 += " WHERE C1_QUANT > C1_QUJE AND D_E_L_E_T_<>'*' AND C1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	_cQuery1 += " GROUP BY C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_CC,C1_CODCOMP,C1_USER,C1_OBS "
	_cQuery1 += " ORDER BY C1_NUM,C1_EMISSAO,C1_SOLICIT,C1_CC,C1_CODCOMP,C1_USER,C1_OBS "

	TcQuery _cQuery1 New Alias qCabec

	qCabec->(DbGotop())

	//Inicio da Impressï¿½o
	pg := 0
	_cContItem := 0
	li := 65
	_cData:=DtoC(DDatabase)
	SetRegua(qCabec->(RecCount()))

	Do while !qCabec->(Eof())
 	 _cQuery2 := " SELECT *, (SELECT D1_FORNECE FROM SD1010 WHERE D1_COD=SD1010.D1_PRODUTO AND D_E_L_E_T_<>'*' AND "
    _cQuery2 += " D1_DTDIGIT = (SELECT MAX(D1_DTDIGIT)DTMAX FROM SD1010 WHERE D1_COD=SD1010.D1_PRODUTO AND D_E_L_E_T_<>'*'))AS MAXFOR, "
    _cQuery2 += " (SELECT D1_QUANT FROM SD1010 WHERE D1_COD=D1_COD=SD1010.SD1010.D1_PRODUTO AND D_E_L_E_T_<>'*' AND "
    _cQuery2 += " D1_DTDIGIT = (SELECT MAX(D1_DTDIGIT)DTMAX FROM SD1010 WHERE D1_COD=SD1010.SD1010.D1_PRODUTO AND D_E_L_E_T_<>'*'))AS MAXQTD, "
    _cQuery2 += " (SELECT D1_VUNIT FROM SD1010 WHERE D1_COD=SD1010.D1_PRODUTO AND D_E_L_E_T_<>'*' AND "
    _cQuery2 += " D1_DTDIGIT = (SELECT MAX(D1_DTDIGIT)DTMAX FROM SD1010 WHERE D1_COD=SD1010.SD1010.D1_PRODUTO AND D_E_L_E_T_<>'*'))AS MAXVAL, "
    _cQuery2 += " (SELECT MAX(D1_DTDIGIT) FROM SD1010 WHERE D1_COD=SD1010.D1_PRODUTO AND D_E_L_E_T_<>'*')AS MAXDT
	 _cQuery2 += " FROM SC1010 "
	 _cQuery2 += " WHERE C1_QUANT > C1_QUJE AND D_E_L_E_T_<>'*' AND C1_NUM = '"+qCabec->C1_NUM+"' "
	 _cQuery2 += " ORDER BY C1_NUM,C1_DATPRF "				
    TcQuery _cQuery2 New Alias qItens
    DbSelectArea("qCabec")
    DbSkip()
   Enddo 

Return


Static Function GeraSC7()         
// Rotina para ordenar por fornecedor 
// Rotina para obter proximo numero do pedido de compra

DbSelectArea("SC1")
nRegSC1 := Recno()
DbSetOrder(14) // C1_FILIAL + C1_NUM + C1_FORNECE + C1_ITEM + C1_PRODUTO  -> aqui... alterado em 08/05/2012 - Herminio (atualizacao Totvs11)
IF DbSeek(xFilial("SC1")+cNumCotacao)
 Do While !eof() .and. SC1->C1_NUM == cNumCotacao
  DbSelectArea("SA2")
  DbSetOrder(1)
  DbSeek(xFilial("SA2")+SC1->C1_FORNECE)

  DbSelectArea("SC1")
  cNumPed := GetSxeNum("SC7","C7_NUM")
  nSeqPed := 1
  cFornece := SC1->C1_FORNECE
 
  Do While cFornece == SC1->C1_FORNECE .and. SC1->C1_NUM == cNumCotacao .and.!eof()
   If !EMPTY(SC1->C1_FORNECE).AND.!EMPTY(SC1->C1_PTFORVE).AND. SC1->C1_VUNIT > 0 .AND. SC1->C1_QUJE < SC1->C1_QUANT
    // if msgbox("Responda !","Gera Pedido ?"+cNumPed,"YESNO")
     DbSelectArea("SC7")
     DbSetOrder(4) // Produto + Numero PC + Item + Sequencia
     if !DbSeek(xFilial("SC7")+SC1->C1_PRODUTO+SC1->C1_ITEM+cNumPed+StrZero(nSeqPed,4))
       RecLock("SC7",.T.)
       C7_FILIAL  := xFilial("SC7")
       C7_TIPO    := 1 // 1 - PEDIDO, 2 - AUT ENTREGA
       C7_ITEM    := SC1->C1_ITEM
       C7_PRODUTO := SC1->C1_PRODUTO
       C7_UM      := SC1->C1_UM
       C7_SEGUM   := SC1->C1_SEGUM
       C7_QUANT   := iif(SC1->C1_QUJE <> 0,SC1->C1_QUJE,SC1->C1_QUANT)
       C7_PRECO   := SC1->C1_VUNIT
       C7_TOTAL   := NoRound((SC1->C1_QUANT * SC1->C1_VUNIT),5)
       C7_DATPRF  := SC1->C1_DATPRF
       C7_LOCAL   := SC1->C1_LOCAL
       C7_OBS     := SC1->C1_OBS
       C7_FORNECE := SC1->C1_PTFORVE
       C7_CC      := SC1->C1_CC
       C7_CONTA   := SC1->C1_CONTA
       C7_LOJA    := IIF(EMPTY(SC1->C1_LOJA),"01",SC1->C1_LOJA)
       C7_COND    := SC1->C1_CONDPAG
       C7_CONTATO := SA2->A2_CONTATO
       C7_FILENT  := SC1->C1_FILENT
       C7_EMISSAO := dDataBase
       C7_NUM     := cNumPed
       C7_DESCRI  := SC1->C1_DESCRI
       C7_TPFRETE := "F" // C-CIF, F-FOB 
       C7_FLUXO   := "S"
       C7_USER    := SC1->C1_USER 
       C7_VALICM  :=  0
       C7_PICM    :=  0
       C7_BASEICM :=  0
       C7_CONAPRO := "L" // L - LIBERADO, B-BLOQUEADO
       C7_NUMSC   := SC1->C1_NUM
       C7_ITEMSC  := SC1->C1_ITEM       
       C7_ITEMCTA := SC1->C1_ITEMCTA 
       
       Msunlock()
       ConfirmSX8()  
       DbSelectArea("SC1")
        RecLock("SC1",.F.)
        SC1->C1_PEDIDO := cNumPed
        SC1->C1_QUJE   := iif(SC1->C1_QUJE <> 0,SC1->C1_QUJE+SC7->C7_QUANT,SC1->C1_QUANT)
        Msunlock()       
     Endif   // dbseek
    // Endif //  msgbox yesno
   Else 
    Alert("Dados insuficientes para Gerar Pedido OU Saldo da Solicitação Atendido : ->"+SC1->C1_PEDIDO+SC1->C1_ITEMPED)
   Endif
  DbSelectArea("SC1")
  DbSkip() 
 Enddo
 DbSelectArea("SC1")
 Enddo
Else 
  Alert("SC nao posicionada ") 
  
Endif
DbSelectArea("SC1")
DbSetOrder(1)
DbGoto(nRegSC1)
Return