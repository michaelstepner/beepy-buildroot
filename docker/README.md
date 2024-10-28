☁️ For instructions on building yourself an SD card image in the cloud using Github Actions, see the [main README](../README.md#instructions).

💻 This README contains advice for local builds, troubleshooting and development. All commands should be run from the *root* of the git repository, not from this subdirectory.

## Local Builds

- Build the SD card image in a docker container on your local machine by running:

    ```
    git submodule init
    git submodule update
    docker build --platform linux/amd64 --file docker/Dockerfile --tag buildroot-os-builder .
    docker run --platform linux/amd64 --name my-beepy-buildroot buildroot-os-builder ./build-image.sh
    docker cp my-beepy-buildroot:/home/builder/beepy-buildroot/buildroot/output/images/sdcard.img ./sdcard.img
    ```

- You can clean up the docker resources once you're done by running:

    ```
    docker rm my-beepy-buildroot
    docker rmi buildroot-os-builder
    ```

## Troubleshooting

- When building on a Mac with Apple Silicon, you might need to limit your docker container to a single CPU to resolve a `write jobserver: Bad file descriptor.  Stop.` error. To do so, we can add `--cpus=1` as an argument to the `docker run` command and add `-j 1` as an argument to the `./build-image.sh` command run within the container:

    ```
    docker run --platform linux/amd64 --cpus=1 --name my-beepy-buildroot buildroot-os-builder ./build-image.sh -j 1
    ```

- When building on a Windows PC using WSL (Windows Subsystem for Linux), you might encounter errors related to timestamps such as `Clock skew detected.` This is a [known issue](https://github.com/microsoft/WSL/issues?q=is:issue%20clock%20skew) with WSL. Launching the docker build from an [Ubuntu Multipass](https://multipass.run/) container instead of a WSL2 ubuntu container resolved the issue.

## Development

- When developing or modifying the build, it is useful to do so from an interactive terminal so you can resume crashed builds and inspect the build artifacts created. Instead of the `docker run` command given above, you can run:

    ```
    docker run -it --platform linux/amd64 --name my-beepy-buildroot buildroot-os-builder /bin/bash
    ```

- Inside the docker container, you can manually execute:

    ```
    ./build-image.sh
    ```

- To re-use the compiler cache in a subsequent build in the same docker container (e.g. to resume a build after it crashes), you can run:

    ```
    cd buildroot
    make -j $(nproc)
    ```
