#!/usr/bin/env bash
set -euo pipefail

OUT=docs/comparison.md
mkdir -p docs

size_mb() { docker image inspect "$1" --format '{{.Size}}' | awk '{printf "%.2f", $1/1024/1024}'; }
layers()  { docker image inspect "$1" --format '{{len .RootFS.Layers}}'; }
user()    { docker image inspect "$1" --format '{{if .Config.User}}{{.Config.User}}{{else}}root{{end}}'; }

# Konteyneri çalıştırmadan dosya listesini çıkar (static image'da shell yok)
list_files() {
  local c
  c=$(docker create "$1")
  docker export "$c" | tar -t > "/tmp/$2.files"
  docker rm "$c" >/dev/null
}
file_count() { grep -vc '/$' "/tmp/$1.files" || true; }
has_file()   { grep -qx "$2" "/tmp/$1.files" && echo yes || echo no; }
digest()     { docker image inspect "$1" --format '{{index .RepoDigests 0}}' 2>/dev/null || echo "n/a"; }

list_files lab:alpine alpine
list_files lab:wolfi  wolfi

GO_ALPINE=$(docker run --rm golang:1.23-alpine go version 2>/dev/null || echo "n/a")
GO_WOLFI=$(docker run --rm cgr.dev/chainguard/go:latest version 2>/dev/null || echo "n/a")

cat > "$OUT" <<MD
# Alpine vs Wolfi: ölçümler

Üretim tarihi: $(date -u +%Y-%m-%dT%H:%MZ)

| Ölçüm | Alpine | Wolfi |
|---|---|---|
| Image boyutu (MB) | $(size_mb lab:alpine) | $(size_mb lab:wolfi) |
| Katman sayısı | $(layers lab:alpine) | $(layers lab:wolfi) |
| Çalışan kullanıcı | $(user lab:alpine) | $(user lab:wolfi) |
| Dosya sayısı | $(file_count alpine) | $(file_count wolfi) |
| /bin/sh var mı | $(has_file alpine bin/sh) | $(has_file wolfi bin/sh) |
| apk var mı | $(has_file alpine sbin/apk) | $(has_file wolfi sbin/apk) |

## Girdiler

- Alpine runtime base: \`$(digest alpine:3.20)\`
- Wolfi runtime base: \`$(digest cgr.dev/chainguard/static:latest)\`
- Alpine builder Go: \`${GO_ALPINE}\`
- Wolfi builder Go: \`${GO_WOLFI}\`
MD

cat "$OUT"
