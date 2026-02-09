@echo off
setlocal enabledelayedexpansion
title Whaomi-Clean v2.1 - Turbo Edition + AutoUpdate
color 0B
mode con: cols=90 lines=45

:: ==========================================
:: CONFIGURAÇÃO DE VERSÃO E ATUALIZAÇÃO
:: ==========================================
set "versao_atual=2.1"
:: IMPORTANTE: Substitua o link abaixo pelo seu link RAW do version.txt no GitHub
set "url_versao=https://raw.githubusercontent.com/whaomiroot-creator/whaomi-clean/refs/heads/main/version.txt"
:: ==========================================

:CHECK_UPDATE
cls
echo [!] Verificando atualizacoes...
:: O comando curl baixa o texto da versão online silenciosamente
curl -s %url_versao% > %temp%\v_online.txt
set /p versao_online=<%temp%\v_online.txt

if "%versao_online%" neq "%versao_atual%" (
    if "%versao_online%" neq "" (
        echo.
        echo ======================================================
        echo  NOVA ATUALIZACAO DISPONIVEL! (%versao_atual% -^> %versao_online%)
        echo ======================================================
        echo  Deseja ir para o GitHub baixar a nova versao? (S/N)
        set /p upd=^> 
        if /i "!upd!"=="S" (
            start https://github.com/whaomiroot-creator/whaomi-clean
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
echo =================================================================================
echo           WHAOMI-CLEAN v%versao_atual% - Otimizacao Completa e Auto-Update
echo =================================================================================
echo.
echo  [1]  BACKUP: Ponto de Restauracao, Drivers e Registro
echo  [2]  LIMPEZA: Temporarios, Lixeira e Windows Update (WinSxS)
echo  [3]  REPARO: SFC Scannow, DISM e Verificacao de Disco
echo  [4]  PRIVACIDADE: Bloquear Telemetria e Rastreamento MS
echo  [5]  GAMER MODE: Otimizar Servicos e Plano de Energia
echo  [6]  DEBLOAT: Remover Apps Inuteis (Clima, Noticias, etc)
echo  [7]  INSTALADOR: Softwares Essenciais (Chrome, 7Zip, VLC)
echo  [8]  REDE: Resetar Cache DNS e Pilha TCP/IP
echo  [9]  HARDWARE: Ver Saude do Disco (S.M.A.R.T) e Bateria
echo.
echo  [0]  Sair
echo.
echo =================================================================================
set /p opcao=Escolha uma categoria: 

if "%opcao%"=="1" goto BACKUP_MENU
if "%opcao%"=="2" goto LIMPEZA
if "%opcao%"=="3" goto REPARO
if "%opcao%"=="4" goto PRIVACIDADE
if "%opcao%"=="5" goto GAMER
if "%opcao%"=="6" goto DEBLOAT
if "%opcao%"=="7" goto WINGET
if "%opcao%"=="8" goto REDE
if "%opcao%"=="9" goto HARDWARE
if "%opcao%"=="0" exit
goto MENU

:: --- FUNÇÕES ---

:BACKUP_MENU
cls
echo [!] Criando Ponto de Restauracao...
powershell.exe -Command "Checkpoint-Computer -Description 'Whaomi-v2' -RestorePointType 'MODIFY_SETTINGS'"
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
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
echo [OK] Sua privacidade foi aumentada.
pause
goto MENU

:GAMER
cls
echo [!] Ativando Modo Desempenho...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
echo [!] Otimizando servicos...
sc stop Spooler >nul 2>&1
echo [INFO] Servicos desnecessarios pausados.
pause
goto MENU

:DEBLOAT
cls
echo [!] Removendo Apps inúteis...
powershell.exe -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
powershell.exe -command "Get-AppxPackage *gethelp* | Remove-AppxPackage"
echo [OK] Debloat concluido.
pause
goto MENU

:WINGET
cls
echo [!] Instalando apps essenciais...
winget install --id Google.Chrome --silent
winget install --id 7zip.7zip --silent
echo [OK] Instalacao finalizada.
pause
goto MENU

:REDE
cls
echo [!] Resetando conexao...
ipconfig /flushdns
netsh winsock reset
echo [OK] Rede resetada.
pause
goto MENU

:HARDWARE
cls
echo [!] Status do Disco:
wmic diskdrive get status, model
pause
goto MENU


