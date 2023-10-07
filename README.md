# Dev Containers

## Structure

base image -> project image -> dev containers

## Example

- Create/update base image

```bash
./update_base__debian.sh
# OR
./update_base__debian.sh --no-cache
```

- Create dev container based on an existing image

```bash
# give you the option to choose the image and project name
./new_devc.sh
```
