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
  # gives you the option to choose the image and project name
  ./devc_new.sh
 
  # limits the cpu usage (useful for containers running evaluation stuff)
  # max cpu usage = cpus / total cpus
  ./devc_new.sh --cpus="15"
  ```
