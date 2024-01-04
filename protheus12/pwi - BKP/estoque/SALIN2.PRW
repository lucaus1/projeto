#Include "topconn.ch"  

User Function SALIN2()
	Private _cProduto  := Space(15)
	Private _cDesc     := Space(15)
	Private _cData     := Space(15)
	Private _cQtdIni   := 0.0000
    Private _cValIni   := 0.0000
    Private _cCMedio   := 0.0000
   
	Define FONT oFnt1 NAME "Comic Sans MS" BOLD Size 010,00
	Define FONT oFnt2 NAME "Ms Sans Serif"
	
	@ 000,000 To 270,330 Dialog oDlgPrc Title "Saldo Inicial:"
	@ 002,002 To 080,115 Title "Produto"
		@ 010,008 Say "Codigo:" Size 050,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 006,055 Get _cProduto Picture "@!" Size 034,000 F3 "SB1"
		
		@ 020,008 Say "Descricao:" Size 050,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 016,055 Get _cDesc Picture "@!" Size 055,000 

		@ 030,008 Say "Data Fech:" Size 050,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 026,055 Get _cData Picture "@D" Size 055,000 

		@ 040,008 Say "QtdIni.:" Size 050,000 Of oDlgPrc Pixel FONT oFnt2 COLOR CLR_HBLUE
		@ 036,055 Get _cQtdIni Picture "@E 99.9999" Size 040,000

		lCheck1 := .f.
		@ 050,055 Checkbox "Exclusão" Var lCheck1
  		@ 062,056 BmpButton Type 1 Action Iif(!lCheck1,_Inclui(),_Exclui())
		@ 062,085 BmpButton Type 2 Action Close(oDlgPrc)

	Activate Dialog oDlgPrc Centered


Return