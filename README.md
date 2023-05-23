
## Glassfish7 Docker

This repo is used to build a docker image to run [Glassfish7](https://projects.eclipse.org/projects/ee4j.glassfish/downloads).


### Usage (with Make)

Ensure you have docker installed, then from the root of the repo run:
```sh
$ make build
```


### Usage (manually)

Since I was haiving some issues with using the auto build on the vps, this is here in case of that.

Download Glassfish:
```sh
$ wget -O glassfish.zip https://download.eclipse.org/ee4j/glassfish/glassfish-7.0.4.zip
```

Unzip the contents into the folder `glassfish`:
```sh
$ unzip -d glassfish glassfish.zip
```

Build the docker image:
```sh
$ docker build -t glassfish7 .
```


### Using the image

Once you've built the image use the name `glassfish7` to create containers:
```sh
$ docker run -itr --rm -p 4848:4848 -p 8080:8080 glassfish7
```
