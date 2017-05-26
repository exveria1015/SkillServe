.PHONY: all bundle zopfli brotli clean mod-clean clean-all

SRC_FILES = $(shell find frontend-src -type f)
WEBPACK = $(shell npm bin)/webpack
BROTLI = $(shell which bro brotli)
ZOPFLI = $(shell which zopfli)
OUTPUT_DIR = ./frontend-dist

all: bundle brotli zopfli
bundle: $(OUTPUT_DIR)/bundle.js
zopfli: $(OUTPUT_DIR)/bundle.js.br
brotli: $(OUTPUT_DIR)/bundle.js.gz

$(OUTPUT_DIR)/bundle.js: $(SRC_FILES) \
	webpack.config.js \
	node_modules

	env NODE_ENV=production $(WEBPACK) -p

$(OUTPUT_DIR)/bundle.js.br: $(OUTPUT_DIR)/bundle.js
	$(BROTLI) < $(OUTPUT_DIR)/bundle.js > $(OUTPUT_DIR)/bundle.js.br

$(OUTPUT_DIR)/bundle.js.gz: $(OUTPUT_DIR)/bundle.js
	$(ZOPFLI) $(OUTPUT_DIR)/bundle.js

node_modules: yarn.lock package.json
	yarn install
	touch -ma node_modules

clean-all: clean mod-clean

clean:
	rm -rf $(OUTPUT_DIR)

mod-clean:
	rm -rf node_modules