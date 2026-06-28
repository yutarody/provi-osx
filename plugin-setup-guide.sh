#!/usr/bin/env bash
# ============================================================
# plugin-setup-guide.sh
# DAWプラグイン インタラクティブセットアップガイド
#
# 使い方:
#   chmod +x plugin-setup-guide.sh
#   ./plugin-setup-guide.sh
#
# 特定フェーズから再開:
#   ./plugin-setup-guide.sh --phase 3
#   ./plugin-setup-guide.sh --step "FabFilter"
# ============================================================

# ============================================================
# 初期設定
# ============================================================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_FILE="$HOME/.plugin-setup-progress"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

TOTAL_STEPS=0
DONE_STEPS=0

# 進捗ファイル読み込み
[[ -f "$STATE_FILE" ]] && source "$STATE_FILE"
declare -A DONE 2>/dev/null || declare -A DONE

# ============================================================
# ユーティリティ
# ============================================================

header() {
  echo ""
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}  $1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

phase() {
  echo ""
  echo -e "${CYAN}${BOLD}▶ Phase $1: $2${NC}"
  echo -e "${DIM}  ─────────────────────────────────────────────────${NC}"
}

step() {
  local key="$1"
  local name="$2"
  local desc="$3"
  local action="$4"  # "app:AppName" or "url:https://..." or "cmd:..."
  local plugins="$5"

  TOTAL_STEPS=$((TOTAL_STEPS + 1))

  # 完了済みチェック
  if [[ "${DONE[$key]}" == "1" ]]; then
    echo -e "  ${GREEN}[✓]${NC} ${DIM}$name（完了済み）${NC}"
    DONE_STEPS=$((DONE_STEPS + 1))
    return
  fi

  echo ""
  echo -e "  ${YELLOW}▸ $name${NC}"
  [[ -n "$desc" ]] && echo -e "    ${DIM}$desc${NC}"
  [[ -n "$plugins" ]] && echo -e "    ${DIM}対象: $plugins${NC}"

  # アクション実行
  case "${action%%:*}" in
    app)
      local app_name="${action#app:}"
      if [[ -d "/Applications/${app_name}.app" ]]; then
        echo -e "    → アプリを起動します..."
        open -a "$app_name" 2>/dev/null || echo -e "    ${YELLOW}アプリが見つかりません: $app_name${NC}"
      else
        echo -e "    ${YELLOW}未インストール: $app_name${NC}"
        echo -e "    brew bundle でインストール後に再実行してください"
      fi
      ;;
    url)
      local url="${action#url:}"
      echo -e "    → ブラウザで開きます: ${DIM}$url${NC}"
      open "$url"
      ;;
    cmd)
      local cmd="${action#cmd:}"
      echo -e "    → 実行: ${DIM}$cmd${NC}"
      eval "$cmd"
      ;;
    script)
      local script="${action#script:}"
      echo -e "    → スクリプト実行: ${DIM}$script${NC}"
      bash "$script"
      ;;
  esac

  echo ""
  echo -ne "    ${BOLD}[Enter] 完了  [s] スキップ  [q] 終了 > ${NC}"
  read -r input

  case "$input" in
    q|Q) echo ""; echo -e "${YELLOW}中断しました。再開: ./plugin-setup-guide.sh${NC}"; save_state; exit 0 ;;
    s|S) echo -e "    ${DIM}スキップ${NC}" ;;
    *)
      DONE[$key]="1"
      DONE_STEPS=$((DONE_STEPS + 1))
      echo -e "    ${GREEN}✓ 完了${NC}"
      ;;
  esac

  save_state
}

save_state() {
  {
    echo "# plugin-setup-guide progress - $(date)"
    for k in "${!DONE[@]}"; do
      echo "DONE[$k]=${DONE[$k]}"
    done
  } > "$STATE_FILE"
}

