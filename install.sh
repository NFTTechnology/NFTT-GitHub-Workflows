#!/bin/bash
set -e

# NFTT-GitHub-Workflows インストールスクリプト
# Copyright (c) 2025 NFTTechnology

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 設定
REPO_URL="https://raw.githubusercontent.com/NFTTechnology/NFTT-GitHub-Workflows/main"
WORKFLOW_DIR=".github/workflows"
BACKUP_DIR=".github/workflows_backup_$(date +%Y%m%d_%H%M%S)"

# ロゴ表示
print_logo() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║         NFTT-GitHub-Workflows インストーラー              ║"
    echo "║   エンタープライズグレードのAI駆動型ワークフロー         ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# エラーハンドリング
error_exit() {
    echo -e "${RED}❌ エラー: $1${NC}" >&2
    exit 1
}

# 成功メッセージ
success_msg() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 警告メッセージ
warning_msg() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 情報メッセージ
info_msg() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 環境チェック
check_environment() {
    echo -e "\n${BLUE}📋 環境チェック中...${NC}"
    
    # Git チェック
    if ! command -v git &> /dev/null; then
        error_exit "Gitがインストールされていません。先にGitをインストールしてください。"
    fi
    
    # curl チェック
    if ! command -v curl &> /dev/null; then
        error_exit "curlがインストールされていません。先にcurlをインストールしてください。"
    fi
    
    # Gitリポジトリチェック
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error_exit "Gitリポジトリではありません。Gitリポジトリ内で実行してください。"
    fi
    
    success_msg "環境チェック完了"
}

# バージョン選択
select_version() {
    echo -e "\n${BLUE}🎯 バージョンを選択してください:${NC}"
    echo "1) v5 - コスト最適化版（推奨）"
    echo "2) v4 - 深い分析版（コメント履歴対応）"
    echo "3) v3 - 安定版"
    echo "4) カスタム（自分で設定）"
    
    read -p "選択 (1-4) [1]: " choice
    choice=${choice:-1}
    
    case $choice in
        1) VERSION="v5"; WORKFLOW_FILE="reusable-3ai-issue-analyzer.yml" ;;
        2) VERSION="v4"; WORKFLOW_FILE="reusable-3ai-issue-analyzer-v4.yml" ;;
        3) VERSION="v3"; WORKFLOW_FILE="reusable-3ai-issue-analyzer-v3.yml" ;;
        4) 
            read -p "カスタムバージョン（例: v2）: " VERSION
            read -p "ワークフローファイル名: " WORKFLOW_FILE
            ;;
        *) error_exit "無効な選択です" ;;
    esac
    
    info_msg "選択されたバージョン: $VERSION"
}

# ワークフロータイプ選択
select_workflow_type() {
    echo -e "\n${BLUE}🔧 どのワークフローをインストールしますか？${NC}"
    echo "1) Issue分析のみ"
    echo "2) PRレビューのみ"
    echo "3) 両方（推奨）"
    
    read -p "選択 (1-3) [3]: " wf_choice
    wf_choice=${wf_choice:-3}
    
    case $wf_choice in
        1) INSTALL_ISSUE=true; INSTALL_PR=false ;;
        2) INSTALL_ISSUE=false; INSTALL_PR=true ;;
        3) INSTALL_ISSUE=true; INSTALL_PR=true ;;
        *) error_exit "無効な選択です" ;;
    esac
}

# 既存ファイルのバックアップ
backup_existing() {
    if [ -d "$WORKFLOW_DIR" ] && [ "$(ls -A $WORKFLOW_DIR 2>/dev/null)" ]; then
        warning_msg "既存のワークフローファイルが見つかりました"
        read -p "バックアップを作成しますか？ (y/N): " backup_choice
        
        if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
            mkdir -p "$BACKUP_DIR"
            cp -r "$WORKFLOW_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
            success_msg "バックアップを作成しました: $BACKUP_DIR"
        fi
    fi
}

# ディレクトリ作成
create_directories() {
    mkdir -p "$WORKFLOW_DIR"
    success_msg "ワークフローディレクトリを作成しました"
}

