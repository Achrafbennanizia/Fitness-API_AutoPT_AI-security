#!/usr/bin/env bash
# Bring up one named stack. Prefers Docker Desktop, then Colima.
set -euo pipefail
if [[ -z "${DOCKER_HOST:-}" ]]; then
  if [[ -S "${HOME}/.docker/run/docker.sock" ]]; then
    export DOCKER_HOST="unix://${HOME}/.docker/run/docker.sock"
  else
    export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"
  fi
fi
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSE="docker-compose"

up() {
  local name="$1" dir="$2" override="$3"
  echo "=== $name ==="
  cd "$dir"
  $COMPOSE -f docker-compose.yml -f "$override" up -d --build
}

# Usage: ./lab/scripts/up-one.sh fitnesstrack|fittrackee|workout-cool|opengym|endurain
app="${1:-}"
case "$app" in
  fitnesstrack) $COMPOSE -f "$ROOT/apps/fitnesstrack/docker-compose.yml" -f "$ROOT/overrides/fitnesstrack.yml" up -d --build ;;
  fittrackee) $COMPOSE -f "$ROOT/apps/fittrackee/docker-compose.yml" -f "$ROOT/overrides/fittrackee.yml" up -d ;;
  workout-cool) $COMPOSE -f "$ROOT/apps/workout-cool/docker-compose.yml" -f "$ROOT/overrides/workout-cool.yml" up -d --build ;;
  opengym) $COMPOSE -f "$ROOT/apps/opengym/docker-compose.yml" -f "$ROOT/overrides/opengym.yml" up -d --build ;;
  endurain)
    mkdir -p "$ROOT/apps-data/endurain"/{backend/data,backend/logs,postgres,redis}
    $COMPOSE -f "$ROOT/apps/endurain/docker-compose.yml" -f "$ROOT/overrides/endurain.yml" up -d
    ;;
  *) echo "usage: $0 fitnesstrack|fittrackee|workout-cool|opengym|endurain"; exit 1 ;;
esac
