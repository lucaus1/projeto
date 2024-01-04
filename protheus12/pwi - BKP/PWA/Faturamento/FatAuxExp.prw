#INCLUDE "rwmake.ch"

User Function FatAuxExp
Private cPerg   := "CDL"
Private cCadastro := "Cadastro de Auxiliar Exportacao"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir",'ExecBlock("Exp_Inc",.F.,.F.)',0,3} ,;
             {"Alterar",'ExecBlock("Exp_Alt",.F.,.F.)',0,4} ,;
             {"Excluir","AxDeleta",0,5} }

//             {"Incluir","AxInclui",0,3} ,;
//             {"Alterar","AxAltera",0,4} ,;

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "CDL"
dbSelectArea("CDL")
dbSetOrder(1)
cPerg   := "CDL"
Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros
dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,"CDL_UFEMB")
Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros
Return


User Function Exp_Inc()

Private cCadastro := "Inclusão de Lancamentos..."
SetPrvt("NOPCA,CCOD,AAC,CSAVCUR5,CSAVSCR5,CSAVROW5")
SetPrvt("CSAVCOL5,CSAVCOR5,LNIVEL,NUSADO,ACAMPOS,CALIAS")
SetPrvt("NREG,NOPC,")

nOpcA := { "Abandona","Confirma" }
cCod := { "Abandona","Confirma" }
aAC := { "Abandona","Confirma" }

While .T.
	nOpcA:=0
	lNivel := 5
	nUsado  := 0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("CDL")
	aCampos := {}
	aadd(acampos,"CDL_FILIAL")
	aadd(acampos,"CDL_DOC")
	aadd(acampos,"CDL_SERIE")
	aadd(acampos,"CDL_ESPEC")
	aadd(acampos,"CDL_CLIENT")
	aadd(acampos,"CDL_LOJA")
	aadd(acampos,"CDL_UFEMB")
	aadd(acampos,"CDL_LOCEMB")
	cAlias := Alias()
	nReg   := Recno()
	nOpc   := 3
	DBSELECTAREA("CDL")
	nOpcA:=AxInclui( "CDL", 0, nOpc, aCampos)
	dbSelectArea(cAlias)
	Exit
EndDo
dbSelectArea(cAlias)
Return

User Function Exp_Alt()
SetPrvt("NOPCA,CCOD,AAC,CSAVCUR5,CSAVSCR5,CSAVROW5")
SetPrvt("CSAVCOL5,CSAVCOR5,LNIVEL,NUSADO,ACAMPOS,CALIAS")
SetPrvt("NREG,NOPC,")
nOpcA := { "Abandona","Confirma" }
cCod := { "Abandona","Confirma" }
aAC := { "Abandona","Confirma" }
while .T.
	nOpcA:=0
	lNivel := 5
	nUsado  := 0
	aCampos := {}
	aadd(acampos,"CDL_FILIAL")
	aadd(acampos,"CDL_DOC")
	aadd(acampos,"CDL_SERIE")
	aadd(acampos,"CDL_ESPEC")
	aadd(acampos,"CDL_CLIENT")
	aadd(acampos,"CDL_LOJA")
	aadd(acampos,"CDL_UFEMB")
	aadd(acampos,"CDL_LOCEMB")
//	aCampos := {"CDL_DOC"}
	aCampAl := {}
	aadd(acampal,"CDL_FILIAL")
	aadd(acampal,"CDL_DOC")
	aadd(acampal,"CDL_SERIE")
	aadd(acampal,"CDL_ESPEC")
	aadd(acampal,"CDL_CLIENT")
	aadd(acampal,"CDL_LOJA")
	aadd(acampal,"CDL_UFEMB")
	aadd(acampal,"CDL_LOCEMB")
//	aCampAl := {"Z6_DTAQUIS","Z6_DETALHE","Z6_RESP","Z6_ATIVO","Z6_DTBX","Z6_MOTIVO","Z6_COR","Z6_ANO","Z6_CHASSIS","Z6_PROP","Z6_EXEC","Z6_RENAVAN","Z6_IPVADT","Z6_IPVAVLR","Z6_LICDT","Z6_LICVLR","Z6_SEGDT","Z6_SEGVLR"} //,"Z6_","Z6_"}
	cAlias := Alias()
	nReg   := Recno()
	nOpc   := 4
	DBSELECTAREA("CDL")
	nOpcA:=AxAltera("CDL", nReg, nOpc, aCampos, aCampAl)
	dbSelectArea(cAlias)
	Exit
EndDo
dbSelectArea(cAlias)
Return NIL
