# cloud-foundry-cli

Docker image containing all the tools for [zero-downtime
deploys](https://github.com/contraband/autopilot) to Cloud Foundry.


## Usage

`cf_deploy.sh` includes the steps needed to deploy.

    cf_deploy.sh  <app> <org> <space> [manifest.yml]

You must define a manifest file as per the autopilot plugin.


## Configuration

You'll want to set the following environment variables as per your Cloud Foundry instance. If unset, `cf_deploy.sh` will assume you have already setup the API and authentication via configuration files.

Env variable | Description | Example
--- | --- | ---
`CF_API` | The API endpoint for your Cloud Foundry instance.  | `https://api.fr.cloud.gov`
`CF_DEPLOY_USER` | The username for your Cloud Foundry deploy account.  | `my-deploy-user`
`CF_DEPLOY_PASSWORD` | The password for your Cloud Foundry deploy account.  | `super-secret-password`


## Maintainers

To build the image for Docker Hub, first make sure you're logged in.

    $ docker login

Then build and push the image.

    $ docker build -t adborden/cloud-foundry-cli:<version>
    $ docker push adborden/cloud-foundry-cli
