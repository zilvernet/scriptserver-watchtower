# scriptserver-watchtower
Is a collection of scripts that uses Script-server web interfase and provide Docker container image updates and other management features

### Script-server
Script-server is a lightweight server that allows you to run scripts with a simple HTTP request. It provides a secure and flexible way to execute scripts, and can be used for a wide variety of tasks, from simple shell scripts to complex automation workflows. ScriptServer is easy to install and configure, and provides a simple yet powerful interface for managing scripts and their associated runners.

### Docker
Docker is a platform for developing, shipping, and running applications using containers. Containers are lightweight, portable, and self-contained environments that can run on any machine, without the need for any specific software or hardware. Docker allows developers to package their applications and all their dependencies into a single container, which can be easily deployed on any system that has Docker installed.

### Watchtower
Watchtower is an open-source tool that automates the process of updating Docker containers. It continuously monitors running Docker containers and automatically updates them to the latest available image on the Docker Hub or a private registry. Watchtower is particularly useful in environments where it is necessary to keep up with the latest security patches and bug fixes, or when new features need to be rolled out quickly. With Watchtower, developers can focus on writing code and let the tool take care of updating containers.

Now that you have a brief idea about Docker and ScriptServer, let's dive into the details of the features of this script.

## Our collection of Scripts
These scripts provides a simple yet powerful interface for managing Watchtower in order to keep your Docker images up-to-date. It utilizes the ScriptServer interface to provide the following features:

- Check for updates: This feature allows you to check for new updates for your Docker images, and manually push updates as required. The script will fetch new updates for your images and present them in a list, where you can select the ones you want to update.

- Force update: In some cases, you may want to manually push an update to an image that has a pending update. The script allows you to manually select an image from the list and push the update.

- Image cleanup: Docker images can take up a significant amount of disk space if they are not cleaned up regularly. This feature allows you to clean up any images that are not being used, which can help recover valuable disk space.

- Watchtower Scheduler: Watchtower can be configured to automatically update your Docker images on a regular basis. This feature allows you to install, reinstall or pull a new update from Watchtower, and set the automatic update schedule.

## Requirements
1. In order to use these scripts, you will need to have *Docker* installed on your system. 
2. You will also need to have *ScriptServer* installed, which is a lightweight server that allows you to run scripts with a simple HTTP request.
You can find ScriptServer on GitHub at https://github.com/bugy/script-server/

The scriptserver runners options are located in: `/opt/script-server/conf/runners`. 
The scripts that the runners use for their different features are located in: `/opt/script-server/conf/scripts`.
The configuration ini files should be placed in: /opt/script-server/conf

> Note:  is not compatible with the script-server docker install.