# Issue分析ワークフローのインストール
install_issue_workflow() {
    local workflow_content
    workflow_content=$(cat << 'EOF'
name: 3AI Issue Analysis

on:
  issue_comment:
    types: [created]

jobs:
  analyze:
    if: startsWith(github.event.comment.body, '/analyze')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/WORKFLOW_FILE@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      comment_id: ${{ github.event.comment.id }}
    secrets: inherit
EOF
)
    
    # ワークフローファイル名を置換
    workflow_content="${workflow_content//WORKFLOW_FILE/$WORKFLOW_FILE}"
    
    echo "$workflow_content" > "$WORKFLOW_DIR/3ai-issue-analysis.yml"
    success_msg "Issue分析ワークフローをインストールしました"
}

# PRレビューワークフローのインストール
install_pr_workflow() {
    local pr_workflow_content
    pr_workflow_content=$(cat << 'EOF'
name: 3AI PR Review

on:
  pull_request:
    types: [opened, synchronize]
  issue_comment:
    types: [created]

jobs:
  pr-review:
    if: |
      github.event_name == 'pull_request' ||
      (github.event_name == 'issue_comment' && 
       github.event.issue.pull_request && 
       startsWith(github.event.comment.body, '/review'))
    runs-on: ubuntu-latest
    steps:
      - name: Get PR details
        id: pr-details
        uses: actions/github-script@v7
        with:
          script: |
            const pr_number = context.payload.pull_request?.number || context.payload.issue?.number;
            const pr = await github.rest.pulls.get({
              owner: context.repo.owner,
              repo: context.repo.repo,
              pull_number: pr_number
            });
            return {
              number: pr.data.number,
              title: pr.data.title,
              body: pr.data.body || '',
              head_sha: pr.data.head.sha
            };

      - name: Run 3AI Review
        uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review.yml@main
        with:
          pr_number: ${{ fromJson(steps.pr-details.outputs.result).number }}
          pr_title: ${{ fromJson(steps.pr-details.outputs.result).title }}
          pr_body: ${{ fromJson(steps.pr-details.outputs.result).body }}
          repository: ${{ github.repository }}
        secrets: inherit
EOF
)
    
    echo "$pr_workflow_content" > "$WORKFLOW_DIR/3ai-pr-review.yml"
    success_msg "PRレビューワークフローをインストールしました"
}

# APIキー設定ガイド
show_api_key_guide() {
    echo -e "\n${BLUE}🔑 APIキーの設定${NC}"
    echo -e "\n以下のAPIキーをGitHubリポジトリのシークレットに追加してください："
    echo -e "\n1. ${YELLOW}Settings${NC} → ${YELLOW}Secrets and variables${NC} → ${YELLOW}Actions${NC} に移動"
    echo -e "\n2. 以下のシークレットを追加:"
    echo -e "   ${GREEN}ANTHROPIC_API_KEY${NC} - https://console.anthropic.com/"
    echo -e "   ${GREEN}OPENAI_API_KEY${NC} - https://platform.openai.com/api-keys"
    echo -e "   ${GREEN}GEMINI_API_KEY${NC} - https://makersuite.google.com/app/apikey"
}

# 次のステップ
show_next_steps() {
    echo -e "\n${BLUE}📝 次のステップ${NC}"
    echo -e "\n1. APIキーを設定（上記参照）"
    echo -e "2. Issueで ${YELLOW}/analyze${NC} とコメントして動作確認"
    if [ "$INSTALL_PR" = true ]; then
        echo -e "3. PRを作成して自動レビューを確認"
    fi
    echo -e "\n詳細なドキュメント: ${BLUE}https://github.com/NFTTechnology/NFTT-GitHub-Workflows${NC}"
}

# メイン処理
main() {
    clear
    print_logo
    
    # 環境チェック
    check_environment
    
    # バージョン選択
    select_version
    
    # ワークフロータイプ選択
    select_workflow_type
    
    # バックアップ
    backup_existing
    
    # ディレクトリ作成
    create_directories
    
    # インストール
    echo -e "\n${BLUE}📦 ワークフローをインストール中...${NC}"
    
    if [ "$INSTALL_ISSUE" = true ]; then
        install_issue_workflow
    fi
    
    if [ "$INSTALL_PR" = true ]; then
        install_pr_workflow
    fi
    
    # 完了メッセージ
    echo -e "\n${GREEN}🎉 インストール完了！${NC}"
    
    # APIキーガイド表示
    show_api_key_guide
    
    # 次のステップ表示
    show_next_steps
    
    echo -e "\n${GREEN}✨ NFTT-GitHub-Workflowsをお楽しみください！${NC}\n"
}

# 実行
main "$@"