.SILENT:

run: ## run flutter app
	flutter run --dart-define BASE_URL=localhost --target lib/main.dart

run-release: ## run flutter app in release
	flutter run --dart-define BASE_URL=herve-guigoz.com --release --target lib/main.dart

run-debug: ## debug mercure in production
	flutter run --dart-define BASE_URL=herve-guigoz.com --device-id macos --target lib/main_debug.dart

run-debug-dev: ## debug mercure in dev
	flutter run --dart-define BASE_URL=localhost --device-id macos --target lib/main_debug.dart

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help