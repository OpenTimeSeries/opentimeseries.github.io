#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BUNDLER_VERSION="${BUNDLER_VERSION:-2.4.22}"
MODE="${1:-serve}"
PORT="${PORT:-4000}"
LIVE_RELOAD_PORT="${LIVE_RELOAD_PORT:-35729}"

# Keep gems inside the project to avoid system Ruby permission issues.
export GEM_HOME="${GEM_HOME:-$ROOT_DIR/.gem}"
export GEM_PATH="${GEM_HOME}"
export PATH="$GEM_HOME/bin:$PATH"

run_bundle() {
  bundle "_${BUNDLER_VERSION}_" "$@"
}

if ! gem list -i bundler -v "$BUNDLER_VERSION" >/dev/null 2>&1; then
  echo "Installing bundler $BUNDLER_VERSION ..."
  gem install bundler -v "$BUNDLER_VERSION" --no-document --install-dir "$GEM_HOME"
fi

echo "Configuring bundle path: vendor/bundle"
run_bundle config set --local path vendor/bundle

echo "Installing dependencies ..."
run_bundle install

case "$MODE" in
  serve)
    echo "Starting Jekyll server at http://127.0.0.1:$PORT"
    run_bundle exec jekyll serve -H 0.0.0.0 --port "$PORT"
    ;;
  serve-live)
    echo "Starting Jekyll server with live reload at http://127.0.0.1:$PORT"
    run_bundle exec jekyll serve -H 0.0.0.0 --port "$PORT" -l --livereload-port "$LIVE_RELOAD_PORT"
    ;;
  build)
    echo "Building site ..."
    run_bundle exec jekyll build
    ;;
  *)
    echo "Unknown mode: $MODE"
    echo "Usage: script/dev.sh [serve|serve-live|build]"
    exit 1
    ;;
esac
