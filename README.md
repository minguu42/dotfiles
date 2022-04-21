# Dotfiles

自分の macOS の環境構築手順を記述しておく。

## セットアップ手順

### 1. システム環境設定を変更する

[macOS のシステム環境設定](./docs/mac_system_config.md)に従い、設定する。

### 2. Homebrew でセットアップする

以下のコマンドで Homebrew をインストールする。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

以下の一連の手順で [.Brewfile](./.config/brew/.Brewfile) をダウンロードする。
そして、必要なライブラリを一括でインストールする。

```bash
$ mkdir -p ~/.config/brew
$ nano ~/.config/brew/.Brewfile
$ export HOMEBREW_BUNDLE_FILE=~/.config/brew/.Brewfile
$ brew bundle
```

### 3. ログインシェルを Bash に変更する

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

## Homebrew でのパッケージ管理

パッケージ管理システムとして Homebrew を利用する。
特に素早く macOS での開発環境を整えられるように Homebrew Bundle を利用する。

具体的に実行するコマンドは以下のようになる。

注意: 環境変数 `HOMEBREW_BUNDLE_FILE` の値は `Brewfile` へのパスである。

```bash
# インストールされているパッケージ一覧を表示する
$ brew bundle list --all

# パッケージを追加する
$ nano $HOMEBREW_BUNDLE_FILE
$ brew bundle --no-upgrade

# パッケージの更新がないか確認する
$ brew update
$ brew bundle check --verbose

# パッケージを更新する
$ brew bundle

# 不要なパッケージをアンインストールする
$ nano $HOMEBREW_BUNDLE_FILE
$ brew bundle cleanup         # 確認
$ brew bundle cleanup --force # 実行
```
