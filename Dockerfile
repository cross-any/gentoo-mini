# name the portage image
FROM gentoo/portage:20230710 as portage

# image is based on stage3
FROM gentoo/stage3:systemd-20230710 build

# copy the entire portage volume in
COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

ENV FEATURES="-ipc-sandbox -network-sandbox -pid-sandbox -sandbox -usersandbox"
# build mini gentoo
RUN PYTHON_TARGETS="python3_11" USE="" ROOT=/mini emerge -av -j$(nproc) --autounmask-continue --autounmask=y --autounmask-write sys-libs/glibc sys-kernel/linux-headers coreutils sys-apps/portage dev-vcs/git sys-devel/gcc

FROM scratch
COPY --from=build /mini/ /

