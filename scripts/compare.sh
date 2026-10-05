#!/usr/bin/env bash
set -euo pipefail

OUT=docs/comparison.md
mkdir -p docs

size_mb() { docker image inspect "$1" --format '{{.Size}}' | awk '{printf "%.2f", $1/1024/1024}'; }
layers()  { docker image inspect "$1" --format '{{len .RootFS.Layers}}'; }
user()    { docker image inspect "$1" --format '{{if .Config.User}}{{.Config.User}}{{else}}root{{end}}'; }
digest()  { docker image inspect "$1" --format '{{join .RepoDigests ", "}}' 2>/dev/null | grep . || echo "n/a"; }
has_file() { grep -qx "$2" "/tmp/$1.files" && echo yes || echo no; }

# Konteyneri çalıştırmadan dosya listesini çıkar (static image'da shell yok)
list_files() {
  local c
  c=$(docker create "$1")
  docker export "$c" | tar -t > "/tmp/$2.files"
  docker rm "$c" >/dev/null
}

builder_go() {
  local img
  img=$(grep -m1 '^FROM' "$1" | awk '{print $2}')
  docker run --rm --entrypoint go "$img" version 2>/dev/null || echo "n/a"
}

list_files lab:alpine alpine
list_files lab:wolfi  wolfi

ALPINE_LIST=$(docker run --rm --entrypoint apk lab:alpine list --installed | awk '{print $1}')
ALPINE_N=$(echo "$ALPINE_LIST" | wc -l)
ALPINE_NAMES=$(echo "$ALPINE_LIST" | paste -sd, -)

WOLFI_LIST=$(grep '^var/lib/db/sbom/.*\.spdx\.json$' /tmp/wolfi.files | sed 's|.*/||; s|\.spdx\.json$||')
WOLFI_N=$(echo "$WOLFI_LIST" | wc -l)
WOLFI_NAMES=$(echo "$WOLFI_LIST" | paste -sd, -)

cat > "$OUT" <<MD
# Alpine vs Wolfi: ölçümler

Üretim tarihi: $(date -u +%Y-%m-%dT%H:%MZ)

| Ölçüm | Alpine | Wolfi |
|---|---|---|
| Image boyutu (MB) | $(size_mb lab:alpine) | $(size_mb lab:wolfi) |
| Katman sayısı | $(layers lab:alpine) | $(layers lab:wolfi) |
| Çalışan kullanıcı | $(user lab:alpine) | $(user lab:wolfi) |
| Kurulu paket sayısı | ${ALPINE_N} | ${WOLFI_N} |
| /bin/sh var mı | $(has_file alpine bin/sh) | $(has_file wolfi bin/sh) |
| apk binary'si var mı | $(has_file alpine sbin/apk) | $(has_file wolfi sbin/apk) |

## Kurulu paketler

- Alpine: \`${ALPINE_NAMES}\`
- Wolfi: \`${WOLFI_NAMES}\`

## Girdiler

- Alpine runtime base: \`$(digest alpine:3.24)\`
- Wolfi runtime base: \`$(digest cgr.dev/chainguard/static:latest)\`
- Alpine builder Go: \`$(builder_go Dockerfile.alpine)\`
- Wolfi builder Go: \`$(builder_go Dockerfile.wolfi)\`
MD

cat "$OUT"
