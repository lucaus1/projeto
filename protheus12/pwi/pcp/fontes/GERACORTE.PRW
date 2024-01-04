#Include "TopConn.ch"   
#INCLUDE "RWMAKE.CH"    
#INCLUDE "JPEG.CH"
#include "VKEY.CH"

/*
GERAÇÃO DE CORTES COM DADOS DO DOF 
*/

User Function PTGCORTES

Private _Doc       := Space(6)
Private oEmissao
Private _Emissao   := DDATABASE
Private _Dir       := Space(20)



@ 000,000 To 310,410 Dialog oDlgPrc Title "Geração de Cortes com dados do DOF  -  By Potencial  Ver 1.01 "
@ 001,001 JPEG SIZE 70,180 FILE "\SYSTEM\preciouswoods.jpg"

@ 002,002 To 090,200 Title "Dados do Lote:"

@ 015,052 Say "Doc:" 
@ 013,080 Get _Doc Picture "@!" Size 030,000 

@ 030,052 Say "Emissao:" 
@ 028,080 Get _Emissao object oEmissao Picture "@D" Size 055,000  Valid ValEmi(.T.)

@ 045,052 Say "Diretorio :" 
@ 043,080 Get _Dir Picture "@!" Size 080,000 
_Dir := "\DOF\DOF.DBF" + Space(20)

/*
@ 075,008 BmpButton Type 1 Action _Import()   

@ 075,040 BmpButton Type 2 Action Close(oDlgPrc)
*/

@ 075,020 BUTTON "Importar DOF " SIZE 40,15 ACTION _Import()
@ 075,070 BUTTON "Exclusao DOF " SIZE 40,15 ACTION _ExcDOF()
@ 075,120 BUTTON "Fechar" SIZE 30,15 ACTION Close(oDlgPrc)      

@ 110,008 Say "a pasta indicada e o arquivo acima informados podem ser modificados " 
@ 120,008 Say "e devem existir para prosseguir com sucesso! " 
@ 130,008 Say "para exclusao, basta informar o documento, pois a serie é fixa (DOF) "
@ 140,008 Say "suporte@potencial.inf.br " 


Activate Dialog oDlgPrc Centered
Return


Static Function ValEmi()

If !empty(Posicione("SD3", 1, xFilial("SD3")+_Doc,"D3_DOC"))
	Alert("Atencao DOF já importado nesta data, mude o documento!!!")
Endif

Return

Static Function _Import()
Private _Contador := 0
Private aStru     := {}
Private aCampos   := {}
Private c_Preco   := 0.00
Private cProduto  := Space(15)
Private nSeq := 1

Close(oDlgPrc)

aStru:= { {"D1_COD"	    , "C",  15, 0},;
{"D1_YESPECI"	    , "C",  04, 0},;
{"D1_UM"     , "C",  02, 0},;
{"D1_ITEM"	    , "C",  2, 0},;
{"D1_UNBRUTO"        , "N",  14, 2},;
{"D1_BRUTO"        , "N",  14, 2},;
{"D1_QUANT"        , "N",  14, 3},;
{"D1_VUNIT"        , "N",  14, 2},;
{"D1_TOTAL"        , "N",  14, 2},;
{"D1_CONTA"        , "C",  20, 0},;
{"D1_PEDIDO"        , "C",  06, 0},;
{"D1_ITEMPC"        , "C",  06, 0},;
{"D1_FORNECE"        , "C",  06, 0},;
{"D1_LOJA"        , "C",  02, 0},;
{"D1_DOC"        , "C",  06, 0},;
{"D1_SERIE"        , "C",  03, 0},;
{"D1_EMISSAO"    , "D",  08, 0},;
{"D1_DTDIGIT"    , "D",  08, 0},;
{"D1_LOCAL"     , "C",  02, 0},;
{"D1_GRUPO"     , "C",  04, 0},;
{"D1_TIPO"	    , "C",  2, 0},;
{"D1_TP"	    , "C",  2, 0},;
{"D1_LOTECTL"	    , "C",  10, 0},;
{"D1_YRODA"        , "N",  06, 2},;
{"D1_YPE1"        , "N",  06, 2},;
{"D1_YPE2"        , "N",  06, 2},;
{"D1_YOCO1"        , "N",  06, 2},;
{"D1_YOCO2"        , "N",  06, 2},;
{"D1_YPONTA1"        , "N",  06, 2},;
{"D1_YPONTA2"        , "N",  06, 2},;
{"D1_YOCOP1"        , "N",  06, 2},;
{"D1_YOCOP2"        , "N",  06, 2},;
{"D1_YCOMPRI"        , "N",  06, 2},;
{"D1_YCOMPRB"        , "N",  06, 2},;
{"D1_QTSEGUM"        , "N",  14, 3},;
{"D1_YCERT"	    , "C",  20, 0},;
{"D1_UPA"	    , "C",  04, 0},;
{"D1_YDOF"         , "C",  12, 0}}


