# **Docker**

![docker logo](https://www.docker.com/wp-content/uploads/2022/03/horizontal-logo-monochromatic-white.png "Docker")

- [**Docker**](#docker)
- [**Basics**](#basics)
  - [**What is a container?**](#what-is-a-container)
  - [**What is Docker?**](#what-is-docker)
    - [**Docker Image**](#docker-image)
    - [**Docker Registry**](#docker-registry)
    - [**Docker Container**](#docker-container)
  - [**Docker Main Points**:](#docker-main-points)
- [**Basic Command Cheatsheet**](#basic-command-cheatsheet)
  - [**Frequent**](#frequent)
  - [** Docker Run**](#-docker-run)
  - [**Docker Build**](#docker-build)
  - [**Docker Image**](#docker-image-1)
- [**Dockerfile**](#dockerfile)
  - [**Dockerfile Cheatsheet**](#dockerfile-cheatsheet)
- [**Docker Volumes**](#docker-volumes)
  - [**Volumes Cheatsheet**](#volumes-cheatsheet)
- [**Docker Network**](#docker-network)
  - [**Network Cheatsheet**](#network-cheatsheet)

<br>
<br>

--------------------------
# **Basics**

## **What is a container?**
Standard software that packages code, libraries, and dependencies, so an application can run quickly on many computing environments.

Container software technology sits on top of the host's Kernel, Hardware, Drivers, and Operating System. Within a container you will only find files that are needed to run that container or application including the container OS. 
Also, since containers share the host's Kernel, it removes "per OS" applications and "per OS" licensing (a Red Hat container does not need any kind of license and can run on an Ubuntu host).
> Containers work by leveraging the container technology to determine if a kernel is "compatible enough" to run the internal processes on the existing host's OS. If a program makes an incompatible system call to the kernel, then that call fails.

<br>

Containers are widely used as they provide several services natively:
* **Secure**: The entire container environment is isolated and you only expose specific ports and directories.
* **Application Concurrency**: You can run different versions of a single piece of software within a single host.
* **Portable**: A container image can be quickly sent to another host and without any additional configurations can be ran.

<br>

**Container Vs. VMs:** VMs virtualize at the hardware level and completely mimic a system. A container virtualizes the OS level by sharing its host's kernel then layering files needed to run on top of it.

<br>
<br>

## **What is Docker?**
Docker is a platform that enables fast software development by creating a repeatable process called "Build, Ship, Run". Docker uses a service daemon that is "always running" to monitor the health and the configuration of the entire environment including volumes and networks. The daemon that is ran is called the **Docker Engine** and is installed alongside **containerd.io**.
Docker creates a universal packaging to bundle applications dependencies within a container to allow for the Docker Engine to run that application on almost any host.

Docker primary Innovations for development:
* Docker Image
* Docker Registry 
* Docker Container

Docker has created the industry standard for how images are created and how containers are executed.

<br>

### **Docker Image**
An image is the basic building block of a container. It is the "Gold Copy" of a container that has the bundled application with files and libraries. All images **are downloaded locally** from a central registry before they are ran. Manual downloads are done through the `docker image pull` command

An image uses *layers* to to keep track of all changes and to modularize ***all*** containers. This prevents the necessity of re-downloading common aspects of images and to enable fast image builds by resuming from the last successful layer. 
Each layer is "named" by creating a hash of that layer and storing it locally.
> If the image `alpine:latest` is pulled it will download the 5.27MB image. If `apache:latest` is pulled afterwards, since the base image used is Alpine, only the layers that are not already present locally are created.

* All images include a tag to determine the version and variation that is pulled. If no tag is specified during a push/pull command then `latest` is **always** assumed.

The Docker image is the standard for how all industries create and define images called the **Open Container Image (OCI)** standard. 

<br>

### **Docker Registry**
External repository that docker images are stored. A "local" registry can be created to minimize the number of images that are pulled externally by using the `registry:2` Docker image.
* Officially published images are commonly labeled  as the "base" image name along with its tag `python:3.9`, `alpine:latest`, `mysql:latest`. 
* "Unofficial" images are labeled with the Docker Hub username, image name, then tag: `angrypanda/supersecuremysql:latest`

> For local registries, the naming convention is: server FQDN, image name, tag. `registryserver.my.domain.com/ubuntu:latest`

<br>

### **Docker Container**
Docker containers are just simply the docker image that is currently running or has stopped but not deleted. Docker containers can be converted into images but it is just easier to build the image and test it.

Since containers are closer to processes, they are not meant to be persistent. The purpose of a container is to be thrown away and be ran anywhere else with zero issues. Thus, the "internal" files that run the container should be volatile, and only a limited amount of objects should be persistent. 

> Keep in mind that if you need to install a package in a container, the container must have access to that package repository

As soon as a container is ran, docker.. network

<br>
<br>

-------------------------------

## **Docker Main Points**:
* **Image** - Binaries, libraries, and source code used that make up the application
* **Container** - Instance of an image that is currently running a process
* **Registry** - Repository of images that is remote (but you can make a server if wanted)
* When you don't have an image specified, docker will always download it locally
* Each time you run a container you get a unique alp/num container ID
* Every time docker runs a container a new instance will be created and will stay on the system until removed
* Docker also generates the container name unless you tell it otherwise
* Docker images work off of **layers**. If a layer already exists between different versions of an image or even between images, Docker will instead download the layer that is needed
* Docker containers are given a virtual IP on a private network w/n the engine
* When a application image is ran (postgres, httpd, nginx) by default it executes the command needed to run, and will continue to run unless you specify for it to stop. 
  * When you do a `-it` the command is switched to a shell and if you exit the container will stop
* If a container is running an application, simply attaching a session to it will only execute commands within that application
  * i.e. a postgres container will already be running the Postgres *commandline session*, so you cant run commands like `/bin/systemctl status postgresql` but you **can** run `\l` which is a postgres commandline meta-command
* A layer is a simple tarball that is hashed to ensure integrity and metadata.


<br>
<br>

------------------------------

# **Basic Command Cheatsheet**
This will have some quick commands to reference. 

## **Frequent**
| Command | Description |
| --- | --- |
| `docker version` | Check the version of docker client and server(daemon) and if they are talking |
| `docker info` | Get all of the docker engine and configuration info |
| `docker container run <OPTIONS> <IMAGE:TAG(optional)>` | Simply run a Docker container |
| `docker container ls` | List all **running** containers. Add `-a` to see **unremoved stopped containers** |
| `docker container stop <ID/NAME>` | Stop a container. You can also just use the first few characters of an ID to stop it as long as it it unique from the others |
| `docker container rm <CONTAINER>` | Delete a stopped container manually |
| `docker container logs <CONTAINER>` | Get the last few lines generated by **all** logs |
| `docker container top <CONTAINER>` | Get the current running processes on a container |
| `docker container inspect <CONTAINER>` | Get the details of how a container is configured as JSON |
| `docker container stats` | Get performance stats on **all** containers in a real-time stream (You can also specify a container name) |
| `docker container start -ai <CONTAINER>` | Similar to the run command with `-it` but used on a **stopped** container |
| `docker container exec <CONTAINER> <COMMAND>` | Execute a command from within a container. If the container is running an application, you don't need to start the application first |
| `docker container exec -it <CONTAINER> bash` | Run an interactive bash from within a **running** container. Useful for containers that run an application |

<br>

## ** Docker Run**
| Command | Description |
| --- | --- |
| `docker container run <OPTIONS> <IMAGE:TAG(optional)>` | Simply run a Docker container |
| Option `-it` | When container starts, launch an interactive terminal (`i` Interactive `t` simulate TTY). (**container shuts down when you exit**) |
| Option `--rm` | Delete the container when it stops |
| Option `-p <LOCALPORT>:<CONTAINERPORT>` | Expose a port within the container (if local port is used you will get an error) |
| Option `--detach/-d` | Run the container in the background of the terminal session |
| Option `--name <NAME>` | Specify a container name |

<br>

## **Docker Build**
| Command | Description |
| --- | --- |

<br>

## **Docker Image**
| Command | Description |
| --- | --- |

<br>
<br>

---------------------------------

# **Dockerfile**
A Dockerfile is a local file that is used as a recipe to create an image. **All images need a parent image to be created**. 
<br>

## **Dockerfile Cheatsheet**
| Stanza | Description |
| --- | --- |

<br>
<br>

---------------------------------

# **Docker Volumes**

<br>

## **Volumes Cheatsheet**
| Command | Description |
| --- | --- |

<br>
<br>

---------------------------------

# **Docker Network**

<br>

## **Network Cheatsheet**
| Command | Description |
| --- | --- |
