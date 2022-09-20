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
- [**Common Docker Command Cheatsheet**](#common-docker-command-cheatsheet)
  - [**General Docker Commands**](#general-docker-commands)
  - [**Docker Container Commands**](#docker-container-commands)
  - [**Docker Run Options**](#docker-run-options)
- [**Docker Storage**](#docker-storage)
  - [**Docker Volumes**](#docker-volumes)
    - [**NFS Mount**](#nfs-mount)
  - [**Bind Mounts**](#bind-mounts)
  - [**Storage Cheatsheet**](#storage-cheatsheet)
- [**Docker Network**](#docker-network)
  - [**Defaults of a network**](#defaults-of-a-network)
  - [**Network Concepts**](#network-concepts)
  - [**Network Cheatsheet**](#network-cheatsheet)
- [**Dockerfile**](#dockerfile)
  - [**Dockerfile Common**](#dockerfile-common)
    - [**FROM**](#from)
    - [**LABEL**](#label)
    - [**WORKDIR**](#workdir)
    - [**RUN**](#run)
    - [**EXPOSE**](#expose)
    - [**ENV**](#env)
    - [**ENTRYPOINT**](#entrypoint)
  - [**Dockerfile skeleton**](#dockerfile-skeleton)
  - [**Building An Image**](#building-an-image)
  - [**Docker build Cheatsheet**](#docker-build-cheatsheet)
- [**Storage Drivers**](#storage-drivers)
  - [**Images and layers**](#images-and-layers)
  - [**Copy-on-write**](#copy-on-write)

<br>
<br>

--------------------------
# **Basics**

## **What is a container?**
Standard software that packages code, libraries, and dependencies, so an application can run quickly on many computing environments.

Container software technology sits on top of the host's Kernel, Hardware, Drivers, and Operating System. Within a container you will only find files that are needed to run that container or application including the container OS. 
Also, since containers share the host's Kernel, it removes "per OS" applications and "per OS" licensing (a Red Hat container does not need any kind of license and can run on an Ubuntu host).
> Containers work by leveraging the container technology to determine if a kernel is "compatible enough" to run the internal processes on the existing host. If a program makes an incompatible system call to the kernel, then that call fails.

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
An image is the basic building block of a container. It is the immutable layer of a container that has the bundled application with files and libraries. Before a container is ran, Docker will look for the image locally, if the container image is not found then docker will download the image. Manual downloads are done through the `docker image pull` command. The only requirement an image has for the host that it will be ran under is that it must be the same architecture; x86/64, ARM64, AMD64, i386.

> Base images are usually very small (\~80MB), while applications images can be over 1GB.

An image uses *layers* to to keep track of all changes and to modularize ***all*** containers. This prevents the necessity of re-downloading common aspects of images and to enable fast image builds by resuming from the last successful layer. Each layer is "named" by creating a hash of that layer and storing it locally.

> If the image `alpine:latest` is pulled it will download the 5.27MB image. If `apache:latest` is pulled afterwards, since the base image used is Alpine, only the layers that are not already present locally are created.

All images include a tag to determine the version or variation that is pulled. If no tag is specified during a push/pull command then `latest` is **always** assumed which is defined by the account that owns that image.

> `nginx:latest` can be different than `nginx:alpine`

The Docker image is the standard for how all industries create and define images called the **Open Container Image (OCI)** standard. 

<br>

### **Docker Registry**
External repository that docker images are stored by organizations or users. All images within a registry are **immutable** unless you are one of the official contributors to that image.

A "local" registry can be created to minimize the number of images that are pulled externally by using the `registry:2` Docker image.

* Officially published images are commonly labeled  as the "base" image name along with its tag `python:3.9`, `alpine:latest`, `mysql:latest`. 
* "Unofficial" images are labeled with the Docker Hub username, image name, then tag: `angrypanda/supersecuremysql:latest`

> For local registries, the naming convention is: server FQDN, image name, tag. `registryserver.my.domain.com/ubuntu:latest`

<br>

### **Docker Container**
Docker containers are just simply the Docker image that is currently running or has stopped but not deleted. Docker containers can be converted into images but it is just easier to build the image and test it.

Since containers are just processes, they are not meant to be persistent. The purpose of a container is to be thrown away and be ran anywhere else with zero issues. Thus, the "internal" files that run the container should be volatile, and only a limited amount of objects should be persistent. 

> Keep in mind that if you need to install a package in a container, the container must have access to that package repository/executable

When a container is ran:

1. Looks for the image locally in image cache
2. If not present, it will look for the image in the repository
   * Downloads the version specified (or "latest" if non given)
3. Creates a new *writable* layer on top of the image and prepares to start
4. Gives the container a virtual IP on a private network within the docker engine (not visible outside engine)
5. Executes specified options then starts the container

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
* The main difference between an application and a base image is that an application has an application command that is ran when the container is started and does not need additional intervention to start. While a base image is usually used to create an application image.


<br>
<br>

------------------------------

# **Common Docker Command Cheatsheet**
This will have some quick commands to reference. 

<br>

## **General Docker Commands**
| Command | Description |
| --- | --- |
| `docker version` | Check the version of docker client and server(daemon) and if they are talking |
| `docker info` | Get all of the docker engine and configuration info |
| `docker image history <IMAGE>` | The entire history of a single image including if layers were discovered |
| `docker image prune` | Remove Docker images and cached layers when building an image (called dangling images) |
| `docker image prune -a` | Remove dangling **and** unused images |
| `docker system df` | See space used by containers, build cache, images, and volumes|
| `docker system prune` | Clean up unused/dangling images |

<br>

## **Docker Container Commands**
| Command | Description |
| --- | --- |
| `docker container run <OPTIONS> <IMAGE:TAG(optional)>` | Simply run a Docker container |
| `docker container ls` | List all **running** containers. Add `-a` to see **unremoved stopped containers** (also use `docker ps -a`)|
| `docker container stop <ID/NAME>` | Stop a container. You can also just use the first few characters of an ID to stop it as long as it it unique from the others |
| `docker container rm <CONTAINER>` | Delete a stopped container manually |
| `docker container logs <CONTAINER>` | Get the last few lines generated by **all** logs |
| `docker container top <CONTAINER>` | Get the current running processes on a container |
| `docker container inspect <CONTAINER>` | Get the details of how a container is configured as JSON |
| `docker container stats` | Get performance stats on **all** containers in a real-time stream (You can also specify a container name) |
| `docker container start -ai <CONTAINER>` | Similar to the run command with `-it` but used on a **stopped** container |
| `docker container exec <CONTAINER> <COMMAND>` | Execute a command from within a container. If the container is running an application, you don't need to start the application first |
| `docker container exec -it <CONTAINER> bash` | Run an interactive bash from within a **running** container. Useful for containers that run an application |
| `docker container port <CONTAINER>` | Shows exposed ports and where traffic is being forwarded to on that host |
| `docker container cp <CONTAINER>:<SRC_PATH> <DEST_PATH>` | Copy files/folders from a container to local filesystem |
| `docker container cp <DEST_PATH> <CONTAINER>:<SRC_PATH>` | Copy files/folders from the local filesystem to a container |

<br>

## **Docker Run Options**
| Option | Description |
| --- | --- |
| `docker container run <OPTIONS> <IMAGE:TAG(optional)>` | Simply run a Docker container |
| `-it` | When container starts, launch an interactive terminal (`i` Interactive `t` simulate TTY). (**container shuts down when you exit**) |
| `--rm` | Delete the container when it stops |
| `-p <LOCAL_PORT>:<CONTAINER_PORT>` | Expose a specific port, or range of ports within the container (if local port is used you will get an error) |
| `--detach/-d` | Run the container in the background of the terminal session |
| `--name <NAME>` | Specify a container name |
| `--network <NETWORK_NAME>` | Attach container to a specific network at startup |
| `--mount source=<VOL_NAME>,target=<CONTAINER_DIR>` | Mount a Docker volume to a directory in the container |

<br>
<br>

---------------------------------

# **Docker Storage**
There are several ways of making data within a container persistent, the two most common ways are using Docker volumes and using bind mounts.

## **Docker Volumes**
Volumes are the preferred mechanism for persisting data generated by and used by Docker containers. It is completely OS agnostic and the volume only needs to be created using a docker command. 
Also, when volumes are used the data stored within it exists *outside* of the container lifecycle, while bind mounts can grow with the container.

* Volumes are easier to back up or migrate than bind mounts.
* You can manage volumes using Docker CLI commands or the Docker API.
* Volumes can be more safely shared among multiple containers.
* Volume drivers let you store volumes on remote hosts or cloud providers, to encrypt the contents of volumes, or to add other functionality.
* New volumes can have their content pre-populated by a container.

When a Docker volume is created all data is stored in the docker root directory. For Linux it is `/var/lib/docker/volumes`

> When starting a container, use the option: `--mount source=<VOL_NAME>,target=<CONTAINER_DIR>`

<br>

### **NFS Mount**
Using Docker volumes you can easily mount an NFS share to a container ***WITHOUT INSTALLING A PACKAGE***! Docker internal drivers take care of it. All you have to do is create a Docker volume that is attached to the NFS share and have the container use that Docker volume.

```bash
docker volume create --driver local \
    --opt type=nfs \
    --opt o=addr=<NFS_SERVER_IP>,rw \
    --opt device=:/path/to/dir \
    <VOL_NAME>
```

<br>

## **Bind Mounts**
Bind mounts simply mount a hosts directory to a container's. Although **most** cases will use Docker volumes, bind mounts are *perfect for local development* because the files within the host's bound directory are "live" within the container. So it is easy to go to that directory and make changes or commits that are immediately recognized by the container.

> To use a bind mount just specify the type as bind: `--mount type=bind,source=<HOST_DIR>,target=<CONTAINER_DIR>`

<br>

## **Storage Cheatsheet**
| Command | Description |
| --- | --- |
| `docker volume create <VOL_NAME>` | Create a new Docker volume |
| `docker volume ls` | List all Docker volumes |
| `docker volume rm <VOL_NAME>` | Remove a Docker volume |


<br>
<br>

---------------------------------

# **Docker Network**
Docker networks follow the philosophy of "batteries included; but removable". When a container is ran it should just "work", but you should also have a lot of power to modify how packets flow within containers. Thus, you will rarely ever modify the default networks of the Docker Engine.

All ports must be manually exposed to send/receive traffic on a container

However, Docker allows you to modify the default network setting of the virtual networks, or you can create a completely new virtual network. This is useful to get a better sense of the traffic flow of an application, or to further lock down the IP space used within (i.e. Your network already uses a 192.168.x.x address space and you want to make it more obvious that they are different).

<br>

## **Defaults of a network**
* Each container is connected to a private virtual network bridge (`bridge`/`docker0`)
* Each virtual network routes through NAT firewall on host IP managed my the Docker daemon to connect to the default interface.
* **ALL** containers that are ran in the same engine can talk to each other.

## **Network Concepts**
You can manually create any number of networks, but the defaults are usually enough to never touch it. Since Docker is secure by default, the "outside" can only see what you tell it to through exposed ports. 

> All containers that are in the same virtual network can talk to each other freely. So a NGINX server with an exposed port can talk to a PostgreSQL server that does not have any exposed ports

**Default Docker Networks:**
* `bridge`/`docker0` - Default for all containers. All internal and external traffic are NAT'ed behind the host's IP
* `host` - Bypass virtual network and directly attach to interface to gain performance. Sacrifices security model.
* `none` - Removes all interfaces from container and only leaves it with `localhost` interface to completely isolate container.

> If you create a network without specifying a driver, then it defaults to the bridge driver.

**DNS:**
* To communicate between containers you don't need the IP address or set static IP addresses
* Docker uses the container name as the hostname so containers can talk to each other without a "discovery"
  * You can manually set an alias to specify another name
* If multiple containers on a *created* network have the same alias, they can respond to the same alias using DNS round-robin

<br>

## **Network Cheatsheet**
| Command | Description |
| --- | --- |
| `docker network ls` | Show Docker networks |
| `docker network inspect <CONTAINER>\|<NETWORK>` | Show configurations of an entire network or of a container |
| `docker network create <NAME>` | Create a Docker network |
| `docker network connect\|disconnect <NETWORK> <CONTAINER>` | Attach/detach a network interface on a **running** container |
| `docker container inspect --format '{{ .NetworkSettings.IPAddress }}' <CONTAINER>` | Get the private IP assigned to a container |
| `docker network inspect --format '{{ .Containers }}' <NETWORK>` | Get all containers running on a specific network |
| `docker container run <OPTIONS> --net-alias <ALIAS_NAME> <IMAGE>` | Create a container and give it a DNS alias |

<br>
<br>

---------------------------------

# **Dockerfile**
A Dockerfile is a local file ( named `Dockerfile`) that is used as a recipe to create an image. **All images need a parent image to be created**. Podman can also use a Dockerfile but there are slight differences in how 

When you create a custom image, you also create additional layers on top of the original parent image. This is useful as parent images or custom images don't need to be modified in its entirety when creating a new image with additional items inside. 

> Each "Stanza" in a Dockerfile is its own layer. You can string multiple commands into a singe `RUN` stanza to instead create a single layer.

<br>

## **Dockerfile Common**

### **FROM**
**MANDATORY** stanza that uses a parent image as the base before additional layers are created on top of it. You can specify a official, unofficial, or local image as the base.

> Common option: `--platform=arm64`

```docker
FROM continuumio/miniconda3:latest
```

<br>

### **LABEL**
Add metadata to an image that can be used to identify custom components of your image. Labels are key-value pairs. 
To view the contents of a label simply inspect the container. 

`docker image inspect --format='' <IMAGE>` Inspect container in a JSON format.

> A layer is **not** created with each `LAYER` stanza

```docker
LABEL description="This text illustrates \
that label-values can span multiple lines."

LABEL multi.label1="value1" \
      multi.label2="value2" \
      other="value3"
```

<br>

### **WORKDIR**
Set the working directory for the build process and for any subsequent `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, and `ADD` stanzas. If the directory does not exist then it will be created.

```docker
WORKDIR /var/lib/httpd/
```

<br>

### **RUN**
Run a command in **shell**. Each `RUN` is its own layer so you can string several commands into one. 

> Uses `/bin/sh -c` by default.

> Use the bash **and** logical expression (`&&`) to fail and destroy the entire `RUN` layer

```docker
RUN yum update -y && \
    yum clean all && \
    rm -Rf /var/cache/yum && \
    rm -Rf /var/tmp/yum*
```

Since logging is handled by Docker you can send all logs for a specific application to stdout/err. This allows Docker to have a single location to where the logs are and can be easily seen. To do this simply create a symbolic link to the application logs

```docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
```

<br>

### **EXPOSE**
Instructs the **person** running the container image to expose the specific a port, set of ports, or port ranges to connect to the container external to the private network. It **acts as a "documentation**" to ensure that it is always known what ports and protocols to expose.

You can also specify if the port is TCP/UDP (By default it will always assume TCP). If you need both to be exposed then they must be named separately.

> To actually expose the port the container must be ran with the `-p <LOCAL_PORT>:<CONTAINER_PORT>` option 

> The syntax is always `<CONTAINER_PORT>/<OPTIONAL_PROTO>`

```docker
EXPOSE 443
EXPOSE 9090/udp
EXPOSE 80/tcp
EXPOSE 80/udp
```

<br>

### **ENV**
Set environment variables for building the image and when the container is running. You can check all of the environment variables by looking at the metadata.

```docker
ENV POSTGRES_PASSWORD='supersecure' \
    POSTGRES_USER='angrypanda' \
    POSTGRES_DB='alltransactions' \
    PGDATA='/var/lib/postgresql/data'
```

<br>

### **ENTRYPOINT**
An `ENTRYPOINT` allows you to configure a container that will run as an executable. Without it, you must run a command inside the container to start a service/script. 

`ENTRYPOINT ["executable", "param1", "param2"]`

> Example: a httpd container can start with `ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]` 

Only the last `ENTRYPOINT` instruction in the Dockerfile will have an effect

```docker
ENTRYPOINT ["/startup_script.sh", "-v"]
```

<br>
<br>

## **Dockerfile skeleton**

```docker
FROM <IMAGENAME>:<TAG>

WORKDIR <DIR>

LABEL custom.label.description="" \
    custom.label.parentImage="" \
    custom.label.arch="" \
    custom.label.entrypoint=""

RUN yum update -y && \
    yum clean all && \
    rm -Rf /var/cache/yum && \
    rm -Rf /var/tmp/yum*

RUN <COMMAND>

EXPOSE <CONTAINERPORT>

ENV <ENV_VAR1>=<VALUE> \
    <ENV_VAR2>=<VALUE>

ENTRYPOINT ["</PATH/TO/COMMAND", "<PARAM_1>". "<PARAM_2>"]
```

> To see the custom labels: `docker image inspect --format='.custom.label' <IMAGE>`

<br>

## **Building An Image**
To build an image you simply need to be in the local directory of the `Dockerfile` or tell it where the file is. All build commands are read from the `Dockerfile` top-down. Additional options past the tag are not required but highly encouraged.

When an image is being built it will create a local cache of each stanza so that only changed sections of the image are built while the others are called from the cache. This incredibly speeds up the image build time for minor changes.

**ALWAYS KEEP FREQUENTLY CHANGED ITEMS AS THE LAST STEP IN THE DOCKER FILE TO ENSURE FAST BUILD TIME**

> If you are publishing to a repository and *not* local, then you need to tag the image as: `<USERNAME>/<IMAGE>:<OPTIONAL_TAG>`

```bash
docker build -t primary_db . # Build from current dir and name the image with optional tag
docker build -t angrypanda/primary_db:postgres # Build and tag for a specific user
```

<br>

## **Docker build Cheatsheet**
| Option | Description |
| --- | --- |
| `--rm` | Remove any created cached layers that were created when building the image |
| `--no-cache` | Don't use previous successful layers and start from scratch |
| `--memory=<MAXIMUM>[m\|g]` | Set a *limit* for the amount of memory to use when building an image |

<br>
<br>

# **Storage Drivers**
Docker uses storage drivers to store image layers, and to store data in the writable layer of a container. 
The container’s writable layer does not persist after the container is deleted, but is suitable for storing ephemeral data that is generated at runtime.

Use Docker volumes for write-intensive data, data that must persist beyond the container’s lifespan, and data that must be shared between containers

<br>

## **Images and layers**
Each layer represents an instruction in the image’s Dockerfile. Each layer except the very last one is read-only.

Both adding, and removing files will result in a new layer. Because each layer is stacked on top of the previous one, if you delete a directory that was present in the previous layer the whole image will **not** be smaller because it existed before.

## **Copy-on-write**
If a file or directory exists in a lower layer within the image, and another layer (including the writable layer) needs read access to it, it just uses the existing file.

The first time another layer needs to modify the file (when building the image or running the container), the file is copied into that layer and modified. This minimizes I/O and the size of each of the subsequent layers

When you use docker pull to pull down an image from a repository, or when you create a container from an image that does not yet exist locally, each layer is pulled down separately, and stored in Docker’s local storage area.

> The `<missing>` lines in the docker history output indicate that those steps were either built on another system and part of the image that was pulled from Docker Hub, or were built with BuildKit as builder
