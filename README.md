[![Build Status](https://travis-ci.org/jenca-cloud/jenca-cloud.svg?branch=master)](https://travis-ci.org/jenca-cloud/jenca-cloud)

# jenca cloud

Kubernetes based SaaS platform.

## Development

To develop Jenca cloud - you need as OSX or Linux machine.

#### install
First you need to install:

 * [VirtualBox version <=4.3](https://www.virtualbox.org/wiki/Download_Old_Builds_4_3)
 * [Vagrant](https://www.vagrantup.com/docs/installation/)

#### boot vm
To start the jenca development environment:

```bash
$ vagrant up
$ vagrant ssh
$ cd /vagrant
```

To start the Kubernetes cluster:

```bash
$ bash scripts/k8s.sh start
```

To stop the Kubernetes cluster:

```bash
$ bash scripts/k8s.sh stop
```

#### build images
Then you need to build to code into the Docker images:

```bash
$ make images
```

#### run tests
Once the images are built - you can run the tests:

```bash
$ make test
```

## Repos

Each service in jenca cloud uses it's own repository under the `jenca-cloud/` namespace.  This repo is the `glue` between all of these service repos.  In order to enable the repos to appear inside the development environment, you need to `git clone` the various repos inside the `repos` folder (which is git ignored).

```bash
$ make updatecode
```

This allows the development VM to see the various service repos and for the developer to still use their git credentials on the host to git commit/git push.

## Images

Each service will have a Makefile inside the repo that will have an `images` make step.  This will use `docker build` to create the jenca images from the various repos.  The `version` of these images is controlled by the VERSION variable at the top of each Makefile.


