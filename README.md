zmk-config for charybdis (3x6)

## Local build

Build with Docker:

```sh
make build-all
```

Useful targets:

```sh
make build-left
make build-right
make build-reset
make shell
make clean
```

Firmware artifacts are written under `build/*/zephyr/`.
