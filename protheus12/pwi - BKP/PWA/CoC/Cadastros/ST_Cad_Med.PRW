#INCLUDE "rwmake.ch"

User Function ST_Cad_Med()

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z01"

dbSelectArea("Z01")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Medidas",cVldAlt,cVldExc)

Return


User Function ST_Calc_Med()
     MED    :=M->Z01_MEDIDA
     MED    := strtran(med,",",".")
     COL    :=1
     COL2   :=1
     MVAR   :=""
     C      :=""
     VESP   :=0
     DO WHILE COL<=12
        C:=SUBSTR(MED,col,1)
        if c="."
           col2:=col+1
           mvar:=substr(MED,1,col-1)
        endif
        if c=","
           col2:=col+1
           mvar:=substr(MED,1,col-1)
        endif
        if c="/"
           a:=substr(MED,col2,col-1)   
           b:=substr(MED,col+1,12)   
           do case
              case M->Z01_TIPO="PL"
                   vesp:=(((val(a)/val(b))+val(mvar))*2.54)/100
              case M->Z01_TIPO="MM"
                   vesp:=(((val(a)/val(b))+val(mvar)))/1000
              case M->Z01_TIPO="PE"							        	
                   vesp:=(((val(a)/val(b))+val(mvar))*30.48)/100
              case M->Z01_TIPO="CM"
                   vesp:=(((val(a)/val(b))+val(mvar)))/100
              case M->Z01_TIPO="MT"
                   vesp:=((val(a)/val(b))+val(mvar))
           endcase        
           exit
        else
           do case
              case M->Z01_TIPO="PL"
                   vesp:=(val(MED)*2.54)/100
              case M->Z01_TIPO="MM"
                   vesp:=(val(MED))/1000
              case M->Z01_TIPO="PE"
                   vesp:=(val(MED)*30.48)/100
              case M->Z01_TIPO="CM"
                   vesp:=(val(MED))/100
              case M->Z01_TIPO="MT"
                   vesp:=(val(MED))
           endcase        
        endif
        col:=col+1
     enddo
return(vesp)


// Calculo de Volume de Pacotes
User Function ST_VPct(vEsp,vLarg,vCompr,vPecas)
nEsp  :=Posicione("Z01",1,xFilial("Z01")+vEsp,"Z01_CONVER")
nLarg :=Posicione("Z01",1,xFilial("Z01")+vLarg,"Z01_CONVER")
nCompr:=Posicione("Z01",1,xFilial("Z01")+vCompr,"Z01_CONVER")
nVolume:=nEsp*nLarg*nCompr*vPecas
Return(nVolume)
