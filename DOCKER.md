# Running sýnesis&trade; Lite for Syslog on Docker

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/robcowart)

## Setting up sýnesis&trade; Lite for Syslog on Docker

The easiest way to get sýnesis&trade; Lite for Syslog up and running quickly is to use Docker and docker-compose. The following instructions will walk you through setting up a single node installation of sýnesis&trade; Lite for Syslog on Docker.

> NOTE: These instructions assume that you will have a server available with a recent Linux distribution and both Docker and docker-composer installed.

## Prepare the Data Path

Data written within a container's file system is ephemeral. It will be lost when the container is removed. For the data to persist it is necessary to write the data to local host's file system using a _bind mount_. You must create a path on the local host, and set the necessary permissions for the processes within the container to write to it.

```
sudo mkdir /var/lib/synlite_es
sudo chown -R 1000:1000 /var/lib/synlite_es
```

## Customize Environment Variables in docker-compose.yml

While the provided defaults should allow you to get up and running quickly, you may need to make changes specific to your requirements. After copying the provided `docker-compose.yml` from the repository to the server, edit any relevant environment variables.

> The sýnesis&trade; Lite for Syslog Logstash container can be configured using the same environment variables discussed in `INSTALL.md`.

## Start the Elastic Stack using docker-compose

Start the Elastic Stack (incl. Logstash with the sýnesis&trade; Lite for Syslog pipeline) using `docker-compose`.

From the path where you placed the `docker-compose.yml` file run:

```
sudo docker-compose up -d
```

## Import Dashboards into Kibana

The Index Patterns, vizualizations and dashboards can be loaded into Kibana by importing the `synesis_lite_syslog.kibana.<VER>.json` file from within the Kibana UI. This is done from the `Management -> Saved Objects` page.

You may also want to configure the recommend advanced Kibana settings discussed in `INSTALL.md`.
