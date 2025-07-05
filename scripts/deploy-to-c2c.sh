#!/bin/bash
# share-manga-c2c-api/admin へのワークフロー導入スクリプト

set -e

# カラー出力用の設定
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== NFTT-GitHub-Workflows 導入スクリプト ===${NC}"
echo ""

# 引数チェック
if [ $# -ne 1 ]; then
    echo -e "${RED}使用方法: $0 <api|admin>${NC}"
    echo "例: $0 api   # share-manga-c2c-apiに導入"
    echo "例: $0 admin # share-manga-c2c-adminに導入"
    exit 1
fi

TARGET=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOWS_DIR="$(dirname "$SCRIPT_DIR")"

case $TARGET in
    api)
        REPO_NAME="share-manga-c2c-api"
        SOURCE_DIR="$WORKFLOWS_DIR/share-manga-c2c-api-workflows"
        ;;
    admin)
        REPO_NAME="share-manga-c2c-admin"
        SOURCE_DIR="$WORKFLOWS_DIR/share-manga-c2c-admin/.github/workflows"
        ;;
    *)
        echo -e "${RED}エラー: 引数は 'api' または 'admin' である必要があります${NC}"
        exit 1
        ;;
esac

echo -e "${YELLOW}対象リポジトリ: $REPO_NAME${NC}"
echo ""

# リポジトリパスの入力
read -p "share-manga-$TARGET のローカルパスを入力してください: " REPO_PATH

# パスの検証
if [ ! -d "$REPO_PATH" ]; then
    echo -e "${RED}エラー: ディレクトリが存在しません: $REPO_PATH${NC}"
    exit 1
fi

if [ ! -d "$REPO_PATH/.git" ]; then
    echo -e "${RED}エラー: Gitリポジトリではありません: $REPO_PATH${NC}"
    exit 1
fi

# ワークフローディレクトリの作成
DEST_DIR="$REPO_PATH/.github/workflows"
mkdir -p "$DEST_DIR"

# ファイルのコピー
echo -e "${GREEN}ワークフローファイルをコピー中...${NC}"

if [ "$TARGET" = "api" ]; then
    cp "$SOURCE_DIR/ai-pr-review.yml" "$DEST_DIR/"
    cp "$SOURCE_DIR/ai-issue-analyzer.yml" "$DEST_DIR/"
else
    cp "$SOURCE_DIR/ai-pr-review.yml" "$DEST_DIR/"
    cp "$SOURCE_DIR/ai-issue-analyzer.yml" "$DEST_DIR/"
fi

echo -e "${GREEN}✓ ワークフローファイルをコピーしました${NC}"

# Git操作の確認
echo ""
echo -e "${YELLOW}以下のコマンドを実行してワークフローを追加します:${NC}"
echo ""
echo "cd $REPO_PATH"
echo "git add .github/workflows/ai-*.yml"
echo "git commit -m \"feat: AI PR Review と 3AI Issue Analyzerワークフローを追加\""
echo "git push"
echo ""

read -p "上記のコマンドを自動実行しますか？ (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd "$REPO_PATH"
    git add .github/workflows/ai-*.yml
    git commit -m "feat: AI PR Review と 3AI Issue Analyzerワークフローを追加"
    echo -e "${GREEN}✓ コミット完了${NC}"
    echo ""
    echo -e "${YELLOW}プッシュは手動で実行してください: git push${NC}"
else
    echo -e "${YELLOW}手動でGit操作を実行してください${NC}"
fi

# APIキーの設定リマインダー
echo ""
echo -e "${YELLOW}=== 重要: APIキーの設定 ===${NC}"
echo "GitHubリポジトリの Settings → Secrets and variables → Actions で以下を設定してください:"
echo ""
echo "  - ANTHROPIC_API_KEY"
echo "  - OPENAI_API_KEY"
echo "  - GEMINI_API_KEY"
echo ""
echo -e "${GREEN}設定完了後、以下で動作確認してください:${NC}"
echo "  - PRを作成 → 自動レビューが開始"
echo "  - Issueで /analyze とコメント → 3AI分析が開始"
echo ""
echo -e "${GREEN}導入作業完了！${NC}"