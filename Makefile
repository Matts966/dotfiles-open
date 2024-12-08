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
	mkdir -p ~/.config/nvim && ln -sfFnv $(abspath init.vim) ~/.config/nvim
	mkdir -p ~/.config/direnv && ln -sfFnv $(abspath direnvrc) ~/.config/direnv
	mkdir -p ~/.config/neovide && ln -sfFnv $(abspath neovide/config.toml) ~/.config/neovide
	ln -sfFnv $(abspath pycodestyle) ~/.config
	sudo ln -sfFnv $(abspath scripts/*) /usr/local/bin


.PHONY: init
init: mac bundle ~/.asdf skk neovide starbucks-daemon ## Initialize installation
	sudo $(shell brew --prefix)/texlive/*/bin/*/tlmgr path add && \
		sudo tlmgr update --self --all && \
		sudo tlmgr install cm-super preprint comment ncctools latexmk \
			totpages xstring environ hyperxmp ifmtarg || true
	mkdir -p $(HOME)/.config/bat/themes && \
		ln -sfFnv $(abspath iceberg.tmTheme) $(HOME)/.config/bat/themes && \
		bat cache --build || true

.PHONY: skk
skk:
	curl openlab.jp/skk/dic/SKK-JISYO.L.gz -o SKK-JISYO.L.gz && \
    gzip -d SKK-JISYO.L.gz && \
    mkdir -p ~/.skk && \
    mv SKK-JISYO.L ~/.skk/SKK-JISYO.L
	docker start google-ime-skk || docker run --name google-ime-skk \
		-d --restart=always --platform=linux/amd64 -p 127.0.0.1:55100:1178 lurdan/yaskkserv2:latest || true

.PHONY: neovide-daemon
neovide-daemon:
ifndef CI # Skip on github actions
	sudo cp dev.neovide.Neovide.plist ~/Library/LaunchAgents/dev.neovide.Neovide.plist
	sudo chown root:wheel ~/Library/LaunchAgents/dev.neovide.Neovide.plist
	sudo launchctl load ~/Library/LaunchAgents/dev.neovide.Neovide.plist || true
	# Skip for now as I use vscode-neovim a lot
	# launchctl start dev.neovide.Neovide || true
endif

.PHONY: neovide
ifeq  ($(shell uname),Darwin)
neovide: neovide-daemon ~/.asdf
	\rm -rf /Applications/Neovide.app
	(cd $(shell mktemp -d) && \
		git clone https://github.com/neovide/neovide && \
		cd neovide && cargo install cargo-bundle && \
		cargo bundle --release && \
		cp -r ./target/release/bundle/osx/Neovide.app /Applications/Neovide.app && \
		\rm -rf ./target/release/bundle/osx/Neovide.app)

else
	cargo install --git https://github.com/neovide/neovide
endif

.PHONY: secret
secret:
ifndef CI # Skip on github actions
	git submodule update --init
	(cd dotfiles-secret && make)
endif

.PHONY: mac
mac:
ifeq  ($(shell uname),Darwin)
	open Iceberg.terminal
	defaults write com.apple.terminal "Startup Window Settings" "Iceberg"
	defaults write com.apple.terminal "Default Window Settings" "Iceberg"

	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

	defaults write com.apple.screencapture location ~/Documents/Screenshots

	git submodule update --init iTerm2-Color-Schemes
	./iTerm2-Color-Schemes/tools/import-scheme.sh iTerm2-Color-Schemes/schemes/iceberg-dark.itermcolors
	cp com.googlecode.iterm2.plist ~/Library/Preferences/
endif

.PHONY: update-iterm-plist
update-iterm-plist:
	cp ~/Library/Preferences/com.googlecode.iterm2.plist com.googlecode.iterm2.plist

.PHONY: brew
brew:
	which brew || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: bundle
.ONESHELL: bundle
bundle: brew
ifeq  ($(shell uname),Linux)
	test -d /home/linuxbrew/.linuxbrew && eval '$(shell /home/linuxbrew/.linuxbrew/bin/brew shellenv)'
endif
	brew install parallel
	cat Brewfile | grep ^tap | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew tap ::: || true
	cat Brewfile | grep ^brew | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew install ::: || true
	cat Brewfile | grep ^cask | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew install --cask ::: || true
ifeq  ($(shell uname),Linux)
	brew install texlive --HEAD || true
	brew install --build-from-source texlive || true
endif
	brew bundle || true

.PHONY: zsh
zsh:
ifeq  ($(shell uname),Linux)
	sudo apt-get update; sudo apt-get install -y zsh; sudo chsh -s /usr/bin/zsh
endif

.ONESHELL: ~/.asdf
~/.asdf: bundle
ifeq  ($(shell uname),Linux)
	test -d /home/linuxbrew/.linuxbrew && eval '$(shell /home/linuxbrew/.linuxbrew/bin/brew shellenv)'
endif
	# Install asdf
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf
	cut -d' ' -f1 .tool-versions | xargs -L1 ~/.asdf/bin/asdf plugin add
	~/.asdf/bin/asdf direnv setup --shell zsh --version system

.PHONY: help
help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
