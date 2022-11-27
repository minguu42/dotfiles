# macOS セットアップ手順

## 0. 最初にすること

まず、次の2つのことを確認し、更新がある場合アップデートを行う。

- ` > この Mac について > ソフトウェア・アップデート...`
- ` > Apple Store... > アップデート > すべてアップデート`

## 1. Command Line Tools for Xcodeのインストール

次のコマンドを実行し、Command Line Tools for Xcodeをインストールする。

```bash
xcode-select --install
```

## 2. Homebrewのインストール

次のコマンドを実行し、Homebrewをインストールする。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 3. 設定ファイルの配置

次のコマンドを実行し、`deploy.sh`を実行する。
`deploy.sh`は`dotfiles`リポジトリに含まれる設定ファイルのシンボリックリンクを`~/.config`ディレクトリ配下の対応するディレクトリに作成する。

```bash
chmod +x ./deploy.sh && ./deploy.sh
```

## 4. パッケージのインストール

次のコマンドを実行し、Homebrew経由で必要なパッケージをインストールする。

```bash
brew bundle install --file "$HOME/.config/brew/.Brewfile"
```

## 5. ログインシェルの変更

`/etc/shells`にHomebrewでインストールしたZshのパスを加える。

```bash
echo /usr/local/bin/zsh | sudo tee -a /etc/shells
```

ログインシェルをZshに変更する。

```bash
chsh -s /usr/local/bin/zsh
```
