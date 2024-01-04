#INCLUDE "rwmake.ch"
user function movimdp(cconta,decc,atecc,periodo,moeda)
Private cArea := Alias()
Private nReg := Recno()
Private nValor:= 0         
Private cContax:= SI3->I3_CONTA
// Private nOrdem:= DbSetOrder()
  cContax := cConta
  nValor := 0
  DbSelectArea("SI3")
  DbSetOrder(1)  // filial + custo + conta + moeda
  Dbgotop()
  DbSeek(xFilial("SI3")+decc)
  Do While alltrim(i3_custo) >= Alltrim(decc) .and. Alltrim(i3_custo) <= Alltrim(atecc) .and. !eof()
   
    if alltrim(i3_conta) <> Alltrim(cContax)
       DbSkip()
       Loop
    Endif  
    Do Case
        Case alltrim(periodo) = '1' 
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED01 - SI3->I3_DEB01
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB01 - SI3->I3_CRED01 
          Endif   
        Case alltrim(periodo) = '2'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED02 - SI3->I3_DEB02
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB02 - SI3->I3_CRED02 
          Endif   
        Case alltrim(periodo) = '3'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED03 - SI3->I3_DEB03
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB03 - SI3->I3_CRED03 
          Endif   
        Case alltrim(periodo) = '4'         
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED04 - SI3->I3_DEB04
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB04 - SI3->I3_CRED04 
          Endif          
        Case alltrim(periodo) = '5'                          
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED05 - SI3->I3_DEB05
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB05 - SI3->I3_CRED05 
          Endif  
        Case alltrim(periodo) = '6'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED06 - SI3->I3_DEB06
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB06 - SI3->I3_CRED06 
          Endif  
        Case alltrim(periodo) = '7'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED07 - SI3->I3_DEB07
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB07 - SI3->I3_CRED07 
          Endif  
        Case alltrim(periodo) = '8'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED08 - SI3->I3_DEB08
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB08 - SI3->I3_CRED08 
          Endif  
        Case alltrim(periodo) = '9'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED09 - SI3->I3_DEB09
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB09 - SI3->I3_CRED09 
          Endif  
        Case alltrim(periodo) = '10'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED10 - SI3->I3_DEB10
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB10 - SI3->I3_CRED10 
          Endif 
        Case alltrim(periodo) = '11'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED11 - SI3->I3_DEB11
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB11 - SI3->I3_CRED11 
          Endif
        Case alltrim(periodo) = '12'
          if substr(cconta,1,1)='3'
             nValor:= nValor + SI3->I3_CRED12 - SI3->I3_DEB12
          Elseif substr(cconta,1,1)='4'                     		
             nValor:= nValor + SI3->I3_DEB12 - SI3->I3_CRED12 
          Endif     
    EndCase
    DbSkip()      
  Enddo     
DbSelectArea(cArea)
DbGoto(nReg)
// DbSetOrder(nOrdem)  
//Return(nValor)     
Return(10000)

// OrcadoCC(conta,CCcusto,Periodo,Moeda,Dat_Conversao)

