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

build-img project_image_name *args: (build-baseimg "pass" "devvoid" "Dockerfile.voidlinux")
    docker build \
      {{ args }}\
      -t {{ project_image_name }} .

build-container container_name image_name *args: (build-img image_name)
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
