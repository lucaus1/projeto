
user Function MANSZ1INC()    
 
//****************************************************************
//    Inclusao de Toras Modelo II - MACEDO (MICROSIGA BELEM)
//    CLIENTE : LISBOA MADEIRAS LTDA       18/12/2001
//****************************************************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//****************************************** CAMPOS DO SZ1
//*  REPLACE Z1_FILIAL  WITH xFilial("SZ1")
//*  REPLACE Z1_ESPECIE WITH _ESPECIE
//*  REPLACE Z1_MEDICAO WITH _MEDICAO
//*  REPLACE Z1_SITUACA WITH _SITUACA 
//*  REPLACE Z1_TIPOORI WITH _TIPOORI
//*  REPLACE Z1_ORIGEM  WITH _ORIGEM
//*  REPLACE Z1_QUALIDA WITH _QUALIDA
//*  REPLACE Z1_FRETEIR WITH _FRETEIR
//*  REPLACE Z1_CODFOR  WITH _CODFOR
//*  REPLACE Z1_BALSA   WITH _BALSA
//*  REPLACE Z1_DCOMPRI WITH _DCOMPRI
   
//   REPLACE Z1_RODO    WITH _RODO
//   REPLACE Z1_CASCA   WITH _CASCA
//   REPLACE Z1_OCOALT  WITH _OCOALT
//   REPLACE Z1_OCOLAR  WITH _OCOLAR
//   REPLACE Z1_COD     WITH _COD
//   REPLACE Z1_COMPRIM WITH nCOMP_B
//   REPLACE Z1_CUBBRUT WITH nCUBBRTB
//   REPLACE Z1_CUBLIQU WITH nCUBLIQB
//   REPLACE Z1_CORTE   WITH "B"
//   REPLACE Z1_NFORN   WITH _NFORN
//********************************************

INCLUI:=.T.
ALTERA:=.F.
nOpcx:=3


DBSELECTAREA("SZ1")
DBSETORDER(2)

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZ1")
nUsado:=0
aHeader:={}

While !Eof() .And. (x3_arquivo == "SZ1")

      IF  x3_nivel >=2 .AND. X3_CAMPO<>"Z1_PROXNUM"   // os campos que tem nivel 2
         nUsado := nUsado+1
        AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
                        x3_tamanho, x3_decimal,.f.,;
                        x3_usado, x3_tipo, x3_arquivo, x3_context } )
      Endif
      dbSkip()

End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCols:=ARRAY(1,nUSADO+1)
nUsado:=0
nAnt:=0

dbSeek("SZ1")
While !Eof() .And. (x3_arquivo == "SZ1")
        IF x3_nivel >= 2 .AND. X3_CAMPO<>"Z1_PROXNUM"

           nUsado:=nUsado+1

           IF nOpcx == 3
              IF     x3_tipo == "C"
                     aCOLS[1][nUsado] := SPACE(x3_tamanho)
              Elseif x3_tipo == "N"
                     aCOLS[1][nUsado] := 0
              Elseif x3_tipo == "D"
                     aCOLS[1][nUsado] := dDataBase
              Elseif x3_tipo == "M"
                     aCOLS[1][nUsado] := ""
              Else
                     aCOLS[1][nUsado] := .F.
              Endif
           Endif
        Endif
   dbSkip()
End

aCOLS[1][nUsado+1] := .F. 
 

dbSelectArea("SZ1")
DbSetOrder(2)


_nQtdCad     := 0 
_nSeq        :=0
_cFlag       :="I"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Rodape do Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLinGetD:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTitulo:="Inclusao de Toras"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aC:={}

// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

