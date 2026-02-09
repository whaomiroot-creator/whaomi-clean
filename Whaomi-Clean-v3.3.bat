@echo off
setlocal enabledelayedexpansion
title Whaomi-Clean v3.3 - Ultimate Edition Plus
color 0B
mode con: cols=100 lines=50

:: ====================================================================================
:: CONFIGURAÇÃO DE VERSÃO E ATUALIZAÇÃO (OFICIAL)
:: ====================================================================================
set "versao_atual=3.3"
set "url_versao=https://raw.githubusercontent.com/whaomiroot-creator/whaomi-clean/refs/heads/main/version.txt"
set "url_projeto=https://github.com/whaomiroot-creator/whaomi-clean"
set "log_file=%temp%\WhaomiClean_!date:~-10!_!time:~0,2!!time:~3,2!.log"
:: ====================================================================================

:CHECK_UPDATE
cls
echo [!] Verificando atualizacoes no servidor...
echo [%date% %time%] Iniciando verificacao de versao >> "%log_file%"
curl -s %url_versao% > %temp%\v_online.txt
set /p versao_online=<%temp%\v_online.txt

if "%versao_online%" neq "%versao_atual%" (
    if "%versao_online%" neq "" (
        echo.
        echo ==================================================================
        echo  NOVA VERSAO DISPONIVEL! [%versao_atual%] ^> [%versao_online%]
        echo ==================================================================
        echo  Uma nova versao foi encontrada no GitHub do Whaomiroot.
        echo  Deseja abrir a pagina de download agora? (S/N)
        set /p upd=^> 
        if /i "!upd!"=="S" (
            start %url_projeto%
            echo [%date% %time%] Usuario optou por atualizar via GitHub >> "%log_file%"
            exit
        )
    )
)

:ADMIN_CHECK
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ======================================================
    echo  [ERRO] O Whaomi-Clean PRECISA DE PERMISSOES DE ADMIN
    echo ======================================================
    echo [%date% %time%] Falha: Sem permissoes de administrador >> "%log_file%"
    pause
    exit
)

:WINDOWS_VERSION_CHECK
for /f "tokens=4-5 delims=. " %%i in ('ver') do set "windows_version=%%i.%%j"
echo [%date% %time%] Windows detectado: %windows_version% >> "%log_file%"

:WINGET_CHECK
where winget >nul 2>&1
if errorlevel 1 (
    set "winget_disponivel=0"
    echo [%date% %time%] Winget nao disponivel >> "%log_file%"
) else (
    set "winget_disponivel=1"
    echo [%date% %time%] Winget disponivel >> "%log_file%"
)

:MENU
cls
echo ====================================================================================================
echo                                   WHAOMI-CLEAN v%versao_atual% - ULTIMATE EDITION PLUS
echo ====================================================================================================
echo.
echo  [1]  BACKUP: Ponto de Restauracao, Drivers e Registro
echo  [2]  LIMPEZA: Temporarios, Lixeira, Logs de Eventos e WinSxS
echo  [2B] LIMPEZA AGRESSIVA: Prefetch, Minidumps e Caches Profundos
echo  [3]  REPARO: SFC Scannow, DISM e Verificacao de Disco
echo  [4]  PRIVACIDADE: Bloquear Telemetria e Rastreamento MS
echo  [5]  GAMER MODE: Otimizar Servicos e Plano de Energia
echo  [6]  DEBLOAT: Remover Apps Inuteis (Menu de Intensidade)
echo  [7]  INSTALADOR: Menu de Escolha de Softwares (Winget)
echo  [7B] ATUALIZAR APPS: Winget Upgrade All
echo  [8]  REDE: Resetar Cache DNS e Pilha TCP/IP
echo  [9]  SISTEMA: Ver Chave, Saude do Disco e Bateria
echo  [10] MANUTENCAO: Backup de Perfil e Limpeza de Inicializacao
echo  [11] LOGS: Ver historico de operacoes do Whaomi
echo.
echo  [0]  Sair
echo.
echo ====================================================================================================
echo  [Log salvo em: %log_file%]
echo ====================================================================================================
set /p opcao=Escolha uma categoria: 

