#!/usr/bin/env bash
# Docker + local PostgreSQL for Ubuntu 26.04
set -euo pipefail

echo "==> Installing Docker"
sudo apt update
sudo apt install -y docker.io docker-compose-v2 docker-buildx
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# Docker pulls ignore your shell's proxy_on, so the daemon needs its own setting
if ss -ltn | grep -q '127.0.0.1:10809'; then
  read -rp "Route Docker image pulls through your proxy 127.0.0.1:10809? [y/N] " ans
  if [[ $ans =~ ^[Yy]$ ]]; then
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo tee /etc/systemd/system/docker.service.d/proxy.conf >/dev/null <<'EOF'
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:10809"
Environment="HTTPS_PROXY=http://127.0.0.1:10809"
Environment="NO_PROXY=localhost,127.0.0.1,::1"
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
  fi
fi

echo "==> Installing lazydocker via mise"
mise use -g lazydocker@latest || echo "   lazydocker skipped (try again after proxy_on)"

echo "==> Installing PostgreSQL"
sudo apt install -y postgresql postgresql-client
sudo systemctl enable --now postgresql

# A superuser role + database named after you, so plain `psql` just works
if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$USER'" | grep -q 1; then
  sudo -u postgres createuser --superuser "$USER"
fi
if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$USER'" | grep -q 1; then
  sudo -u postgres createdb -O "$USER" "$USER"
fi

echo
echo "Set a password for '$USER' (needed when apps connect over localhost):"
psql -c '\password'

echo
echo "Done. Log out and back in so docker works without sudo."
