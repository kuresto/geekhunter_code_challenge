WORKSPACE_CONTAINER=abundantia_app

help: ## make [target]
	@echo ""
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@echo

copy-keys: # Copy your ssh keys for third party purposes
	mkdir -p .keys
	cp ~/.ssh/id_rsa ./.keys/id_rsa

install-dependencies: ## Install composer dependencies
	@echo "--> Installing composer dependencies locally"
	composer install -v

build: copy-keys install-dependencies ## Build Docker image for tests
	@echo "--> Build Docker image for tests."
	docker-compose --file docker/development/docker-compose.yml build

build-no-cache: copy-keys install-dependencies ## Build docker image without cache
	@echo "--> Build Docker image for tests."
	docker-compose --file docker/development/docker-compose.yml build --no-cache

up: ## Up docker containers
	@echo "--> Docker up."
	docker-compose --file docker/development/docker-compose.yml up -d

stop: ## Stop all containers
	@echo "--> Docker stop."
	docker-compose --file docker/development/docker-compose.yml stop

up-no-cache: # Up docker containers from zero
	@echo "--> Docker up."
	docker-compose --file docker/development/docker-compose.yml up --force-recreate

test: ## Run all tests (pytest) inside docker.
	@echo "--> Testing on Docker."
	docker-compose --file docker/development/docker-compose.yml run --rm test py.test -s --cov-report term --cov-report html

bash: ## Run bash for container.
	@echo "--> Starting bash"
	docker-compose --file docker/development/docker-compose.yml run --rm $(WORKSPACE_CONTAINER) bash