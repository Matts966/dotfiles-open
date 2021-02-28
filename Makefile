CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .ssh
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)
.PHONY: list

deploy: ## Create symlink to home directory
	@echo 'Symlink dot files in your home directory...'
	@$(foreach val, $(DOTFILES), ln -sfFnv $(abspath $(val)) $(HOME);)
	mkdir -p ~/.config/karabiner && ln -sfFnv $(abspath karabiner.json) ~/.config/karabiner
	mkdir -p ~/.config/kitty && ln -sfFnv $(abspath kitty)/* ~/.config/kitty
	mkdir -p ~/.config/spotify-tui && ln -sfFnv $(abspath spotify-tui)/* ~/.config/spotify-tui
	mkdir -p ~/.config/nvim && ln -sfFnv $(abspath init.vim) ~/.config/nvim
	ln -sfFnv $(abspath pycodestyle) ~/.config
.PHONY: deploy

update: ## Fetch changes for this repo
	git pull origin main
.PHONY: update

install: ## Run make update, deploy and init
	make --jobs all
.PHONY: install

all: update
	make deploy
	make init
	make secret
.PHONY: all

init: zsh pip yarn ## Initialize installation
	sudo $(shell brew --prefix)/texlive/*/bin/*/tlmgr path add && \
		sudo tlmgr update --self --all && \
		sudo tlmgr install cm-super preprint comment ncctools latexmk && \
			totpages xstring environ hyperxmp ifmtarg || true
	curl openlab.jp/skk/dic/SKK-JISYO.L.gz -o SKK-JISYO.L.gz && \
		gzip -d SKK-JISYO.L.gz && \
		mkdir -p ~/.skk && \
		mv SKK-JISYO.L ~/.skk/SKK-JISYO.L
	docker start google-ime-skk || docker run --name google-ime-skk \
		 -d --restart=always -d -p 55100:55100 matts966/google-ime-skk-docker || true
.PHONY: init

secret:
	git submodule update --init && \
		(cd dotfiles-secret && make) || true
.PHONY: secret

brew:
	which brew || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
		brew bundle || true && \
		mkdir -p $(HOME)/.config/bat/themes && \
		ln -sfFnv $(abspath iceberg.tmTheme) $(HOME)/.config/bat/themes && \
		bat cache --build
.PHONY: brew

zsh:
	# Install zinit
	which zinit || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
.PHONY: zsh

# glances installed via brew is broken.
# TODO: Use brew after the fix.
pip: brew
	pip3 install -r requirements.txt
.PHONY: pip

yarn: brew
	npm install --global yarn @marp-team/marp-cli
.PHONY: yarn

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
.PHONY: clean

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
