#!/bin/bash
data=(
golang.org/x/tools/cmd/guru
golang.org/x/tools/gopls
github.com/davidrjenni/reftools/cmd/fillstruct
github.com/rogpeppe/godef
github.com/fatih/motion
github.com/kisielk/errcheck
github.com/go-delve/delve/cmd/dlv
github.com/koron/iferr
golang.org/x/lint/golint
github.com/jstemmer/gotags
github.com/josharian/impl
golang.org/x/tools/cmd/goimports
github.com/golangci/golangci-lint/cmd/golangci-lint
github.com/fatih/gomodifytags
honnef.co/go/tools/cmd/keyify
golang.org/x/tools/cmd/gorename
github.com/klauspost/asmfmt/cmd/asmfmt
)

for value in ${data[@]}; do
    go get -v ${value}
done
