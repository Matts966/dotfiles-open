CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .ssh
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)
.PHONY: list

deploy: ## Create symlink to home directory
	@echo 'Symlink dot files in your home directory...'
	@$(foreach val, $(DOTFILES), ln -sFnv $(abspath $(val)) $(HOME);)
	cp -nv karabiner.json ~/.config/karabiner/karabiner.json
.PHONY: deploy

update: ## Fetch changes for this repo
	git pull origin main
.PHONY: update

install: update deploy init ## Run make update, deploy and init
.PHONY: install

init: zsh hyper pip fzf ## Initialize installation
.PHONY: init

hyper:
	hyper i hyper-search
	hyper i hypercwd
	hyper i hyper-opacity
	hyper i hyper-tab-icons-plus
	hyper i hyper-statusline
	hyper i hyper-drop-file
.PHONY: hyper

brew:
	brew bundle || true
.PHONY: brew

_zsh:
	mkdir -p ~/.zsh/completion
.PHONY: _zsh

zsh: _zsh brew
	npm install --global filthy-prompt
	curl -o ~/.zsh/completion/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
	curl -o ~/.zsh/completion/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
	curl -o ~/.zsh/completion/_docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
.PHONY: zsh

# glances installed via brew is broken.
# TODO: Use brew after the fix.
pip: brew
	pip3 install glances
	pip3 install termdown
.PHONY: pip

clean: ## Remove the dot files and this repo
	@echo 'Remove dot files in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
.PHONY: clean

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
