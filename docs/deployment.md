# Deployment

## Review apps

When you raise a pull request in GitHub an Action will create a review app in AKS so that you can preview your changes in a production-like environment (or present changes to other team members ahead of merging). When the review all is built a comment will be posted to the PR with a link to the app.

## Deploying to production

A merged pull request will deploy **to dev, test and production**.

## Deploying to dev/test manually

On occasion it can be useful to manually deploy to dev/test ahead of production. In order to do this you need to raise your PR and wait for the checks to complete. As part of these checks a Docker image will be pushed; you need to [find your image](https://github.com/DFE-Digital/get-into-teaching-app/pkgs/container/get-into-teaching-frontend) and note the SHA.

To deploy you can go to GitHub Actions -> SHA Release -> Run Workflow. You can then select the target environment and enter your Docker image SHA to deploy. Be aware that if another pull request is merged after you do this it will overwrite whatever you have deployed.
