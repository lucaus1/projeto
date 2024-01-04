user function Movicc(cConta,cDecc,cAtecc,cPeriodo,nMoeda)
	Private nValor:= 0                              
    Private aCc:={}
    

	Dbselectarea ("SI3")
	Dbgotop()
	Dbsetorder(1)
	Dbseek(xFilial("SI3")+cDecc)
	Do while !eof() .and. SI3->I3_Custo <=cAtecc
		If SI3->I3_CONTA <> cConta 
			Dbskip()
			Loop
		Endif
		
		If SI3->I3_MOEDA <> val(nmoeda)  
			Dbskip()
			Loop
		Endif   
	    
		fPeriodo(cPeriodo)
	
		Dbskip()
	enddo  
	
	Alert (nvalor)

return (nValor)

       
Static Function fPeriodo(cVar)
	Do case
		Case cVar == '1' ; nValor += SI3->I3_CRED01 - SI3->I3_DEB01
		Case cVar == '2' ; nValor += SI3->I3_CRED02 - SI3->I3_DEB02	
		Case cVar == '3' ; nValor += SI3->I3_CRED03 - SI3->I3_DEB03		
		Case cVar == '4' ; nValor += SI3->I3_CRED04 - SI3->I3_DEB04		
		Case cVar == '5' ; nValor += SI3->I3_CRED05 - SI3->I3_DEB05		
		Case cVar == '6' ; nValor += SI3->I3_CRED06 - SI3->I3_DEB06		
		Case cVar == '7' ; nValor += SI3->I3_CRED07 - SI3->I3_DEB07		
		Case cVar == '8' ; nValor += SI3->I3_CRED08 - SI3->I3_DEB08		
		Case cVar == '9' ; nValor += SI3->I3_CRED09 - SI3->I3_DEB09		
		Case cVar == '10'; nValor += SI3->I3_CRED10 - SI3->I3_DEB10		
		Case cVar == '11' ; nValor += SI3->I3_CRED11 - SI3->I3_DEB11		
		Case cVar == '12' ; nValor += SI3->I3_CRED12 - SI3->I3_DEB12		
			
	Endcase
Return
	