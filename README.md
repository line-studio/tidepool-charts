# Tidepool Charts

This repository is meant to hold custom charts for Tidepool. For more information, take a look at [Tidepool's development guide](https://github.com/tidepool-org/development), specifically the `charts/tidepool` directory for their own, development version.

## Local Setup

Before making changes to any of the values, copy the `values` directory as `values_local`, which won't be tracked by git, but will be tracked in Tilt for overrides. 

To have Tidepool up and running locally, do the following:

0. Make sure Docker is installed, and a local K8s cluster like Minikube, Kind or k3s.
    0.1. Install Tilt <br>
    0.2. Also make sure the `GHP_TOKEN` environment variable is defined with a Github Personal Access Token to be able to use private Github Packages (if developing locally, building the images and such, otherwise if using remote images, will not be needed)
1. Run `tilt up --port=10351 --file=Tiltfile.gloo` to boot up Gloo
2. Run `tilt up --port=10352 --file=Tiltfile.keycloak` to boot up Keycloak
3. Run `tilt up` to boot up the Tidepool application itself
4. Wait for everything to load (tip: check the Tilt UIs)
5. Go to http://localhost:3000
6. ... Profit?

### Database
If you want to use an internal database, set the `enabled` property in the mongo values file `values_local/mongo.yaml` to `true`.

For external databases, set the same property above to `false` and change your information accordingly in the `mongo.data_` property in the secrets values file `values_local/secrets.yaml`.

### Development
Currently, 4 of the repositories (Seagull, Shoreline, Blip and Jellyfish) are setup for file watching (lines 37-52 in `Tiltfile`). The repositories should be cloned into the same root folder (e.g., Line), like:
```
|--Line
|----tidepool-blip
|----tidepool-charts
|----tidepool-jellyfish
|----tidepool-seagull
|----tidepool-shoreline
| ...
```
If the `deployment.image` property in the values file is set to what is configured in the lines 37-52 mentioned above, then this will be enabled, otherwise nothing will happen.

If it is enabled, when you make a change to a file in the folders that are being watched, Tilt will deploy the new changes accordingly, either just copying the files, or rebuilding the docker image.
