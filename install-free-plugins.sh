#!/usr/bin/env bash
# ============================================================
# install-free-plugins.sh
# 認証不要の無料DAWプラグインを自動インストール
#
# 対象:
#   - Airwindows Consolidated (AU, VST3, CLAP)
#   - NeuralAmpModeler (AU, VST3)
#   - TSE Audio BOD (VST2) ※ 手動DLが必要なため案内のみ
#
# 使い方:
#   chmod +x install-free-plugins.sh
#   ./install-free-plugins.sh
# ============================================================

set -e

AU_DIR="/Library/Audio/Plug-Ins/Components"
VST3_DIR="/Library/Audio/Plug-Ins/VST3"
CLAP_DIR="/Library/Audio/Plug-Ins/CLAP"
TMP_DIR="$(mktemp -d)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

# sudo が必要
if [[ $EUID -ne 0 ]]; then
  warn "このスクリプトは sudo で実行してください"
  exec sudo "$0" "$@"
fi

mkdir -p "$AU_DIR" "$VST3_DIR" "$CLAP_DIR"

install_dmg() {
  local name="$1"
  local url="$2"
  local dmg="$TMP_DIR/${name}.dmg"

  echo ""
  log "=== $name ==="
  echo "  DL: $url"
  curl -L --progress-bar -o "$dmg" "$url"

  local volume
  volume=$(hdiutil attach "$dmg" -nobrowse -noautoopen 2>/dev/null \
    | grep "/Volumes/" | awk '{print $NF}')
  echo "  マウント: $volume"

  # AU
  find "$volume" -name "*.component" | while read -r f; do
    log "  AU: $(basename "$f") → $AU_DIR"
    cp -rf "$f" "$AU_DIR/"
  done

  # VST3
  find "$volume" -name "*.vst3" | while read -r f; do
    log "  VST3: $(basename "$f") → $VST3_DIR"
    cp -rf "$f" "$VST3_DIR/"
  done

  # CLAP
  find "$volume" -name "*.clap" | while read -r f; do
    log "  CLAP: $(basename "$f") → $CLAP_DIR"
    cp -rf "$f" "$CLAP_DIR/"
  done

  hdiutil detach "$volume" -quiet
  rm -f "$dmg"
}

# ============================================================
# 1. Airwindows Consolidated
#    GitHub の DAWPlugin タグから最新の macOS DMG を取得
# ============================================================
echo ""
log "Airwindows Consolidated の最新リリースを確認中..."

AIRWIN_URL=$(curl -s "https://api.github.com/repos/baconpaul/airwin2rack/releases/tags/DAWPlugin" \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
for a in data.get('assets', []):
    if 'macOS' in a['name'] and a['name'].endswith('.dmg'):
        print(a['browser_download_url'])
        break
")

if [[ -z "$AIRWIN_URL" ]]; then
  err "Airwindows: DMG URLが取得できませんでした（GitHub API rate limit の可能性）"
  warn "手動DL: https://github.com/baconpaul/airwin2rack/releases/tag/DAWPlugin"
else
  install_dmg "airwindows-consolidated" "$AIRWIN_URL"
fi

# ============================================================
# 2. NeuralAmpModeler
#    最新リリースからアセットありのバージョンを自動検出
# ============================================================
echo ""
log "NeuralAmpModeler の最新リリースを確認中..."

NAM_URL=$(curl -s "https://api.github.com/repos/sdatkinson/NeuralAmpModelerPlugin/releases" \
  | python3 -c "
import sys, json
releases = json.load(sys.stdin)
for r in releases:
    for a in r.get('assets', []):
        if 'mac' in a['name'].lower() and a['name'].endswith('.dmg'):
            print(a['browser_download_url'])
            raise SystemExit
")

if [[ -z "$NAM_URL" ]]; then
  err "NeuralAmpModeler: DMG URLが取得できませんでした"
  warn "手動DL: https://github.com/sdatkinson/NeuralAmpModelerPlugin/releases"
else
  install_dmg "NeuralAmpModeler" "$NAM_URL"
fi

# ============================================================
# 3. TSE Audio BOD （VST2 のみ・要手動DL）
# ============================================================
echo ""
warn "=== TSE Audio BOD ==="
warn "  BOD は公式サイトからの手動ダウンロードが必要です"
warn "  URL: https://www.tse-audio.com/content/BOD.html"
warn "  DL後: DMG を開いて VST を /Library/Audio/Plug-Ins/VST/ にコピー"

# ============================================================
# クリーンアップ
# ============================================================
rm -rf "$TMP_DIR"

echo ""
log "完了！DAW を再起動してプラグインスキャンを実行してください。"
echo ""
echo "インストール先:"
echo "  AU   → $AU_DIR"
echo "  VST3 → $VST3_DIR"
echo "  CLAP → $CLAP_DIR"
