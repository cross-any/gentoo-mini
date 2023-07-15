# name the portage image
FROM gentoo/portage:20230710 as portage

# image is based on stage3
FROM gentoo/stage3:systemd-20230710 as build

# copy the entire portage volume in
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

ENV FEATURES="-ipc-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox"
# build mini gentoo
RUN sed -i "s/O2/Os/g" /etc/portage/make.conf \
    && emerge -v merge-usr \
    && merge-usr \
    && eselect profile set 19 \
    && PYTHON_TARGETS="python3_11" USE="-multilib -split-usr" ROOT=/mini emerge -v -j$(nproc) sys-libs/glibc sys-kernel/linux-headers coreutils sys-apps/portage dev-vcs/git sys-devel/gcc  wget curl vim grep \
    && cp -avf /etc/portage /mini/
FROM scratch
COPY --from=build /mini/ /

