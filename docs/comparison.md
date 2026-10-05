# Alpine vs Wolfi: ölçümler

Üretim tarihi: 2026-10-05T08:01Z

| Ölçüm | Alpine | Wolfi |
|---|---|---|
| Image boyutu (MB) | 12.44 | 8.23 |
| Katman sayısı | 3 | 2 |
| Çalışan kullanıcı | 10001 | 65532 |
| Dosya sayısı | 428 | 1254 |
| /bin/sh var mı | yes | no |
| apk var mı | yes | no |

## Girdiler

- Alpine runtime base: `
n/a`
- Wolfi runtime base: `cgr.dev/chainguard/static@sha256:fe55470f22d3259488d9d3739168d8f04da67755f0b69382bc26eda4a7d3d327`
- Alpine builder Go: `go version go1.23.12 linux/amd64`
- Wolfi builder Go: `go version go1.27.1 linux/amd64`