if "%opcao%"=="1" goto BACKUP_MENU
if "%opcao%"=="2" goto LIMPEZA
if "%opcao%"=="2B" goto LIMPEZA_AGRESSIVA
if "%opcao%"=="3" goto REPARO
if "%opcao%"=="4" goto PRIVACIDADE
if "%opcao%"=="5" goto GAMER
if "%opcao%"=="6" goto DEBLOAT_MENU
if "%opcao%"=="7" goto APPS_MENU
if "%opcao%"=="7B" goto ATUALIZAR_APPS
if "%opcao%"=="8" goto REDE
if "%opcao%"=="9" goto HARDWARE
if "%opcao%"=="10" goto MANUTENCAO
if "%opcao%"=="11" goto VER_LOGS
if "%opcao%"=="0" (
    echo [%date% %time%] Script finalizado pelo usuario >> "%log_file%"
    exit
)
goto MENU

:: --- CATEGORIAS ---

:BACKUP_MENU
cls
echo [%date% %time%] Menu de Backup iniciado >> "%log_file%"
echo [!] Criando Ponto de Restauracao...
powershell.exe -Command "Checkpoint-Computer -Description 'Whaomi-v3' -RestorePointType 'MODIFY_SETTINGS'" 2>nul
echo [!] Exportando Drivers para C:\Backup_Drivers...
if not exist "C:\Backup_Drivers" mkdir "C:\Backup_Drivers"
dism /online /export-driver /destination:"C:\Backup_Drivers" >nul 2>&1
echo [!] Fazendo Backup do Registro no Desktop...
reg export HKLM "%UserProfile%\Desktop\Whaomi_Registry_HKLM.reg" /y >nul 2>&1
reg export HKCU "%UserProfile%\Desktop\Whaomi_Registry_HKCU.reg" /y >nul 2>&1
echo [OK] Processos de Seguranca Concluidos!
echo [%date% %time%] Backup concluido com sucesso >> "%log_file%"
pause
goto MENU

:LIMPEZA
cls
echo [%date% %time%] Limpeza padrao iniciada >> "%log_file%"
echo [!] Removendo lixo do sistema...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q "%USERPROFILE%\AppData\Local\Temp\*.*" >nul 2>&1
echo [!] Limpando Logs de Eventos do Windows (Event Viewer)...
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (wevtutil.exe cl "%%G" >nul 2>&1)
echo [!] Limpando base de dados do Windows Update (WinSxS)...
dism /online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1
echo [!] Esvaziando Lixeira...
powershell.exe -command "Clear-RecycleBin -Force" >nul 2>&1
echo [OK] Limpeza concluida.
echo [%date% %time%] Limpeza padrao finalizada >> "%log_file%"
pause
goto MENU

:LIMPEZA_AGRESSIVA
cls
echo [%date% %time%] Limpeza agressiva iniciada >> "%log_file%"
echo [!] Aviso: Esta operacao eh mais agressiva!
echo [!] Continuar? (S/N)
set /p conf_agressiva=^> 
if /i not "%conf_agressiva%"=="S" goto MENU

echo [!] Limpando Prefetch (Cache de Programas)...
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1
echo [!] Limpando arquivos de Mini Dump...
del /s /f /q C:\Windows\Minidump\*.* >nul 2>&1
echo [!] Limpando pasta Recent do Usuario...
del /s /f /q "%USERPROFILE%\Recent\*.*" >nul 2>&1
echo [!] Limpando arquivos de cache do navegador (se aplicavel)...
del /s /f /q "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*" >nul 2>&1
del /s /f /q "%USERPROFILE%\AppData\Local\Mozilla\Firefox\Profiles\*\cache2\*.*" >nul 2>&1
echo [!] Limpando Temporary Internet Files...
del /s /f /q "%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache\*.*" >nul 2>&1
echo [OK] Limpeza agressiva concluida.
echo [%date% %time%] Limpeza agressiva finalizada >> "%log_file%"
pause
goto MENU

:REPARO
cls
echo [%date% %time%] Reparo do sistema iniciado >> "%log_file%"
echo [!] Iniciando SFC e DISM (Isso pode demorar 10-20 minutos)...
sfc /scannow >nul 2>&1
dism /online /cleanup-image /restorehealth >nul 2>&1
echo [!] Otimizando unidades...
defrag C: /O /U >nul 2>&1
echo [!] Verificando disco (agendado para proxima reinicializacao)...
chkdsk C: /F /R >nul 2>&1
echo [OK] Reparo finalizado.
echo [%date% %time%] Reparo do sistema finalizado >> "%log_file%"
pause
goto MENU

:PRIVACIDADE
cls
echo [%date% %time%] Bloqueio de telemetria iniciado >> "%log_file%"
echo [!] Desativando Telemetria e Rastreamento...

:: Desativar servicos de telemetria
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
sc stop doSvc >nul 2>&1
sc config doSvc start= disabled >nul 2>&1

