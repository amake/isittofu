SHELL := /usr/bin/env bash
override build_args += --web-renderer html
flutter := $(shell command -v fvm) flutter

.PHONY: run
run: ## Run in debug mode
	$(flutter) run $(build_args)

.PHONY: build
build: ## Build the web artifact
	$(flutter) build web $(build_args) --base-href /

.PHONY: build-release
build-release: ## Build the web artifact for release
build-release: build_args += --release
build-release: build

port := 8080
serve = python3 -m http.server --directory $(1) $(port) & trap "kill $$!" EXIT

.PHONY: web-release-serve
web-release-serve: ## Serve the web release locally over HTTP
web-release-serve: build
	$(call serve,build/web); open http://localhost:$(port) && wait

.PHONY: test
test: ## Run tests
test: lint test-unit test-integration

.PHONY: lint
lint: ## Run linter
	$(flutter) analyze

.PHONY: test-unit
test-unit: ## Run unit tests
	$(flutter) test

env := .env

$(env):
	python3 -m venv $(@)
	$(@)/bin/pip install shot-scraper
	$(@)/bin/shot-scraper install

.PHONY: test-integration
test-integration: ## Run integration tests
test-integration: clean build-release | $(env)
	$(call serve,build/web); $(env)/bin/shot-scraper 'http://localhost:$(port)?q=a' \
		--wait-for 'document.querySelector("flutter-view")' \
		-o $(@).png \
		--log-console 2>&1 \
	| awk '/Failed/ {f++}; {print}; END {exit f}'

.PHONY: clean
clean: ## Clean up build artifacts
	$(flutter) clean

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
