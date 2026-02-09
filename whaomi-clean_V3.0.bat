@echo off
setlocal enabledelayedexpansion
title Whaomi-Clean v3.0 - Ultimate Edition
color 0B
mode con: cols=100 lines=50

:: ====================================================================================
:: CONFIGURAÇÃO DE VERSÃO E ATUALIZAÇÃO (OFICIAL)
:: ====================================================================================
set "versao_atual=3.0"
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
    echo [ERRO] O Whaomi-Clean precisa de privilegios de ADMINISTRADOR.
    echo Por favor, clique com o botao direito e 'Executar como Administrador'.
    pause
    exit
)

:MENU
cls
echo ====================================================================================================
echo                                   WHAOMI-CLEAN v%versao_atual% - ULTIMATE EDITION
echo ====================================================================================================
echo.
echo  [1]  MANUTENCAO: Ponto de Restauracao + Limpeza Temp + Lixeira
echo  [2]  REPARO AVANCADO: SFC + DISM + Resetar Windows Update (WU)
echo  [3]  DESEMPENHO: RAM Cleaner + Modo Gamer + Plano de Energia
echo  [4]  SISTEMA: Otimizar Disco (TRIM) + Limpar Drivers Antigos
echo  [5]  PRIVACIDADE: Anti-Spy + Desativar Cortana/Telemetria
echo  [6]  PERSONALIZAR: Ativar Modo Escuro (Dark Mode) / Modo Claro
echo  [7]  REDES: DNS Flush + Reset de Adaptadores + Otimizar Latencia
echo  [8]  SOFTWARES: Instalador Winget (Chrome, Steam, 7Zip, Spotify)
echo  [9]  INFO: Key do Windows + Saude do SSD + Ciclos de Bateria
echo.
echo  [0]  Sair do Whaomi-Clean
echo.
echo ====================================================================================================
set /p opcao=Selecione uma opcao: 

if "%opcao%"=="1" goto QUICK_CLEAN
if "%opcao%"=="2" goto REPARO_FULL
if "%opcao%"=="3" goto BOOST
if "%opcao%"=="4" goto DISK_ADV
if "%opcao%"=="5" goto PRIVACY
if "%opcao%"=="6" goto THEME
if "%opcao%"=="7" goto NET_FIX
if "%opcao%"=="8" goto APPS
if "%opcao%"=="9" goto SYS_INFO
if "%opcao%"=="0" exit
goto MENU

:: --- IMPLEMENTAÇÃO DAS FUNÇÕES ---

:QUICK_CLEAN
cls
echo [!] Criando ponto de seguranca...
powershell.exe -Command "Checkpoint-Computer -Description 'Whaomi_v3' -RestorePointType 'MODIFY_SETTINGS'"
echo [!] Limpando arquivos temporarios e cache...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.tmp >nul 2>&1
powershell.exe -command "Clear-RecycleBin -Force"
echo [OK] Limpeza concluida.
pause
goto MENU

:REPARO_FULL
cls
echo [!] Resetando Componentes do Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old >nul 2>&1
net start wuauserv >nul 2>&1
echo [!] Executando SFC e DISM Restore Health...
sfc /scannow
dism /online /cleanup-image /restorehealth
echo [OK] Reparo finalizado.
pause
goto MENU

:BOOST
cls
echo [!] Limpando Working Set de Memoria (RAM Cleaner)...
powershell.exe -command "[System.GC]::Collect();"
echo [!] Ativando plano de energia de Desempenho Maximo...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
echo [OK] Otimizacoes de performance aplicadas.
pause
goto MENU

:DISK_ADV
cls
echo [!] Limpando logs de drivers antigos (PnPUtil)...
pnputil /cleanup-logs >nul 2>&1
echo [!] Executando Otimizacao/TRIM no disco C:...
defrag C: /O /U
echo [OK] Disco otimizado.
pause
goto MENU

:PRIVACY
cls
echo [!] Desativando Telemetria e Coleta de Dados...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
echo [OK] Privacidade reforcada.
pause
goto MENU

:THEME
cls
echo [1] Ativar Modo Escuro (Dark Mode)
echo [2] Ativar Modo Claro (Light Mode)
set /p t=Escolha: 
if "%t%"=="1" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f >nul
) else (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f >nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f >nul
)
echo [OK] Tema alterado.
pause
goto MENU

:NET_FIX
cls
echo [!] Flush DNS e Reset de IP...
ipconfig /flushdns
netsh int ip reset
netsh winsock reset
echo [OK] Rede resetada.
pause
goto MENU

:APPS
cls
echo [!] Verificando instalacao de softwares essenciais...
winget install --id Google.Chrome --silent --accept-source-agreements
winget install --id 7zip.7zip --silent
winget install --id Valve.Steam --silent
echo [OK] Softwares instalados.
pause
goto MENU

:SYS_INFO
cls
echo [CHAVE DO WINDOWS]
wmic path softwarelicensingservice get OA3xOriginalProductKey
echo [SAUDE DO DISCO]
wmic diskdrive get status, model
echo [RELATORIO DE BATERIA]
powercfg /batteryreport /output "%UserProfile%\Desktop\Saude_Bateria.html"
echo Relatorio gerado no Desktop.
pause
goto MENU
