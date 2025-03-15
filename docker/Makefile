PROJECT_MODE ?= dev
PROJECT_NAME ?= avs-cms-$(PROJECT_MODE)

ifeq ($(PROJECT_MODE), prod)
DOCKER_COMP = \
	IMAGE_NAME=$(PROJECT_NAME) \
	docker compose -p $(PROJECT_NAME) -f compose.yaml -f compose.prod.yaml
else
DOCKER_COMP = \
	IMAGE_NAME=$(PROJECT_NAME) \
	docker compose -p $(PROJECT_NAME) -f compose.yaml -f compose.override.yaml
endif

.DEFAULT_GOAL = help
.PHONY        : help build up down

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker compose in detached mode (no logs)
	@$(DOCKER_COMP) up --detach --wait

down: ## Stop the docker compose
	@$(DOCKER_COMP) down --remove-orphans
