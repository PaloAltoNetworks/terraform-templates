## PANW Cloud Automation Container

This is the PaloAltoNetworks cloud automation container. The container includes
all the tools and scripts needed to automatically deploy the PANW cloud infrastructure.

### How to build the container

This image is on Dockerhub at [`gunjan5/terraform_ansible`](https://hub.docker.com/r/gunjan5/terraform_ansible/) if you don't want to build it locally. 
Run the following command to pull the image.

`docker pull gunjan5/terraform_ansible:latest`

```
Note: 
    You'll need to have docker installed on your machine to build the image.
    Follow the [Docker install docs](https://docs.docker.com/install/) for more details.
```

Run the following command to build this container image.

`docker build -t <repo>/terraform_ansible:latest .`
```
         ^    ^   ^           ^            ^    ^
         |    |   |           |            |    | 
         |    |   |           |            |    \-- Path to Dockerfile (current directory in our case)
         |    |   |           |            \------- Version of the container image (`latest` by default)
         |    |   |           \-------------------- Name of the container image 
         |    |   \-------------------------------- Container repo name. It's usually your username in 
         |    |                                     Dockerhub (`gunjan5` for example, or anything if
         |    |                                     it's a local image)
         |    \------------------------------------ The flag to tell Docker we're bulding and tagging
         |                                          this image
         \----------------------------------------- Argument to tell Docker to build this image
```

This command assumes the Dockerfile (that's in this drectory) is in your current directory.
If not, you can specify the path to it instead of the `.` at the end.

```
Note: 
    You'll have to build (and optionally, push) the image whenever you want the latest
    version of the tools/scripts.
```


### (Optional) Push the image to container registry

You can push the container image to your favorite container registry (Dockerhub, gcr.io, quay.io, gitlab, etc.)

To push it to your registry, run the following command:

`docker push <repo>/terraform_ansible:latest`

