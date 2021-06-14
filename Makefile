CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .ssh .github
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help
SHELL := $(shell which bash)

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
	sudo ln -sfFnv $(abspath scripts/*) /usr/local/bin
.PHONY: deploy

update: ## Fetch changes for this repo
	git pull origin main
.PHONY: update

install: update ## Run make update, deploy and init
	make --jobs all
.PHONY: install

all: deploy init secret
.PHONY: all

init: mac asdf ## Initialize installation
	sudo $(shell brew --prefix)/texlive/*/bin/*/tlmgr path add && \
		sudo tlmgr update --self --all && \
		sudo tlmgr install cm-super preprint comment ncctools latexmk && \
			totpages xstring environ hyperxmp ifmtarg || true
.PHONY: init

asdf: brew zsh
	zsh ~/.zshrc && cut -d' ' -f1 .tool-versions | sort \
  	| while read plugin ; do \
  			asdf plugin add $$plugin; asdf install $$plugin & \
  		done && wait && \
  mkdir -p $(HOME)/.config/bat/themes && \
		ln -sfFnv $(abspath iceberg.tmTheme) $(HOME)/.config/bat/themes && \
		bat cache --build
.PHONY: asdf

mac: asdf
ifeq  ($(shell uname),Darwin)
ifndef CI # Skip on github actions
	gh -R televator-apps/vimari release download -p Vimari.app.zip && \
		unzip Vimari.app.zip && gomi -s /Applications/Vimari.app && \
		mv -f Vimari.app /Applications && open /Applications/Vimac.app && \
		gomi -s Vimari.app.zip
	open https://apps.apple.com/app/ghosttext/id1552641506
	open "https://appcenter-filemanagement-distrib1ede6f06e.azureedge.net/7372ab44-0d76-48fb-b4c9-f9aa97aedc2d/Vimac_distribution.zip?sv=2019-02-02&sr=c&sig=WXWZBSXlBU488%2FatDModyJyjg4s0iA3yenjFkDcYn5k%3D&se=2021-03-24T12%3A13%3A46Z&sp=r&download_origin=appcenter"
endif
	open Iceberg.terminal
	defaults write com.apple.terminal "Startup Window Settings" "Iceberg"
	defaults write com.apple.terminal "Default Window Settings" "Iceberg"
endif
.PHONY: mac


secret:
	git submodule update --init && \
		(cd dotfiles-secret && make) || true
.PHONY: secret

brew:
	which brew || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
		brew bundle || true
.PHONY: brew

zsh:
	# Install zinit
	which zinit || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
.PHONY: zsh

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
.PHONY: clean

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
