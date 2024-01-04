#Include "TopConn.ch"   
#INCLUDE "RWMAKE.CH"    
#INCLUDE "JPEG.CH"
#include "VKEY.CH"

/*
+-------------------------------------------------------------------------------+
¦ +-----------+------------+-------+----------------------+------+------------+ ¦
¦ ¦ Programa  ¦  PTESTA03  ¦ Autor ¦ Franciney Alves      ¦ Data ¦ 13/08/2008 ¦ ¦
¦ +-----------+------------+-------+----------------------+------+------------+ ¦
¦ ¦ Descriçäo ¦ Geracao da Pre-nota de entrada automatica                     ¦ ¦
¦ |           ¦                                                               ¦ ¦
¦ |           ¦                                                               ¦ ¦
¦ +-----------+---------------------------------------------------------------+ ¦
¦                                                                               ¦
+-------------------------------------------------------------------------------+
ZB1 - tabela de especie para buscar codigo da MP
ZB1_FILIAL     C       2
ZB1_COD        C       4
ZB1_DESC       C       100                      
ZB1_YCODMP     C       15 


 inicio de validação e alteraçoes: 
 14/08 - campos especies
 15/08 - indice para ZB1 
 19/08 -  
 1) correcao preenchimento do d1_item com funcao, devido ausencia do campo na tabela temporária;
  D1_PEDIDO ,D1_ITEMPC , D1_DOC , D1_DTDIGIT , D1_GRUPO , D1_TP
 2) - variable does not exist _FILFOR on _IMPORT(PTESTA03.PRW) 19/08/2008 line : 216
   trocada por xfilial("SD1")
 3) B1_LOCPAD, estava B1_LOCAL 
 4) If DbSeek(xFilial("SF1")+ wLote->DOC), trocado por If DbSeek(xFilial("SF1")+ wLote->D1_DOC) 
 5) preenchimento de campos da SF1, inclusive rotina para totalizar valores da SD1 para gravar na SF1
                                                                                            
20/08 
1)posicionamento no wLote
2)correção de sequencia 
3)d1_fornece de '01' para D1_FORNECE := "044368"  
4)D1_TIPO    := 'N'
5)Comentada linha para preencher condição de pagamento;
   
10/09/2008 
Inclusao do campo serie para pesquisar conforme serie "DOF" na composição da chave. 
correção da palavra sucesso.                 

02/10/2008 
Inclusao da rotina para exclusao do DOF, mudança das bibliotecas retirando protheus para simplificar uso de Botoes.

26/11/2008 - inclusao do campo UPA na rotina de importaçao

/*/

User Function PTAEST03

Private _Doc       := Space(6)
Private oEmissao
Private _Emissao   := DDATABASE
Private _Dir       := Space(20)



@ 000,000 To 310,410 Dialog oDlgPrc Title "Importação e Gerenciador de DOF  -  By Potencial  Ver 2.02 "
@ 001,001 JPEG SIZE 70,180 FILE "\SYSTEM\preciouswoods.jpg"

@ 002,002 To 090,200 Title "Dados do Lote:"

@ 015,052 Say "Doc:" 
@ 013,080 Get _Doc Picture "@!" Size 030,000 

@ 030,052 Say "Emissao:" 
@ 028,080 Get _Emissao object oEmissao Picture "@D" Size 055,000  Valid ValEmi(.T.)

@ 045,052 Say "Diretorio :" 
@ 043,080 Get _Dir Picture "@!" Size 080,000 
_Dir := "\IMPDOF\DOF.DBF" + Space(20)

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
@ 140,008 Say "suporte 24h: potencial@potencial.inf.br " 


Activate Dialog oDlgPrc Centered
Return


Static Function ValEmi()

If !empty(Posicione("SD1", 1, xFilial("SD1")+_Doc+"DOF","D1_DOC"))
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
Use &(_Dir) Alias wImp New VIA "DBFCDX"
dbSelectArea ("wImp")
ProcRegua(RecCount())
wImp->(dbGoTop())
	_fornec 	:= "044368"
	_lojfor 	:= "01" 
	nSeq := 1
Do While !wImp->(Eof())
    DbSelectarea("ZB1")
    if DbSeek(xFilial("ZB1")+wImp->D1_YESPECI)
     cProduto:= ZB1->ZB1_YCODMP 
     DbSelectArea("SB1")
     DbSeek(xFilial("SB1")+cProduto)
     DbSelectArea("SB2")
     DbSeek(xFilial("SB2")+cProduto)
     dbSelectArea ("wLote")
	  wLote->(DbAppend())
		D1_COD     := cProduto
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
		D1_DOC     := _Doc
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