:: Politicas de privacidade
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v SyncDesktopItems /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v SyncDocuments /t REG_DWORD /d 0 /f >nul 2>&1

:: Desativar publicidade
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul 2>&1

echo [OK] Sua privacidade foi aumentada.
echo [%date% %time%] Bloqueio de telemetria concluido >> "%log_file%"
pause
goto MENU

:GAMER
cls
echo [%date% %time%] Modo Gamer ativado >> "%log_file%"
echo [!] Ativando Modo Desempenho...

:: Duplicar esquema de desempenho maximo
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: Desativar Game DVR
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1

:: Desativar Xbox Game Bar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: Desativar Captura em segundo plano
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v HistoricalCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1

echo [!] Otimizando servicos de segundo plano...
sc stop Spooler >nul 2>&1
sc config Spooler start= demand >nul 2>&1
sc stop WSearch >nul 2>&1
sc config WSearch start= demand >nul 2>&1

echo [!] Aumentando prioridade de GPU para jogos...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1

echo [OK] Servicos otimizados para jogos.
echo [%date% %time%] Modo Gamer finalizado >> "%log_file%"
pause
goto MENU

:DEBLOAT_MENU
cls
echo [%date% %time%] Menu Debloat acessado >> "%log_file%"
echo =================================================================================
echo           WHAOMI-CLEAN - MENU DE DEBLOAT
echo =================================================================================
echo  Escolha o nivel de remocao de apps:
echo.
echo  [1] Debloat LEVE (Noticias, Clima, Get Help)
echo  [2] Debloat MEDIO (Acima + Maps, Fotos, Groove Music)
echo  [3] Debloat AGRESSIVO (Acima + Xbox, Clipchamp, Photos)
echo  [M] Voltar ao Menu Principal
echo =================================================================================
set /p debloat_choice=Digite sua escolha: 

if /i "%debloat_choice%"=="M" goto MENU
if "%debloat_choice%"=="1" goto DEBLOAT_LEVE
if "%debloat_choice%"=="2" goto DEBLOAT_MEDIO
if "%debloat_choice%"=="3" goto DEBLOAT_AGRESSIVO

goto DEBLOAT_MENU

:DEBLOAT_LEVE
cls
echo [!] Removendo apps leves...
echo [%date% %time%] Debloat leve iniciado >> "%log_file%"
powershell.exe -command "Get-AppxPackage *bingweather* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *gethelp* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo [OK] Debloat leve concluido.
echo [%date% %time%] Debloat leve finalizado >> "%log_file%"
pause
goto DEBLOAT_MENU

:DEBLOAT_MEDIO
cls
echo [!] Removendo apps nivel medio...
echo [%date% %time%] Debloat medio iniciado >> "%log_file%"
powershell.exe -command "Get-AppxPackage *bingweather* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *gethelp* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *maps* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *photos* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *zune* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo [OK] Debloat medio concluido.
echo [%date% %time%] Debloat medio finalizado >> "%log_file%"
pause
goto DEBLOAT_MENU

:DEBLOAT_AGRESSIVO
cls
echo [!] Aviso: Remocao AGRESSIVA de apps!
echo [!] Continuar? (S/N)
set /p conf_debloat=^> 
if /i not "%conf_debloat%"=="S" goto DEBLOAT_MENU

echo [!] Removendo apps agressivamente...
echo [%date% %time%] Debloat agressivo iniciado >> "%log_file%"
powershell.exe -command "Get-AppxPackage *bingweather* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *gethelp* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *maps* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *photos* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *zune* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *xbox* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *clipchamp* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
powershell.exe -command "Get-AppxPackage *feedback* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
echo [OK] Debloat agressivo concluido.
echo [%date% %time%] Debloat agressivo finalizado >> "%log_file%"
pause
goto DEBLOAT_MENU

:APPS_MENU
cls
echo =================================================================================
echo           WHAOMI-CLEAN - MENU DE INSTALACAO MODULAR (v%versao_atual%)
echo =================================================================================

if "%winget_disponivel%"=="0" (
    echo [ERRO] Winget nao foi detectado no sistema!
    echo Para instalar, acesse: https://www.microsoft.com/p/app-installer/9nblggh4nns1
    echo [%date% %time%] Tentativa de uso do menu de apps sem Winget >> "%log_file%"
    pause
    goto MENU
)

