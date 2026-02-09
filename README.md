# 🚀 Whaomi-Clean

**Whaomi-Clean** é uma ferramenta de otimização e manutenção de sistema *open-source* para Windows 10 e 11. Desenvolvido em Batch Script (.bat), ele combina comandos nativos do CMD e PowerShell para limpar, reparar e acelerar seu PC com segurança.

## 📋 Funcionalidades

O script oferece um menu interativo com as seguintes opções:

### 🛡️ Segurança & Backup
* **Criar Ponto de Restauração:** Cria um checkpoint do sistema antes de alterações.
* **Backup de Drivers:** Exporta todos os drivers de terceiros para uma pasta (ideal antes de formatar).
* **Backup do Registro:** Salva uma cópia de segurança do `HKEY_LOCAL_MACHINE`.

### 🧹 Limpeza
* **Arquivos Temporários:** Remove lixo do `%temp%`, `Windows\Temp` e `Prefetch`.
* **Lixeira:** Esvazia a lixeira automaticamente via PowerShell.
* **Windows Update:** Limpa backups antigos de atualizações (WinSxS) para liberar espaço.

### ⚡ Otimização
* **Disco:** Executa o `TRIM` em SSDs ou Desfragmentação em HDDs.
* **Sistema:** Verifica e repara arquivos corrompidos do Windows (`SFC` e `DISM`).
* **Energia:** Ativa o plano de energia oculto "Desempenho Máximo".
* **Rede:** Reseta o cache DNS e a pilha TCP/IP para resolver problemas de conexão.

## 📥 Como Baixar e Usar

1. Vá até a aba **[Releases](../../releases)** aqui no GitHub e baixe o arquivo `whaomi-clean.bat`.
2. Ou clique no botão verde **Code** > **Download ZIP**.
3. **Importante:** Clique com o botão direito no arquivo baixado e selecione:
   > **Executar como Administrador**

## ⚠️ Aviso Legal (Disclaimer)

Este software é fornecido "como está", sem garantia de qualquer tipo. Embora os comandos utilizados sejam nativos do Windows e seguros, o autor não se responsabiliza por quaisquer danos ou perda de dados. **Sempre faça um backup ou ponto de restauração antes de executar ferramentas de otimização.**

## 🤝 Contribuição

Sinta-se à vontade para fazer um **Fork** deste projeto, sugerir melhorias via **Issues** ou enviar um **Pull Request**.

---
*Desenvolvido com foco em simplicidade e eficiência.*