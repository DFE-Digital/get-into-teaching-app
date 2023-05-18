# Codespaces

GitHub Codespaces is setup on the website repository and some content editors use this to make changes. 

You need to add the development secrets to your GitHub account before starting a Codespace:

1. Go to GitHub -> Settings
1. Select the 'Codespaces' section in the sidebar
1. Add secrets from your `.env.development` to the `get-into-teaching-app` repository
  * You only need the `GIT_API_TOKEN` secret to get the website booting

After spinning up a new Codespace you may need to wait around a minute for the `postCreateCommand` to run (its finished when you get the popup notification to say Postgres is running on port 5432); you should then be able to boot the website:

```
bin/dev
```
