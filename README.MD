# HBase Phoenix Docker

This project provides a standalone HBase and Phoenix setup embedded in a Docker container. It is intended strictly for
development purposes and not suitable for production environments.

## Build

To build the Docker image:

    podman build -t hbase-phoenix .

## Run

Start the container using Docker Compose:

    podman compose up -d

## How to use

Exec into the container to have Java set up by bash:

    podman compose exec -it hbase bash

Start HBase shell for native HBase operations:

    hbase shell

Start SQLLine for interacting with Phoenix:

    sqlline.py

## Notes

### WAL Configuration

Starting from HBase 2.4, the default write-ahead log (WAL) uses asynchronous file system operations like hflush, which
are not supported by Docker file systems or some host file systems like NTFS. This setup includes custom configurations 
in `hbase-site.xml` to disable these checks and revert to the legacy WAL mechanism for compatibility.

### Data Persistence

The `docker-compose.yml` includes a volume for HBase data, ensuring the data is persisted even after `compose down`.

### Compatibility

Tested on amd64 and arm64 as well. Only used it from host, but should work from other containers.
