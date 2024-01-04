#include "rwmake.CH"
#include "font.CH"
#include "topconn.ch"
#include "vkey.ch"
#include "colors.ch"
#include "fivewin.ch"
#include "protheus.ch"
		
//U_PTEST001()                      


User Function MT240TOK()
	//U_PTEST001(M->D3_QUANT, M->D3_EMISSAO, M->D3_CC, M->D3_DOC)
Return .T.

//32010001

User Function PTEST001(_cArg1, _cArg2, _cArq3, _cArq4)
	private cDocto := _cArq4

	private dData   := _cArg2
	private cCodigo := Space(10)
	private oCodigo
	private cCCusto := _cArq3
	private cbTipo  := ""
	private oTipo
	private aTipo   := {"1=Quilometragem", "2=Horimetro"}
	private nKm     := 0
	private nQuant  := _cArg1
	
	               	
	private cNomeVeic   := Space(30)
	private cNomeCCusto := Space(30)
	private cGrupo      := Space(30)
	private nAntKm      := 0
	private dKmAntData  := Date()
	private nAntQuant   := 0 
	
	private lRetorno := .F.
	
	//Objetos -> Outras Informações
	private oNomeVeic
	private oNomeCCusto                                    
	private oGrupo
	private oAntKm
	private oKmAntData
	private oAntQuant
    
	//Atualizaçao Inicial de Centro de Custo
	cNomeCCusto := Posicione("SI3",1,xFilial("SI3") + cCCusto,"I3_DESC")

	Define FONT oFonte NAME "Comic Sans MS" BOLD Size 010,000
	
	@ 000,000 To 355,400 Dialog oDlg Title "Controle de Combustível"
	@ 015,005 To 085,195
		oDlg:LESCCLOSE := .F.
	
		@ 020,010 Say "Data" Pixel
		@ 020,060 Get dData Size 040,008 Picture "@D" Pixel READONLY
	    
		@ 030,010 Say "Cod. Veículo" Pixel COLOR 16711680
		@ 030,060 Get cCodigo Object oCodigo Size 10*4,008 F3 "PT1" Valid fRetNomeVei() ; oCodigo:SetFocus()
		
		@ 040,010 Say "C. Custo" Pixel COLOR 16711680
		@ 040,060 Get cCCusto Size 9*4,008 F3 "CTT" Valid fRetCCusto()
		
		@ 050,010 Say "Tipo" Pixel
		@ 050,060 ComboBox oTipo var cbTipo Items aTipo Size 14*4,008 Pixel When .F.
		
		@ 060,010 Say "Km/Horimetro" Pixel COLOR 255
		@ 060,060 Get nKm Size 14*4,008 Picture "@E 999,999,999.99" Pixel COLOR 255
                                           
		@ 070,010 Say "Quantidade" Pixel
		@ 070,060 Get nQuant Size 14*4,008 Picture "@E 999,999,999.99" Pixel READONLY

		@ 025,120 BitMap oBmp File "lgrl01.bmp" Size 080,050 NOBORDER Pixel

	@ 090,005 To 175,195 Title "Outras Informações"
		@ 100,010 Say "Veículo" Pixel COLOR 16711680
		@ 100,060 Get oNomeVeic var cNomeVeic Size 33*4,008 Picture "@!" NOBORDER COLOR 16711680 Pixel READONLY 
		
		@ 110,010 Say "C. Custo" Pixel COLOR 16711680 
		@ 110,060 Get oNomeCCusto var cNomeCCusto Size 33*4,008 Picture "@!" NOBORDER Pixel COLOR 16711680  READONLY

		@ 120,010 Say "Grupo" Pixel COLOR 16711680 
		@ 120,060 Get oGrupo var cGrupo Size 33*4,008 Picture "@!" NOBORDER Pixel COLOR 16711680  READONLY
             
		@ 130,010 Say "Km Anterior" Pixel COLOR 16711680 
		@ 130,060 Get oAntKm var nAntKm Size 14*4,008 Picture "@E 999,999,999.99" NOBORDER Pixel COLOR 16711680  READONLY

		@ 140,010 Say "Dt. Ult. Abast" Pixel COLOR 16711680 
		@ 140,060 Get oKmAntData var dKmAntData Size 14*4,008 Picture "@D" NOBORDER Pixel COLOR 16711680  READONLY

		@ 150,010 Say "Qtd Ult. Abast" Pixel COLOR 16711680 
		@ 150,060 Get oAntQuant var nAntQuant Size 14*4,008 Picture "@E 999,999,999.99" NOBORDER Pixel COLOR 16711680  READONLY
		
		@ 160,010 Say "Documento" Pixel COLOR 16711680 
		@ 160,060 Get cDocto Size 6*4,008 Picture "@!" NOBORDER Pixel COLOR 16711680  READONLY

	bOk     := {|| fOK() }
	bCancel := {|| fClose(), oDlg:End() }                                                                                     
	Activate Dialog oDlg on Init EnchoiceBar(oDlg, bOk, bCancel)  Centered

Return lRetorno

static function fOK()
	lRetorno := fRetNomeVei()
	lRetorno := fRetCCusto()
	
	//Validando Controle de Quilometragem ou Horimetro
	if nKm == 0
		lRetorno := .F.
		Alert( aTipo[ Val(cbTipo) ] + " não Lancado!!!"  )
	EndIf	
	
	if ( lRetorno )
		M->D3_CC := cCCusto
		
		//Rotina de Gravação
	    RecLock("ZT6", .T.)
	    	ZT6->ZT6_FILIAL := xFilial("ZT6") 
	    	ZT6->ZT6_DOC    := cDocto
	    	ZT6->ZT6_DATA   := dData
	    	ZT6->ZT6_CODIGO := cCodigo
	    	ZT6->ZT6_MARC   := nKm
	    	ZT6->ZT6_QUANT  := nQuant
	    	ZT6->ZT6_CC     := cCCusto
	    msUnlock()
	
		//Fechando Rotina e Confirmando Operação
		oDlg:End()
	EndIf
Return

static function fClose()
	lRetorno := .F.
Return


static function fRetNomeVei()
	lRet := .T.
	
	cNomeVeic := Posicione("SN1",1,xFilial("SN1") + cCodigo,"N1_DESCRIC")
	oNomeVeic:Refresh()
	
	cbTipo := Posicione("SN1",1,xFilial("SN1") + cCodigo,"N1_YFATOR")
	oTipo:Refresh()

	cGrupo := Posicione("SX5",1,xFilial("SX5") + "P1" + Posicione("SN1",1,xFilial("SN1") + cCodigo,"N1_YGRUPO"),"X5_DESCRI")
	oGrupo:Refresh()
	
	
	if Empty(cNomeVeic)
		lRet := .F.
		Alert("Código do Veículo Incorreto!!!")
	Endif 
Return lRet

static function fRetCCusto()
	lRet := .T.

	cNomeCCusto := Posicione("SI3",1,xFilial("SI3") + cCCusto,"I3_DESC")
	oNomeCCusto:Refresh()

	if Empty(cNomeCCusto)
		lRet := .F.
		Alert("Código de Centro de Custo Incorreto!!!")
	Endif 
Return lRet