progress_bar() {
  local done=$DONE_STEPS
  local total=$TOTAL_STEPS
  local pct=0
  [[ $total -gt 0 ]] && pct=$((done * 100 / total))
  local filled=$((pct / 5))
  local bar=""
  for ((i=0; i<20; i++)); do
    [[ $i -lt $filled ]] && bar+="█" || bar+="░"
  done
  echo -e "  進捗: ${GREEN}${bar}${NC} ${done}/${total} (${pct}%)"
}

# ============================================================
# 引数処理
# ============================================================
START_PHASE=1
JUMP_STEP=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase) START_PHASE="$2"; shift 2 ;;
    --step)  JUMP_STEP="$2";  shift 2 ;;
    --reset) rm -f "$STATE_FILE"; echo "進捗をリセットしました"; exit 0 ;;
    *) shift ;;
  esac
done

# ============================================================
# メイン
# ============================================================

clear
header "DAWプラグイン セットアップガイド"
echo ""
echo -e "  このスクリプトは全プラグインのインストールをステップバイステップで案内します。"
echo -e "  ${DIM}[Enter] で次へ  [s] でスキップ  [q] で中断（再開可能）${NC}"
echo ""
[[ -f "$STATE_FILE" ]] && echo -e "  ${GREEN}前回の進捗を引き継ぎます。${NC}  リセット: ./plugin-setup-guide.sh --reset"
echo ""
echo -ne "  ${BOLD}準備ができたら Enter を押してください...${NC}"
read -r

# ============================================================
# Phase 1: 事前準備
# ============================================================
[[ $START_PHASE -le 1 ]] && {

phase 1 "事前準備"

step "brewfile" \
  "Brewfile インストール" \
  "brew bundle でアプリ・マネージャーを一括インストール" \
  "cmd:echo 'brew bundle --file=~/.local/share/chezmoi/Brewfile を実行してください'" \
  ""

step "iLok" \
  "iLok License Manager" \
  "起動してアカウントにサインイン・ライセンスをアクティベート" \
  "app:iLok License Manager" \
  "Soundtoys, FabFilter, Celemony, Sonnox 等"

step "1pw_ssh" \
  "1Password SSH Agent 設定" \
  "1Password → 設定 → デベロッパー → SSH Agent を有効化" \
  "app:1Password" \
  ""

}