c_Arq:= CriaTrab(aStru,.t.)
dbUseArea(.t.,,c_Arq,"wLote",.f.,.f.)

c_Key:= "D1_ITEM+D1_COD"
c_Ind:= CriaTrab(nil,.f.)
IndRegua("wLote",c_Ind,c_Key,,,"Criando Arquivo Temporário...")

aCampos:= {{"D1_ITEM"	     , "",  "SEQ"   , "@!"},;
{"D1_COD"	    , "",  "CODIGO", "@!"},;
{"D1_YESPECI"	, "",  "Especie", "@!"},;
{"D1_UM"    	, "",  "UM"     , "@!"},;
{"D1_UNBRUTO"	, "",  "Valor Unitario "   , "@E 999,999.99"},;
{"D1_BRUTO"     , "", "Valor Unitario "   , "@E 999,999.99"},; 
{"D1_QUANT"     , "", "Quantidade "   , "@E 9,999.999"},;
{"D1_VUNIT"     , "", "Valor Unit "   , "@E 999,999.99"},;
{"D1_TOTAL"     , "", "Total "   , "@E 999,999.99"},;
{"D1_CONTA"     , "", "Conta"     , "@!"},;
{"D1_PEDIDO"    , "", "Pedido"     , "@!"},;
{"D1_ITEMPC"    , "", "Item Pedido"     , "@!"},;
{"D1_FORNECE"   , "", "Fornecedor "     , "@!"},;
{"D1_LOJA"      , "", "Loja"     , "@!"},;
{"D1_DOC"       , "", "Doc"     , "@!"},;
{"D1_SERIE"     , "", "Serie"     , "@!"},;
{"D1_EMISSAO"   , "", "Emissao"     , "@D"},;
{"D1_DTDIGIT"   , "", "Data Digitacao"     , "@!"},;
{"D1_LOCAL"     , "", "Local "     , "@!"},;
{"D1_GRUPO"     , "", "Grupo"     , "@!"},;
{"D1_TIPO"	    , "", "Tipo"     , "@!"},;
{"D1_TP"	    , "", "Tipo"     , "@!"},;
{"D1_LOTECTL"	, "", "Lote/Tora "     , "@!"},;
{"D1_YRODA"     , "", "Roda"   , "@E 999.99"},;
{"D1_YPE1"      , "", "PE 1"   , "@E 999.99"},;
{"D1_YPE2"      , "", "PE 2"   , "@E 999.99"},;
{"D1_YOCO1"     , "", "OCO 1"   , "@E 999.99"},;
{"D1_YOCO2"     , "", "OCO 2"   , "@E 999.99"},;
{"D1_YPONTA1"   , "", "Ponta 1"   , "@E 999.99"},;
{"D1_YPONTA2"   , "", "Ponta 2"   , "@E 999.99"},;
{"D1_YOCOP1"    , "", "OCO P 1"   , "@E 999.99"},;
{"D1_YOCOP2"    , "", "OCO P 1"   , "@E 999.99"},;
{"D1_YCOMPRI"   , "", "Comprim"   , "@E 999.99"},;
{"D1_YCOMPRB"   , "", "Comp Bruto"   , "@E 999.99"},;
{"D1_QTSEGUM"   , "", "Qtde Seg UM"   , "@E 999.99"},;
{"D1_YCERT"	    , "", "Certificado"     , "@!"},;
{"D1_UPA"	    , "", "Unid Prod Anual"     , "@!"},;
{"D1_YDOF"      , "", "DOF"     , "@!"}}



//************************************************************************************************************************************
//*  Importação de produtos
//************************************************************************************************************************************
Alert("Caminho e arquivo a ser aberto: "+_Dir)
// Use &(_Dir) Alias wImp New VIA "DBFCDX"
// dbUseArea(.T., “DBFCDX”, “\SA1010.DBF”, “SA1DBF”, .T., .F.)
// Algumas chaves válidas são: "DBFCDX", "CTREECDX", "DBFCDXAX" e “TOPCONN”.

