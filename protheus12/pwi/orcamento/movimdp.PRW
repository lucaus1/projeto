#include "rwmake.ch"
user function movimdp(cconta,decc,atecc,periodo,moeda)
Private cArea := Alias()
Private nReg := Recno()
Private nValor:= 0         
Private cContax:= SI3->I3_CONTA
Private cCustox:=SI3->I3_CUSTO
Private cCustoy:=SI3->I3_CUSTO

// Private nOrdem:= DbSetOrder()
  cContax := cConta          
  cCustox := decc             
  cCustoy := atecc
  nValor := 0
  DbSelectArea("SI3")
  DbSetOrder(1)  // filial + custo + conta + moeda
  Dbgotop()
  DbSeek(xFilial("SI3")+cCustox,.T.)
  Do While Alltrim(i3_custo) >= Alltrim(cCustox).and.Alltrim(i3_custo) <= Alltrim(cCustoy) .and. !eof()
    if !(Alltrim(cContax)$alltrim(i3_conta))
       DbSkip()
       Loop
    Endif  
    Do Case
        Case alltrim(periodo) $ '1' 
          if substr(ccontax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE01 - SI3->I3_DEB01
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB01 - SI3->I3_CRE01 
          Endif   
        Case alltrim(periodo) $ '2'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE02 - SI3->I3_DEB02
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB02 - SI3->I3_CRE02 
          Endif   
        Case alltrim(periodo) $ '3'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE03 - SI3->I3_DEB03
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB03 - SI3->I3_CRE03 
          Endif   
        Case alltrim(periodo) $ '4'         
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE04 - SI3->I3_DEB04
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB04 - SI3->I3_CRE04 
          Endif          
        Case alltrim(periodo) $ '5'                          
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE05 - SI3->I3_DEB05
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB05 - SI3->I3_CRE05 
          Endif  
        Case alltrim(periodo) $ '6'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE06 - SI3->I3_DEB06
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB06 - SI3->I3_CRE06 
          Endif  
        Case alltrim(periodo) $ '7'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE07 - SI3->I3_DEB07
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB07 - SI3->I3_CRE07 
          Endif  
        Case alltrim(periodo) $ '8'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE08 - SI3->I3_DEB08
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB08 - SI3->I3_CRE08 
          Endif  
        Case alltrim(periodo) $ '9'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE09 - SI3->I3_DEB09
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB09 - SI3->I3_CRE09 
          Endif  
        Case alltrim(periodo) == '10'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE10 - SI3->I3_DEB10
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB10 - SI3->I3_CRE10 
          Endif 
        Case alltrim(periodo) == '11'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE11 - SI3->I3_DEB11
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB11 - SI3->I3_CRE11 
          Endif
        Case alltrim(periodo) == '12'
          if substr(cContax,1,1)$'3'
             nValor:= nValor + SI3->I3_CRE12 - SI3->I3_DEB12
          Elseif substr(cContax,1,1)$'4'                     		
             nValor:= nValor + SI3->I3_DEB12 - SI3->I3_CRE12 
          Endif     
    EndCase
    DbSkip()      
  Enddo     
DbSelectArea(cArea)
DbGoto(nReg)
// DbSetOrder(nOrdem)  
Return(nValor)     
// Return(10000)

// OrcadoCC(conta,CCcusto,Periodo,Moeda,Dat_Conversao)

