.SILENT:

install: ## Install project
	docker-compose pull
	docker-compose up --build -d

start: ## Start project
	docker-compose up -d --remove-orphans --no-recreate

stop: ## Stop project
	docker-compose stop

reset: ## Reset all installation (use it with precaution!)
	docker-compose kill
	docker-compose down --volumes --remove-orphans
	make install

back-ssh: ## Connect to the container in ssh
	docker exec -it cocook_php sh

back-db-schema-update: ## Update database schema
	docker-compose exec cocook_php bin/console doctrine:migrations:migrate --no-interaction

back-db-reset: ## Reset the database with fixtures data
	docker-compose exec cocook_php bin/console hautelook:fixtures:load --no-interaction --purge-with-truncate

back-db-schema-reset: ## Drop the database and run migrations
	docker-compose exec cocook_php bin/console doctrine:database:drop --force
	docker-compose exec cocook_php bin/console doctrine:database:create
	docker-compose exec cocook_php bin/console doctrine:migrations:migrate --no-interaction
	docker-compose exec cocook_php bin/console doctrine:schema:validate

back-db-full-reset: ## Drop the database, run migrations and hydrate the database with fixtures data
	make back-db-schema-reset
	make back-db-reset
 
docs: ## Export swagger documentation
	docker-compose exec cocook_php bin/console api:openapi:export --output=swagger_docs.json

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help