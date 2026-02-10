<div align="center">
  <img src="banner.png" alt="Whaomi-Clean v3.3 Banner" width="100%"/>

  # 🚀 Whaomi-Clean v3.3 - Ultimate Edition Plus
  
  **A ferramenta definitiva de otimização, manutenção e privacidade para Windows 10 e 11.**
  
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  [![Windows](https://img.shields.io/badge/OS-Windows%2010%2F11-blue)](https://www.microsoft.com/windows)
  [![Version](https://img.shields.io/badge/Version-3.3%20Stable-green)](https://github.com/whaomiroot-creator/whaomi-clean/releases)
  [![Script](https://img.shields.io/badge/Script-Batch-lightgrey)](https://github.com/whaomiroot-creator/whaomi-clean)
</div>

---

## 🌟 O que há de novo na v3.3?

A versão **Ultimate Edition Plus** traz uma interface interativa profissional totalmente em Batch Script (.bat), combinando o poder do **CMD, PowerShell e Winget**. Agora com **11 categorias especializadas**, **animação de inicialização** e **sistema de logs automatizado**.

### ✨ Destaques da Versão

- 🎨 **Interface Profissional**: Animação de carregamento suave com transição de cores
- 📊 **Barra de Progresso**: Feedback visual durante a inicialização (0-100%)
- 🔄 **Auto-Update**: Verificação automática de novas versões no GitHub
- 📝 **Sistema de Logs**: Histórico completo de todas as operações em `%temp%`
- 🎯 **ASCII Art Moderno**: Design limpo e compatível com qualquer terminal Windows

---

## 🛠️ Funcionalidades Principais

<table>
  <tr>
    <th width="20%">Categoria</th>
    <th width="80%">Descrição</th>
  </tr>
  <tr>
    <td><b>🛡️ BACKUP</b></td>
    <td>Criação automática de Pontos de Restauração + Exportação completa de Drivers (C:\Backup_Drivers) + Backup do Registro (HKLM/HKCU) salvo na Área de Trabalho.</td>
  </tr>
  <tr>
    <td><b>🧹 LIMPEZA</b></td>
    <td><b>Padrão:</b> Remove temporários (%temp%, Windows\Temp), limpa logs de eventos e executa limpeza WinSxS com DISM.<br><b>Agressiva [2B]:</b> Adiciona remoção de Prefetch, Minidumps, cache de navegadores e arquivos Recent.</td>
  </tr>
  <tr>
    <td><b>🔧 REPARO</b></td>
    <td>Execução completa de <code>SFC /scannow</code>, <code>DISM /RestoreHealth</code>, otimização de disco e agendamento de <code>CHKDSK /F /R</code> para próxima reinicialização.</td>
  </tr>
  <tr>
    <td><b>🛡️ PRIVACIDADE</b></td>
    <td>Desativa serviços de telemetria (DiagTrack, dmwappushservice), bloqueia coleta de dados via registro e remove sincronização invasiva do Windows.</td>
  </tr>
  <tr>
    <td><b>🎮 GAMER MODE</b></td>
    <td>Ativa plano de energia de alto desempenho oculto, desativa Game DVR/Xbox Game Bar, otimiza serviços em segundo plano (Spooler, Windows Search) e aumenta prioridade de GPU.</td>
  </tr>
  <tr>
    <td><b>📱 DEBLOAT</b></td>
    <td><b>3 Níveis de Intensidade:</b><br>• Leve (clima, notícias)<br>• Médio (+Maps, Fotos, Groove)<br>• Agressivo (+Xbox, Clipchamp, Feedback)</td>
  </tr>
  <tr>
    <td><b>📦 INSTALADOR</b></td>
    <td><b>12 Apps via Winget:</b> Chrome, Firefox, 7-Zip, VLC, Notepad++, Discord, Steam, Spotify, VS Code, WhatsApp, OBS Studio, Git.<br><b>[7B]</b> Atualiza todos os apps instalados automaticamente.</td>
  </tr>
  <tr>
    <td><b>🌐 REDE</b></td>
    <td>Reset completo: <code>ipconfig /flushdns</code>, <code>netsh winsock reset</code> e <code>netsh int ip reset</code> para resolver problemas de conexão.</td>
  </tr>
  <tr>
    <td><b>💻 SISTEMA</b></td>
    <td>Ferramentas de diagnóstico: recuperar chave do Windows (BIOS/Registro), verificar saúde do disco (S.M.A.R.T), gerar relatório de bateria, agendar CHKDSK e listar especificações completas.</td>
  </tr>
  <tr>
    <td><b>🛠️ MANUTENÇÃO</b></td>
    <td>Backup de perfil de usuário (Documentos/Desktop/Downloads), visualização de apps de inicialização e regeneração de cache de thumbnails.</td>
  </tr>
  <tr>
    <td><b>📊 LOGS</b></td>
    <td>Visualização do histórico de operações com timestamp completo de cada ação executada pelo script.</td>
  </tr>
</table>

---

## 📊 Menu Interativo

O script apresenta um painel organizado e intuitivo:

```text
====================================================================================================================
                                 #     # #     #    #     #####  #     # ###       #####  #       #######    #    #    # 
                                 #     # #     #   # #   #     # ##   ##  #       #     # #       #         # #   ##   # 
                                 #     # #     #  #   #  #     # # # # #  #       #       #       #        #   #  # #  # 
                                 #  #  # ####### #     # #     # #  #  #  #  ###  #       #       #####   #     # #  # # 
                                 #  #  # #     # ####### #     # #     #  #       #       #       #       ####### #   ## 
                                  ## ##  #     # #     # #     # #     #  #       #     # #       #       #     # #    # 
                                   ###   #     # #     #  #####  #     # ###       #####  ####### ####### #     # #    # 
====================================================================================================================
                                              v3.3 - ULTIMATE EDITION PLUS
====================================================================================================================

   BACKUP: Ponto de Restauracao, Drivers e Registro[1]
   LIMPEZA: Temporarios, Lixeira, Logs de Eventos e WinSxS[2]
 [2B] LIMPEZA AGRESSIVA: Prefetch, Minidumps e Caches Profundos
   REPARO: SFC Scannow, DISM e Verificacao de Disco[3]
   PRIVACIDADE: Bloquear Telemetria e Rastreamento MS[4]
   GAMER MODE: Otimizar Servicos e Plano de Energia[5]
   DEBLOAT: Remover Apps Inuteis (Menu de Intensidade)[6]
   INSTALADOR: Menu de Escolha de Softwares (Winget)[7]
 [7B] ATUALIZAR APPS: Winget Upgrade All
   REDE: Resetar Cache DNS e Pilha TCP/IP[8]
   SISTEMA: Ver Chave, Saude do Disco e Bateria[9]
  MANUTENCAO: Backup de Perfil e Limpeza de Inicializacao[10]
  LOGS: Ver historico de operacoes do Whaomi[11]

   Sair
