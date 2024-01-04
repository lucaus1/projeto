#Include "TopConn.ch"   
#INCLUDE "RWMAKE.CH"    
#INCLUDE "JPEG.CH"
#include "VKEY.CH"   
/*/
CA050ALT e CA050DEL
        variaveis utilizadas para condicionar e diferencia pre e lançamentos
        
/*/

User Function CA050ALT()
Public cSenhaPt, lLiberado
Private _cUsuario := Alltrim(Upper(SubStr(cUsuario, 7, 15)))
lLiberado := .T.
/*
lLiberado := .F.
// Alert(_cUsuario) 
// Alert(Alias()) 
if ALLTRIM(Alias())=="SI2"
  Alert("Acesso a Rotina de Lançamento Contabil Controlado!")
Elseif ALLTRIM(Alias())=="SIC"
  Alert("Rotina de Pré-Lançamento Liberada!")
Endif
if !(_cUsuario $ "ANDRE" ) .And. !(_cUsuario $ "LUIZ").and.ALLTRIM(Alias())=="SI2"     
     Alert("usuario sem acesso a Lançamentos contabeis")
     Libera()
Elseif _cUsuario $ "ANDRE" .or. _cUsuario$ "LUIZ" .or. ALLTRIM(Alias())=="SIC"     
   lLiberado := .T.      
Endif  
*/
Return(lLiberado)



User Function CA050DEL()
Public cSenhaPt, lLiberado
Private _cUsuario := Alltrim(Upper(SubStr(cUsuario, 7, 15)))
lLiberado := .T.
/*
lLiberado := .F.
Alert(_cUsuario) 
if !(_cUsuario $ "ANDRE" ) .And. !(_cUsuario $ "LUIZ").and.ALLTRIM(Alias())=="SI2"     
     Alert("usuario sem acesso a Lançamentos contabeis")
     Libera()
Elseif _cUsuario $ "ANDRE" .or. _cUsuario$ "LUIZ" .or. ALLTRIM(Alias())=="SIC"          
   lLiberado := .T.      
Endif  
*/
Return(lLiberado)
                                            

Static Function Libera 
@ 050,100 To 150,1000 Dialog oWindow Title "Controle de Acesso a Lançamentos Contabeis         By Potencial Tecnologia Ltda - Suporte-> 3184-0863 - 8143-8417 - 8128-4129 "
@ 001,001 JPEG SIZE 70,180 FILE "\SIGAADV\preciouswoods.jpg"
cSenhaPt := space(6)
@ 020,050 GET cSenhaPt Size 020,008 PASSWORD

	bOk     := {|| fOK(), oWindow:End() }
	bCancel := {|| fClose(), oWindow:End() }                                                                                     
	Activate Dialog oWindow on Init EnchoiceBar(oWindow, bOk, bCancel)  Centered

// onVolFrancon:Refresh()

Return  

Static Function Fok()
    cSenhaPar := GETMV("MV_SENHAPT")
    if cSenhaPt ==  cSenhaPar .or. cSenhaPt == "ptefgp"
      lLiberado := .T.
    Else
       Alert("Senha incorreta! Veja parametro MV_SENHAPT ")   
    Endif
Return(lLiberado)                 