# ============================================================
# Phase 2: プラグインマネージャー系
# ============================================================
[[ $START_PHASE -le 2 ]] && {

phase 2 "プラグインマネージャー（起動してインストール）"

step "native_access" \
  "Native Access" \
  "サインイン → 「インストール済み」を確認 → 未インストールを一括インストール" \
  "app:Native Access" \
  "Kontakt 7, Reaktor 6, Battery 4, Raum, Supercharger GT"

step "izotope_pp" \
  "iZotope Product Portal" \
  "サインイン → 全製品をインストール" \
  "app:iZotope Product Portal" \
  "Ozone 11, Neutron 4, Nectar 4, RX 9, Stutter Edit 2, Neoverb, VocalSynth 2"

step "ik_pm" \
  "IK Product Manager" \
  "サインイン → 全製品をインストール" \
  "app:IK Product Manager" \
  "T-RackS 5, AmpliTube 5, MODO BASS 2, Syntronik 2, MixBox, TONEX"

step "pa_manager" \
  "PA Installation Manager" \
  "サインイン → 全製品をインストール" \
  "url:https://www.plugin-alliance.com/en/installation-manager.html" \
  "bx_ 系, SPL, elysia, Shadow Hills, Maag, Diezel, Friedman 等 100+ プラグイン"

step "ua_connect" \
  "UA Connect" \
  "サインイン → UAD / UADx 全製品をインストール" \
  "app:UA Connect" \
  "UADx 1176, Neve, Pultec, Ocean Way 等"

step "waves_central" \
  "Waves Central" \
  "サインイン → インストール済みプランを適用" \
  "app:Waves Central" \
  "WaveShell 全バージョン"

step "slate_connect" \
  "Slate Digital Connect" \
  "サインイン → Virtual Mix Rack, SSD 等をインストール" \
  "url:https://slatedigital.com/slate-digital-connect/" \
  "Virtual Mix Rack, SSD Sampler 5"

step "softube_central" \
  "Softube Central" \
  "サインイン → Dirty Tape, Marshall Plexi をインストール" \
  "url:https://www.softube.com/softube-central" \
  "Dirty Tape, Marshall Plexi Super Lead 1959"

step "techivation" \
  "Techivation Manager" \
  "サインイン → M-Clarity, T-De-Esser, Protector をインストール" \
  "url:https://techivation.com/downloads/" \
  "M-Clarity 2, M-Leveller, T-De-Esser 2, Protector, T-Saturator, Tilt EQ"

step "soundid" \
  "SoundID Download Manager" \
  "サインイン → Sonarworks Reference 4 / SoundID Voice AI をインストール" \
  "url:https://www.sonarworks.com/downloads" \
  "Sonarworks Reference 4, SoundID Voice AI"

step "ssl_dl" \
  "SSL Download Manager" \
  "サインイン → SSL Native プラグインをインストール" \
  "url:https://www.solidstatelogic.com/downloads" \
  "SSL Native Bus Compressor 2, Channel Strip 2, X-Saturator"

step "xln_installer" \
  "XLN Online Installer" \
  "サインイン → RC-20 Retro Color をインストール" \
  "url:https://www.xlnaudio.com/onlineinstaller" \
  "RC-20 Retro Color"

step "bfd_lm" \
  "BFD License Manager" \
  "サインイン → BFD3, BFDPlayer をインストール" \
  "url:https://www.bfddrums.com/downloads/" \
  "BFD3, BFDPlayer"

step "toontrack" \
  "Toontrack Product Manager" \
  "サインイン → EZbass をインストール" \
  "url:https://www.toontrack.com/product-manager/" \
  "EZbass, Toontrack Audio Sender"

step "splice_app" \
  "Splice" \
  "サインイン → SpliceBridge プラグインを確認" \
  "app:Splice" \
  "SpliceBridge"

}

