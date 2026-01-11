load_env_downwards_from_dev() {
  local dir="$PWD"
  local root="/"
  local env_files=()

  # 1. 向上收集 .env
  while [ "$dir" != "$root" ]; do
    if [ -f "$dir/.env" ]; then
      env_files+=("$dir/.env")
    fi
    dir="$(dirname "$dir")"
  done

  # 2. 反向加载（远 → 近）
  for (( i=${#env_files[@]}-1; i>=0; i-- )); do
    dotenv "${env_files[i]}"
  done
}

load_env_downwards_from_dev
