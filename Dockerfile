######### Arm64 Gentoo Cross Container for AMD64 & or P-ROOT (Chroot) to fake arm64 enviorment.
FROM sabayon/builder-amd64-squashed docker pull

######## ADD Layman
RUN equo up && equo i layman git eix sabayon-devkit sabayon-sark
# layman -L && layman -a sabayon  && layman -a sabayon-distro
RUN layman -S

build /ADD Proot chroot misc binformat tools for arm/arm64 etc. 
ADD https://raw.githubusercontent.com/mickael-guene/proot-static-build/master-umeq/static/proot-x86_64 /usr/bin/proot
ADD https://github.com/mickael-guene/umeq/releases/download/1.7.3/umeq-arm64 /usr/bin/umeq
https://github.com/Sabayon/sabayon-sark/archive/master.zip


## Add Chroot Subunit. 
ADD http://distfiles.gentoo.org/experimental/arm/arm64/stage3-arm64-20160324.tar.bz2 /gentoo-arm64/
ADD https://raw.githubusercontent.com/Sabayon-Labs/Sabayon-arm64-builder/master/aarch64-make.conf /gentoo-arm64/etc/portage/
RUN mv /gentoo-arm64/etc/portage/make.conf /gentoo-arm64/etc/portage/make.conf.original
RUN mv  /gentoo-arm64/etc/portage/aarch64-make.conf /gentoo-arm64/etc/portage/make.conf
# Set locales to en_US.UTF-8
ENV LC_ALL=en_US.UTF-8


# Define working directory.


# Define standard volumes
VOLUME ["/usr/portage", "/usr/portage/distfiles", "/usr/portage/packages", "/var/lib/layman/]
### Define were to get the goodies from for arm64 on AMD64 Host container. Export chroot vol just in case of 
## Sh* hitting the fan... 
VOLUME ["/gentoo-arm64/packages" "/gentoo-arm64" "/gentoo-arm64/entropy-packages"]

### DO  mounts or symlinks 
RUN mount -o -R /usr/portage /gentoo-arm64/usr/portage/
RUN  mkdir /gentoo-arm64/packages/  && mkdir /gentoo-arm64/entropy-packages
RUN mount -o -R  /gentoo-arm64/packages/  /gentoo-arm64/usr/portage/packages
RUN mount -o  -R  /var/lib/layman/ /gentoo-arm64/var/lib/layman/

# Define default command.
ENTRYPOINT ["/usr/bin/proot -R/gentoo-arm64/ -q umeq-arm64 bash] 
emerge -b  gentoolkit eix 
