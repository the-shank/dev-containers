_default:
    just --list

build-baseimg pass image_name dockerfile *args:
    docker build \
      {{ args }} \
      --build-arg PASSWD="{{ pass }}" \
      --build-arg="UID=$(id -u)" \
      --build-arg="GID=$(id -g)" \
      -t {{ image_name }} \
      -f "{{ dockerfile }}" .

_build-img project_image_name *args:
    docker build \
      {{ args }}\
      -t {{ project_image_name }} .

build-img-void project_image_name *args: (build-baseimg "pass" "devvoid" "Dockerfile.voidlinux")
    just _build-img {{ project_image_name }} {{ args }}

build-img-ubuntu2204 project_image_name *args: (build-baseimg "pass" "dev2204" "Dockerfile.ubuntu2204")
    just _build-img {{ project_image_name }} {{ args }}

_build-container container_name image_name *args:
    docker run \
      --label no-prune \
      -it \
      --name {{ container_name }} \
      --hostname {{ container_name }} \
      --volume /tmp/.X11-unix:/tmp/.X11-unix \
      --volume $HOME:/host_home \
      --volume $HOME/code:/home/shank/code \
      --volume $HOME/.ssh:/home/shank/.ssh \
      --env DISPLAY=$DISPLAY \
      {{ args }} \
      {{ image_name }}

build-container-void container_name image_name *args: (build-img-void image_name)
    just _build-container {{ container_name }} {{ image_name }} {{ args }}

build-container-ubuntu2204 container_name image_name *args: (build-img-ubuntu2204 image_name)
    just _build-container {{ container_name }} {{ image_name }} {{ args }}
