@echo off
title Otimizador de PC - Open Source Project
color 0A

:: --- VERIFICAR ADMIN ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ======================================================
    echo  ERRO: ESTE SCRIPT PRECISA DE PERMISSOES DE ADMIN
    echo  Por favor, clique com o botao direito e selecione
    echo  "Executar como Administrador".
    echo ======================================================
    pause
    exit
)

:MENU
cls
echo ======================================================
echo           OTIMIZADOR DE SISTEMA V1.0
echo ======================================================
echo.
echo  [1] Limpar Arquivos Temporarios e Lixeira
echo  [2] Otimizar Disco (TRIM para SSD / Defrag para HDD)
echo  [3] Corrigir Arquivos do Sistema (SFC e DISM)
echo  [4] Resetar Rede e DNS
echo  [5] Limpeza do Windows Update (WinSxS)
echo  [6] Agendar CHKDSK (Requer Reinicializacao)
echo  [0] Sair
echo.
echo ======================================================
set /p opcao=Escolha uma opcao: 

if "%opcao%"=="1" goto LIMPEZA
if "%opcao%"=="2" goto DISCO
if "%opcao%"=="3" goto SISTEMA
if "%opcao%"=="4" goto REDE
if "%opcao%"=="5" goto UPDATE
if "%opcao%"=="6" goto CHKDSK
if "%opcao%"=="0" exit
goto MENU

:LIMPEZA
cls
echo [!] Limpando arquivos temporarios...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1
echo [!] Limpando Lixeira...
powershell.exe -command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
echo [OK] Limpeza concluida.
pause
goto MENU

:DISCO
cls
echo [!] Otimizando unidade C:...
echo     Isso pode demorar alguns minutos.
defrag C: /O /U /V
echo [OK] Otimizacao concluida.
pause
goto MENU

:SISTEMA
cls
echo [!] Verificando integridade do sistema (SFC)...
sfc /scannow
echo [!] Verificando imagem do sistema (DISM)...
dism /online /cleanup-image /restorehealth
echo [OK] Verificacoes concluidas.
pause
goto MENU

:REDE
cls
echo [!] Resetando configuracoes de rede...
ipconfig /flushdns
ipconfig /release
ipconfig /renew
netsh winsock reset
echo [OK] Rede resetada.
pause
goto MENU

:UPDATE
cls
echo [!] Limpando backups antigos de atualizacoes...
dism /online /Cleanup-Image /StartComponentCleanup
echo [OK] Limpeza concluida.
pause
goto MENU

:CHKDSK
cls
echo [ATENCAO] O CHKDSK requer que o PC seja reiniciado.
echo O Windows verificara o disco durante o proximo boot.
set /p resp=Deseja agendar agora? (S/N): 
if /i "%resp%"=="S" (
    echo y | chkdsk C: /f /r
    echo [OK] Agendado. Reinicie o PC para iniciar.
)
pause
goto MENU