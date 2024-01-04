#include "RwMake.ch"
#include "topconn.ch"
/*
#############################################################################################################################################
#                                                                                  @@@@@ @@@@@ @@@@@@@ @@@@@@ @    @ @@@@@@ @ @@@@@@ @
#                                                                                  @   @ @   @    @    @      @ @  @ @      @ @    @ @
#                                                                                  @@@@@ @   @    @    @@@@@@ @  @ @ @      @ @@@@@@ @
#                                                                                  @     @   @    @    @      @   @@ @      @ @    @ @
#                                                                                  @     @@@@@    @    @@@@@@ @    @ @@@@@@ @ @    @ @@@@@@@
############################################################################################################################################
#Rotina = Cálculo do Volume Geométrico / Liquido PCP"
#Data = 02/07/2008
#Desenvolvedor = Clelio Souza 
Descricao: 
//Alteração efetuada para atender o resultado  do valor do Volume Liquido no campo D1_QTSEGUM conforme foi passado em planilha do Excel 
//=((((MÉDIA(C4;D4;G4;H4)*PI())/400)^2)*K4)-(MÁXIMO(P4:Q4))
#Alterações = "Seguindo novas definições passado por e-mail no dia 11/07/08"       
//Volume Geométrico Bruto
//=((((((0,25*PI())*(((C23+D23)/200)^2))+((0,25*PI())*(((G23+H23)/200)^2)))/2)*K23)) 
//Volume Geométrico Liquido
//=((((((0,25*PI())*(((C23+D23)/200)^2))+((0,25*PI())*(((G23+H23)/200)^2)))/2)*L23)-((0,25*PI())*((MÉDIA(E23;F23;I23;J23)/100)^2)*L23))
Data           Desenvolvedor 	Descricao


############################################################################################################################################
*/
//=((((((0,25*PI())*(((C23+D23)/200)^2))+((0,25*PI())*(((G23+H23)/200)^2)))/2)*K23)) 
//U_CubPcpG(M->D1_YPE1,M->D1_YPE2,M->D1_YPONTA1,M->D1_YPONTA2,M_D1_YCOMPRI)
//U_CubPcpL(M->D1_YPE1,M->D1_YPE2,M->D1_YOCO1,M->D1_YOCO2,M->D1_YPONTA1,M->D1_YPONTA2,M->D1_YOCOP1,M->D1_YOCOP2,M->D1_YCOMPRI,M->D1_YCOMPRB)


User Function CUBPCPG(nPe1,nPe2,nPonta1,nPonta2,nComp1)
Private nVolG   := 0.00 //Variável de Retorno Volume Geométrico
Private nFator  := 0.7854
Private aAlias := GetArea()

nVolG := (((nFator*(((nPe1+nPe2)/200)**2))+(nFator*(((nPonta1+nPonta2)/200)**2)))/2)*nComp1

RestArea( aAlias )

Return(nVolG)


User Function CUBPCPL(nPe1,nPe2,nOcoPe1,nOcoPe2,nPonta1,nPonta2,nOcoPn1,nOcoPn2,nComp1,nComp2)
Private nVolL     := 0.00 //Variável de Retorno Volume Geométrico
Private nFator    := 0.7854
Private aAlias    := GetArea()
Private nOcoPe    := 0.00
Private nOcoPonta := 0.00
Private nOcoMax   := 0.00
                                                                                        
OcoPe := ((nOcoPe1*nOcoPe2)/10000)*nComp1
OcoPonta := ((nOcoPn1*nOcoPn2)/10000)*nComp1
                     
If OcoPe > OcoPonta
	nOcoMax := OcoPe
Else
	nOcoMax := 	OcoPonta
Endif
//nVolG := (((nFator*(((nPe1+nPe2)/200)**2))+(nFator*(((nPonta1+nPonta2)/200)**2)))/2)*nComp1
//nVolL :=(((((((nPe1+nPe2+nPonta1+nPonta2)/4)*3.1416))/400)**2)*nComp1)-nOcoMax
//=(((0,7854*(((C5+D5)/200)^2))+(0,7854*(((G5+H5)/200)^2)))/2)*L5-((0,7854*(((E5+F5+I5+J5)/4)/100)^2)*L5)
nVolL :=(((nFator*(((nPe1+nPe2)/200)**2))+(nFator*(((nPonta1+nPonta2)/200)**2)))/2)*nComp2-((nFator*(((nOcoPe1+nOcoPe2+nOcoPn1+nOcoPn2)/4)/100)**2)*nComp2)
        
              
RestArea( aAlias )
                       
Return(nVolL)
