# Alpine vs Wolfi: ölçümler

Üretim tarihi: 2026-10-05T10:38Z

| Ölçüm | Alpine | Wolfi |
|---|---|---|
| Image boyutu (MB) | 14.32 | 8.23 |
| Katman sayısı | 3 | 2 |
| Çalışan kullanıcı | 10001 | 65532 |
| Kurulu paket sayısı | 16 | 3 |
| /bin/sh var mı | yes | no |
| apk binary'si var mı | yes | no |

## Kurulu paketler

- Alpine: `alpine-baselayout-3.7.2-r1,alpine-baselayout-data-3.7.2-r1,alpine-keys-2.6-r0,alpine-release-3.24.2-r0,apk-tools-3.0.8-r0,busybox-1.37.0-r31,busybox-binsh-1.37.0-r31,ca-certificates-bundle-20260909-r0,libapk-3.0.8-r0,libcrypto3-3.5.8-r0,libssl3-3.5.8-r0,musl-1.2.6-r2,musl-utils-1.2.6-r2,scanelf-1.3.9-r1,ssl_client-1.37.0-r31,zlib-1.3.2-r0`
- Wolfi: `ca-certificates-bundle-20260909-r2,tzdata-2026e-r0,wolfi-baselayout-20230201-r30`

## Girdiler

- Alpine runtime base: `alpine@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6`
- Wolfi runtime base: `cgr.dev/chainguard/static@sha256:fe55470f22d3259488d9d3739168d8f04da67755f0b69382bc26eda4a7d3d327`
- Alpine builder Go: `go version go1.27.1 linux/amd64`
- Wolfi builder Go: `go version go1.27.1 linux/amd64`
