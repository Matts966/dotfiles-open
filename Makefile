CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .ssh .github
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help
SHELL := $(shell which bash)

.PHONY: list
list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

.PHONY: update
update: ## Fetch changes for this repo
	git pull origin main

.PHONY: install
install: update ## Run make update, deploy and init
	make --jobs all

.PHONY: clean
clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)

.PHONY: all
all: deploy init secret

.PHONY: deploy
deploy: ## Create symlink to home directory
	@echo 'Symlink dot files in your home directory...'
	@$(foreach val, $(DOTFILES), ln -sfFnv $(abspath $(val)) $(HOME);)
	mkdir -p ~/.config/karabiner && ln -sfFnv $(abspath karabiner.json) ~/.config/karabiner
	mkdir -p ~/.config/kitty && ln -sfFnv $(abspath kitty)/* ~/.config/kitty
	mkdir -p ~/.config/spotify-tui && ln -sfFnv $(abspath spotify-tui)/* ~/.config/spotify-tui
	mkdir -p ~/.config/nvim && ln -sfFnv $(abspath init.vim) ~/.config/nvim
	ln -sfFnv $(abspath pycodestyle) ~/.config
	sudo ln -sfFnv $(abspath scripts/*) /usr/local/bin


.PHONY: init
init: mac bundle asdf brew ## Initialize installation
	sudo $(shell brew --prefix)/texlive/*/bin/*/tlmgr path add && \
		sudo tlmgr update --self --all && \
		sudo tlmgr install cm-super preprint comment ncctools latexmk \
			totpages xstring environ hyperxmp ifmtarg || true

.PHONY: secret
secret:
ifndef CI # Skip on github actions
	git submodule update --init
	(cd dotfiles-secret && make)
endif

.PHONY: asdf
asdf: zsh ~/.zinit parallel asdf-dep
	$(eval SHELL := zsh)
	. ~/.zshrc && cut -d' ' -f1 .tool-versions | \
		while read plugin ; do \
			asdf plugin add $$plugin; asdf install $$plugin & \
		done && wait && \
	mkdir -p $(HOME)/.config/bat/themes && \
	ln -sfFnv $(abspath iceberg.tmTheme) $(HOME)/.config/bat/themes && \
	bat cache --build

.PHONY: asdf-dep
asdf-dep: brew
	brew install coreutils gawk gnupg

.PHONY: mac
mac: asdf
ifeq  ($(shell uname),Darwin)
ifndef CI # Skip on github actions
	gh -R televator-apps/vimari release download -p Vimari.app.zip
	unzip Vimari.app.zip && gomi -s /Applications/Vimari.app
	mv -f Vimari.app /Applications && open /Applications/Vimac.app
	gomi -s Vimari.app.zip
	open https://apps.apple.com/app/ghosttext/id1552641506
	open "https://appcenter-filemanagement-distrib1ede6f06e.azureedge.net/7372ab44-0d76-48fb-b4c9-f9aa97aedc2d/Vimac_distribution.zip?sv=2019-02-02&sr=c&sig=WXWZBSXlBU488%2FatDModyJyjg4s0iA3yenjFkDcYn5k%3D&se=2021-03-24T12%3A13%3A46Z&sp=r&download_origin=appcenter"
endif
	open Iceberg.terminal
	defaults write com.apple.terminal "Startup Window Settings" "Iceberg"
	defaults write com.apple.terminal "Default Window Settings" "Iceberg"
endif

.PHONY: brew
brew:
	which brew || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: parallel
parallel: brew
	brew install parallel

.PHONY: bundle
bundle: parallel asdf-dep # Wait for installation of asdf deps by brew
	cat Brewfile | grep ^tap | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew tap ::: || true
	cat Brewfile | grep ^brew | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew install ::: || true
	cat Brewfile | grep ^cask | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew install --cask ::: || true
ifeq  ($(shell uname),Linux)
	brew install texlive
endif
	brew bundle || true

.PHONY: zsh
zsh:
ifeq  ($(shell uname),Linux)
	sudo apt-get update; sudo apt-get install -y zsh; sudo chsh -s /usr/bin/zsh
endif

~/.zinit:
	# Install zinit
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

.PHONY: help
help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