# ============================================================
# Phase 3: 直接ダウンロード
# ============================================================
[[ $START_PHASE -le 3 ]] && {

phase 3 "直接ダウンロード（ブラウザで開いてインストール）"

step "soundtoys" \
  "Soundtoys 5 Bundle" \
  "アカウントにサインイン → ダウンロード → インストーラー実行（iLok認証）" \
  "url:https://www.soundtoys.com/my-soundtoys/" \
  "EchoBoy, Decapitator, PhaseMistress, FilterFreak, LittleAlterBoy 等 18種"

step "fabfilter" \
  "FabFilter" \
  "アカウントにサインイン → My Products → 一括ダウンロード" \
  "url:https://www.fabfilter.com/my-account/" \
  "Pro-Q 3, Pro-C 2, Pro-L 2 (Pro-Q 2 は旧版)"

step "valhalla" \
  "Valhalla DSP" \
  "アカウントにサインイン → ダウンロード → 各プラグインをインストール" \
  "url:https://valhalladsp.com/my-account/" \
  "ValhallaRoom, ValhallaPlate, ValhallaVintageVerb"

step "gullfoss" \
  "Soundtheory Gullfoss" \
  "アカウントにサインイン → Gullfoss, Gullfoss Master をダウンロード" \
  "url:https://www.soundtheory.com/my-account" \
  "Gullfoss, Gullfoss Live, Gullfoss Master"

step "wavesfactory" \
  "Wavesfactory" \
  "アカウントにサインイン → Trackspacer, Cassette, Echo Cat, Equalizer をダウンロード" \
  "url:https://www.wavesfactory.com/my-account/" \
  "Trackspacer, Cassette, Echo Cat, Equalizer"

step "sylenth1" \
  "Sylenth1" \
  "アカウントにサインイン → Mac版をダウンロード" \
  "url:https://www.lennardigital.com/sylenth1/downloads/" \
  "Sylenth1 3.x"

step "serum" \
  "Serum / Serum2" \
  "Xfer アカウント → Serum + Serum2 Mac版をダウンロード" \
  "url:https://xferrecords.com/my_account" \
  "Serum 1.363, Serum2 2.x"

step "scaler2" \
  "Scaler 2" \
  "Plugin Boutique アカウント → Scaler 2 をダウンロード" \
  "url:https://www.pluginboutique.com/account/downloads" \
  "Scaler2, ScalerAudio2, ScalerControl2"

step "pulsar" \
  "Pulsar Audio" \
  "アカウントにサインイン → 1178, Mu, W495 をダウンロード" \
  "url:https://pulsar.audio/my-account/" \
  "Pulsar 1178, Pulsar Mu, Pulsar W495"

step "soothe2" \
  "soothe2" \
  "oeksound アカウント → soothe2 Mac版をダウンロード（VST3のみ）" \
  "url:https://oeksound.com/my-account/" \
  "soothe2 1.3.x"

step "sonible" \
  "sonible" \
  "アカウントにサインイン → smart 系プラグインをダウンロード" \
  "url:https://www.sonible.com/my-account/" \
  "smartEQ 3, smartEQ 4, smartComp 2, smartlimit"

step "melodyne" \
  "Celemony Melodyne" \
  "アカウントにサインイン → Melodyne 5 をダウンロード" \
  "url:https://www.celemony.com/en/service1/download-shop" \
  "Melodyne 5.x"

step "unfiltered" \
  "Unfiltered Audio" \
  "アカウントにサインイン → 各プラグインをダウンロード" \
  "url:https://www.unfilteredaudio.com/collections/plug-ins" \
  "LION, Byome, G8, Dent 2, Fault, Sandman Pro 等 14種"

step "melda" \
  "MeldaProduction" \
  "MCompleteBundle インストーラーをダウンロード → 必要プラグインのみ選択インストール" \
  "url:https://www.meldaproduction.com/downloads" \
  "MAutoAlign, MAutoDynamicEq, MMultiAnalyzer, MUtility"

step "bettermaker" \
  "Bettermaker" \
  "アカウントにサインイン → EQ232D 等をダウンロード" \
  "url:https://bettermaker.eu/plugins/" \
  "Bettermaker EQ232D, Bus Compressor, C502V, Passive Equalizer"

step "lindell" \
  "Lindell Plugins" \
  "アカウントにサインイン → Bundle をダウンロード" \
  "url:https://www.lindellplugins.com/my-account/" \
  "6X-500, 7X-500, 254E, 354E, 80 Series, ChannelX, MBC, SBC, TE-100 等"

step "plugindoctor" \
  "PluginDoctor (DDMF)" \
  "ライセンスキーでダウンロード" \
  "url:https://ddmf.eu/plugindoctor/" \
  "PluginDoctor 2.x"

step "gainmatch" \
  "GainMatch (LetiMix)" \
  "ダウンロードページから無料取得" \
  "url:https://letimix.com/products/gainmatch" \
  "GainMatch AU / VST3"

step "aom" \
  "A.O.M. Triple Fader" \
  "アカウントにサインイン → ダウンロード" \
  "url:https://www.aom-factory.jp/products/triple-fader/" \
  "Triple Fader"

step "dotec" \
  "DOTEC-AUDIO DeeGain" \
  "アカウントにサインイン → DeeGain をダウンロード" \
  "url:https://dotec-audio.com/deegain.html" \
  "DeeGain 1.1.3"

step "voosteq" \
  "VoosteQ" \
  "アカウントにサインイン → Material Comp, Model N Channel をダウンロード" \
  "url:https://www.voosteq.com/products/" \
  "Material Comp, Model N Channel"

step "cableguys" \
  "Cableguys ShaperBox 2" \
  "アカウントにサインイン → ShaperBox 2 をダウンロード" \
  "url:https://www.cableguys.com/shaperbox.html" \
  "ShaperBox 2"

step "apogee" \
  "Apogee SoftLimit" \
  "Apogee アカウント → SoftLimit をダウンロード" \
  "url:https://apogeedigital.com/downloads" \
  "SoftLimit 1.x"

step "sonnox" \
  "Sonnox" \
  "アカウントにサインイン → Claro, ListenHub, Voca, VoxD をダウンロード（iLok認証）" \
  "url:https://www.sonnox.com/my-account" \
  "Claro, ListenHub, Voca, VoxD Thicken, VoxD Widen"

step "ltl" \
  "Louder Than Liftoff" \
  "アカウントにサインイン → LTL Chop Shop EQ, Silver Bullet mk2 をダウンロード" \
  "url:https://louderthanliftoff.com/account/" \
  "LTL Chop Shop EQ, Silver Bullet mk2"

step "kit_plugins" \
  "KIT Plugins" \
  "ダウンロードページ → KIT BB N105 V2 を取得" \
  "url:https://kitplugins.com/downloads/" \
  "KIT BB N105 V2"

step "toneboosters" \
  "Toneboosters Morphit" \
  "アカウントにサインイン → Morphit をダウンロード" \
  "url:https://www.toneboosters.com/tb_morphit_v2.html" \
  "Morphit 2.x"

step "stevenslate" \
  "Steven Slate Drums (SSD Sampler 5)" \
  "Steven Slate Audio アカウント → SSD 5 インストーラーをダウンロード" \
  "url:https://stevenslatedrums.com/account/" \
  "SSD Sampler 5"

step "vienna_ep" \
  "Vienna Ensemble Pro 7" \
  "VSL ショップ → Vienna Ensemble Pro 7 をダウンロード（eLicenser / Vienna Key 必要）" \
  "url:https://www.vsl.co.at/en/Service/Downloads" \
  "Vienna Ensemble Pro 7, Audio Input, Event Input"

}

