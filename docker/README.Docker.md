# AVS CMS powered by Docker Compose

## Overview

This project uses Docker to simplify the deployment and management of the application. It employs `docker compose` with multiple configuration files (e.g., development and production) and a `Makefile` to streamline common tasks such as building, starting, and stopping containers. By leveraging `Makefile` commands, you can efficiently run the application in different environments without manually constructing complex `docker compose` commands.

---

## Prerequisites

- **Docker**: Make sure Docker is installed ([Get Docker](https://docs.docker.com/get-docker/)).
- **Docker Compose**: Docker Compose comes with Docker Desktop, or you can install it separately ([Install Docker Compose](https://docs.docker.com/compose/install/)).
- **Make**: Ensure that `make` is installed on your system ([Install Make](https://www.gnu.org/software/make/)).

---

## Deployment Environments

### Development
The development environment uses the `app_dev` image, which includes debugging tools like Xdebug and environment configurations optimized for development. It will also forward the database port for external connections. **This is the default mode if no additional configuration is provided**.

### Production
The production environment uses the `app_prod` image, a more secure and optimized build for use in live deployments. It includes the necessary configuration for performance but omits development-specific tools.

When running `make` commands for production mode, you **must** provide values for the following environment variables:

- **`MYSQL_ROOT_PASSWORD`**: This is the root password for the production database.
- **`MYSQL_PASSWORD`**: This is the password for the MySQL user.

---

## Configuration Details

- **Base Configuration**: `compose.yaml` contains the main configuration for the services, including essential definitions for the `server` and `database` containers.
- **Development Overrides**: `compose.override.yaml` is used in the development environment to provide additional context, such as extra hosts and database port exposure.
- **Production Overrides**: `compose.prod.yaml` is used for the production environment, with secure credentials and production-optimized settings.

---

## Environment Variables

The `Makefile` and `docker compose` configurations rely on the following environment variables:

| Variable              | Default Value (if applicable) | Description                                         |
|-----------------------|-------------------------------|-----------------------------------------------------|
| `IMAGE_NAME`          | `app`                         | Base name for the Docker image.                     |
| `IMAGE_TAG`           | `latest`                      | Tag for the Docker image.                           |
| `HTTP_HOST`           | `localhost`                   | HTTP hostname.                                      |
| `MYSQL_USER`          | `avscms`                      | MySQL database user.                                |
| `MYSQL_DATABASE`      | `avscms`                      | MySQL database name.                                |
| `MYSQL_PASSWORD`      | `password` (dev)              | MySQL user's password (MUST be set for production). |
| `MYSQL_ROOT_PASSWORD` | Not set by default            | Root password (MUST be set for production).         |
| `HTTP_PORT`           | `80`                          | Published HTTP port.                                |
| `DB_PORT`             | `3306`                        | Published database port.                            |

Override these values using `.env` files or by directly exporting environment variables on your system.

---

## How to Use

### 1. Build the Docker Images
To build the Docker images for your selected environment:

- **For default (development) mode**:
  ```bash
  make build
  ```

- **For production mode**:
  ```bash
  make build PROJECT_MODE=prod MYSQL_ROOT_PASSWORD=<your_root_password> MYSQL_PASSWORD=<your_user_password>
  ```

You **must** specify both `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` when running the `make` command in production mode.

---

### 2. Start the Services
To start the containers in detached mode (background), use:

- **For default (development) mode**:
  ```bash
  make up
  ```

- **For production mode**:
  ```bash
  make up PROJECT_MODE=prod MYSQL_ROOT_PASSWORD=<your_root_password> MYSQL_PASSWORD=<your_user_password>
  ```

---

### 3. Stop the Services
To stop and remove all running containers, execute:

- **For default (development) mode**:
  ```bash
  make down
  ```

- **For production mode**:
  ```bash
  make down PROJECT_MODE=prod MYSQL_ROOT_PASSWORD=<your_root_password> MYSQL_PASSWORD=<your_user_password>
  ```

---

### 4. Common Commands

| Command                          | Description                                                            |
|----------------------------------|------------------------------------------------------------------------|
| `make build`                     | Build Docker images for development mode (default).                    |
| `make build PROJECT_MODE=prod`   | Build Docker images for the production mode.                           |
| `make up`                        | Start services in development mode (default).                          |
| `make up PROJECT_MODE=prod`      | Start services in production mode (requires `MYSQL_ROOT_PASSWORD`).    |
| `make down`                      | Stop services in development mode (default).                           |
| `make down PROJECT_MODE=prod`    | Stop services in production mode (requires `MYSQL_ROOT_PASSWORD`).     |
| `make help`                      | Display available `Makefile` commands.                                 |

---

## Deployment Examples

### Development Deployment (Default)
1. Build and start the containers:
   ```bash
   make build
   make up
   ```

2. Access the application at: `http://localhost`.

3. Stop the services when you're done:
   ```bash
   make down
   ```

### Production Deployment
1. Build and start the containers in production mode:
   ```bash
   make build PROJECT_MODE=prod MYSQL_ROOT_PASSWORD=example_root MYSQL_PASSWORD=example_user
   make up PROJECT_MODE=prod MYSQL_ROOT_PASSWORD=example_root MYSQL_PASSWORD=example_user
   ```

2. Access the application at your configured host's URL.

3. Stop the services when necessary:
   ```bash
   make down PROJECT_MODE=prod MYSQL_ROOT_PASSWORD=example_root MYSQL_PASSWORD=example_user
   ```

---

## Files Overview

### Key Files and Their Roles

- **`compose.yaml`**: The base configuration defining the core services and their relationships.
- **`compose.override.yaml`**: Overrides for the development environment, adding debugging functionality and exposing ports.
- **`compose.prod.yaml`**: Production overrides, including secure configurations and optimized builds.
- **`Dockerfile`**: Multi-stage Dockerfile building `app_base`, `app_dev`, and `app_prod` images tailored for different environments.
- **`Makefile`**: Simplifies Docker Compose commands for building, starting, and stopping the containers.

---

## Maintenance Notes

1. **Defaults**:
    - If no `PROJECT_MODE` is specified, the default mode is `development`.
    - In development mode, no additional mandatory environment variables are required.
2. **Production Specifics**:
    - Set `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` when running commands in production mode.
    - Always back up the `db-data` Docker volume before making any production changes.

---

## Troubleshooting

### Common Issues

- **Database Connection Issues**: Ensure that `MYSQL_USER`, `MYSQL_PASSWORD`, and `MYSQL_DATABASE` variables are properly set and match across both the `server` and `database` services.
- **Missing Required Variables in Production**: Double-check that `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` are provided in production mode.
- **Permission Errors**: Verify that the `www-data` user owns the necessary files, especially in production mode.

### Debugging Tips

For real-time logging and debugging, you can start the containers interactively by omitting the `--detach` flag:
```bash
make up
```

Or, for production mode:
```bash
make up PROJECT_MODE=prod MYSQL_ROOT_PASSWORD=example_root MYSQL_PASSWORD=example_user
```

Logs will be displayed in the terminal for real-time output.
