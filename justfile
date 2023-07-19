default:
    just --list

build-baseimg pass image_name dockerfile *args:
    docker build \
      {{ args }} \
      --build-arg PASSWD="{{ pass }}" \
      --build-arg="UID=$(id -u)" \
      --build-arg="GID=$(id -g)" \
      -t {{ image_name }} \
      -f "{{ dockerfile }}" .

build-img: (build-baseimg "pass" "devvoid" "Dockerfile.voidlinux")
    @echo ">> TODO: implement this"

build-container:
    @echo ">> TODO: implement this"
