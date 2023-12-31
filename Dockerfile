# name the portage image
FROM gentoo/portage:20230710 as portage

# image is based on stage3
FROM gentoo/stage3:systemd-20230710 as build

# copy the entire portage volume in
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

ENV FEATURES="-ipc-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox"
# build mini gentoo
RUN sed -i "s/O2/Os -ffunction-sections -fdata-sections/g" /etc/portage/make.conf \
    && emerge -v merge-usr \
    && merge-usr \
    && eselect profile set 19 \
    && mkdir -p /mini/usr/{lib,lib64,bin} && ln -s usr/bin /mini/sbin && ln -s usr/{bin,lib,lib64} /mini/ && ln -s bin /mini/usr/sbin
RUN PYTHON_TARGETS="python3_11" USE="-multilib -split-usr openmp" ROOT=/mini emerge -v -j$(nproc) sys-libs/glibc sys-kernel/linux-headers coreutils sys-apps/portage dev-vcs/git sys-devel/gcc sys-devel/binutils  \
    sys-apps/shadow \
    app-arch/gzip \
    sys-process/procps \
    sys-apps/diffutils \
    sys-apps/locale-gen \
    awk patch wget curl vim grep make cmake
RUN cp -avf /etc/portage /mini/etc/
FROM scratch
COPY --from=build /mini/ /

