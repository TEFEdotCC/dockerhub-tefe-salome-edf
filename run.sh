#!/bin/bash

Version=${1:-latest}

#
xhost local:root
docker run -ti --rm                        \
  --runtime=nvidia                         \
  -e DISPLAY                               \
  -v /tmp/.X11-unix:/tmp/.X11-unix         \
  -v /usr/share/X11:/usr/share/X11         \
  -v $HOME/.Xauthority:$HOME/.Xauthority   \
  -v /mnt:/mnt                             \
  --net=host                               \
  --pid=host                               \
  --ipc=host                               \
  tefe/salome-edf:${Version} $2

