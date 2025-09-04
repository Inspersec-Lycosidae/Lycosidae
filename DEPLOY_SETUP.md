# 🚀 GitHub Actions - Deploy Automático Lycosidae

## ✅ **Implementação Concluída**

Criei workflows GitHub Actions para **todos os repositórios** do projeto:

### 📁 **Estrutura de Workflows:**

```
Lycosidae/ (repositório principal)
├── .github/workflows/deploy.yml          ← NOVO
├── src/
│   ├── Frontend-Lycosidae/
│   │   └── .github/workflows/deploy.yml  ← NOVO
│   ├── Backend-Lycosidae/
│   │   └── .github/workflows/deploy.yml  ← NOVO
│   ├── Interpreter-Lycosidae/
│   │   └── .github/workflows/deploy.yml  ← NOVO
│   └── Orchester-Lycosidae/
│       └── .github/workflows/deploy.yml  ← NOVO
```

## 🎯 **Como Funciona**

Cada workflow:
1. **Executa automaticamente** quando houver commit em `main` ou `develop`
2. **Conecta na VPS** via SSH usando as credenciais configuradas
3. **Atualiza o repositório principal** com `git pull origin main`
4. **Executa seu script** `deploy.sh` (sem modificações)
5. **Rebuilda e reinicia** todos os serviços

## 🔐 **Configuração Necessária**

### 1. Secrets no GitHub

Para **cada repositório** (incluindo o principal), configure:

1. Vá em **Settings** → **Secrets and variables** → **Actions**
2. Clique em **New repository secret**
3. Adicione:

```
VPS_HOST = seu-ip-da-vps.com
VPS_USERNAME = root
VPS_SSH_KEY = sua-chave-privada-ssh
```

### 2. Gerar Chave SSH (se necessário)

```bash
# Na VPS
ssh-keygen -t rsa -b 4096 -C "github-actions@lycosidae" -f ~/.ssh/github_actions
cat ~/.ssh/github_actions.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/github_actions  # Copie para VPS_SSH_KEY
```

## 🧪 **Testando**

### Teste Manual:
1. Vá em **Actions** de qualquer repositório
2. Clique no workflow "Deploy [Nome]"
3. Clique em **Run workflow**

### Teste com Commit:
1. Faça uma mudança em qualquer repositório
2. Commit e push
3. Verifique se o workflow executa automaticamente

## 📊 **Repositórios com Workflow:**

- ✅ **Lycosidae** (principal) → Deploy Lycosidae Main
- ✅ **Frontend-Lycosidae** → Deploy Frontend
- ✅ **Backend-Lycosidae** → Deploy Backend
- ✅ **Interpreter-Lycosidae** → Deploy Interpreter
- ✅ **Orchester-Lycosidae** → Deploy Orchester

## ⚡ **Vantagens**

✅ **Deploy automático** - qualquer commit executa o deploy  
✅ **Funciona para toda a equipe** - cada dev pode fazer commit em qualquer repo  
✅ **Script original preservado** - seu `deploy.sh` não foi modificado  
✅ **Logs detalhados** - fácil de debugar problemas  
✅ **Execução independente** - cada serviço tem seu próprio workflow  
✅ **Repositório principal incluído** - mudanças na raiz também executam deploy  

## 🔄 **Próximos Passos**

1. **Configure os secrets** em todos os repositórios
2. **Teste com um commit** em qualquer repositório
3. **Verifique os logs** para confirmar que está funcionando
4. **Compartilhe com a equipe** - todos podem fazer commit normalmente

---

**Status**: ✅ **Pronto para uso!** Apenas configure os secrets e teste.
