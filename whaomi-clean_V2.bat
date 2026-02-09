@echo off
title Otimizador de PC - Versao 2.0 (GitHub Project)
color 0A
mode con: cols=85 lines=40

:: --- VERIFICAR ADMIN ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ======================================================
    echo  [ERRO] ESTE SCRIPT PRECISA DE PERMISSOES DE ADMIN
    echo ======================================================
    echo  Por favor, clique com o botao direito e selecione
    echo  "Executar como Administrador".
    echo.
    pause
    exit
)

:MENU
cls
echo =================================================================================
echo                             OTIMIZADOR DE SISTEMA V2.0
echo =================================================================================
echo.
echo   [SEGURANCA E BACKUP]
echo   [1]  Criar Ponto de Restauracao (Recomendado antes de iniciar)
echo   [2]  Fazer Backup de Todos os Drivers (C:\Backup_Drivers)
echo   [3]  Fazer Backup do Registro (Area de Trabalho)
echo.
echo   [LIMPEZA E MANUTENCAO]
echo   [4]  Limpar Arquivos Temporarios e Lixeira (Basico)
echo   [5]  Limpeza Avancada (WinSxS / Windows Update)
echo   [6]  Otimizar Disco (Defrag/Trim)
echo   [7]  Corrigir Arquivos do Sistema (SFC / DISM)
echo.
echo   [UTILITARIOS E TWEAKS]
echo   [8]  Ativar Plano de Energia "Desempenho Maximo"
echo   [9]  Reiniciar Windows Explorer (Destravar interface)
echo   [10] Gerar Relatorio de Saude da Bateria (Notebooks)
echo   [11] Resetar Rede e Cache DNS
echo.
echo   [0]  Sair
echo.
echo =================================================================================
set /p opcao=Digite o numero da opcao: 

if "%opcao%"=="1" goto RESTOREPOINT
if "%opcao%"=="2" goto DRIVERBACKUP
if "%opcao%"=="3" goto REGBACKUP
if "%opcao%"=="4" goto LIMPEZA
if "%opcao%"=="5" goto UPDATE
if "%opcao%"=="6" goto DISCO
if "%opcao%"=="7" goto SISTEMA
if "%opcao%"=="8" goto POWER
if "%opcao%"=="9" goto EXPLORER
if "%opcao%"=="10" goto BATTERY
if "%opcao%"=="11" goto REDE
if "%opcao%"=="0" exit
goto MENU

:: --- FUNCOES ---

:RESTOREPOINT
cls
echo [!] Criando Ponto de Restauracao do Sistema...
echo     Isso garante que voce possa voltar atras se algo der errado.
powershell.exe -Command "Checkpoint-Computer -Description 'Backup_Antes_Otimizacao' -RestorePointType 'MODIFY_SETTINGS'"
if %errorLevel% == 0 (
    echo [OK] Ponto de restauracao criado com sucesso!
) else (
    echo [ERRO] Nao foi possivel criar. Verifique se a Protecao do Sistema esta ativada.
)
pause
goto MENU

:DRIVERBACKUP
cls
echo [!] Iniciando backup dos drivers...
if not exist "C:\Backup_Drivers" mkdir "C:\Backup_Drivers"
dism /online /export-driver /destination:"C:\Backup_Drivers"
echo.
echo [OK] Drivers salvos em C:\Backup_Drivers
echo      Guarde essa pasta se for formatar o PC!
pause
goto MENU

:REGBACKUP
cls
echo [!] Fazendo backup do Registro do Windows...
reg export HKLM "%UserProfile%\Desktop\Backup_Registro_HKLM.reg" /y
echo.
echo [OK] Backup salvo na sua Area de Trabalho como "Backup_Registro_HKLM.reg".
pause
goto MENU

:LIMPEZA
cls
echo [!] Limpando arquivos temporarios...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1
echo [!] Esvaziando a Lixeira...
powershell.exe -command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
echo [OK] Limpeza concluida.
pause
goto MENU

:UPDATE
cls
echo [!] Limpando backups antigos de atualizacoes do Windows...
echo     Isso pode liberar varios GBs, mas demora um pouco.
dism /online /Cleanup-Image /StartComponentCleanup
echo [OK] Limpeza concluida.
pause
goto MENU

:DISCO
cls
echo [!] Otimizando unidade C:...
defrag C: /O /U /V
echo [OK] Otimizacao concluida.
pause
goto MENU

:SISTEMA
cls
echo [!] Verificando integridade do sistema (Etapa 1/2)...
sfc /scannow
echo [!] Reparando imagem do sistema (Etapa 2/2)...
dism /online /cleanup-image /restorehealth
echo [OK] Verificacoes concluidas.
pause
goto MENU

:POWER
cls
echo [!] Tentando ativar o plano Desempenho Maximo...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
echo.
echo [AVISO] Se apareceu um codigo acima, va em "Opcoes de Energia" no Painel de Controle
echo         e selecione o novo plano criado.
pause
goto MENU

:EXPLORER
cls
echo [!] Reiniciando o Windows Explorer...
taskkill /f /im explorer.exe
start explorer.exe
echo [OK] Interface reiniciada.
pause
goto MENU

:BATTERY
cls
echo [!] Gerando relatorio de bateria...
powercfg /batteryreport /output "%UserProfile%\Desktop\Relatorio_Bateria.html"
echo.
echo [OK] Relatorio salvo na Area de Trabalho: Relatorio_Bateria.html
pause
goto MENU

:REDE
cls
echo [!] Resetando pilha TCP/IP e DNS...
ipconfig /flushdns
ipconfig /release
ipconfig /renew
netsh winsock reset
netsh int ip reset
echo [OK] Rede resetada.
pause
goto MENU