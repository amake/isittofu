.PHONY: web-release-serve
web-release-serve: ## Serve the web release locally over HTTP
web-release-serve:
	flutter build web
	cd build/web; python3 -m http.server

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
