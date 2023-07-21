#!/bin/bash
set -e
set -x
if ! which nativerun >/dev/null 2>/dev/null; then
    alias nativerun=time
fi
nativerun emerge -vn patchelf
ROOT=${ROOT:=/mini}
sed -i "s/O2/Os -ffunction-sections -fdata-sections/g" /etc/portage/make.conf \
    && nativerun emerge -vn merge-usr \
    && nativerun merge-usr \
    && nativerun eselect profile set 19 \
    && mkdir -p $ROOT/etc/ \
    && cp -avf /etc/portage $ROOT/etc/ \
    && mkdir -p $ROOT/usr/{lib,lib64,bin} && ln -s usr/bin $ROOT/sbin && ln -s usr/{bin,lib,lib64} $ROOT/ && ln -s bin $ROOT/usr/sbin

PYTHON_TARGETS="python3_11" USE="-multilib -split-usr openmp pam" ROOT=$ROOT emerge -vn -j$(nproc) =sys-libs/glibc-2.36-r8 sys-kernel/linux-headers =sys-devel/gcc-12.2.1_p20230428-r1
patchelf --remove-rpath $ROOT/lib/ld*so*
patchelf --remove-rpath $ROOT/lib/libc.so.6

PYTHON_TARGETS="python3_11" USE="-multilib -split-usr pam" ROOT=$ROOT emerge  --autounmask-continue --autounmask=y --autounmask-write -vn -j$(nproc) =sys-devel/gcc-12.2.1_p20230428-r1 coreutils sys-apps/portage dev-vcs/git sys-devel/binutils  \
    sys-apps/shadow \
    app-arch/gzip \
    sys-process/procps \
    sys-apps/diffutils \
    app-alternatives/awk patch wget curl vim grep make cmake 
if [ -n "${crossenv}" ]; then
arch="${crossenv%%-*}"
set +x
for ff in $(find $ROOT -type f); do
    ((/usr/bin/readelf -h $ff 2>/dev/null|/usr/bin/grep Machine:|/usr/bin/grep -vi $arch) && echo $ff)||true
done
fi
mkdir -p $ROOT/root
cp -avf /root/*-mini.sh $ROOT/root/
rm -rf $ROOT/sys/* $ROOT/proc/*
echo build done
