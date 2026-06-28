# provi-osx

M4 Pro MacBook Pro セットアップ手順（2026年版）

## 概要

| ツール | 役割 |
|--------|------|
| **1Password** | SSH鍵管理・SSH Agent |
| **chezmoi** | dotfiles管理（.zshrc, .gitconfig, .ssh/config 等） |
| **Homebrew + Brewfile** | パッケージ・アプリ一括インストール |
| **macos-defaults.sh** | macOS システム設定の自動化 |

---

## 0. macOS 初期化（新MacのOS設定）

新しいMacを開封したら、まず macOS の初期設定ウィザードを完了させる。

### 0-1. セットアップアシスタント（GUI）

1. 言語・地域・キーボード設定
2. Wi-Fi 接続
3. Apple ID サインイン（iCloud 有効化）
4. Touch ID 登録
5. スクリーンタイム・Siri は後で設定

### 0-2. macOS デフォルト設定を一括適用

```bash
# リポジトリを clone してから実行
git clone https://github.com/yutarody/provi-osx.git ~/dev/provi-osx
bash ~/dev/provi-osx/macos-defaults.sh
```

または curl で直接実行:
```bash
curl -fsSL https://raw.githubusercontent.com/yutarody/provi-osx/master/macos-defaults.sh | bash
```

---

## 1. Homebrew のインストール

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> Xcode Command Line Tools は Homebrew のインストール時に自動でインストールされる。

インストール後、PATH を通す（Apple Silicon）:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

---

## 2. 1Password のインストールと SSH Agent 設定

```bash
brew install --cask 1password
```

インストール後:
1. **1Password → 設定 → 開発者** を開く
2. 「SSH Agentを使用」を有効化
3. 1Password で GitHub 用 SSH 鍵を作成
4. GitHub に公開鍵を登録:  
   → [github.com/settings/keys](https://github.com/settings/keys)

接続テスト:
```bash
ssh -T git@github.com
```

chezmoi で管理している `~/.ssh/config` に以下が含まれる（自動適用）:
```
Host *
  IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

---

## 3. chezmoi で dotfiles を適用

```bash
brew install chezmoi
chezmoi init --apply git@github.com:yutarody/dotfiles.git
```

適用される主な設定:
- `~/.zshrc` / `~/.zprofile`
- `~/.gitconfig`
- `~/.ssh/config`
- starship, zoxide, fzf 等の設定

---

## 4. Brewfile で一括インストール

```bash
brew bundle --global
```

または Brewfile を直接指定:
```bash
brew bundle --file=~/Brewfile
```

インストール内容:
- CLI ツール（fzf, gh, git, fnm, uv, starship, zoxide 等）
- 開発ツール（Warp, VS Code, Cursor, Claude, Claude Code 等）
- 生産性ツール（1Password, Alfred, BetterTouchTool, Karabiner 等）
- DAW・音楽ツール（Ableton Live, Cycling74 Max, Native Access 等）
- Mac App Store アプリ（Magnet, Xcode, LINE 等）

> **事前に App Store にサインインしておくこと**（mas のインストールに必要）

---

## 5. DAW・プラグインのセットアップ

Brewfile でプラグインマネージャーがインストールされた後、インタラクティブガイドを実行:

```bash
bash ~/dev/provi-osx/plugin-setup-guide.sh
```

フェーズ構成:
1. 事前準備（iLok, 1Password）
2. プラグインマネージャー 15 種の起動・認証
3. 直接ダウンロードプラグイン 25 種
4. 無料プラグイン自動インストール（Airwindows, NeuralAmpModeler）
5. DAW スキャン・動作確認

---

## 6. 手動設定が必要な項目

| 設定 | 場所 |
|------|------|
| Night Shift | システム設定 → ディスプレイ → Night Shift |
| Focus モード | システム設定 → フォーカス |
| Dock カスタマイズ | dockutil（Brewfile に含む）で管理 |
| Parallels Desktop | ライセンス認証が必要（手動インストール） |
| Studio One 7 | Cask なし → [presonus.com](https://www.presonus.com) |
| Synthesizer V | Cask なし → [dreamtonics.com](https://dreamtonics.com) |

---

## ファイル構成

```
provi-osx/
├── README.md              # このファイル
├── macos-defaults.sh      # macOS defaults write 設定
├── plugin-setup-guide.sh  # DAWプラグイン インタラクティブガイド
├── legacy/                # 旧スクリプト（参考用・非推奨）
│   ├── provi-osx.sh
│   ├── install.sh
│   ├── setup_zgen.zsh
│   └── setup_zprezto.zsh
└── windows-setup.md       # Windows 環境セットアップ
```

---

## 参考

- [chezmoi ドキュメント](https://www.chezmoi.io/)
- [Homebrew](https://brew.sh/)
- [1Password SSH Agent](https://developer.1password.com/docs/ssh/agent/)
