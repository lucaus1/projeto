#INCLUDE "rwmake.ch"
#include 'Ap5Mail.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO6     º Autor ³ AP6 IDE            º Data ³  05/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SIGACFG
Local cServer   := GETMV("MV_RELSERV")    
Local cAccount  := GETMV("MV_RELACNT")
Local cEnvia    := GETMV("MV_RELACNT")
Local cCopia    := "diretoria@potencial.inf.br"
Local cPassword := GETMV("MV_RELPSW")
Local aFiles    := {}
Local nI        := 1
Local cMensagem := 'Acesso ao Configurador !!'
Local cTos
Local CRLF      := Chr(13) + Chr(10)                                   
Local cAnexos   := SC7->C7_NUM
Local lConectou := .F. 
Local cRecebe   := "diretoria@potencial.inf.br"

// Alert(cUsuario) 
// Alert(substr(cUsuario,7,11)) 
cIP := GetClientIP()       
cEmpresa := LEFT(SM0->M0_NOMECOM,10)                                   
cMensagem := " Registro de acesso ao configurador "+cEmpresa+CRLF+" Login: "+substr(cUsuario,7,11)+CRLF+"Computador: "+ComputerName()+CRLF+" Usuario: "+substr(cUsuario,7,11)+CRLF+" IP:"+cIP 
  
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
MAILAUTh(cAccount,cPassword) //caso servidor de email precisar de autenticação utilizar esta função

If lConectou
 //   MsgInfo("Teste com sucesso de Conexao com servidor de E-Mail - " + cServer,"Atenção...")
Endif

If lConectou
  SEND MAIL FROM cEnvia;
          TO cRecebe;
          Cc cCopia;
          SUBJECT cEmpresa+' Acesso ao Configurador ! ';
          BODY cMensagem;
          RESULT lEnviado
 If lEnviado
  //   MsgInfo("E-mail enviado com sucesso! para: "+cCopia+";"+cRecebe,"Atenção...")
 Else
     cMensagem := ""
     GET MAIL ERROR cMensagem 
     Alert(cMensagem)
 Endif
   
 DISCONNECT SMTP SERVER Result lDisConectou

 If lDisConectou
    // Alert("Desconectado com servidor de E-Mail - " + cServer)
 Endif
Else                               

     Alert("Erro na conexao com servidor de E-Mail - " + cServer)

Endif

Return
