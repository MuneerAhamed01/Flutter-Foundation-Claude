# Uses FVM when installed (version pinned in .fvmrc), plain flutter otherwise.
FLUTTER := $(shell command -v fvm >/dev/null 2>&1 && echo "fvm flutter" || echo "flutter")
DART    := $(shell command -v fvm >/dev/null 2>&1 && echo "fvm dart" || echo "dart")

DEV  := --flavor dev  -t lib/main_dev.dart
PROD := --flavor prod -t lib/main_prod.dart

.PHONY: help setup gen watch clean analyze format test run-dev run-prod \
        apk-dev apk-prod aab-prod ipa-dev ipa-prod feature new-project flavors

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

setup: ## Install packages and run code generation
	$(FLUTTER) pub get
	$(DART) run build_runner build --delete-conflicting-outputs

gen: ## Run code generation once (freezed, json, retrofit)
	$(DART) run build_runner build --delete-conflicting-outputs

watch: ## Run code generation in watch mode
	$(DART) run build_runner watch --delete-conflicting-outputs

clean: ## Clean build outputs and re-setup
	$(FLUTTER) clean
	$(MAKE) setup

analyze: ## Static analysis
	$(FLUTTER) analyze

format: ## Format Dart code
	$(DART) format lib test

test: ## Run tests
	$(FLUTTER) test

run-dev: ## Run dev flavor
	$(FLUTTER) run $(DEV)

run-prod: ## Run prod flavor
	$(FLUTTER) run $(PROD)

apk-dev: ## Build dev APK
	$(FLUTTER) build apk $(DEV)

apk-prod: ## Build prod APK
	$(FLUTTER) build apk --release $(PROD)

aab-prod: ## Build prod App Bundle (Play Store)
	$(FLUTTER) build appbundle --release $(PROD)

ipa-dev: ## Build dev IPA
	$(FLUTTER) build ipa $(DEV)

ipa-prod: ## Build prod IPA (App Store)
	$(FLUTTER) build ipa --release $(PROD)

feature: ## Scaffold a feature: make feature name=reports
	./scripts/new_feature.sh $(name)

new-project: ## New app from this foundation: make new-project dest=../x pkg=x bundle=com.co.x name="X"
	./scripts/new_project.sh "$(dest)" "$(pkg)" "$(bundle)" "$(name)"

flavors: ## Re-generate native flavor config from flavorizr.yaml
	$(DART) run flutter_flavorizr -f
