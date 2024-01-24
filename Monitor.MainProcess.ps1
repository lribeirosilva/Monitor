# @file: Monitor.MainProcess.ps1
# @comment: Automatizar rotinas de suporte
# @version: 1.0
# @objective: Monitorar processos Main de Sincronia no intervalo de 10 segundos

#Arquivo de log
$log = "C:\Users\Administrador\Desktop\Monitor.log"

#Nome do Processo
$nome_processo_funcionando = "AutoSystem - Sincronização"
$nome_processo_erro = "Erro"

#Arquivo do Processo
$arquivo_processo = "main"

#Tempo de verificacao do processo em segundos
$segundos = 10

#Loop infinito
While( $true ) {

Try {
 
    #Procurar processos de sincronia
    $processos_funcionando = Get-Process $arquivo_processo | Where-Object MainWindowTitle -eq $nome_processo_funcionando
    $processos_erro = Get-Process $arquivo_processo | Where-Object MainWindowTitle -eq $nome_processo_erro
    
    #Verifica se existe processo em execucao
    If( $processos_funcionando.length -gt 0 ) {

        #Registra a sincronia no console
        "<#"
        $agora = Get-Date
        $agora 
        $processos_funcionando | FT StartTime, MainWindowTitle, Id, ProcessName, Responding
        "#>"
    }
    
    If( $processos_erro.length -gt 0 ) {

        #Registra a sincronia no console
        "<#"
        $agora = Get-Date
        $agora 
        $processos_erro | FT StartTime, MainWindowTitle, Id, ProcessName, Responding
        "#>"

        #Encerra processos com janela de Erro
        ForEach( $processo_erro in $processos_erro ) {

            $processo_erro.Kill()

        }
    }

    #Aguardar
    Start-Sleep -Seconds $segundos

} catch {

    #Em caso de erro registrar no arquivo de log
    $agora >> $log
    $processos_funcionando| FT MainWindowTitle, Id, ProcessName, StartTime, Responding >> $log
    $processos_erro | FT MainWindowTitle, Id, ProcessName, StartTime, Responding >> $log

}

}