# ============================================================
# Phase 4: 自動インストール（スクリプト）
# ============================================================
[[ $START_PHASE -le 4 ]] && {

phase 4 "自動インストール（スクリプト実行）"

step "free_plugins" \
  "無料プラグイン自動インストール" \
  "Airwindows Consolidated, NeuralAmpModeler を GitHub から自動DL・インストール" \
  "script:$(dirname "$0")/install-free-plugins.sh" \
  "Airwindows 全種（AU/VST3/CLAP）, NeuralAmpModeler（AU/VST3）"

step "tse_bod" \
  "TSE Audio BOD（手動）" \
  "BODはVST2のみ・要手動ダウンロード" \
  "url:https://www.tse-audio.com/content/BOD.html" \
  "BOD 3.x（VST2）"

}

# ============================================================
# Phase 5: 後処理
# ============================================================
[[ $START_PHASE -le 5 ]] && {

phase 5 "後処理"

step "daw_rescan" \
  "DAWでプラグインスキャン" \
  "Ableton Live / Studio One を起動してプラグインを再スキャン" \
  "app:Ableton Live 12 Suite" \
  ""

step "pluginfo" \
  "PlugInfo でインストール確認" \
  "MAS版 PlugInfo を起動して全プラグインを確認" \
  "cmd:open -a PlugInfo" \
  ""

step "plugoff_verify" \
  "Plugoff で最終確認" \
  "Plugoff を起動して前回レポートと比較" \
  "url:https://plugoff.app" \
  ""

}

# ============================================================
# 完了サマリー
# ============================================================
echo ""
header "セットアップ完了！"
echo ""
progress_bar
echo ""
echo -e "  ${GREEN}お疲れ様でした！${NC}"
echo ""
echo -e "  進捗ファイル: ${DIM}$STATE_FILE${NC}"
echo -e "  リセット:     ${DIM}./plugin-setup-guide.sh --reset${NC}"
echo -e "  特定Phaseから再開: ${DIM}./plugin-setup-guide.sh --phase 3${NC}"
echo ""
