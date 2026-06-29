# provi-osx

M4 Pro MacBook Pro セットアップ手順（2026年版）

## 概要

| ツール | 役割 |
|--------|------|
| **1Password** | SSH鍵管理・SSH Agent |
| **chezmoi** | dotfiles管理（.zshrc, .gitconfig, .ssh/config 等） |
| **Homebrew + Brewfile** | パッケージ・アプリ一括インストール |
| **macos-defaults.sh** | macOS システム設定の自動化 |

## クイックスタート

macOS 初期化（セクション 0）が完了したら、以下の1コマンドで全自動実行：

```bash
git clone https://github.com/yutarody/provi-osx.git ~/dev/provi-osx
bash ~/dev/provi-osx/setup.sh
```

途中から再開する場合:
```bash
bash ~/dev/provi-osx/setup.sh --from 3  # Step 3 から再開
bash ~/dev/provi-osx/setup.sh --reset   # 進捗リセット
```

> 以降のセクション（1〜6）は各ステップの詳細・補足。setup.sh が自動で処理する。

---

## 0. macOS 初期化（新MacのOS設定）

新しいMacを開封したら、以下の順番で進める。

### 0-0. macOS クリーンインストール（必要な場合のみ）

新品状態から始める場合はスキップ。再インストールが必要な場合：

1. Mac の電源を切る
2. 電源ボタンを長押し → 「オプション」が表示されたら選択（Apple Silicon の起動オプション）
3. **macOS リカバリ**が起動する
4. 「macOS を再インストール」を選択
5. インストール先ディスクを選択 → インストール開始（Wi-Fi 接続が必要）
6. 完了後、セットアップアシスタントが起動する

> ディスクを完全に消去してからインストールする場合は「ディスクユーティリティ」→ 対象ディスクを選択 → 「消去」を先に実行する。

### 0-1. セットアップアシスタント（GUI）

電源を入れると起動するウィザードを完了させる。

1. **言語・地域・キーボード** → English / United States / US
2. **Wi-Fi** → 接続する
3. **移行アシスタント** → 「今は情報を転送しない」でスキップ（クリーンセットアップ）
4. **Apple ID** → サインイン（iCloud 有効化）
5. **Touch ID** → 指紋を登録（複数登録推奨）
6. **スクリーンタイム** → 「後で設定」
7. **Siri** → 「後で設定」またはオフ
8. **外観モード** → ダーク / ライト を選択

### 0-2. システム設定（手動・優先度高）

セットアップアシスタント完了後、システム設定で以下を先に済ませる。

**ディスプレイ**
- システム設定 → ディスプレイ → 解像度を「スペースを拡大」に設定
- Night Shift → 日の入りから日の出まで / カラーを調整

**トラックパッド**
- システム設定 → トラックパッド → 軌跡の速さを好みに調整
- 「タップでクリック」を好みで有効化

**キーボード**
- システム設定 → キーボード → キーのリピート速度・リピート入力認識までの時間を最速に
- 「音声入力」は不要なら無効化

**Dock**
- システム設定 → デスクトップと Dock → サイズを小さめに、自動的に隠すをオン
- 「最近使ったアプリケーションを Dock に表示」をオフ

**通知**
- システム設定 → 通知 → 不要なアプリの通知をオフ（セットアップ後に整理）

**集中モード（フォーカス）**
- システム設定 → フォーカス → おやすみモード / 仕事 を設定

**セキュリティ**
- システム設定 → プライバシーとセキュリティ → FileVault がオンになっていることを確認

### 0-3. macOS デフォルト設定を一括適用

```bash
# リポジトリを clone してから実行
git clone https://github.com/yutarody/provi-osx.git ~/dev/provi-osx
bash ~/dev/provi-osx/macos-defaults.sh
```

または curl で直接実行:
```bash
curl -fsSL https://raw.githubusercontent.com/yutarody/provi-osx/master/macos-defaults.sh | bash
```

> Finder の隠しファイル表示・Dock の挙動・キーリピート等が自動で設定される。

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
brew bundle --file=~/dev/provi-osx/Brewfile
```

インストール内容:
- CLI ツール（fzf, gh, git, fnm, uv, starship, zoxide 等）
- 開発ツール（Warp, VS Code, Cursor, Claude, Claude Code 等）
- 生産性ツール（1Password, Alfred, BetterTouchTool, Karabiner 等）
- DAW・音楽ツール（Ableton Live, Cycling74 Max, Native Access 等）
- Mac App Store アプリ（Magnet, LINE, Reeder 等）

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

### システム設定

| 設定 | 場所 |
|------|------|
| Night Shift | システム設定 → ディスプレイ → Night Shift |
| Focus モード | システム設定 → フォーカス |
| Dock カスタマイズ | dockutil（Brewfile に含む）で管理 |
| Obsidian Sync | Obsidian 起動 → 設定 → 同期 → サインイン → Vault 選択 → コミュニティプラグイン有効化 |

### アプリのインストール（Cask なし）

| アプリ | URL |
|--------|-----|
| Studio One 7 | [presonus.com](https://www.presonus.com) |
| Synthesizer V Studio Pro | [dreamtonics.com](https://dreamtonics.com) |

### ライセンス認証が必要なアプリ

| アプリ | 備考 |
|--------|------|
| Ableton Live Suite | シリアル認証 |
| BetterTouchTool | ライセンスキー |
| Alfred | Powerpack ライセンス |
| Parallels Desktop | サブスクリプション認証 |
| Adobe Creative Cloud | Adobe ID でサインイン |

### システム権限の承認（要 GUI 操作）

| アプリ | 必要な権限 |
|--------|----------|
| Karabiner-Elements | システム拡張 / 入力監視 / アクセシビリティ |
| BetterTouchTool | アクセシビリティ |
| Alfred | アクセシビリティ |
| Magnet | アクセシビリティ |

権限はシステム設定 → プライバシーとセキュリティ で許可する。

### DAW データの移行

旧 Mac のサンプルライブラリを外付けSSD に移行する:

```bash
# 旧Mac で外付けSSDにコピー（旧Mac側で実行）
cp -R ~/Music/Samples/ /Volumes/外付けSSD名/Samples/
cp -R ~/Parallels/ /Volumes/外付けSSD名/Parallels/
```

Native Instruments のコンテンツは Native Access で再インストール後、コンテンツの場所を外付けSSD に変更する。

---

## ファイル構成

```
provi-osx/
├── README.md              # このファイル
├── setup.sh               # メインスクリプト（全ステップを包括）
├── macos-defaults.sh      # macOS defaults write 設定
├── Brewfile               # Homebrew パッケージ一覧
├── plugin-setup-guide.sh  # DAWプラグイン インタラクティブガイド
├── install-free-plugins.sh # 無料プラグイン自動インストール
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
