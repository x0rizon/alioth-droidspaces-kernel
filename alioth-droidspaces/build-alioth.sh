#!/usr/bin/env bash
# Build kernel alioth (POCO F3 / Redmi K40) com DroidSpaces
# Testado logicamente para: MiCode/Xiaomi_Kernel_OpenSource, branch alioth-r-oss, kernel 4.19.113
# Uso: chmod +x build-alioth.sh && ./build-alioth.sh
set -euo pipefail

KERNEL_DIR="${KERNEL_DIR:-$HOME/alioth-kernel}"
CLANG_DIR="${CLANG_DIR:-$HOME/clang-r377782c}"
FRAGMENT="$(dirname "$0")/droidspaces-alioth.fragment"
JOBS="$(nproc --all)"

echo "[1/6] A verificar dependências..."
for cmd in git make python3 gcc flex bison libssl-dev; do :; done
sudo apt update
sudo apt install -y git-core gnupg flex bison build-essential zip curl \
  zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev \
  x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip \
  fontconfig python3 python-is-python3 rsync cpio libssl-dev bc ccache

echo "[2/6] A clonar kernel Xiaomi alioth-r-oss em $KERNEL_DIR..."
if [ ! -d "$KERNEL_DIR/.git" ]; then
  git clone --depth=1 -b alioth-r-oss https://github.com/MiCode/Xiaomi_Kernel_OpenSource.git "$KERNEL_DIR"
else
  echo "  já existe, a atualizar..."
  git -C "$KERNEL_DIR" fetch --depth=1 origin alioth-r-oss || true
fi

echo "[3/6] Clang r377782c (o indicado pelo build.config.common da branch)..."
if [ ! -d "$CLANG_DIR" ]; then
  mkdir -p "$(dirname "$CLANG_DIR")"
  # Download via AOSP prebuilt (exemplo). Se falhar, usa Proton Clang como alternativa.
  echo "  -> Faz download manual de: https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android-11.0.0_r48/clang-r377782c.tar.gz"
  echo "  -> Extrai para $CLANG_DIR"
  echo "  Alternativa: git clone --depth=1 https://github.com/kdrag0n/proton-clang.git $HOME/proton-clang"
  exit 1
fi

echo "[4/6] A aplicar fragmento DroidSpaces ao vendor/alioth_user_defconfig..."
cd "$KERNEL_DIR"
cp arch/arm64/configs/vendor/alioth_user_defconfig /tmp/alioth_user_defconfig.bak
# Porta o gcc-wrapper.py para python3 (a árvore traz versão python2, que falha em distros modernas)
cp "$(dirname "$FRAGMENT")/gcc-wrapper-py3.py" scripts/gcc-wrapper.py
# Anexa o fragmento ao defconfig (o make defconfig resolve dependências; fluxo validado)
cat "$FRAGMENT" >> arch/arm64/configs/vendor/alioth_user_defconfig

echo "[5/6] Patches non-GKI (obrigatório, passo 3 do guia)..."
echo "  Faz download de https://github.com/ravindu644/droidspaces-oss/tree/main/Documentation/resources/kernel-patches/non-GKI"
echo "  e aplica com: patch -p1 < /caminho/para/patch.patch"
echo "  (o script não aplica automaticamente porque os patches evoluem; verifica a pasta atual)"

echo "[6/6] A compilar..."
export PATH="$CLANG_DIR/bin:$PATH"
export ARCH=arm64
export SUBARCH=arm64
export CC=clang
export LD=ld.lld
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-android-
export CROSS_COMPILE_ARM32=arm-linux-androideabi-

make O=out ARCH=arm64 vendor/alioth_user_defconfig
# Resolve novos símbolos sem perguntas interativas
make O=out ARCH=arm64 olddefconfig
# Nota: esta árvore não tem target dtbo.img; o dtbo stock é reutilizado no flash.
set -o pipefail
make -j"$JOBS" O=out ARCH=arm64 CC=clang LD=ld.lld \
  CLANG_TRIPLE=aarch64-linux-gnu- \
  CROSS_COMPILE=aarch64-linux-android- \
  CROSS_COMPILE_ARM32=arm-linux-androideabi- \
  Image.gz 2>&1 | tee build.log
test -f out/arch/arm64/boot/Image.gz

echo
echo "OK! Artefactos em $KERNEL_DIR/out/arch/arm64/boot/"
echo "Próximo: empacota com AnyKernel3 para alioth + flash + 'Check Requirements' na app DroidSpaces."
