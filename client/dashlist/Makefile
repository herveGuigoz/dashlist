.SILENT:

include .env

run: ## run flutter app
	flutter run --dart-define BASE_URL=${BASE_URL} --target lib/main.dart

run-dev: ## run flutter app
	flutter run --dart-define BASE_URL=localhost

run-debug: ## debug mercure
	flutter run --dart-define BASE_URL=${BASE_URL} --target lib/main_debug.dart

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help