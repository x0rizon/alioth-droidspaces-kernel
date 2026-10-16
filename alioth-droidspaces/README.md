# Kernel DroidSpaces para POCO F3 (alioth)

Boa notícia: o alioth é **non-GKI (4.19)**, o caso mais simples do guia oficial.
Não há risco de bootloop por kABI como nos GKI 5.4+ — basta ligar as opções e aplicar os patches non-GKI.

## O que foi preparado aqui

- [droidspaces-alioth.fragment](droidspaces-alioth.fragment) — fragmento exato do guia oficial
  `Documentation/Kernel-Configuration.md`, secção **Non-GKI (3.18–4.19)**.
- [build-alioth.sh](build-alioth.sh) — script de build para a fonte oficial
  `MiCode/Xiaomi_Kernel_OpenSource`, branch `alioth-r-oss` (4.19.113),
  defconfig `vendor/alioth_user_defconfig`, Clang r377782c.

## Opção A — GitHub Actions (recomendado, grátis)

1. Faz push desta pasta + `.github/workflows/build-alioth.yml` para o teu GitHub.
2. Vai a **Actions → Build alioth kernel (DroidSpaces) → Run workflow**.
3. No fim, descarrega o artefacto `alioth-droidspaces-kernel`:
   `Image.gz`, `dtbo.img`, `alioth-droidspaces.config`, `build.log`.
4. Empacota com AnyKernel3 para alioth e faz flash.

O workflow usa Proton Clang + GCC Ubuntu, aplica o fragmento,
aplica as patches `non-GKI` do DroidSpaces e falha se faltar alguma opção chave.

## Opção B — máquina própria

Um build 4.19 + Clang precisa de ~15–20 GB livres e 8+ GB RAM/swap.
Corre `./build-alioth.sh` numa máquina Linux com recursos.

## Passos (resumo)

1. Numa máquina Linux com espaço: `./build-alioth.sh`
2. Antes de compilar, aplica os patches em
   `Documentation/resources/kernel-patches/non-GKI/` do repo
   https://github.com/ravindu644/droidspaces-oss
   ```bash
   patch -p1 < /caminho/para/patch.patch
   ```
3. Empacota `Image.gz` + `dtbo` com AnyKernel3 para alioth, flash via TWRP/OrangeFox.
4. Na app DroidSpaces: **Settings → Requirements → Check Requirements**.
   Tudo em "must have" e "recommended" deve passar.
5. Root: KernelSU recomendado (Magisk/APatch também funcionam).

## Alternativa sem compilar

Vê primeiro a lista de dispositivos suportados pela comunidade:
https://github.com/ravindu644/droidspaces-oss → `Documentation/community-supported-devices.md`.
Se já existir kernel pronto para alioth, usa-o e poupa o build.

## Notas alioth

- Fonte oficial: `MiCode/Xiaomi_Kernel_OpenSource`, branch `alioth-r-oss`.
- Não uses `alioth_defconfig` nessa árvore — o nome correto é `vendor/alioth_user_defconfig`.
- Toolchain fiel à árvore: Clang r377782c (`CC=clang`, `LD=ld.lld`).
  Proton Clang funciona como alternativa, mas não é a mais fiel ao build Xiaomi.
- KVM / Binder / ashmem **não** são requisitos do DroidSpaces — é runtime LXC-like
  (namespaces + cgroups + seccomp + rede NAT), não VM.
