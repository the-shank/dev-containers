# Dev Containers

## Building Base Images

This is not required to be done for all projects because the base image would
likely be shared between multiple projects.

```
./build_baseimg.sh <password> <image_name> <dockerfile> [<other-args>]
```

For example:

```bash
./build_baseimg.sh pass devvoid Dockerfile.voidlinux
```

For building base image from scratch

```bash
./build_baseimg.sh pass devvoid Dockerfile.voidlinux --no-cache
```

## Building Project Specific Image

```
./build_img.sh <project_image_name> [<other-args>]
```

For example:

```bash
./build_img.sh devvoid_rust4embedded
```

## Create Container for the Project

```
./build_container.sh <container_name> <project_image_name>
```

For example:

```bash
./build_container.sh devvoid_rust4embedded devvoid_rust4embedded
```
