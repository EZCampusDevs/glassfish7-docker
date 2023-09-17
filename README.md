
## Glassfish7 Docker

This repo is used to build a docker image to run [Glassfish7](https://projects.eclipse.org/projects/ee4j.glassfish/downloads).


## Building

Make sure you have `wget` or `curl`, and `unzip`.

Then in a unix-like environment run `build.sh`. This should download the Glassfish zip and store it in the cache folder, verify it's sha sum and build the docker image.

The resulting image should be called `glassfish7`.


## Usage

Using docker run, you will want to specify some arguments:

```sh
docker run --rm \
   -p 4848:4848 \
   -p 8080:8080 \
   -v "./autodeploy":/opt/app/glassfish7/glassfish/domains/domain1/autodeploy \
   -v "./apps":/opt/app/glassfish7/glassfish/domains/domain1/config/apps \
   glassfish7:latest
```

- Port `4848` is for the admin panel

- Port `8080` is for the API

- Volume `.../autodeploy` is for easy deployment of war files

- Volume `.../apps` will be located in the working directory of deployed war files

