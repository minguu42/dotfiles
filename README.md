# Dotfiles

macOSにおける環境構築の手順を示す。

## セットアップ手順

### 0. 最初にすること

以下の2つのことを最初に行う。

- ` > この Mac について > ソフトウェア・アップデート...`
- ` > Apple Store... > アップデート > すべてアップデート`

### 1. 設定ファイルのセットアップ

まず、`dotfiles`リポジトリをクローンする。

```bash
$ mkdir -p ~/ghq/github.com/minguu42
$ git -C ~/ghq/github.com/minguu42 clone https://github.com/minguu42/dotfiles
```

そして、`install.sh`を実行する。

```bash
$ cd ~/ghq/github.com/minguu42/dotfiles
$ chmod +x install.sh
$ ./install.sh
```

### 2. パッケージのインストール

次のコマンドでHomebrewをインストールする。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

そして、以下のコマンドで必要なパッケージを一括でインストールする。

```bash
$ brew bundle install --file ~/.config/brew/.Brewfile
```

### 3. ログインシェルの変更

`/etc/shells`にHomebrewでインストールしたfishのパスを使える。

```bash
echo /usr/local/bin/fish | sudo tee -a /etc/shells
```

ログインシェルをfishに変更する。

```bash
chsh -s /usr/local/bin/fish
```
