# share-manga-c2c-api ワークフロー設定手順

このディレクトリには、NFTTechnology/share-manga-c2c-apiリポジトリ用のGitHub Actionsワークフローが含まれています。

## ワークフローファイル

1. **ai-pr-review.yml** - PR自動レビューワークフロー（詳細レビューにカスタマイズ済み）
2. **ai-issue-analyzer.yml** - 3AI Issue分析ワークフロー

## セットアップ手順

### 1. ワークフローファイルのコピー

share-manga-c2c-apiリポジトリで以下のコマンドを実行してください：

```bash
# リポジトリのルートディレクトリへ移動
cd /path/to/share-manga-c2c-api

# .github/workflowsディレクトリを作成（既存の場合はスキップ）
mkdir -p .github/workflows

# ワークフローファイルをコピー
cp /home/godamasato/projects/NFTTechnology/NFTT-GitHub-Workflows/share-manga-c2c-api-workflows/ai-pr-review.yml .github/workflows/
cp /home/godamasato/projects/NFTTechnology/NFTT-GitHub-Workflows/share-manga-c2c-api-workflows/ai-issue-analyzer.yml .github/workflows/

# ファイルをGitに追加
git add .github/workflows/ai-pr-review.yml
git add .github/workflows/ai-issue-analyzer.yml

# コミット
git commit -m "feat: AI PR Review と 3AI Issue Analyzerワークフローを追加"

# プッシュ
git push origin main
```

### 2. 必要なシークレットの設定

GitHubリポジトリの Settings → Secrets and variables → Actions で以下のシークレットを設定してください：

- **ANTHROPIC_API_KEY** - Claude API キー
- **OPENAI_API_KEY** - OpenAI API キー
- **GEMINI_API_KEY** - Google Gemini API キー

### 3. 動作確認

#### PR Reviewの確認
1. 新しいPRを作成する
2. 自動的にAIレビューが開始される
3. 詳細なレビューコメントが投稿される

#### 3AI Issue Analyzerの確認
1. Issueを作成する
2. コメントで `/analyze` と入力
3. 3つのAIによる分析結果が投稿される

## カスタマイズ内容

### PR Review
- `review_type` を常に `detailed` に設定
- これにより、全てのPRで詳細なコードレビューが実行されます

## トラブルシューティング

### ワークフローが実行されない場合
1. リポジトリの Actions タブでワークフローが有効になっているか確認
2. 必要なシークレットが正しく設定されているか確認
3. ワークフローファイルの権限設定を確認

### APIエラーが発生する場合
1. API キーが正しく設定されているか確認
2. API の利用制限に達していないか確認
3. ワークフローのログを確認して詳細なエラーメッセージを確認