dbUseArea(.T., "DBFCDX", _Dir , "wImp", .T., .F.)

dbSelectArea ("wImp")
ProcRegua(RecCount())
wImp->(dbGoTop())
	_fornec 	:= "044368"
	_lojfor 	:= "01" 
	nSeq := 1
Do While !wImp->(Eof())
    DbSelectarea("Z00")
    if DbSeek(xFilial("Z00")+wImp->D1_YESPECI)
     cProduto:= wImp->D1_YESPECI
     DbSelectArea("SB1")
     DbSeek(xFilial("SB1")+cProduto)
     DbSelectArea("SB2")
     DbSeek(xFilial("SB2")+cProduto)
     dbSelectArea ("wLote")
	  wLote->(DbAppend())
		D1_COD := wImp->D1_YESPECI
		D1_ITEM    := Strzero(nSeq,2)
		D1_UM      := SB1->B1_UM
		D1_UNBRUTO := SB2->B2_CM1
		D1_BRUTO   := SB2->B2_CM1
		D1_QUANT   := wImp->D1_QUANT
		D1_VUNIT   := SB2->B2_CM1
		D1_TOTAL   := SB2->B2_CM1 * wImp->D1_QUANT 
		D1_CONTA   := SB1->B1_CONTA 
	    // Campos nao informados pela Eco-Florestal
		// D1_PEDIDO  := wImp->D1_PEDIDO
		// D1_ITEMPC  := wImp->D1_ITEMPC
		D1_FORNECE := "044368"
		D1_LOJA    := "01"
		D1_DOC     := wImp->D1_YDOF
		D1_SERIE   := "DOF"
		D1_EMISSAO := wImp->D1_EMISSAO
		D1_DTDIGIT := wImp->D1_EMISSAO
		D1_LOCAL   := SB1->B1_LOCPAD
		D1_GRUPO   := SB1->B1_GRUPO
		D1_TIPO    := 'N'
		D1_TP      := SB1->B1_TIPO
  		D1_LOTECTL := wImp->D1_LOTECTL
		D1_YESPECI := wImp->D1_YESPECI
		D1_YRODA   := wImp->D1_YRODA
		D1_YPE1    := wImp->D1_YPE1
		D1_YPE2    := wImp->D1_YPE2
		D1_YOCO1   := wImp->D1_YOCO1
		D1_YOCO2   := wImp->D1_YOCO2
		D1_YPONTA1 := wImp->D1_YPONTA1
		D1_YPONTA2 := wImp->D1_YPONTA2
		D1_YOCOP1  := wImp->D1_YOCOP1
		D1_YOCOP2  := wImp->D1_YOCOP2
		D1_YCOMPRI := wImp->D1_YCOMPRI
		D1_YCOMPRB := wImp->D1_YCOMPRB
		D1_QTSEGUM := wImp->D1_QTSEGUM
		D1_YDOF    := wImp->D1_YDOF
		D1_YCERT   := wImp->D1_YCERT  
		D1_UPA     := wImp->UPA
		_Contador++
	Else
	  Alert("Especie no arquivo não cadastrada na tabela ZB1: "+wImp->D1_YESPECI)  
	  
	Endif
	wImp->(dbSkip())
	nSeq := nSeq + 1
Enddo
wLote->(dbGoTop())

Define MSDialog oDlgBrowse Title "Espelho de Importação DOF    - By Potencial " From 000,000 To 446,722 Pixel
@ 010,003 TO 028, (oDlgBrowse:nWidth-12)/2

@ 018,005 SAY "LOTE:" 
@ 018,025 SAY _Doc    
@ 018,055 SAY "EMISSAO:" 
@ 018,085 SAY _Emissao   

oMark:= MsSelect():New("wLote",,,aCampos,.F.,,{30,3,(oDlgBrowse:nHeight-40)/2, (oDlgBrowse:nWidth-12)/2 })
bCancel:= {||oDlgBrowse:End(), Close(oDlgPrc)}
bOk:= {||IncluSD1(), oDlgBrowse:End(), Close(oDlgPrc)}

@ (oDlgBrowse:nHeight-39)/2, 003 Say "Importação de DOF     -    Registros: " 
@ (oDlgBrowse:nHeight-39)/2, 160 Say _Contador 

