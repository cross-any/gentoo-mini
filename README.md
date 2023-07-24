# gentoo-mini
gentoo mini docker image is a test image built by [crossany - cross compile envirionment](https://github.com/cross-any/cross-any).  
It's small repalcement for gentoo/stage3 docker image.  
# Tags
https://hub.docker.com/r/crossany/gentoo-mini/tags  
# Mirrors  
Use aliyun if docker hub is slow for you: registry.cn-beijing.aliyuncs.com/crossany/gentoo-mini  
# Run it  
```
docker run --rm -ti crossany/gentoo-mini:latest uname -a
```
# Run it if you need install more packages with emerge  
```
docker create -v /var/db/repos/gentoo --name 20230710 gentoo/portage:20230710 /bin/true
docker run --rm -ti --volumes-from 20230710 crossany/gentoo-mini:latest /bin/bash
```
# Run it on different architeture cpu  
```
docker run -ti --rm --privileged crossany/qemu
docker run  --rm -ti --platform arm64 crossany/gentoo-mini:latest uname -a
docker run  --rm -ti --platform amd64 crossany/gentoo-mini:latest uname -a
```
# crossany
Try [crossany](https://github.com/cross-any/cross-any) https://github.com/cross-any/cross-any if you need cross compile toolset.
