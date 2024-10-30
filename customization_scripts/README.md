This folder contains shell scripts which are used by **[build-image.sh](/build-image.sh)** in combination with a **customization.json** file to customize the settings of your Buildroot OS image. This README documents how this process is configured and how to add additional customization options.

### customization.json

The **customization.json** file must be located in the root directory of the repository, adjacent to **build-image.sh**. It is created automatically when you run the "Build image" Github Action manually and enter your customizations in the web GUI.

This JSON file has a single level of hierarchy. For each key-value pair, the key corresponds to the filename of the script in the **[customization_scripts](/customization_scripts)** directory, and the value corresponds to the first (and only) positional argument passed to that script. For example, if **customization.json** contains `"timezone": "Eastern Time (US and Canada)"` then **build-image.sh** will run `./customization_scripts/timezone.sh 'Eastern Time (US and Canada)'` before starting the build.

## Adding a new customization option

To add a new customization option, you need to add the new option as an input to the Github Action defined in **[.github/workflows/build.yml](/.github/workflows/build.yml)** and save a new script that handles this customization in the **[customization_scripts](/customization_scripts)** directory. You can then open a Pull Request to propose the change.