echo  Escolha o software para instalar via Winget:
echo.
echo  [1] Google Chrome         [6] Discord
echo  [2] Mozilla Firefox       [7] Steam
echo  [3] 7-Zip (Compactador)   [8] Spotify
echo  [4] VLC Media Player      [9] Visual Studio Code
echo  [5] Notepad++             [10] WhatsApp Desktop
echo  [11] OBS Studio           [12] Git
echo.
echo  [M] Voltar ao Menu Principal
echo =================================================================================
set /p app_choice=Digite o numero da sua escolha: 

if /i "%app_choice%"=="M" goto MENU
if "%app_choice%"=="1" set "app_id=Google.Chrome"
if "%app_choice%"=="2" set "app_id=Mozilla.Firefox"
if "%app_choice%"=="3" set "app_id=7zip.7zip"
if "%app_choice%"=="4" set "app_id=VideoLAN.VLC"
if "%app_choice%"=="5" set "app_id=Notepad++.Notepad++"
if "%app_choice%"=="6" set "app_id=Discord.Discord"
if "%app_choice%"=="7" set "app_id=Valve.Steam"
if "%app_choice%"=="8" set "app_id=Spotify.Spotify"
if "%app_choice%"=="9" set "app_id=Microsoft.VisualStudioCode"
if "%app_choice%"=="10" set "app_id=WhatsApp.WhatsApp"
if "%app_choice%"=="11" set "app_id=OBSProject.OBSStudio"
if "%app_choice%"=="12" set "app_id=Git.Git"

cls
echo [!] Baixando e instalando: %app_id%...
echo [%date% %time%] Instalacao iniciada: %app_id% >> "%log_file%"
winget install --id %app_id% --silent --accept-source-agreements --accept-package-agreements >nul 2>&1

if %errorLevel% == 0 (
    echo [OK] Instalacao de %app_id% concluida!
    echo [%date% %time%] Instalacao concluida com sucesso: %app_id% >> "%log_file%"
) else (
    echo [!] Falha na instalacao ou o app ja esta presente.
    echo [%date% %time%] Falha ou app ja existe: %app_id% >> "%log_file%"
)
pause
goto APPS_MENU

:ATUALIZAR_APPS
cls
echo [%date% %time%] Atualizacao de apps iniciada >> "%log_file%"

if "%winget_disponivel%"=="0" (
    echo [ERRO] Winget nao foi detectado no sistema!
    echo [%date% %time%] Tentativa de upgrade sem Winget >> "%log_file%"
    pause
    goto MENU
)

echo [!] Atualizando todos os apps instalados via Winget...
echo [!] Isto pode levar alguns minutos...
winget upgrade --all --silent --accept-source-agreements --accept-package-agreements >nul 2>&1

echo [OK] Atualizacao de apps concluida!
echo [%date% %time%] Atualizacao de apps finalizada >> "%log_file%"
pause
goto MENU

:REDE
cls
echo [%date% %time%] Operacoes de rede iniciadas >> "%log_file%"
echo [!] Limpando Cache DNS...
ipconfig /flushdns >nul 2>&1
echo [!] Resetando Pilha WINSOCK...
netsh winsock reset >nul 2>&1
echo [!] Resetando Stack TCP/IP...
netsh int ip reset >nul 2>&1
echo [OK] Conexao resetada.
echo [%date% %time%] Operacoes de rede finalizadas >> "%log_file%"
pause
goto MENU

:HARDWARE
cls
echo =================================================================================
echo           INFORMACOES DE HARDWARE E SISTEMA
echo =================================================================================
echo.
echo [1] Ver Chave de Ativacao do Windows (Product Key)
echo [2] Ver Saude do Disco (S.M.A.R.T)
echo [3] Gerar Relatorio de Bateria (Notebooks)
echo [4] Teste de Superficie do Disco (CHKDSK /F /R)
echo [5] Ver Especificacoes do Sistema (RAM, CPU, GPU)
echo.
echo [M] Voltar ao Menu Principal
echo =================================================================================
set /p h_choice=Escolha uma opcao: 

