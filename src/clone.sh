set -e

# Function to clone or pull a repo
clone_or_pull() {
  repo_url=$1
  repo_name=$(basename "$repo_url" .git)

  if [ -d "$repo_name" ]; then
    echo "Updating $repo_name..."
    cd "$repo_name"
    git pull origin main
    cd ..
  else
    echo "Cloning $repo_name..."
    git clone "$repo_url"
  fi
}

clone_or_pull https://github.com/Inspersec-Lycosidae/Interpreter-Lycosidae.git
clone_or_pull https://github.com/Inspersec-Lycosidae/Backend-Lycosidae.git
clone_or_pull https://github.com/Inspersec-Lycosidae/Orchester-Lycosidae.git
clone_or_pull https://github.com/Inspersec-Lycosidae/Frontend-Lycosidae.git