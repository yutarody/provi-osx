#!/usr/bin/env bash
# ============================================================
# setup.sh
# M4 Pro MacBook Pro セットアップスクリプト
#
# 使い方:
#   bash setup.sh          # 最初から実行
#   bash setup.sh --from 3 # Step 3 から再開
#   bash setup.sh --reset  # 進捗リセット
# ============================================================

# set -e は使わない（brew bundle が一部失敗で non-zero を返すため）
# 各コマンドの失敗は個別にハンドリング
set -uo pipefail

PROGRESS_FILE="$HOME/.macos-setup-progress"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

log()    { echo -e "${GREEN}[✓]${NC} $1"; }
info()   { echo -e "${YELLOW}[→]${NC} $1"; }
step()   { echo -e "\n${BOLD}${BLUE}━━━ $1 ━━━${NC}\n"; }
manual() { echo -e "${YELLOW}[手動]${NC} $1"; }
err()    { echo -e "${RED}[✗]${NC} $1"; }

# 1Password SSH Agent socket（chezmoi 適用前でも SSH を使えるように明示）
OP_SSH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# ============================================================
# 引数処理
# ============================================================
while [[ $# -gt 0 ]]; do
  case $1 in
    --reset)
      rm -f "$PROGRESS_FILE"
      echo "進捗をリセットしました。"
      exit 0
      ;;
    --from)
      shift
      if [[ $# -eq 0 || ! "${1:-}" =~ ^[0-9]+$ ]]; then
        echo "エラー: --from には Step 番号（整数）を指定してください。例: --from 3" >&2
        exit 1
      fi
      FROM_STEP="$1"
      # 進捗値 N は "Step (N-1) まで完了" を意味する（各 Step は `set_progress (label+1)` を呼ぶ）。
      # よって Step K から再開させたい場合は progress=K を書く（Steps 0..K-1 完了済み扱い）。
      echo "$FROM_STEP" > "$PROGRESS_FILE"
      echo "Step $FROM_STEP から再開します。"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# ============================================================
# 進捗管理
# ============================================================
get_progress() {
  [[ -f "$PROGRESS_FILE" ]] && cat "$PROGRESS_FILE" || echo "0"
}

set_progress() {
  echo "$1" > "$PROGRESS_FILE"
}

completed_step() {
  local current
  current=$(get_progress)
  [[ "$current" -ge "$1" ]]
}

# 手動確認プロンプト
wait_confirm() {
  echo ""
  read -rp "  完了したら Enter を押してください... " _
  echo ""
}

# ============================================================
# ヘッダー
# ============================================================
clear
echo ""
echo -e "${BOLD}============================================${NC}"
echo -e "${BOLD}  macOS セットアップ - M4 Pro MacBook Pro${NC}"
echo -e "${BOLD}============================================${NC}"
echo ""

CURRENT=$(get_progress)
if [[ "$CURRENT" -gt 0 ]]; then
  info "前回の進捗: Step $CURRENT まで完了"
  info "--reset で最初からやり直せます"
fi

echo ""

# ============================================================
# Step 0: macOS デフォルト設定
# ============================================================
step "Step 0: macOS デフォルト設定"

if completed_step 1; then
  log "スキップ（完了済み）"
else
  bash "$SCRIPT_DIR/macos-defaults.sh"
  set_progress 1
  log "完了"
fi

# ============================================================
# Step 1: Homebrew
# ============================================================
step "Step 1: Homebrew インストール"

if completed_step 2; then
  log "スキップ（完了済み）"
elif command -v brew &>/dev/null; then
  log "Homebrew はインストール済み → スキップ"
  set_progress 2
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Apple Silicon: PATH を通す
  if [[ -f /opt/homebrew/bin/brew ]]; then
    # chezmoi が dot_zprofile を管理していない前提で append（重複防止）
    if ! grep -q "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # Rosetta 2（Native Access 等 Intel バイナリのために必要）
  if ! /usr/bin/pgrep -q oahd; then
    info "Rosetta 2 をインストール中（sudo パスワードが要求されます）..."
    sudo softwareupdate --install-rosetta --agree-to-license || \
      err "Rosetta 2 のインストールに失敗（後で手動: sudo softwareupdate --install-rosetta --agree-to-license）"
  else
    log "Rosetta 2 はインストール済み"
  fi

  set_progress 2
  log "完了"
fi

# ============================================================
# Step 2: 1Password + SSH Agent 設定
# ============================================================
step "Step 2: 1Password インストール + SSH Agent 設定"

if completed_step 3; then
  log "スキップ（完了済み）"
else
  # 1Password インストール
  if ! brew list --cask 1password &>/dev/null; then
    info "1Password をインストール中..."
    brew install --cask 1password
  else
    log "1Password はインストール済み"
  fi

  echo ""
  manual "以下を手動で設定してください："
  manual "  1. 1Password を起動してサインイン"
  manual "  2. 設定 → 開発者 → 「SSH Agent を使用」を有効化"
  manual "  3. 1Password で GitHub 用 SSH 鍵を新規作成"
  manual "  4. 公開鍵を GitHub に登録 → https://github.com/settings/keys"
  echo ""
  open "https://github.com/settings/keys" 2>/dev/null || true
  wait_confirm

  # SSH 接続テスト
  # この時点で ~/.ssh/config はまだ chezmoi で配置されていないため、
  # 1Password Agent のソケットを SSH_AUTH_SOCK で明示する
  info "GitHub SSH 接続テスト..."
  ssh_output=$(SSH_AUTH_SOCK="$OP_SSH_SOCK" ssh -T -o StrictHostKeyChecking=accept-new git@github.com 2>&1 || true)
  if echo "$ssh_output" | grep -q "successfully authenticated"; then
    log "SSH 接続成功"
  else
    err "SSH 接続失敗:"
    echo "$ssh_output" | sed 's/^/    /'
    err "1Password の SSH Agent 設定 / GitHub への公開鍵登録を確認してから Enter を押してください"
    wait_confirm
  fi

  set_progress 3
  log "完了"
fi

# ============================================================
# Step 3: Brewfile で一括インストール
# ============================================================
step "Step 3: Brewfile で一括インストール"

if completed_step 4; then
  log "スキップ（完了済み）"
else
  manual "App Store にサインインしていることを確認してください（mas のインストールに必要）"
  wait_confirm

  info "brew bundle を実行中（時間がかかります）..."
  # brew bundle は一部 cask の再インストールやライセンス都合で non-zero を返すことがある
  # その場合も継続して、ユーザーに最後に確認を促す
  # caffeinate でアイドル・システムスリープを抑止（実行中のみ）
  if ! caffeinate -is brew bundle --file="$SCRIPT_DIR/Brewfile"; then
    err "brew bundle で一部失敗しました。後で 'brew bundle --file=$SCRIPT_DIR/Brewfile' を再実行してください"
    read -rp "  続行しますか？ [Y/n]: " ans
    [[ "$ans" == "n" || "$ans" == "N" ]] && exit 1
  fi

  set_progress 4
  log "完了"
fi

# ============================================================
# Step 4: chezmoi で dotfiles を適用
# ============================================================
step "Step 4: chezmoi で dotfiles を適用"

if completed_step 5; then
  log "スキップ（完了済み）"
else
  # chezmoi は Brewfile に含まれているので Step 3 でインストール済み
  # ~/.ssh/config はこのコマンドで配置されるため、それまでは 1Password Agent ソケットを明示
  info "dotfiles を適用中..."
  SSH_AUTH_SOCK="$OP_SSH_SOCK" chezmoi init --apply git@github.com:yutarody/dotfiles.git

  set_progress 5
  log "完了"
fi

# ============================================================
# Step 5: Node.js セットアップ
# ============================================================
step "Step 5: Node.js セットアップ（fnm）"

if completed_step 6; then
  log "スキップ（完了済み）"
else
  if command -v fnm &>/dev/null; then
    info "Node.js LTS をインストール中..."
    eval "$(fnm env)"
    fnm install --lts
    fnm use --lts
    # この時点で fnm current は実バージョン（例: v20.x.x）を返す
    fnm default "$(fnm current)"
    log "Node.js $(node -v) をインストール完了"

    # npm グローバルパッケージ
    info "npm グローバルパッケージをインストール中..."
    npm install -g defuddle-cli || err "defuddle-cli のインストールに失敗（後で手動実行）"
  else
    err "fnm が見つかりません。Brewfile のインストールを確認してください"
  fi

  set_progress 6
  log "完了"
fi

# ============================================================
# Step 6: アプリのサインイン + 権限承認
# ============================================================
step "Step 6: アプリのサインイン + 権限承認"

if completed_step 7; then
  log "スキップ（完了済み）"
else
  manual "▼ クラウドサインイン"
  manual "  1. Dropbox → サインイン → バックアップ設定（Desktop / Documents / Downloads）"
  manual "  2. Google Drive → サインイン"
  echo ""
  manual "▼ システム権限承認（要・GUI操作）"
  manual "  3. Karabiner-Elements を起動"
  manual "     → システム拡張をブロック解除（システム設定 → プライバシーとセキュリティ）"
  manual "     → 入力監視を許可"
  manual "     → アクセシビリティを許可"
  manual "  4. BetterTouchTool を起動 → アクセシビリティを許可"
  manual "  5. Alfred を起動 → アクセシビリティを許可 → Powerpack ライセンス入力"
  manual "  6. Magnet を起動 → アクセシビリティを許可"
  echo ""
  open -a Dropbox 2>/dev/null || true
  wait_confirm

  set_progress 7
  log "完了"
fi

# ============================================================
# Step 7: DAW データ（サンプルライブラリ）の移行
# ============================================================
step "Step 7: DAW データの移行（外付けSSD）"

if completed_step 8; then
  log "スキップ（完了済み）"
else
  manual "旧 Mac のサンプルライブラリを外付けSSD にコピーしてください："
  manual "  コピー元（旧Mac）: パーティション or ~/Music/Samples/"
  manual "  コピー先（外付けSSD）: /Volumes/外付けSSD名/Samples/"
  manual ""
  manual "Native Instruments コンテンツ（Kontakt 等）は"
  manual "  Native Access で再インストール後、コンテンツの場所を外付けSSDに変更"
  echo ""
  read -rp "  スキップする場合は [s]、完了したら [Enter]: " ans
  if [[ "$ans" == "s" ]]; then
    info "スキップ（後で --from 7 で再実行可能）"
  else
    set_progress 8
    log "完了"
  fi
fi

# ============================================================
# Step 8: Parallels イメージのコピー
# ============================================================
step "Step 8: Parallels イメージのコピー"

if completed_step 9; then
  log "スキップ（完了済み）"
else
  manual "Parallels VM イメージは外付けSSD（TB4）上に保管します："
  manual "  1. 旧 Mac から外付けSSD の /Volumes/<外付けSSD名>/Parallels/ に .pvm をコピー済みであることを確認"
  manual "  2. Parallels Desktop を起動 → ライセンス認証"
  manual "  3. ファイル → 開く → /Volumes/<外付けSSD名>/Parallels/<VM>.pvm を選択"
  manual "  4. VM 設定 → 「移動しました」を選択（コピーではなく）"
  manual ""
  manual "※ 内蔵 SSD には移動しないこと（外付けSSDで運用）"
  echo ""
  read -rp "  スキップする場合は [s]、完了したら [Enter]: " ans
  if [[ "$ans" == "s" ]]; then
    info "スキップ（後で --from 8 で再実行可能）"
  else
    set_progress 9
    log "完了"
  fi
fi

# ============================================================
# Step 9: Obsidian セットアップ
# ============================================================
step "Step 9: Obsidian セットアップ"

if completed_step 10; then
  log "スキップ（完了済み）"
else
  open -a Obsidian 2>/dev/null || true
  manual "以下を手動で設定してください："
  manual "  1. Obsidian を起動"
  manual "  2. 設定 → 同期 → Obsidian Sync にサインイン"
  manual "  3. Vault を選択して同期開始"
  manual "  4. 同期完了後、コミュニティプラグインを有効化"
  wait_confirm

  set_progress 10
  log "完了"
fi

# ============================================================
# Step 10: DAW プラグインセットアップ
# ============================================================
step "Step 10: DAW プラグインセットアップ"

if completed_step 11; then
  log "スキップ（完了済み）"
else
  read -rp "  DAW プラグインのセットアップを開始しますか？ [Y/n]: " ans
  if [[ "$ans" != "n" && "$ans" != "N" ]]; then
    bash "$SCRIPT_DIR/plugin-setup-guide.sh"
  else
    info "スキップ（後で ./plugin-setup-guide.sh を実行してください）"
  fi

  set_progress 11
  log "完了"
fi

# ============================================================
# 完了
# ============================================================
echo ""
echo -e "${BOLD}${GREEN}============================================${NC}"
echo -e "${BOLD}${GREEN}  セットアップ完了！${NC}"
echo -e "${BOLD}${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}ライセンス認証が必要なアプリ:${NC}"
echo "  - Ableton Live Suite"
echo "  - BetterTouchTool"
echo "  - Alfred（Powerpack）"
echo "  - Parallels Desktop"
echo "  - Adobe Creative Cloud"
echo ""
log "Warp / VS Code / Cursor を起動して動作確認してください"
log "DAW を起動してプラグインスキャンを実行してください"
echo ""
