#include "rwmake.CH"
#include "font.CH"
#include "topconn.ch"
#include "vkey.ch"
#include "colors.ch"
#include "fivewin.ch"
#include "protheus.ch"

User Function SALCON()
	Private _cProduto  := Space(15)
	Private _cDesc     := Space(15)
    Private _cDoc      := Space(06)
    Private _clocal    := '01'
    Private _nCusto    := 0.0000
    Private oProduto
    Private oLocal
	Private oDesc                   
	Private oDoc
	Private oCusto
    Private lCheck1
    Private oCheck1
    
     
	Define FONT oFnt1 NAME "Comic Sans MS" BOLD Size 010,00
	Define FONT oFnt2 NAME "Ms Sans Serif"
	
	@ 000,000 To 270,330 Dialog oDlgPrc Title "Atualização Contabil:"
	@ 002,002 To 120,165 Title "Requisicao"
		@ 020,008 Say "Codigo:" Size 050,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 016,060 Get _cProduto object oProduto Picture "@!" Size 060,000 F3 "SB1" Valid AtuDesc(.T.)
		
		@ 035,008 Say "Descricao:" Size 070,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 031,060 Get _cDesc object oDesc  Picture "@!" Size 100,000 
        
        @ 050,008 Say "Local:" Size 050,000 Of oDlgPrc Pixel FONT oFnt1 COLOR CLR_HBLUE
		@ 046,060 Get oLocal var _cLocal Picture "@E 99" Size 008,000 Pixel FONT oFnt1 COLOR CLR_HBLUE

		@ 065,008 Say "Doc:" Size 050,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 061,060 Get _cDoc object oDoc  Picture "@!" Size 040,000  Valid AtuExist() 
		
		@ 080,008 Say "Custo Est.:" Size 050,000 Of oDlgPrc Pixel FONT oFnt1 COLOR CLR_HBLUE
		@ 076,060 Get oCusto var _nCusto Picture "@E 999,999.99" Size 040,000 Pixel FONT oFnt1 COLOR CLR_HBLUE

		lCheck1 := .f.
		
		@ 122,008 Checkbox oCheck1 var lCheck1 Prompt "Lançam.Efet." Size 050,010
 
  		@ 122,075 BmpButton Type 1 Action  Confirma()
		@ 122,0105 BmpButton Type 2 Action Close(oDlgPrc)

	Activate Dialog oDlgPrc Centered
Return                                                                            

Static Function AtuDesc(lFlag)
    
		If !empty(Posicione("SB1", 1, xFilial("SB1")+_cProduto,"B1_DESC"))
			_cDesc:= Posicione("SB1", 1, xFilial("SB1")+_cProduto,"B1_DESC")
	    Else
			if lFlag
		        Alert('Produto Não Cadastrado')
		    Endif    

	    _cDesc:=""

	    Endif
     
   oDesc:Refresh()
   
Return	

Static Function AtuExist()
	dbSelectArea("SD3")
    //_nIndice := IndexOrder()
	dbSetOrder(2)
	SD3->(dbGotop())
	dbSeek (xFilial()+_cDoc+_cProduto)
	   if Found()
	       _nCusto := SD3->D3_CUSTO1
		Else
     	   Msgbox("PRODUTO INEXISTENTE", "Atenção" , "STOP")
		   _nCusto  := 0
		Endif                         `

    oCusto:Refresh()
    
    //dbSetOrder(_nIndice)
Return

Static Function Confirma()

If lCheck1 == .f.
	If MsgYesNo("Deseja Realmente Alterar o Pré-Lançamento?")
	        
			TCSQLExec ( " UPDATE "+RetSqlName('SIC')+" SET IC_VALOR=D3_CUSTO1 " + ;
			            " FROM "+RetSqlName('SIC')+","+RetSqlName('SD3')+" " + ;
	                    " WHERE D3_CODIGO = '"+_cProduto+"' AND D3_DOC = '"+_cDoc+"' AND D3_LOCAL = '"+_cLocal+"' AND " + ;
	                    " SUBSTRING(IC_HIST,7,6)=D3_DOC AND SUBSTRING(IC_HIST,36,2)=D3_LOCAL AND SUBSTRING(IC_HIST,14,15)=D3_COD " + ; 
	                    " AND "+RetSqlName('SD3')+".D_E_L_E_T_<>'*' AND "+RetSqlName('SIC')+".D_E_L_E_T_<>'*' ")
				            
			Msgbox("PROCESSO CONCLUÍDO ", "Atenção" , "INFO")
	Else
	        Alert("ATUALIZAÇÃO NAO REALIZADA!!")
	Endif
 
Else       
 
 	If MsgYesNo("Deseja Realmente Alterar o Lançamento?")
			TCSQLExec ( " UPDATE " + RetSQLName("SI2")+ " SET I2_VALOR=D3_CUSTO1 " + ;
			            " FROM " + RetSQLName("SI2")+ "," + RetSQLName("SD3")+ " " + ;
	                    " WHERE D3_CODIGO = '"+_cProduto+"' AND D3_DOC = '"+_cDoc+"' AND D3_LOCAL = '"+_cLocal+"' AND " + ;
	                    " SUBSTRING(I2_HIST,7,6)=D3_DOC AND SUBSTRING(I2_HIST,36,2)=D3_LOCAL AND SUBSTRING(I2_HIST,14,15)=D3_COD " + ; 
	                    " AND " + RetSQLName("SD3")+ ".D_E_L_E_T_<>'*' AND " + RetSQLName("SI2")+ ".D_E_L_E_T_<>'*' ")
				            
			Msgbox("PROCESSO CONCLUÍDO ", "Atenção" , "INFO")
	Else
	        Alert("ATUALIZAÇÃO NAO REALIZADA!!")
    Endif
Endif
LimpaVar()   
Return   
    
Static Function LimpaVar()
 _cProduto := Space(15)
 _cLocal   := "01"
 _cDesc    := ""
 _cDoc     := ""

 oDlgPrc:Refresh()
 oProduto:SetFocus()
 AtuDesc(.F.)
Return