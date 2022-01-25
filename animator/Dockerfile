FROM julia:latest

EXPOSE 80

ENV INDOCKER=true
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y cmake xorg-dev mesa-utils xvfb libgl1 freeglut3-dev 

COPY ./ ./
RUN julia install.jl

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  libgl1-mesa-dri \
  menu \
  net-tools \
  openbox \
  python-pip \
  sudo \
  supervisor \
  tint2 \
  x11-xserver-utils \
  x11vnc \
  xinit \
  xserver-xorg-video-dummy \
  xserver-xorg-input-void \
  websockify && \
  rm -f /usr/share/applications/x11vnc.desktop && \
  apt-get remove -y python-pip && \
  wget https://bootstrap.pypa.io/get-pip.py && \
  python get-pip.py && \
  pip install supervisor-stdout && \
  apt-get -y clean

CMD julia animator.jl