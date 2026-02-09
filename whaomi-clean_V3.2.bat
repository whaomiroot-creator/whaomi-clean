@echo off
setlocal enabledelayedexpansion
title Whaomi-Clean v3.2 - Ultimate Edition
color 0B
mode con: cols=100 lines=50

:: ====================================================================================
:: CONFIGURAÇÃO DE VERSÃO E ATUALIZAÇÃO (OFICIAL)
:: ====================================================================================
set "versao_atual=3.2"
set "url_versao=https://raw.githubusercontent.com/whaomiroot-creator/whaomi-clean/refs/heads/main/version.txt"
set "url_projeto=https://github.com/whaomiroot-creator/whaomi-clean"
:: ====================================================================================

:CHECK_UPDATE
cls
echo [!] Verificando atualizacoes no servidor...
curl -s %url_versao% > %temp%\v_online.txt
set /p versao_online=<%temp%\v_online.txt

if "%versao_online%" neq "%versao_atual%" (
    if "%versao_online%" neq "" (
        echo.
        echo ==================================================================
        echo  NOVA VERSAO DISPONIVEL! [%versao_atual%] -> [%versao_online%]
        echo ==================================================================
        echo  Uma nova versao foi encontrada no GitHub do Whaomiroot.
        echo  Deseja abrir a pagina de download agora? (S/N)
        set /p upd=^> 
        if /i "!upd!"=="S" (
            start %url_projeto%
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
    pause
    exit
)

:MENU
cls
echo ====================================================================================================
echo                                   WHAOMI-CLEAN v%versao_atual% - ULTIMATE EDITION
echo ====================================================================================================
echo.
echo  [1]  BACKUP: Ponto de Restauracao, Drivers e Registro
echo  [2]  LIMPEZA: Temporarios, Lixeira, Logs de Eventos e WinSxS
echo  [3]  REPARO: SFC Scannow, DISM e Verificacao de Disco
echo  [4]  PRIVACIDADE: Bloquear Telemetria e Rastreamento MS
echo  [5]  GAMER MODE: Otimizar Servicos e Plano de Energia
echo  [6]  DEBLOAT: Remover Apps Inuteis (Clima, Noticias, etc)
echo  [7]  INSTALADOR: Menu de Escolha de Softwares (Winget)
echo  [8]  REDE: Resetar Cache DNS e Pilha TCP/IP
echo  [9]  SISTEMA: Ver Chave (Key) do Windows, Saude do Disco e Bateria
echo.
echo  [0]  Sair
echo.
echo ====================================================================================================
set /p opcao=Escolha uma categoria: 

if "%opcao%"=="1" goto BACKUP_MENU
if "%opcao%"=="2" goto LIMPEZA
if "%opcao%"=="3" goto REPARO
if "%opcao%"=="4" goto PRIVACIDADE
if "%opcao%"=="5" goto GAMER
if "%opcao%"=="6" goto DEBLOAT
if "%opcao%"=="7" goto APPS_MENU
if "%opcao%"=="8" goto REDE
if "%opcao%"=="9" goto HARDWARE
if "%opcao%"=="0" exit
goto MENU

:: --- CATEGORIAS ---

:BACKUP_MENU
cls
echo [!] Criando Ponto de Restauracao...
powershell.exe -Command "Checkpoint-Computer -Description 'Whaomi-v3' -RestorePointType 'MODIFY_SETTINGS'"
echo [!] Exportando Drivers para C:\Backup_Drivers...
if not exist "C:\Backup_Drivers" mkdir "C:\Backup_Drivers"
dism /online /export-driver /destination:"C:\Backup_Drivers"
echo [!] Fazendo Backup do Registro no Desktop...
reg export HKLM "%UserProfile%\Desktop\Whaomi_Registry.reg" /y
echo [OK] Processos de Seguranca Concluidos!
pause
goto MENU

:LIMPEZA
cls
echo [!] Removendo lixo do sistema...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
powershell.exe -command "Clear-RecycleBin -Force"
echo [!] Limpando Logs de Eventos do Windows (Event Viewer)...
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (wevtutil.exe cl "%%G")
echo [!] Limpando base de dados do Windows Update (WinSxS)...
dism /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo [OK] Limpeza concluida.
pause
goto MENU

:REPARO
cls
echo [!] Iniciando SFC e DISM (Isso pode demorar)...
sfc /scannow
dism /online /cleanup-image /restorehealth
echo [!] Otimizando unidades...
defrag C: /O /U
echo [OK] Reparo finalizado.
pause
goto MENU

:PRIVACIDADE
cls
echo [!] Desativando Telemetria e Rastreamento...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
echo [OK] Sua privacidade foi aumentada.
pause
goto MENU

:GAMER
cls
echo [!] Ativando Modo Desempenho...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
echo [!] Otimizando servicos de segundo plano...
sc stop Spooler >nul 2>&1
sc config Spooler start= demand >nul 2>&1
echo [OK] Servicos otimizados para jogos.
pause
goto MENU

:DEBLOAT
cls
echo [!] Removendo Apps nativos desnecessarios...
powershell.exe -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
powershell.exe -command "Get-AppxPackage *gethelp* | Remove-AppxPackage"
powershell.exe -command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
echo [OK] Debloat concluido.
pause
goto MENU

:APPS_MENU
cls
echo =================================================================================
echo           WHAOMI-CLEAN - MENU DE INSTALACAO MODULAR
echo =================================================================================
echo  Escolha o software para instalar via Winget:
echo.
echo  [1] Google Chrome         [6] Discord
echo  [2] Mozilla Firefox       [7] Steam
echo  [3] 7-Zip (Compactador)   [8] Spotify
echo  [4] VLC Media Player      [9] Visual Studio Code
echo  [5] Notepad++             [10] WhatsApp Desktop
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

cls
echo [!] Baixando e instalando: %app_id%...
winget install --id %app_id% --silent --accept-source-agreements --accept-package-agreements
if %errorLevel% == 0 (
    echo [OK] Instalacao de %app_id% concluida!
) else (
    echo [!] Falha na instalacao ou o app ja esta presente.
)
pause
goto APPS_MENU

:REDE
cls
echo [!] Flush DNS e Reset de IP...
ipconfig /flushdns
netsh winsock reset
netsh int ip reset
echo [OK] Conexao resetada.
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
echo.
echo [M] Voltar ao Menu Principal
echo =================================================================================
set /p h_choice=Escolha uma opcao: 

if /i "%h_choice%"=="M" goto MENU
if "%h_choice%"=="1" (
    cls
    echo [!] Tentando recuperar Chave do Windows da BIOS/Firmware...
    wmic path softwarelicensingservice get OA3xOriginalProductKey
    echo [!] Tentando recuperar Chave do Registro...
    powershell.exe -command "(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BackupProductKeyDefault"
    pause
)
if "%h_choice%"=="2" (
    cls
    echo [!] Verificando Status S.M.A.R.T dos Discos...
    wmic diskdrive get status, model
    pause
)
if "%h_choice%"=="3" (
    cls
    echo [!] Gerando relatorio de bateria no Desktop...
    powercfg /batteryreport /output "%UserProfile%\Desktop\Saude_Bateria_Whaomi.html"
    echo [OK] Relatorio salvo na Area de Trabalho como Saude_Bateria_Whaomi.html.
    pause
)
goto HARDWARE
