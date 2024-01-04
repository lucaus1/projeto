#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
#IFNDEF WINDOWS
	#DEFINE PSAY SAY 
#ENDIF

**********************
User Function GPE001()        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
**********************
PERGUNTE("GPE001",.T.)


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                                                                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

 cDesc1 := " "
 cDesc2 := " "
 cDesc3 := " "
 cString:="SRA"
 nChar:=18

#IFNDEF WINDOWS
	 cSavCor:=SetColor()
#ENDIF

 titulo  :="Emissao do Contrato de Experiencia."
// aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 4, 2, 1, "",1 }  
 aReturn := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
 nomeprog:="GPE001"
 nLastKey:= 0
 cPerg    :="GPE001"
 li       :=1

wnrel := "GPE001"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"M")

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	#IFNDEF WINDOWS
		SetColor(cSavCor)
	#ENDIF
	Return
Endif

RptStatus({|| GPE01Imp()})

Return

**************************
Static Function GPE01Imp()
**************************

nTipo :=IIF(aReturn[4]==1,15,18)


DBSELECTAREA("SRA")                    // POSICIONA CABEC NFS
DBSETORDER(1)
DBSEEK(xFILIAL()+MV_PAR01)
IF !FOUND()
    ALERT(MV_PAR01+" nao consta no cadastro de funcionario!!")
ENDIF


SetRegua(RecCount())

GPE01Cabec(nTipo)

_Filial:=SM0->M0_CODFIL
 While !Eof() .AND. SRA->RA_MAT<=MV_PAR02 .AND. SRA->RA_FILIAL==_Filial
	#IFNDEF WINDOWS
	   Inkey()
		If LastKey()==K_ALT_A
			lEnd := .t.
		End
	#ENDIF

       dbselectarea("SRJ")
       dbsetorder(1)
       dbseek(xFilial()+sra->ra_codfunc)
       dbselectarea("SRA")

       @ 01,040 PSAY "C O N T R A T O    D E    T R A B A L H O"
       @ 02,040 PSAY "========================================="

       @ 04,08 psay "que entre si celebram a PRECIOUS WOODS BELEM LTDA., pessoa juridica de direito privado, inscrita no  CNPJ"
       @ 05,08 psay "sob o No. 03.945.278/0001-20 e estabelecida a Quadra 4 Setor B Lotes 9/13,  Distrito Industrial  de"
       @ 06,08 psay "Icoaraci, Belem - Pa, 퀲MPREGADORA`,  e o(a)  퀲MPREGADO`(a)  abaixo qualificado(a),  nos termos  e"
       @ 07,08 psay "condicoes seguintes:"

       @ 09,08 psay "EMPREGADO(A): "+SRA->RA_NOME
       @ 11,08 psay "CTPS: "+RA_NUMCP+"-"+RA_SERCP+"/"+RA_UFCP
       @ 11,40 psay "Identidade: "+RA_RG
       cNatural := IIF(SRA->RA_NATURAL <> SPACE(2),TABELA("12",RA_NATURAL),"")
       cNaciona := IIF(SRA->RA_NACIONA <> SPACE(2),TABELA("34",RA_NACIONA),"")
       @ 13,08 psay "Naturalidade: "+cNatural
       @ 13,40 psay "Nacionalidade: "+cNaciona

       @ 15,08 psay "CLAUSULA PRIMEIRA"
       @ 16,08 PSAY "O Contrato de Trabalho ora firmado o e em carater de EXPERIENCIA e, assim, e� de PRAZO DETERMINADO,"
       @ 17,08 psay "com duracao prevista,  inicialmente, para  44 (quarenta e quatro dias), findo os quais, nao havendo"
       @ 18,08 psay "manifestacao contraria de quaisquer das  partes,  estara  automaticamente  prorrogado por  mais  46"
       @ 19,08 PSAY "(quarenta e seis dias). Esgotado este prazo e mantido o vinculo empregaticio, a relacao de trabalho"
       @ 20,08 PSAY "passara a ser por PRAZO INDETERMINADO."
       @ 21,08 PSAY "Paragrafo Primeiro" 
       @ 22,08 PSAY "Em caso de rescisao unilateral do presente contrato observar-se-a o disposto nos artigos  479 e 480"
       @ 23,08 PSAY "da CLT."
       @ 24,08 PSAY "Paragrafo Segundo" 
       @ 25,08 PSAY "As regras ora contidas neste contrato,  permanecerao em vigencia ainda que o pacto passe a ser  por"
       @ 26,08 PSAY "prazo indeterminado." 
       @ 28,08 psay "CLAUSULA SEGUNDA"
       @ 29,08 PSAY "EMPREGADO(A) e� admitido nos quadros da EMPREGADORA, para trabalhar como: "
       @ 30,08 PSAY "               * CARGO              : "+srj->rj_desc
       @ 31,08 PSAY "               * REMUNERA플O MENSAL: R$ "+ALLTRIM(STR(ra_salario,12,2))
       @ 32,08 PSAY "                 ja inclusos os valores relativos ao descanso semanal remunerado"
       @ 34,08 psay "CLAUSULA TERCEIRA"
       @ 35,08 PSAY "A EMPREGADORA podera efetuar os pagamentos de  salarios atraves  de  bancos  conveniados,  por esta"
       @ 36,08 PSAY "escolhidos,  dentro dos prazos legais,  desde  que  estabeleca  facilidades  para o EMPREGADO fazer"
       @ 37,08 PSAY "abertura de conta corrente bancaria."

       @ 39,08 psay "CLAUSULA QUARTA"
       @ 40,08 PSAY "A jornada de trabalho do EMPREGADO sera de 44 (quarenta e quatro horas semanais, sendo facultado  a"
       @ 41,08 PSAY "EMPREGADORA alterar o horario de prestacao dos servicos, estabelecer regime de  compensacao,  banco"
       @ 42,08 PSAY "horas, revezamento ou horario noturno e misto, e tambem, reduzir a jornada pactuada,  obervadas  as"
       @ 43,08 PSAY "condicoes legais ou convencionais, ressalvado no  entanto  o  direito  de  restabelecer  o  horario"
       @ 44,08 PSAY "pactuado, sem qualquer acrescimo ou vantagem salarial."
       @ 45,08 PSAY "Paragrafo Primeiro" 
       @ 46,08 PSAY "O horario de trabalho sera o anotado na sua  Ficha  de  Registro  de  Empregado,  ou ainda,  aquele"
       @ 47,08 PSAY "estabelecido em Acordos ou Convencoes Coletivas de Trabalho"

       @ 50,090 PSAY "Continua ......."
       
       @ 03,08 psay "CLAUSULA QUINTA"
       @ 04,08 PSAY "O EMPREGADO(A) concorda, expressamente, em prestar servicos para a EMPREGADORA, tanto na localidade"
       @ 05,08 PSAY "de celebracao deste contrato, como em qualquer outra Cidade, Capital ou Vila do Territorio Nacional"
       @ 06,08 PSAY "em carater transitorio ou definitivo, obedecidos os requisitos legais."

       @ 08,08 psay "CLAUSULA SEXTA"
       @ 09,08 PSAY "Os  danos  eventualmente  causados  pelo(a)  EMPREGADO(A)  na  execucao  dos  servicos,  dolosa  ou"
       @ 10,08 PSAY "culposamente, serao indenizadas a EMPREGADORA mediante desconto no pagamento do salario ou rescisao"
       @ 11,08 PSAY "de contrato, desde ja por ele(a) autorizado(a)."


       @ 13,08 psay "CLAUSULA SETIMA"
       @ 14,08 PSAY "A EMPREGADORA esta autorizada a descontar dos salarios: os uniformes, EPI큦  e/ou  ferramentas nao"
       @ 15,08 PSAY "devolvidas no desligamento do empregado ou mal conservados, e ainda, a descontar valores aprovados"
       @ 16,08 PSAY "pelo empregado, a titulo de antecipacao, vales, adiantamentos diversos ou outra forma."

       @ 18,08 PSAY "Estando assim justos e contratados, firmam o presente em duas vias de igual teor,  uma  para  cada"
       @ 19,08 PSAY "parte, a vista de duas testemunhas."

       @ 21,80 PSAY ALLTRIM(SM0->M0_CIDCOB)+", "+DTOC(RA_ADMISSA)
       @ 24,08 PSAY "--------------------------------------------           -------------------------------------------"
       @ 25,08 PSAY "                TESTEMUNHA                                               EMPREGADORA              "
       @ 28,08 PSAY "--------------------------------------------           -------------------------------------------"
       @ 30,08 PSAY "                TESTEMUNHA                             "+ALLTRIM(RA_NOME)

