bloom_filter_data := $(wildcard lib/data/*.txt)
bloom_filter_src := $(bloom_filter_data:.txt=.g.dart)
bloom_filter_probability := 0.01

.PHONY: gen
gen: ## Generate source
gen: $(bloom_filter_src)

$(bloom_filter_src): $(bloom_filter_data) | pub
	flutter pub run bloom_filter_builder:generate_bloom_filter \
		-p $(bloom_filter_probability) \
		$(^)

.PHONY: clean
clean: ## Delete generated files
clean:
	find lib -name '*.g.dart' -delete

.PHONY: pub
pub: pubspec.lock .dart_tool/package_config.json

.dart_tool/package_config.json pubspec.lock: pubspec.yaml
	flutter pub get

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
