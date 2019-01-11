FROM nvidia/cudagl:10.0-devel-ubuntu16.04
MAINTAINER "Thomas Enzinger <info@thomas-enzinger.de>"

ARG SALOME_VERSION

ENV SALOME_PLATFORM=UB16.04
ENV SALOME_FILE_RUN "Salome-V8_5_0-univ_withOT.run"
ENV SALOME_URL "http://files.salome-platform.org/Salome/Contributions/EDF/${SALOME_FILE_RUN}"
ENV SALOME_FILE_MD5 "${SALOME_FILE_RUN}.md5"
ENV SALOME_FILE_SHA512SUM "${SALOME_FILE_RUN}.sha512"

RUN apt update
RUN apt install -y curl tar gzip
RUN apt install -y nano vim
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
  python3 \
  bash-completion binutils coreutils \
  sudo \
  module-init-tools iputils-ping net-tools \
  libglu1-mesa libxmu6 libpng16-16 \
  zlib1g-dev libboost-python-dev liblapack-dev \
  python-numpy python-dev python cmake gfortran g++ gcc \
  wget rsync build-essential ca-certificates locales openssh-client \
  python-apt git dvipng libfftw3-dev libreadline-dev libhdf5-dev hdf5-tools gfortran automake autoconf libtool \
  python libboost-all-dev swig libcgal-dev libomniorb4-dev graphviz-dev libgl1-mesa-dev libglu1-mesa-dev libxmu-dev \
  omniidl omniidl-python omniorb-nameserver libcos4-dev python-omniorb liblapack-dev python-numpy python-scipy \
  graphviz doxygen libxml2 libxslt1-dev python-lxml python-setuptools python-pygments python-jinja2 python-docutils \
  python-sphinx libtbb-dev libfreetype6-dev libfreeimage-dev python-sip-dev metis libmetis-dev scotch libscotch-dev \
  libtogl-dev tcl8.5-dev tk8.5-dev tix-dev libcgns-dev libopencv-dev libcppunit-dev python-pkgconfig cython python-h5py \
  tralics libmuparser-dev libcgal-dev python-pil python-gnuplot libnlopt-dev \
  libfontconfig1 libglib2.0-0 libglu1-mesa libxmu6 libxrender1 mesa-utils net-tools \
  dbus-x11 fonts-dejavu fonts-liberation hicolor-icon-theme \
  libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module \
  libglib2.0 libgtk2.0-0 libdbus-glib-1-2 libxt6 libexif12 \
  libgl1-mesa-glx libgl1-mesa-dri \
  xserver-xorg-video-intel \
  msttcorefonts fonts-liberation ttf-dejavu \
  && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
  && echo 127.0.1.1 $(hostname) >> /etc/hosts
#  flex bison tk

#
RUN apt autoremove \
  && apt clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/build_salome.sh /opt/build_salome.sh
COPY hash/* /opt/

#
ENV HOME /home/salome_user

RUN useradd -m -s /bin/bash -G sudo salome_user && \
echo "salome_user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#
RUN /opt/build_salome.sh
RUN rm -f /opt/build_salome.sh && rm -Rf /opt/hash
ENV PATH $HOME/salome/appli_V8_5_0:$PATH

#
USER salome_user
CMD ["bash"]

