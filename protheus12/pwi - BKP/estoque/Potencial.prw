#include "rwmake.CH"
#include "font.CH"
#include "topconn.ch"
#include "vkey.ch"
#include "colors.ch"
#include "fivewin.ch"
#include "protheus.ch"


User Function Potencial(cNome)

	Define FONT oFonte NAME "Comic Sans MS" BOLD Size 013,000

	@ 000,000 To 400,400 Dialog oDlg Title "Controle de Combustível"
	@ 005,075 BitMap oBmp File "potlogo.bmp" Size 080,065 NOBORDER Pixel

	@ 065,005 To 080,195 Title "Desenvolvimento"
		@070,010 Say PadR("Consultor - " + cNome,  95) Pixel COLOR 16711680
    
	@ 090,005 To 175,195 Title "Informações Adicionais"
		@100,010 Say PadR("Potencial Tecnologia e Soluções Empresariais Ltda",  95) Pixel COLOR 16711680
		@110,010 Say PadR("Av. Des. João Machado, 1297, Sala 402, Planalto",  95) Pixel COLOR 16711680
		@120,010 Say PadR("Fone: 3184-0863",  95) Pixel COLOR 16711680

		@130,010 Say PadC("Contatos",  95) Pixel COLOR 16711680 FONT oFonte Dialog oDlg
		
		@140,010 Say PadR("Ellcyo Castro - ellcyo@potencial.inf.br",  95) Pixel COLOR 16711680
		@150,010 Say PadR("Franciney Alves - franciney@potencial.inf.br",  95) Pixel COLOR 16711680
		@160,010 Say PadR("Gustavo Cunha - gustavo@potencial.inf.br",  95) Pixel COLOR 16711680
		
		@175,010 Say PadC("www.potencial.inf.br",  95) Pixel COLOR 16711680
	
        @185,160  BmpButton Type 1 Action oDlg:End()
	Activate Dialog oDlg Centered
Return