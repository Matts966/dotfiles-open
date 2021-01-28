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
	mkdir -p ~/.config/nvim && ln -sfFnv $(abspath init.vim) ~/.config/nvim
.PHONY: deploy

update: ## Fetch changes for this repo
	git pull origin main
.PHONY: update

install: update ## Run make update, deploy and init
	make deploy
	make init
	make secret
.PHONY: install

init: zsh pip ## Initialize installation
	ghq get https://github.com/sachaos/todoist.git && \
		cd ~/ghq/github.com/sachaos/todoist && make install
		sudo tlmgr update --self --all && \
		suto tlmgr install cm-super preprint comment ncctools latexmk
.PHONY: init

secret:
	git submodule update --init && \
		(cd dotfiles-secret && make) || true
.PHONY: secret

brew:
	brew bundle || true && \
		mkdir -p $(HOME)/.config/bat/themes && \
		ln -sfFnv $(abspath iceberg.tmTheme) $(HOME)/.config/bat/themes && \
		bat cache --build
.PHONY: brew

_zsh:
	# Install zplug
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh || true
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
	pip3 install -r requirements.txt
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
