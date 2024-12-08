#!/bin/sh

NVIM_SOCKET=/tmp/neovide.socket
if [ ! -S $NVIM_SOCKET ]; then
    neovide --listen $NVIM_SOCKET $@
else
    neovide --server $NVIM_SOCKET $@
fi

# NVIM_SOCKET=/tmp/neovide.socket
# if [ ! -S $NVIM_SOCKET ]; then
#     nvim $@ --listen $NVIM_SOCKET
# else
#     nvim $@ --server $NVIM_SOCKET
# fi