#!/usr/bin/env bash
# ============================================================
# macos-defaults.sh
# macOS システム設定の自動化（defaults write）
#
# 対象: macOS Sequoia / M4 Pro MacBook Pro
# 更新: 2026-06-29
#
# 使い方:
#   bash macos-defaults.sh
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
info() { echo -e "${YELLOW}[→]${NC} $1"; }

echo ""
echo "============================================"
echo "  macOS デフォルト設定を適用します"
echo "============================================"
echo ""

# ============================================================
# Finder
# ============================================================
info "Finder 設定..."

# 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -bool true

# 拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

# 新規ウィンドウをホームフォルダで開く
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# .DS_Store をネットワーク/USBドライブに作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

log "Finder 設定完了"

# ============================================================
# Dock
# ============================================================
info "Dock 設定..."

# Dock のサイズ
defaults write com.apple.dock tilesize -int 48

# 自動的に隠す
defaults write com.apple.dock autohide -bool true

# 隠す/表示のアニメーション速度を速く
defaults write com.apple.dock autohide-delay -float 0.1
defaults write com.apple.dock autohide-time-modifier -float 0.3

log "Dock 設定完了"

# ============================================================
# キーボード・入力
# ============================================================
info "キーボード・入力設定..."

# キーリピートを速くする
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# スマートクオートを無効
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# スマートダッシュを無効
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# 自動大文字を無効
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# スペル自動修正を無効
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ピリオドの自動変換（スペース2回）を無効
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

log "キーボード・入力設定完了"

# ============================================================
# 一般
# ============================================================
info "一般設定..."

# Crash Reporter を無効化
defaults write com.apple.CrashReporter DialogType -string "none"

# アクティビティモニタをすべてのプロセス表示に
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# アクティビティモニタの更新頻度を上げる
defaults write com.apple.ActivityMonitor UpdatePeriod -int 2

log "一般設定完了"

# ============================================================
# 再起動が必要なアプリを再起動
# ============================================================
echo ""
info "設定を反映するためアプリを再起動中..."

for app in "Finder" "Dock" "SystemUIServer"; do
  killall "$app" &>/dev/null || true
done

echo ""
log "============================================"
log "  macOS デフォルト設定の適用が完了しました"
log "  ※ 一部設定はログアウト/再起動後に反映されます"
log "============================================"
echo ""