//       @ 33,01 PSAY REPLICATE("#",131)
//       @ 34,50 PSAY "T E R M O   D E   P R O R R O G A C A O"
//       @ 35,50 PSAY "======================================="
//       @ 36,03 PSAY "     Por mutuo acordo entre as partes, fica o presente Contrato de Experiencia, que deveria vencer nesta data, prorrogado"
//       @ 37,03 psay "ate       /      /         , ou Indeterminadamente ate que uma das partes opte pelo referido cancelamento."

//       @ 40,80 PSAY SM0->M0_CIDCOB+", "
//       @ 41,03 PSAY "        ---------------------------------------------                    ---------------------------------------------   "
//       @ 42,03 PSAY "                        TESTEMUNHA                                                        EMPREGADORA                    "
//       @ 45,03 PSAY "        ---------------------------------------------                    ---------------------------------------------   "
//       @ 46,03 PSAY "                        TESTEMUNHA                                       "+ALLTRIM(RA_NOME)





	If lEnd
		@Prow()+1,1 PSAY "Cancelado pelo operador"
		Exit
	EndIF

	IncRegua()
        DBSKIP()
EndDO

@ LI,000 PSAY " "

Set Device To Screen
Set Filter To

If aReturn[5]==1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

RETURN

****************************
Static Function GPE01cabec()
****************************

 cTamanho := "M"
 aDriver := ReadDriver()

If !( "DEFAULT" $ Upper( __DRIVER ) )
	SetPrc(000,000)
Endif
if nChar == NIL
	 @ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
else
	if nChar == 15
	      @ pRow(),pCol() PSAY CHR(15)
//		  @ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
	else
//		  AA:=(if(cTamanho=="P",aDriver[2],if(cTamanho=="G",aDriver[6],aDriver[4])))                  
		  AA:=aDriver[6]
		  @ Prow(),pCol() PSAY &AA
	endif
endif
Return(.T.)