Activate MSDialog oDlgBrowse On Init EnchoiceBar(oDlgBrowse, bOk, bCancel) Centered
_Fechar()
Close(oDlgPrc)
Return

Static Function _Fechar
wImp->(dbCloseArea())
wLote->(DbCloseArea())
Ferase(c_Arq+".DBF")
Ferase(c_Ind+".DBF")

Return


Static Function IncluSD1()
Private c_Contador := 0

IncProc(wLote->(RecCount()))
wLote->(dbGotop())

dbSelectArea("SD3")
If DbSeek(xFilial("SD3")+wLote->D1_DOC)
		MsgBox("Documento ja Cadastrado:"+wLote->D1_DOC,"Atenção","Info")
		Return
Else 
    dbSelectArea("wLote")
	Do While !EOF()
    
    	
     dbSelectArea ("SD3")
	 Reclock ("SD3",.T.)
	    SD3->D3_FILIAL  := XfILIAL("SD3")
	    SD3->D3_TM      := "001"
        SD3->D3_COD     := Wlote->D1_COD 
        SD3->D3_UM      := Wlote->D1_UM 
        SD3->D3_QUANT   := Wlote->D1_QUANT 
        SD3->D3_CF      := "PR0"
        SD3->D3_OP      := DTOS(DDATABASE)
        SD3->D3_LOCAL   := Wlote->D1_LOCAL 
        SD3->D3_DOC	:=	Wlote->D1_YDOF 
		// 	:=	Wlote->D1_YCERT 
		SD3->D3_EMISSAO	:= Wlote->D1_EMISSAO
		SD3->D3_GRUPO   := Wlote->D1_GRUPO 
		SD3->D3_CUSTO1  := Wlote->D1_TOTAL
		SD3->D3_PARCTOT := "P"
		SD3->D3_NUMSEQ  := PROXNUM()
		SD3->D3_LOTECTL	:= Wlote->D1_LOTECTL
		SD3->D3_TORA    := wLote->D1_LOTECTL
		SD3->D3_TIPO    := Wlote->D1_TP
		SD3->D3_CHAVE   := "R0"
		SD3->D3_IDENT   := STRZERO(Val(PROXNUM())+1,6) 
		
		/*
		SD3->D3_DATADIV := 
		SD3->D3_PARTEA  := 
		SD3->D3_PARTEB  := 
		SD3->D3_PARTEC  := 
		SD3->D3_PARTED  := 
		SD3->D3_PARTEE  := 
		SD3->D3_PARTEF  := 
		SD3->D3_ARVORE  := 
		SD3->D3_PARTEA  := 
        */

    	// :=	Wlote->D1_YESPECI
		SD3->D3_YRODA 	:=	Wlote->D1_YRODA
		SD3->D3_YPE1	:=	Wlote->D1_YPE1
		SD3->D3_YPE2	:=	Wlote->D1_YPE2
		SD3->D3_YOCO1	:=	Wlote->D1_YOCO1
		SD3->D3_YOCO2	:=	Wlote->D1_YOCO2
		SD3->D3_YPONTA1	:=	Wlote->D1_YPONTA1
		SD3->D3_YPONTA2	:=	Wlote->D1_YPONTA2
		SD3->D3_YOCOP1	:=	Wlote->D1_YOCOP1
		SD3->D3_YOCOP2	:=	Wlote->D1_YOCOP2
		SD3->D3_YCOMPRI	:=	Wlote->D1_YCOMPRI
		SD3->D3_YCOMPRB	:=	Wlote->D1_YCOMPRB
		SD3->D3_QUANT	:=	Wlote->D1_QUANT
		SD3->D3_QTSEGUM	:=	Wlote->D1_QTSEGUM
		
	 MsUnlock()
	 dbSelectArea("wLote")
	  c_Contador++
	  MsUnLock()
	  wLote->(dbskip())
    Enddo

Endif	
	

	Msgbox(Str(c_Contador, 6) + " Registros Atualizados com Sucesso na Tabela SD3 ...","Importação do DOF ","Info")
	
Return


Static Function _ExcDOF
DbSelectArea("SD3")
If DbSeek(xFilial("SD3")+_Doc)  
Do While D3_DOC == _Doc 
  RecLock("SD3",.F.)
   Dele
   MsUnlock()
   DbSkip()
Enddo
   
Alert("Excluido(s) registro(s) na  SD3")
Endif


MATA300()

Return 
                                       