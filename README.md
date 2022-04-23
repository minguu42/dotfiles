# Dotfiles

自分の macOS の環境構築手順を記述しておく。

## セットアップ手順

### 0. 最初にすること

以下の2つのことを最初に行う。

- ` > この Mac について > ソフトウェア・アップデート...`
- ` > Apple Store... > アップデート > すべてアップデート`

### 1. 設定ファイルのセットアップ

以下の一連のコマンドで `dotfiles` リポジトリをクローンする。

```bash
$ mkdir -p ~/ghq/github.com/minguu42
$ git -C ~/ghq/github.com/minguu42 clone https://github.com/minguu42/dotfiles
```

そして、`install.sh` を実行する。


```bash
$ cd ~/ghq/github.com/minguu42
$ chmod +x install.sh
$ ./install.sh
```

### 2. パッケージのインストール

以下のコマンドで Homebrew をインストールする。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

そして、以下のコマンドで必要なパッケージを一括でインストールする。

```bash
$ brew bundle install --file ~/.config/brew/.Brewfile
```

### 3. ログインシェルの変更

`/etc/shells` を以下のように書き換えて、Homebrew でインストールした Bash にパスを通す。

```bash
sudo nano /etc/shells
```

```text
# List of acceptable shells for chpass(1).
# Ftpd will not allow users to connect who are not using
# one of these shells.

/bin/bash
/bin/csh
/bin/dash
/bin/ksh
/bin/sh
/bin/tcsh
/bin/zsh
/usr/local/bin/bash
```

以下のコマンドでログインシェルを Bash に変更する。

```bash
chsh -s /usr/local/bin/bash
```
