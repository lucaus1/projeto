user function MT681INC()
// ponto de entrada pro YURE 
alert("Entrando apos apontamento de producao modelo 2")
// gravar dados na SD3
cAlias := Alias()
DbSelectArea("SD3")
Reclock("SD3",.F.)
D3_TORA := SH6->H6_TORA 
D3_DATADIV := SH6->H6_DTAPONT
D3_YCOMPRI := SH6->H6_COMPBRU
// D3_YRODA   := SH6->H6_
D3_YPE1    := SH6->H6_PE1
D3_YPE2    := SH6->H6_PE2
D3_YOCO1   := SH6->H6_OCO1
D3_YOCO2   := SH6->H6_OCO2
D3_YPONTA1 := SH6->H6_OCOPON
D3_YPONTA2 := SH6->H6_OCOPON2
// D3_YOCOP1  := SH6->H6_
// D3_YOCOP2  := SH6->H6_
D3_YCOMPRB := SH6->H6_COMPBRU
D3_PARTEA := SH6->H6_PARTEA
D3_PARTEB := SH6->H6_PARTEB
D3_PARTEC := SH6->H6_PARTEC
D3_PARTED := SH6->H6_PARTED
D3_PARTEE := SH6->H6_PARTEE
D3_PARTEF := SH6->H6_PARTEF
D3_VOLA := SH6->H6_VOLA
D3_VOLB := SH6->H6_VOLB
D3_VOLC := SH6->H6_VOLC
D3_VOLD := SH6->H6_VOLD
D3_VOLE := SH6->H6_VOLE
D3_VOLF := SH6->H6_VOLF    
D3_CUSTO1 := SH6->H6_CUSTO 

MsUnlock()

// gravar dados custo na SB2

IF SH6->H6_CUSTO > 0
 DbSelectArea("SB2")
 DbSetOrder(1)
 Dbseek(xFilial("SB2")+SH6->H6_PRODUTO+SH6->H6_LOCAL)  
  Reclock("SB2",.F.)
  nValatu := B2_VATU1
  B2_VATU1 := nValatu + SH6->H6_CUSTO
  B2_CM1   := SH6->H6_CUSTO / SH6->H6_QTDPROD 
  MsUnlock()
ENDIF

DbSelectArea(cAlias) 




Return


