# alioth-droidspaces-kernel

Kernel 4.19 para **POCO F3 / Redmi K40 (alioth)** com suporte
[DroidSpaces](https://github.com/ravindu644/droidspaces-oss),
pronto a flashar via OrangeFox/TWRP.

- **Fonte:** [MiCode/Xiaomi_Kernel_OpenSource](https://github.com/MiCode/Xiaomi_Kernel_OpenSource), branch `alioth-r-oss` (4.19.113), defconfig `vendor/alioth_user_defconfig`
- **Build automático:** GitHub Actions (Proton Clang + GCC Ubuntu) — ver [`.github/workflows/build-alioth.yml`](.github/workflows/build-alioth.yml)
- **Release:** ZIP AnyKernel3 em [Releases](https://github.com/x0rizon/alioth-droidspaces-kernel/releases) — substitui só o kernel no `boot`, mantém ramdisk + dtbo stock da ROM

## Instalar (OrangeFox)

1. Backup: **Backup → Boot**
2. **Install** → escolhe `Alioth-DroidSpaces-Kernel-v1.0.zip` → confirma
3. Reboot
4. App DroidSpaces → **Settings → Requirements → Check Requirements**

## O que está neste repo

| Ficheiro | Para quê |
|---|---|
| [`alioth-droidspaces/droidspaces-alioth.fragment`](alioth-droidspaces/droidspaces-alioth.fragment) | Opções de config DroidSpaces (non-GKI 3.18–4.19) anexadas ao defconfig |
| [`alioth-droidspaces/build-alioth.sh`](alioth-droidspaces/build-alioth.sh) | Build local numa máquina Linux |
| [`alioth-droidspaces/gcc-wrapper-py3.py`](alioth-droidspaces/gcc-wrapper-py3.py) | `gcc-wrapper.py` da árvore portado para Python 3 |
| [`alioth-droidspaces/patches/`](alioth-droidspaces/patches/) | Patches locais: `stpcpy()` p/ Clang moderno, `__packed` p/ `genksyms` (ver README na pasta) |
| [`.github/workflows/build-alioth.yml`](.github/workflows/build-alioth.yml) | Workflow CI: fragmento + patches non-GKI + patches locais + verificação das 23 opções |

Detalhes do processo de build: [`alioth-droidspaces/README.md`](alioth-droidspaces/README.md).

## Créditos

- Kernel: Xiaomi / MiCode ([GPL-2.0](LICENSE))
- Toolchain CI: [Proton Clang](https://github.com/kdrag0n/proton-clang) (kdrag0n)
- Requisitos contentores: [DroidSpaces](https://github.com/ravindu644/droidspaces-oss) (ravindu644)
- Formato do ZIP: [AnyKernel3](https://github.com/osm0sis/AnyKernel3) (osm0sis)

## Licença

[GPL-2.0](LICENSE) — como a árvore de origem. O ZIP da release é distribuído
com o código-fonte correspondente neste repo (fragmento, patches, workflow).