_ESPECIE := SPACE(LEN(Z1_ESPECIE))
_MEDICAO := dDataBase
_SITUACA := "P"
_TIPOORI := "1"
_ORIGEM  := "CO"
_QUALIDA := SPACE(LEN(Z1_QUALIDA))
_FRETEIR := SPACE(LEN(Z1_FRETEIR))
_CODFOR  := SPACE(LEN(Z1_CODFOR))
_BALSA   := 0

   AADD(aC,{"_ESPECIE"  ,{15,010}, "Especie   ","","ExistCpo('SB1')","SB1",.T.})
   AADD(aC,{"_MEDICAO"  ,{15,070}, "Dt Medicao","","",,.T.})
   AADD(aC,{"_SITUACA"  ,{15,150}, "Sit (PVSR)","","PERTENCE('PVSR')",,.T.})  // PATIO/VENDIDA/SERRADA/REFUGO
   AADD(aC,{"_TIPOORI"  ,{15,200}, "1-Prop 2-Terc","","PERTENCE('12')",,.T.})    // PROPRIO/TERCEIROS
   AADD(aC,{"_ORIGEM"   ,{15,260}, "Origem    ","","","Z1 ",.T.})
   AADD(aC,{"_QUALIDA"  ,{30,010}, "Certific.?","","PERTENCE('SN')",,.T.})    // PRIMEIRA/SEGUNDA
   AADD(aC,{"_FRETEIR"  ,{30,070}, "Freteiro  ","","","SZ4",.T.})
   AADD(aC,{"_CODFOR"   ,{30,150}, "Cod Forn  ","","","SA2",.T.})
   AADD(aC,{"_BALSA"    ,{30,235}, "Balsa     ","999999","",,.T.})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape do Modelo 2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aR:={}

//aCGD:={60,5,130,315}

aCGD:={60,5,130,315}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//cIncLin:="ExecBlock('ReqLin',.f.,.f.)"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// lRetMod2 = .t. se confirmou 
// lRetMod2 = .f. se cancelou

  lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,3,"execblock('cOk1',.F.,.F.)")

// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente


If lRetMod2

   _nSeq:=0

   For i:=1 to len(aCols)

       DbSelectArea("SZ1")
       dbsetorder(1)
       go top


       _lAltera := .t.

       
       if _cFlag <> "A"


          If !aCols[i][nUsado+1] .and. !EMPTY(aCols[i][1])

          
             //Grava no SZ1

             Reclock("SZ1",.T.)
             REPLACE Z1_FILIAL  WITH xFilial("SZ1")
             REPLACE Z1_ESPECIE WITH _ESPECIE
             REPLACE Z1_MEDICAO WITH _MEDICAO
             REPLACE Z1_SITUACA WITH _SITUACA 
             REPLACE Z1_TIPOORI WITH _TIPOORI
             REPLACE Z1_ORIGEM  WITH _ORIGEM
             REPLACE Z1_QUALIDA WITH _QUALIDA
             REPLACE Z1_FRETEIR WITH _FRETEIR
             REPLACE Z1_CODFOR  WITH _CODFOR
             REPLACE Z1_BALSA   WITH _BALSA
   
             REPLACE Z1_COD     WITH aCols[i][01]
             REPLACE Z1_NFORN   WITH aCols[i][02]
             REPLACE Z1_RODO    WITH aCols[i][03]
             REPLACE Z1_COMPRIM WITH aCols[i][04]
             REPLACE Z1_OCOALT  WITH aCols[i][05]
             REPLACE Z1_OCOLAR  WITH aCols[i][06]
             REPLACE Z1_CUBLIQU WITH aCols[i][07]
             REPLACE Z1_CUBBRUT WITH aCols[i][08]
             REPLACE Z1_CASCA   WITH aCols[i][09]
             REPLACE Z1_DCOMPRI WITH aCols[i][10]



             MsUnlock()
          Endif

       Endif
   Next
Else
   DbSelectArea("SZ1")
Endif


Return(nil)              


User Function cOk1(cValid)

Local cValid:=.t.
IF n>= 2
   FOR JJ:=1 TO (len(aCols)-1)
       IF acols[n][1]==acols[JJ][1]
          ALERT("!!! Tora ja cadastrada neste formulario !!!" + acols[n][1])
          cValid:=.F.
       ENDIF
   NEXT JJ
ENDIF
    

if empty(acols[n][1])
   ALERT("!!! Tora em branco !!!")
   cValid:=.F.
endif

if n == 98
   ALERT("!!! Falta apenas 1 tora a ser lancada - LIMITE DE 99 LANCAMENTOS!!!")
endif

Return(cValid)     
