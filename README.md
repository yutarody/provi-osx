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

> 初回 `git` 実行時に **Command Line Developer Tools**（~1.5GB、git/clang/make 等）のインストールを求められる。  
> これは **Homebrew でも必須**なので「インストール」を選択する（Xcode 本体 10GB+ ではない、別物）。

途中から再開する場合:
```bash
bash ~/dev/provi-osx/setup.sh --from 3  # Step 3 から再開
bash ~/dev/provi-osx/setup.sh --reset   # 進捗リセット
```

> 以降のセクション（1〜6）は各ステップの詳細・補足。setup.sh が自動で処理する。

---

## 0. macOS セットアップ（OS クリーンインストール）

新しい Mac を開封したら以下の順番で進める。

---

### 0-1. 前提確認

| 確認項目 | 内容 |
|----------|------|
| **OS の確認** | 新品 M4 Pro には Tahoe（macOS 26）が入っている可能性あり |
| **Sequoia 対応** | M4 は Sequoia（macOS 15）にダウングレード可能。M5 以降は不可 |
| **インストール方針** | 移行アシスタントは使わない（クリーンセットアップ） |

> **Sequoia で使いたい場合は 0-2 のブータブルドライブ方式を実施する。**  
> Tahoe のままで構わない場合は 0-3（セットアップアシスタント）にスキップ。

---

### 0-2. ブータブルドライブで Sequoia をクリーンインストール

> **別の Mac（旧 Mac 等）で作業する。32GB 以上の USB メモリが必要。**

#### Step 1：Sequoia インストーラーを取得

Mac App Store で **macOS Sequoia** を検索してダウンロード。  
（ダウンロード後、Applications フォルダに `Install macOS Sequoia.app` が保存される）

#### Step 2：ブータブルドライブを作成

USB メモリを接続し、ターミナルで以下を実行：

```bash
sudo /Applications/Install\ macOS\ Sequoia.app/Contents/Resources/createinstallmedia \
  --volume /Volumes/<USBメモリ名>
```

> `<USBメモリ名>` は Finder で確認した USB のボリューム名に置き換える。  
> 完了まで 10〜20 分程度かかる。

#### Step 3：新 Mac のディスクを消去

1. 新 Mac に USB メモリを挿す
2. 電源ボタンを長押し → 「起動オプションの読み込み中」と表示されるまで待つ
3. 「オプション」をクリック → 「続ける」
4. **ディスクユーティリティ**を選択 → 「続行」
5. 左サイドバーで**起動ディスク**を選択（通常 `Macintosh HD`）
6. 「消去」→ フォーマット：`APFS`、スキーム：`GUIDパーティションマップ` → 「ボリュームグループの消去」
7. 完了後、左上メニューから Mac をシャットダウン

#### Step 4：Sequoia をインストール

1. 電源ボタンを長押し → 「起動オプションの読み込み中」まで待つ
2. ブータブルドライブ（USB）が起動オプションに表示されない場合は一度シャットダウンし再度長押し
3. **USB ドライブ（Install macOS Sequoia）** を選択
4. 「macOS Sequoia をインストール」→ インストール先を選択 → 「続ける」
5. インストール完了（10〜30 分）→ 自動的にセットアップアシスタントが起動

---

### 0-3. セットアップアシスタント（GUI）

インストール後に起動するウィザード：

1. **言語・地域・キーボード** → 日本語 / 日本 / US
2. **Wi-Fi** → インストール時に接続済みのためスキップ
3. **移行アシスタント** → 「今は情報を転送しない」でスキップ
4. **Apple ID** → サインイン（iCloud 有効化）
5. **Touch ID** → 指紋を複数登録
6. **スクリーンタイム** → 「後で設定」
7. **Siri** → オフ または「後で設定」
8. **外観モード** → 好みで選択

---

### 0-4. システム設定（手動・優先度高）

セットアップアシスタント完了後、システム設定で先に済ませる：

