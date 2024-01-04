#include "rwmake.CH"
#include "font.CH"
#include "topconn.ch"
#include "vkey.ch"
#include "colors.ch"
#include "fivewin.ch"
#include "protheus.ch"

User Function SALINI()
	Private _cProduto  := Space(15)
	Private _cDesc     := Space(15)
    Private _clocal    := '01'
    Private oProduto
    Private oLocal
	Private oDesc
	Private oQtdIni
    Private oValIni
	Private _cData     := CTOD("31/10/06")
	Private _cQtdIni   := 0.0000
    Private _cValIni   := 0.0000
    Private _cCMedio   := 0.0000
    Private lCheck1
    Private oCheck1
   
	Define FONT oFnt1 NAME "Comic Sans MS" BOLD Size 010,00
	Define FONT oFnt2 NAME "Ms Sans Serif"
	
	@ 000,000 To 270,330 Dialog oDlgPrc Title "Saldo Inicial:"
	@ 002,002 To 120,165 Title "Produto"
		@ 020,008 Say "Codigo:" Size 050,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 016,060 Get _cProduto object oProduto Picture "@!" Size 060,000 F3 "SB1" Valid AtuDesc(.T.)
		
		@ 035,008 Say "Descricao:" Size 070,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 031,060 Get _cDesc object oDesc  Picture "@!" Size 100,000 //Pixel FONT oFnt1 COLOR CLR_HBLUE
        
        @ 050,008 Say "Local:" Size 050,000 Of oDlgPrc Pixel FONT oFnt1 COLOR CLR_HBLUE
		@ 046,060 Get oLocal var _cLocal Picture "@E 99" Size 010,000 Pixel FONT oFnt1 COLOR CLR_HBLUE
                   	
		@ 065,008 Say "Data Fechamento:" Size 050,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 061,060 Get _cData Picture "@D" Size 040,000 Pixel FONT oFnt1 COLOR CLR_HBLUE  Valid AtuExist()              
		
		@ 080,008 Say "Qtd Inicial:" Size 050,000 Of oDlgPrc Pixel FONT oFnt1 COLOR CLR_HBLUE
		@ 076,060 Get oQtdIni var _cQtdIni Picture "@E 999,999.99" Size 040,000 Pixel FONT oFnt1 COLOR CLR_HBLUE
                                                                                                    
		@ 095,008 Say "Val Inicial:" Size 050,000 Of oDlgPrc Pixel FONT oFnt1 COLOR CLR_HBLUE
		@ 091,060 Get oValIni var _cValIni Picture "@E 999,999.99" Size 040,000 Pixel FONT oFnt1 COLOR CLR_HBLUE

		lCheck1 := .f.
		
		@ 122,008 Checkbox oCheck1 var lCheck1 Prompt "Exclusão" Size 050,010

  		@ 122,075 BmpButton Type 1 Action Iif(!lCheck1,Confirma(),Exclui())
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
	dbSelectArea("SB9")
	dbSetOrder(1)
	SB9->(dbGotop())
	dbSeek (xFilial()+_cProduto+_cLocal+DtoS(_cData))
	   if Found()
	       _cProduto := SB9->B9_COD
		   _cQtdIni  := SB9->B9_QINI
		   _cValIni  := SB9->B9_VINI1
		Else
     	   Msgbox("PRODUTO INEXISTENTE", "Atenção" , "STOP")
		   _cQtdIni  := 0
		   _cValIni  := 0
		Endif       

    oQtdIni:Refresh()
    oValIni:Refresh()
Return
	
Static Function Confirma()


dbSelectArea("SB9")
dbSetOrder(1)
SB9->(dbGotop())
dbSeek (xFilial()+_cProduto+_cLocal+DtoS(_cData))
   if Found()
          Reclock("SB9", .F.)                 
            Replace SB9->B9_FILIAL with xFilial("SB9")
            Replace SB9->B9_COD    with _cProduto
			Replace SB9->B9_LOCAL  with _cLocal
			Replace SB9->B9_QINI   with _cQtdIni
			Replace SB9->B9_VINI1  with _cValIni
          MsUnlock()
          Msgbox("PRODUTO ALTERADO","Atenção", "INFO")
	Else 
          Reclock("SB9", .T.)
			SB9->B9_FILIAL  := xFilial("SB9") 
			SB9->B9_COD   := _cProduto
			SB9->B9_LOCAL := _cLocal
			SB9->B9_DATA  := _cData
			SB9->B9_QINI  := _cQtdIni
			SB9->B9_VINI1 := _cValIni
          MsUnlock()
  	      Msgbox("PRODUTO INCLUÍDO", "Atenção" , "INFO")
    Endif
Return   
    
Static Function Exclui()
SB9->(dbGotop())
dbSeek (xFilial()+_cProduto+_cLocal+DtoS(_cData))
   If MsgYesNo("Deseja Realmente Excluir Produto?")
	   if Found()
	      Reclock("SB9")                 
	          DELE
	      MsUnlock()

	  	  Msgbox("PRODUTO EXCLUÍDO", "Atenção" , "INFO")
	   Else
	      Msgbox("PRODUTO NÃO CONSTA MAIS NO SALDO INICIAL", "Atenção" , "STOP")
	   Endif   
	Else 
      Msgbox("PRODUTO NÃO EXCLUÍDO", "Atenção" , "STOP")
	Endif   
LimpaVar()
Return

Static Function LimpaVar()
 _cProduto := Space(15)
 _cLocal   := "01"
 _Desc     := ""
 _cQtdIni  := 0
 _cValIni  := 0

 oDlgPrc:Refresh()
 oProduto:SetFocus()
 AtuDesc(.F.)
Return