if /i "%h_choice%"=="M" goto MENU
if "%h_choice%"=="1" (
    cls
    echo [!] Tentando recuperar Chave do Windows da BIOS/Firmware...
    wmic path softwarelicensingservice get OA3xOriginalProductKey
    echo.
    echo [!] Tentando recuperar Chave do Registro...
    powershell.exe -command "(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BackupProductKeyDefault"
    echo [%date% %time%] Chave do Windows consultada >> "%log_file%"
    pause
)
if "%h_choice%"=="2" (
    cls
    echo [!] Verificando Status S.M.A.R.T dos Discos...
    wmic diskdrive get status, model, size
    echo [%date% %time%] Status SMART dos discos consultado >> "%log_file%"
    pause
)
if "%h_choice%"=="3" (
    cls
    echo [!] Gerando relatorio de bateria no Desktop...
    powercfg /batteryreport /output "%UserProfile%\Desktop\Saude_Bateria_Whaomi.html"
    echo [OK] Relatorio salvo na Area de Trabalho.
    echo [%date% %time%] Relatorio de bateria gerado >> "%log_file%"
    pause
)
if "%h_choice%"=="4" (
    cls
    echo [!] Aviso: CHKDSK /F /R requer reinicializacao!
    echo [!] Deseja agendar para proxima reinicializacao? (S/N)
    set /p conf_chkdsk=^> 
    if /i "%conf_chkdsk%"=="S" (
        chkdsk C: /F /R >nul 2>&1
        echo [OK] CHKDSK agendado para proxima reinicializacao.
        echo [%date% %time%] CHKDSK agendado >> "%log_file%"
    )
    pause
)
if "%h_choice%"=="5" (
    cls
    echo [!] Especificacoes do Sistema:
    echo.
    wmic os get caption, version, buildnumber
    echo.
    wmic cpu get name, cores, threads, maxclockspeed
    echo.
    wmic logicaldisk get name, size, freespace
    echo.
    powershell.exe -command "Get-WmiObject -Class Win32_VideoController | select Name, AdapterRam, DriverVersion"
    echo [%date% %time%] Especificacoes do sistema consultadas >> "%log_file%"
    pause
)
goto HARDWARE

:MANUTENCAO
cls
echo =================================================================================
echo           MENU DE MANUTENCAO AVANCADA
echo =================================================================================
echo.
echo [1] Backup de Perfil de Usuario (Documentos e Desktop)
echo [2] Limpar Apps de Inicializacao
echo [3] Regenerar Thumbnails do Windows
echo.
echo [M] Voltar ao Menu Principal
echo =================================================================================
set /p maint_choice=Escolha uma opcao: 

if /i "%maint_choice%"=="M" goto MENU

if "%maint_choice%"=="1" (
    cls
    echo [!] Criando backup da pasta do usuario...
    if not exist "C:\Backup_Perfil" mkdir "C:\Backup_Perfil"
    echo [!] Copiando Documentos...
    robocopy "%UserProfile%\Documents" "C:\Backup_Perfil\Documentos" /E /Z >nul 2>&1
    echo [!] Copiando Area de Trabalho...
    robocopy "%UserProfile%\Desktop" "C:\Backup_Perfil\Desktop" /E /Z >nul 2>&1
    echo [!] Copiando Downloads...
    robocopy "%UserProfile%\Downloads" "C:\Backup_Perfil\Downloads" /E /Z >nul 2>&1
    echo [OK] Backup de perfil concluido em C:\Backup_Perfil
    echo [%date% %time%] Backup de perfil realizado >> "%log_file%"
    pause
)

if "%maint_choice%"=="2" (
    cls
    echo [!] Aplicacoes de inicializacao comuns:
    echo [!] Para editar, abra: msconfig (Inicializacao tab)
    echo [!] Ou use o Gerenciador de Tarefas (Ctrl+Shift+Esc)
    echo.
    echo Servicos que consomem muita memoria no startup:
    tasklist /v /fo table
    echo [%date% %time%] Lista de processos de inicializacao exibida >> "%log_file%"
    pause
)

if "%maint_choice%"=="3" (
    cls
    echo [!] Regenerando cache de thumbnails...
    rd /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
    echo [OK] Cache de thumbnails removido. Sera regenerado automaticamente.
    echo [%date% %time%] Cache de thumbnails regenerado >> "%log_file%"
    pause
)

goto MANUTENCAO

:VER_LOGS
cls
echo =================================================================================
echo           HISTORICO DE OPERACOES - WHAOMI-CLEAN
echo =================================================================================
echo.
echo [1] Ver ultimo log
echo [2] Ver todos os logs (diretorio)
echo.
echo [M] Voltar ao Menu Principal
echo =================================================================================
set /p log_choice=Escolha uma opcao: 

if /i "%log_choice%"=="M" goto MENU

if "%log_choice%"=="1" (
    cls
    echo [!] Exibindo logs recentes:
    echo.
    type "%log_file%"
    echo.
)

if "%log_choice%"=="2" (
    cls
    echo [!] Abrindo pasta de logs em Explorer...
    explorer "%temp%"
    echo [!] Procure por arquivos WhaomiClean_*.log
)

pause
goto MENU
