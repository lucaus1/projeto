#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GQREENTR  º Autor ³ FRANCINEY          º Data ³  17/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA PARA CADASTRO AUTOMATICO DE TORAS         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ENTRADA DE NOTA FISCAL                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Alteracoes
21/08/2008   Campos novos obtidos apos integração com DOF 
17/09/2008   preenchimento automatico do DOF na tabela SF1 para uso em Browse 

/*/

User Function GQREENTR


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Private cString := ""
Private cDocSF1 := SF1->F1_DOC 
Private cSerSF1 := SF1->F1_SERIE
Private cFornec := SF1->F1_FORNECE
Private cLoja   := SF1->F1_LOJA    
Private cDof    := Space(12)

// Filtrando funcao para tratar somente DOF
if cSerSF1 == "DOF" 
	Alert(" NF: "+SF1->F1_DOC+" Serie: "+SF1->F1_SERIE)

	DbSelectArea("SD1")                 
	dbSetOrder(1)   // indice Doc + serie + fornecedor + loja  
	DbSeek(xFilial("SD1")+cDocSF1+cSerSF1+cFornec+cLoja) 
	Do While  !Eof() .And. cDocSF1+cSerSF1+cFornec+cLoja == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	
	    // incluindo as informaçoes das toras presentes na SD1 para o cadastro de tora
	    dbSelectArea("SZ1")
	    dbSetOrder(2)                          
        /* D1_LOTE, ,D1_YRODA, D1_YPE1, D1_YPE2, D1_YOCO1, D1_YOCO2, D1_YPONTA1, D1_YPONT2, D1_YOCOP1, D1_YOCOP2, 
        D1_YCOMPRI, D1_YCOMPRB, 
        
        Z1_FILIAL , Z1_COMPRIM, Z1_CUBLIQU, Z1_CUBBRUT, 
        Z1_COD, 
        */                                              
        // caso nao encontre o Lote deve incluir os dados da tora
        cDof := SD1->D1_YDOF
        if !DbSeek(xFilial("SZ1")+SD1->D1_LOTECTL)
            RecLock("SZ1",.T.)
               Replace Z1_FILIAL  WITH xFilial("SZ1")
               Replace Z1_LOTE    WITH SD1->D1_LOTECTL
               Replace Z1_COD     WITH SD1->D1_LOTECTL
               Replace Z1_COMPRIM WITH SD1->D1_YCOMPRI 
               Replace Z1_CUBLIQU WITH SD1->D1_QTSEGUM 
               Replace Z1_CUBBRUT WITH SD1->D1_QUANT 
               Replace Z1_CODFOR with SD1->D1_FORNECE 
               Replace Z1_ESPECIE with SD1->D1_YESPECI
               // Replace Z1_DESC with  "DOF :"+ SD1->D1_YDOF+" Cert:"+ SD1->D1_YCERT 
               
               /*/
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
				// D1_YCOMPRI := wLote->D1_YCOMPRI
				D1_YCOMPRB := wLote->D1_YCOMPRB
				D1_QTSEGUM := wLote->D1_QTSEGUM
				D1_YDOF    := wLote->D1_YDOF
				D1_YCERT   := wLote->D1_YCERT
            	/*/
        	
            Msunlock()
        Endif
         
    	DbSelectArea("SD1")
    	DbSkip()
	Enddo    
    DbSelectArea("SF1")
            RecLock("SF1",.F.)
             Replace F1_YDOF with cDof
            Msunlock()
    
Endif
// U_EmailNFE()
  
Return
