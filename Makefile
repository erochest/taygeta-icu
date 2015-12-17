SRC=$(shell find src -name '*.hs')

CABAL=stack
FLAGS=--enable-tests

all: init test docs package

init: stack.yaml

stack.yaml:
	stack init --prefer-nightly

test:
	stack test --pedantic


run: build
	stack exec -- taygeta-icu


# docs:
# generate api documentation
#
# package:
# build a release tarball or executable
#
# dev:
# start dev server or process. `vagrant up`, `yesod devel`, etc.
#
# deploy:
# prep and push

install:
	stack install

tags: ${SRC}
	codex update

hlint:
	hlint *.hs src specs

clean:
	stack clean
	codex cache clean

distclean: clean

build:
	stack build --pedantic

watch:
	ghcid "--command=stack ghci"

restart: distclean init build

rebuild: clean build

.PHONY: all init test run clean distclean build rebuild hlint watch tags
