#Include "TopConn.ch"   
#INCLUDE "RWMAKE.CH"    
#INCLUDE "JPEG.CH"
#include "VKEY.CH"   
/*/


/*/

User Function CalcM3G
Public nCubico,nPex,nPey,nOcoPeX,nOcoPeY,nPontax
Public nPontaY,nOcoPontaX,nOcoPontaY,nCompBruto
Public nCompLiqui, nVolliq, nVolGeom, nFatGeo, onM3Geo,nVolGeoLiq, nVolFrancon 

nPex := nPey := nOcoPeX := nOcoPeY := 0 
nPontax := nPontaY := nOcoPontaX := nOcoPontaY := 0   
nCompBruto := nCompLiqui := nVolliq := 0
nVolGeom := nVolGeoLiq := nVolFrancon := 0.0000
nFatGeo:= 0.7854

// Gethal
// nM3Smaliam := ( (((aCols[nLin,_PONFIN]+aCols[nLin,_PONFIN])/200)**2)-((0**2)/10000) ) * _FATGEO * (Val(Subs(SUB->(FIELDNAME(nC)),2))/100) * SUB->(FIELDGET(nC))
//   m3FrcPP:= m3FrcPP + (X1*(mDiam*mDiam)*0.6168)
// Braspor
// Cubico :=((Z5_Pe1+Z5_Pe2)/2+(Z5_Ponta1+Z5_Ponta2)/2)/2*((Z5_Pe1+Z5_Pe2)/2+(Z5_Ponta1+Z5_Ponta2)/2)/2*0,7854*Z5_COMP


@ 050,100 To 260,900 Dialog oWindow Title "Calculo Cubagem         By Potencial Tecnologia Ltda - Suporte-> 3184-0863 - 8143-8417 - 8128-4129 "
@ 001,001 JPEG SIZE 70,180 FILE "\SIGAADV\preciouswoods.jpg"

@ 020,070 SAY "Pe X"
@ 020,100 GET nPeX PICTURE "@E 999.99 " SIZE 45,12 object onPeX 
@ 020,150 SAY "Pe Y "
@ 020,175 GET nPeY PICTURE "@E 999.99 " SIZE 45,12 object onPeY
@ 020,225 SAY "Ponta X"
@ 020,260 GET nPontaX PICTURE "@E 999.99 " SIZE 45,12 object onPontaX 
@ 020,310 SAY "Ponta Y"
@ 020,350 GET nPontaY PICTURE "@E 999.99 " SIZE 45,12 object onPontaY

@ 035,070 SAY "Comprimento Bruto "
@ 035,200 GET nCompBruto PICTURE "@E 999.99 " SIZE 45,12 object oCompBruto  


// calculo do Oco para uso no Francon 
@ 050,070 SAY "Oco Pe X"
@ 050,100 GET nOcoPeX PICTURE "@E 999.99 " SIZE 45,12 object oOcoPeX
@ 050,150 SAY "Oco Pe Y"
@ 050,175 GET nOcoPeY PICTURE "@E 999.99 " SIZE 45,12 object oOcoPeY 
@ 050,225 SAY "Oco Ponta  X"
@ 050,260 GET nOcoPontaX PICTURE "@E 999.99 " SIZE 45,12 object oOcoPontaX
@ 050,310 SAY "Oco Ponta  Y"
@ 050,350 GET nOcoPontaY PICTURE "@E 999.99 " SIZE 45,12 object oOcoPontaY 
@ 075,070 SAY "Comprimento Liquido "
@ 075,200 GET nCompLiquido PICTURE "@E 999.99 " SIZE 45,12 object oCompLiquido  

@ 090,070 SAY "M3 Geo: "
@ 090,100 GET nVolGeom PICTURE "@E 999.999999 " SIZE 55,12 object onM3Geo     

@ 090,180 SAY "M3 Geo Liq : "
@ 090,210 GET nVolGeoLiq PICTURE "@E 999.999999 " SIZE 55,12 object onM3GeoLiq     

@ 090,270 SAY "M3 Francon : "
@ 090,310 GET nVolFrancon PICTURE "@E 999.999999 " SIZE 55,12 object onVolFrancon     

@ 110,050 SAY "  F5-Calcula M3 Smaliam ou Geometrico "


onM3Geo:disable()
onM3GeoLiq:disable()
onVolFrancon:disable()
onM3Geo:disable()

SetKey(VK_F5   ,{ || CalcM3Geo()})     

	bOk     := {|| fOK() }
	bCancel := {|| fClose(), oWindow:End() }                                                                                     
	Activate Dialog oWindow on Init EnchoiceBar(oWindow, bOk, bCancel)  Centered

Return


Static Function fOk


Return

Static Function CalcM3Geo
Alert(STR(nPeX)+STR(nPeY)+STR(nPontaX)+STR(nPontaY))
// nVolGeom :=(((nPeX+nPeY)/2+(nPontaX+nPontaY)/2)/2*((nPeX+nPeY)/2+(nPontaX+nPontaY)/2)/2*nFatGeo*nCompBruto)/10000
// anterior // nVolGeom :=((((nFatGeo*(((nPeX+nPeY)/2)**2))+(nFatGeo*(((nPontaX+nPontaY)/2)**2)))/2)*nCompBruto)/10000  
nVolGeom :=((((nFatGeo*(((nPeX+nPeY)/2)**2))+(nFatGeo*(((nPontaX+nPontaY)/2)**2)))/2)*nCompBruto)/10000
nVolOco1  :=(((nOcoPeX*nOcoPeY)/10000)*nCompBruto) 
nVolOco2  :=(((nOcoPontaX*nOcoPontaY)/10000)*nCompBruto)
if nVolOco1 > nVolOco2 
  nVolOcoMax := nVolOco1
Else 
  nVolOcoMax := nVolOco2
Endif 
  
nVolGeoLiq :=  ((((nFatGeo*(((nPeX+nPeY)/2)**2))+(nFatGeo*(((nPontaX+nPontaY)/2)**2)))/2)*nCompLiquido)/10000 - nVolOcoMax
 
nVolFrancon := (((nPeX+nPeY)/2+(nPontaX+nPontaY)/2)/2*((nPeX+nPeY)/2+(nPontaX+nPontaY)/2)/2*0.6168*nCompLiquido)/10000
onM3GeoLiq:Refresh()
onVolFrancon:Refresh()
onM3Geo:Refresh()
Alert(nVolGeom)
Return(nVolGeom)  
