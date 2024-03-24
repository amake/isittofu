SHELL := /usr/bin/env bash
override build_args += --web-renderer html

.PHONY: run
run: ## Run in debug mode
	flutter run $(build_args)

.PHONY: build
build: ## Build the web artifact
	flutter build web $(build_args) --base-href /

serve = cd $(1) && python3 -m http.server & pid=$$!; trap 'kill $$pid' EXIT

.PHONY: web-release-serve
web-release-serve: ## Serve the web release locally over HTTP
web-release-serve: build
	$(call serve,build/web); open http://localhost:8000 && wait

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
