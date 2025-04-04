CANDIDATES := $(wildcard .??*) $(wildcard dots/.??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml .ssh .github
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help
SHELL := $(shell which bash)

ifeq ($(shell uname),Linux)
export PATH := /home/linuxbrew/.linuxbrew/bin:$(PATH)
endif

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
	sudo ln -sfFnv $(abspath scripts/google) /usr/local/bin/google

.PHONY: init
init: mac bundle ~/.asdf skk nvim lazygit ## Initialize installation

.PHONY: skk
skk:
	curl openlab.jp/skk/dic/SKK-JISYO.L.gz -o SKK-JISYO.L.gz && \
    gzip -d SKK-JISYO.L.gz && \
    mkdir -p ~/.skk && \
    mv SKK-JISYO.L ~/.skk/SKK-JISYO.L

.PHONY: nvim
nvim: bundle
	nvim -c 'call DeinInstall()' -c 'q'
	nvim -c 'exe "silent! r!curl -sS https://raw.githubusercontent.com/neovim/neovim/v0.7.2/runtime/syntax/lua.vim"' -c 'w! ~/.config/nvim/syntax/lua.vim' -c 'q'

.PHONY: secret
secret:
ifndef CI # Skip on github actions
	git submodule update --init
	(cd dotfiles-secret && make)
endif

.PHONY: mac
mac:
ifeq ($(shell uname),Darwin)
	open Iceberg.terminal
	defaults write com.apple.terminal "Startup Window Settings" "Iceberg"
	defaults write com.apple.terminal "Default Window Settings" "Iceberg"

	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

	defaults write -g com.apple.trackpad.scaling 3
	defaults write -g KeyRepeat -int 2
	defaults write -g InitialKeyRepeat -int 15
	defaults write -g ApplePressAndHoldEnabled -bool false

	mkdir -p ~/Documents/Screenshots
	defaults write com.apple.screencapture target clipboard
	defaults write com.apple.screencapture name ""
	defaults write com.apple.screencapture show-thumbnail -bool false

	defaults write NSGlobalDomain AppleShowAllExtensions -bool true
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder ShowStatusBar -bool true

	sudo nvram StartupMute=%01

	osascript -e 'tell application "System Events" to make new login item at end with properties {name:"MonitorControl", path:"/Applications/MonitorControl.app", hidden:true}'
	osascript -e 'tell application "System Events" to make new login item at end with properties {name:"noTunes", path:"/Applications/noTunes.app", hidden:true}'
	osascript -e 'tell application "System Events" to make new login item at end with properties {name:"MonitorControl", path:"/Applications/MacGesture.app", hidden:true}'

	defaults write com.apple.dock persistent-apps -array && defaults write com.apple.dock "autohide" -bool "true" && killall Dock
	# sudo reboot
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
ifeq ($(shell uname),Linux)
	test -d /home/linuxbrew/.linuxbrew && eval '$(shell /home/linuxbrew/.linuxbrew/bin/brew shellenv)'
endif
	brew install parallel
	cat dots/.Brewfile | grep ^tap | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew tap ::: || true
	cat dots/.Brewfile | grep ^brew | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew install ::: || true
	cat dots/.Brewfile | grep ^cask | cut -d' ' -f2 | xargs echo \
		| xargs parallel brew install --cask ::: || true
	brew bundle --global || true

.PHONY: lazygit
lazygit: bundle
	\rm -rf "$(shell lazygit --print-config-dir)/config.yml" && mkdir -p "$(shell lazygit --print-config-dir)" && ln -sfFnv $(abspath lazygit/config.yml) "$(shell lazygit --print-config-dir)/"

.PHONY: zsh
zsh:
ifeq ($(shell uname),Linux)
	sudo apt-get update; sudo apt-get install -y zsh; sudo chsh -s /usr/bin/zsh
endif

# .ONESHELL: ~/.asdf
# ~/.asdf: bundle
# 	# Install asdf
# 	git clone https://github.com/asdf-vm/asdf.git ~/.asdf
# 	cut -d' ' -f1 dots/.tool-versions | xargs -L1 ~/.asdf/bin/asdf plugin add
# 	~/.asdf/bin/asdf direnv setup --shell zsh --version system

.PHONY: asdf
asdf: ## Initialization for asdf and dependencies
	cut -d' ' -f1 dots/.tool-versions | xargs -L1 asdf plugin add
	asdf direnv setup --shell zsh --version system
	mkdir -p $(HOME)/.config/bat/themes && \
		ln -sfFnv $(abspath iceberg.tmTheme) $(HOME)/.config/bat/themes && \
		asdf install rust && \
		asdf exec bat cache --build
	asdf install

.PHONY: help
help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
