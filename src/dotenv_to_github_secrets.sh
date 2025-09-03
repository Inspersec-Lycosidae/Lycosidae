#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-.env}"                 # Caminho do .env (default: ./.env)
REPO="${2:-}"                         # owner/repo opcional; se vazio, usa repo atual
TARGET="${3:-repo}"                   # repo | env:<NOME_DO_AMBIENTE> | org:<ORG_NAME>

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERRO: arquivo $ENV_FILE não encontrado." >&2
  exit 1
fi

# Obtém owner/repo atual se não foi passado
if [[ -z "$REPO" ]]; then
  REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)"
  if [[ -z "$REPO" ]]; then
    echo "ERRO: rode dentro de um repo ou informe owner/repo como segundo argumento." >&2
    exit 1
  fi
fi

echo "Usando ENV_FILE=$ENV_FILE | REPO=$REPO | TARGET=$TARGET"

# Função que envia um segredo usando gh
set_secret() {
  local key="$1"
  local val="$2"

  case "$TARGET" in
    repo)
      gh secret set "$key" --repo "$REPO" --body "$val" >/dev/null
      ;;
    env:*)
      local env_name="${TARGET#env:}"
      gh secret set "$key" --repo "$REPO" --env "$env_name" --body "$val" >/dev/null
      ;;
    org:*)
      local org_name="${TARGET#org:}"
      gh secret set "$key" --org "$org_name" --body "$val" >/dev/null
      ;;
    *)
      echo "ERRO: TARGET inválido: $TARGET (use repo | env:<NOME> | org:<ORG>)" >&2
      exit 1
      ;;
  esac
  echo "✔ Secret: $key"
}

# Lê o .env linha a linha
# Regras:
# - Ignora linhas em branco e comentários (#)
# - Suporta "export KEY=VAL" e KEY="VAL com espaços"
# - Não interpreta variáveis; copia o valor literal
while IFS= read -r line || [[ -n "$line" ]]; do
  # remove espaços ao redor
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"

  # ignora vazio e comentário
  [[ -z "$line" || "${line:0:1}" == "#" ]] && continue

  # remove prefixo "export " se existir
  [[ "$line" =~ ^export[[:space:]]+ ]] && line="${line#export }"

  # precisa ser KEY=VAL
  if [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
    key="${line%%=*}"
    val="${line#*=}"

    # remove aspas externas se houver (simples ou duplas)
    if [[ "$val" =~ ^\".*\"$ ]]; then
      val="${val:1:${#val}-2}"
    elif [[ "$val" =~ ^\'.*\'$ ]]; then
      val="${val:1:${#val}-2}"
    fi

    # trata \n literais para virar quebra de linha real (suporta multiline)
    val="${val//\\n/
}"

    set_secret "$key" "$val"
  else
    echo "↪ Ignorando linha não compatível com KEY=VAL: $line"
  fi
done < "$ENV_FILE"

echo "✅ Todos os secrets processados."