| 項目 | 設定場所 | 内容 |
|------|----------|------|
| ディスプレイ解像度 | システム設定 → ディスプレイ | 「スペースを拡大」に設定 |
| Night Shift | システム設定 → ディスプレイ → Night Shift | 日の入りから日の出まで |
| トラックパッド | システム設定 → トラックパッド | 軌跡の速さを調整、タップでクリックを好みで有効化 |
| キーボード | システム設定 → キーボード | キーのリピート速度・認識時間を最速に、音声入力は無効化 |
| Dock | システム設定 → デスクトップと Dock | サイズ小さめ、自動的に隠す ON、最近使ったアプリを非表示 |
| FileVault | システム設定 → プライバシーとセキュリティ | オンになっていることを確認 |
| 通知 | システム設定 → 通知 | 不要なアプリをオフ（セットアップ後に整理） |

---

### 0-5. macOS デフォルト設定を一括適用

```bash
git clone https://github.com/yutarody/provi-osx.git ~/dev/provi-osx
bash ~/dev/provi-osx/macos-defaults.sh
```

> 初回 `git` 実行時に **Command Line Developer Tools**（~1.5GB）のインストールを求められる → 「インストール」を選択。  
> Homebrew でも必須なので必ず入れる（フル Xcode の 10GB+ とは別物）。  
> Finder の隠しファイル表示・Dock の挙動・キーリピート等が自動で設定される。  
> その後 `bash ~/dev/provi-osx/setup.sh` でメインセットアップを開始。

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

### 2-1. インストール

```bash
brew install --cask 1password
```

### 2-2. SSH Agent を有効化

1. **1Password アプリを起動** → サインイン
2. **左上メニュー** → 「1Password」→ 「設定」
3. 左サイドバーで **「開発者」** をクリック
4. **「SSH Agent を使用」** の切り替えを **ON**
5. 「SSH 公開鍵の表示を許可」も **ON** にする（必須）
6. 「SSH Agent のソケットを使用」が表示されたら確認（パス: `~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock`）

### 2-3. SSH 鍵を新規作成（1Password 側）

1. 1Password アプリ内で **「+」（新規）** をクリック
2. 「SSH キー」を選択（または「セキュアノート」→「SSH キー」テンプレート）
3. **タイトル**: `GitHub` または `github-personal`
4. **用途**: ドロップダウンから「GitHub」を選択（またはカスタマイズ）
5. 「生成」ボタンをクリック → SSH キーペア（秘密鍵・公開鍵）が自動生成される
6. **保存**

> ⚠️ 秘密鍵は 1Password 内に自動保存される。ローカルファイル（`~/.ssh/id_rsa` 等）は作られない。

### 2-4. GitHub に公開鍵を登録

1. 1Password で作成した **SSH キー** を開く
2. **公開鍵をコピー**（右クリック → コピー、または長押し）
3. ブラウザで **[github.com/settings/keys](https://github.com/settings/keys)** を開く
4. **「New SSH key」** をクリック
5. **Title**: `M4 MacBook Pro` または任意の名前
6. **Key type**: `Authentication Key` を選択
7. **Key** フィールドに公開鍵をペースト
8. **「Add SSH key」** をクリック
9. GitHub でパスワード再認証を求められたら入力

### 2-5. SSH 接続テスト

```bash
ssh -T git@github.com
```

正常なら以下が返る：
```
Hi <your-username>! You've successfully authenticated, but GitHub does not provide shell access.
```

> `~/.ssh/config` は chezmoi で自動管理される（Step 4）。  
> 以下が含まれ、1Password Agent のソケットが自動指定される：
> ```
> Host *
>   IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
> ```

### 参考

- [1Password SSH Agent ドキュメント](https://developer.1password.com/docs/ssh/)
- [1Password で SSH 鍵を生成・管理](https://support.1password.com/ssh-keys/)

---

## 3. chezmoi で dotfiles を適用

```bash
brew install chezmoi
chezmoi init --apply git@github.com:yutarody/dotfiles.git
```

適用される主な設定:
- `~/.zshrc`
- `~/.gitconfig`
- `~/.ssh/config`
- starship, zoxide, fzf 等の設定

> `~/.zprofile` は chezmoi 管理外。Homebrew インストール時に setup.sh が `brew shellenv` を追記する。

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
