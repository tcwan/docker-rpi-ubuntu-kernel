# Default debuginfod to off, to avoid extensive URL timeout issue
set debuginfod enabled off
set serial baud 115200
# Specify architecture to avoid gdb client confusion when connecting to kgdb
set arch aarch64