dbSelectArea("SF1")
If DbSeek(xFilial("SF1")+ wLote->D1_DOC+wLote->D1_SERIE)
		MsgBox("Documento ja Cadastrado","Atenção","Info")
		Return
Else	
    dbSelectArea ("SF1")
	Reclock ("SF1",.T.)
	F1_FILIAL   := xFilial("SF1")
	F1_DOC      := _DOC
	F1_SERIE    := "DOF"      
	F1_FORNECE  := "044368"
	F1_LOJA     := "01"
	F1_EMISSAO  := wLote->D1_EMISSAO
	F1_ESTADO   := "AM"
	F1_TIPO     := "N"
	F1_ESPECIE  := "NFE"
	 
	// novos campos a serem preenchidos
	// F1_COND := '000' 
	F1_EST  := 'AM'
	F1_DTDIGIT := wLote->D1_EMISSAO
	F1_MOEDA   := 1
	F1_RECBMTO := dDataBase 
	
	MsUnlock()
Endif	
dbSelectArea("wLote")
nValMerc := 0

Do While !wLote->(Eof())
	IncProc()
		RecLock("SD1",.T.)
		D1_FILIAL  := xFilial("SD1")
		D1_COD     := wLote->D1_COD
		D1_ITEM    := wLote->D1_ITEM
		D1_UM      := SB1->B1_UM
		D1_UNBRUTO := SB2->B2_CM1
		D1_BRUTO   := SB2->B2_CM1
		D1_QUANT   := wLote->D1_QUANT
		D1_VUNIT   := SB2->B2_CM1
		D1_TOTAL   := SB2->B2_CM1 * wImp->D1_QUANT 
		D1_CONTA   := SB1->B1_CONTA 
		D1_PEDIDO  := wLote->D1_PEDIDO
		D1_ITEMPC  := wLote->D1_ITEMPC
		D1_FORNECE := "044368"
		D1_LOJA    := "01"
		D1_DOC     := wLote->D1_DOC
		D1_SERIE   := "DOF"
		D1_EMISSAO := wLote->D1_EMISSAO
		D1_DTDIGIT := wLote->D1_EMISSAO
		D1_LOCAL   := SB1->B1_LOCPAD
		D1_GRUPO   := wLote->D1_GRUPO
		D1_TIPO    := 'N'
		D1_TP      := wLote->D1_TP
  		D1_LOTECTL := wLote->D1_LOTECTL
		D1_YESPECI := wLote->D1_YESPECI
		D1_YRODA   := wLote->D1_YRODA
		D1_YPE1    := wLote->D1_YPE1
		D1_YPE2    := wLote->D1_YPE2
		D1_YOCO1   := wLote->D1_YOCO1
		D1_YOCO2   := wLote->D1_YOCO2
		D1_YPONTA1 := wLote->D1_YPONTA1
		D1_YPONTA2 := wLote->D1_YPONTA2
		D1_YOCOP1  := wLote->D1_YOCOP1
		D1_YOCOP2  := wLote->D1_YOCOP2
		D1_YCOMPRI := wLote->D1_YCOMPRI
		D1_YCOMPRB := wLote->D1_YCOMPRB
		D1_QTSEGUM := wLote->D1_QTSEGUM
		D1_YDOF    := wLote->D1_YDOF
		D1_YCERT   := wLote->D1_YCERT
		D1_UPA   :=  wLote->D1_UPA

	    nValMerc := nValMerc +  wLote->D1_TOTAL
		c_Contador++
		MsUnLock()
	wLote->(dbskip())
Enddo
    dbSelectArea ("SF1")
	Reclock ("SF1",.F.) 
	 F1_VALMERC := nValMerc 
	 F1_VALBRUT := nValMerc         
	 F1_YDOF    := SD1->D1_YDOF
	MsUnLock()
	

	Msgbox(Str(c_Contador, 6) + " Registros Atualizados com Sucesso na Tabela SD1 ...","Importação do DOF ","Info")
	
Return


Static Function _ExcDOF
DbSelectArea("SF1")
If DbSeek(xFilial("SF1")+_Doc+"DOF" )
RecLock("SF1",.F.)
Dele
MsUnlock()
Alert("Excluido registro na  SF1")
Endif

DbSelectArea("SD1")                 
If DbSeek(xFilial("SD1")+_Doc+"DOF")
	Do While !SD1->(Eof()).And. SD1->D1_DOC == _Doc .And. SD1->D1_SERIE == "DOF"
	 RecLock("SD1",.F.)
	 Dele
	 MsUnlock()
	 DbSkip()
	Enddo
	Alert("Exclusao com Sucesso da SD1")
Endif

MATA300()

Return 
                                       