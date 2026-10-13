# Dev container & Codespaces

The repository ships a [dev container](https://containers.dev/) so that anyone —
developers and content editors alike — can run a full local copy of the website
without installing Ruby, Node, PostgreSQL or Redis themselves. Everything is
installed, configured and started for you.

You can use it two ways:

- **GitHub Codespaces** — runs in the cloud, nothing to install. Best for
  content editors.
- **VS Code on your own machine** — runs in Docker locally. Best for developers.

## Option 1: GitHub Codespaces (recommended for content editors)

1. On the repository page in GitHub, click **Code → Codespaces → Create
   codespace on `master`** (or on your branch).
2. Wait for it to build. The first build takes a few minutes while it installs
   everything; you can watch the progress in the terminal.
3. When setup finishes, the website starts automatically and a notification
   offers to open it in your browser. If you miss it, open the **Ports** panel
   and click the globe icon next to port **3000**.

### Secrets

The website boots against the shared test API using a token that is already
committed in `.env.development`, so no extra configuration is normally needed.
If you need to point at a different API, add the relevant values as
[Codespaces secrets](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces)
for the `get-into-teaching-app` repository.

## Option 2: VS Code dev container (recommended for developers)

Prerequisites:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (running)
- [Visual Studio Code](https://code.visualstudio.com/)
- The [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  extension

Steps:

1. Open the repository folder in VS Code.
2. When prompted, click **Reopen in Container** (or run **Dev Containers:
   Reopen in Container** from the command palette).
3. Wait for the build to finish. As with Codespaces, the website starts
   automatically and opens on port **3000** once everything is ready.

## What happens automatically

When the container is created it:

1. Installs the build tools and system libraries the app needs.
2. Installs the Ruby gems, JavaScript packages and prepares the database
   (create, migrate and seed) by running `bin/setup` — the same script used for
   local development.
3. Starts the app (Rails, the asset server and the background worker) via
   `bin/dev` as soon as setup has finished, and opens it in your browser on
   port 3000.

The first build takes a few minutes. Opening the container again later is fast
because everything is already installed.

## Starting and stopping the website

The website runs in the **Start Get Into Teaching** terminal (visible in the
terminal panel). To stop it, click into that terminal and press `Ctrl+C`. To
start it again, run:

```bash
bin/dev
```

## Viewing the database

The [PostgreSQL extension](https://marketplace.visualstudio.com/items?itemName=ms-ossdata.vscode-pgsql)
(`ms-ossdata.vscode-pgsql`) is installed automatically. To browse the database:

1. Open the **PostgreSQL** panel from the Activity Bar and add a connection.
2. Enter the following connection details:

   | Setting   | Value                                            |
   | --------- | ------------------------------------------------ |
   | Host      | `postgres`                                       |
   | Port      | `5432`                                           |
   | User      | `postgres`                                       |
   | Password  | `postgres`                                       |
   | Database  | `git_service_dev` (use `git_service_test` for the test database) |

These match the `DB_*` values set for the container in
[`.devcontainer/docker-compose.yml`](../.devcontainer/docker-compose.yml).

## Troubleshooting

- **The website didn't open.** Open the **Ports** panel and click the globe icon
  next to port 3000, or run `bin/dev` in a terminal.
- **A Ruby LSP error appears right after the container opens.** The editor can
  try to start before setup has finished installing gems. Wait for setup to
  complete, then run **Developer: Reload Window** from the command palette.
- **You changed something in `.devcontainer/`.** Run **Dev Containers: Rebuild
  Container** (use **Rebuild Without Cache** if you added system packages) so the
  changes take effect.

## For developers: how it's wired up

All configuration lives in [`.devcontainer/`](../.devcontainer):

- `devcontainer.json` — the Ruby/Node versions, VS Code extensions and settings,
  forwarded ports and the `postCreateCommand`.
- `docker-compose.yml` — the app, PostgreSQL and Redis services, plus the
  `DB_*` and `REDIS_URL` environment variables the app reads.
- `boot.sh` — runs once after the container is created: installs the locked
  Bundler version, runs `bin/setup`, and writes a "ready" marker when done.
- `start-app.sh` — launched by the **Start Get Into Teaching** task; waits for
  the ready marker, then runs `bin/dev`.

Forwarded ports: `3000` (website), `5432` (PostgreSQL) and `6379` (Redis).
