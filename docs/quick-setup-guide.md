# NFTT-GitHub-Workflows クイックセットアップガイド

## 即座に導入するための手順

### 1. 必須の事前準備（5分）

#### APIキーの取得と設定
各リポジトリのSettings → Secrets and variables → Actions → New repository secretで以下を設定：

1. **ANTHROPIC_API_KEY**
   - [Anthropic Console](https://console.anthropic.com/)で取得
   
2. **OPENAI_API_KEY**
   - [OpenAI Platform](https://platform.openai.com/api-keys)で取得
   
3. **GEMINI_API_KEY**
   - [Google AI Studio](https://makersuite.google.com/app/apikey)で取得

### 2. PR Reviewワークフローの導入（3分）

#### share-manga-c2c-api用コマンド
```bash
# リポジトリのルートディレクトリで実行
mkdir -p .github/workflows

# ワークフローファイルを作成
cat > .github/workflows/ai-pr-review.yml << 'EOF'
name: AI PR Auto Review

on:
  pull_request:
    types: [opened, synchronize]
  
  workflow_dispatch:
    inputs:
      pr_number:
        description: 'PR番号（手動実行時）'
        required: true
        type: number

permissions:
  contents: read
  pull-requests: write

jobs:
  trigger-review:
    runs-on: ubuntu-latest
    outputs:
      number: ${{ steps.pr.outputs.number }}
    steps:
      - name: Determine PR number
        id: pr
        run: |
          if [[ "${{ github.event_name }}" == "workflow_dispatch" ]]; then
            echo "number=${{ inputs.pr_number }}" >> $GITHUB_OUTPUT
          else
            echo "number=${{ github.event.pull_request.number }}" >> $GITHUB_OUTPUT
          fi

      - name: Post start message
        uses: actions/github-script@v7
        with:
          script: |
            const pr_number = ${{ steps.pr.outputs.number }};
            await github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: pr_number,
              body: '🤖 AI Code Review を開始します...'
            });

  review:
    needs: trigger-review
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review.yml@main
    with:
      pr_number: ${{ needs.trigger-review.outputs.number }}
      repository: ${{ github.repository }}
      review_type: 'detailed'
      max_diff_lines: 5000
      enable_code_suggestions: true
    secrets: inherit
EOF

# コミットしてプッシュ
git add .github/workflows/ai-pr-review.yml
git commit -m "feat: AI PR自動レビューワークフローを追加"
git push
```

#### share-manga-c2c-admin用コマンド
```bash
# adminリポジトリ用（UIフォーカス設定）
cat > .github/workflows/ai-pr-review.yml << 'EOF'
name: AI PR Auto Review

on:
  pull_request:
    types: [opened, synchronize]
    paths-ignore:
      - '*.md'
      - 'docs/**'
      - 'package-lock.json'

permissions:
  contents: read
  pull-requests: write

jobs:
  trigger-review:
    runs-on: ubuntu-latest
    outputs:
      number: ${{ steps.pr.outputs.number }}
    steps:
      - name: Determine PR number
        id: pr
        run: |
          echo "number=${{ github.event.pull_request.number }}" >> $GITHUB_OUTPUT

      - name: Post start message
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: ${{ github.event.pull_request.number }},
              body: '🤖 AI Code Review を開始します... (UI/UXフォーカス)'
            });

  review:
    needs: trigger-review
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review.yml@main
    with:
      pr_number: ${{ needs.trigger-review.outputs.number }}
      repository: ${{ github.repository }}
      review_type: 'balanced'
      max_diff_lines: 8000
      enable_code_suggestions: true
    secrets: inherit
EOF
```

### 3. 3AI Issue Analyzerの導入（2分）

両リポジトリ共通：
```bash
cat > .github/workflows/3ai-issue-analyzer.yml << 'EOF'
name: 3AI Issue Analysis

on:
  issue_comment:
    types: [created]
  
  workflow_dispatch:
    inputs:
      issue_number:
        description: '分析するIssue番号'
        required: true
        type: number

jobs:
  analyze-issue:
    if: |
      (github.event_name == 'issue_comment' && 
       github.event.issue.pull_request == null &&
       contains(github.event.comment.body, '/analyze')) ||
      github.event_name == 'workflow_dispatch'
    
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    
    with:
      issue_number: ${{ github.event_name == 'workflow_dispatch' && github.event.inputs.issue_number || github.event.issue.number }}
      issue_title: ${{ github.event.issue.title || 'Manual Analysis' }}
      issue_body: ${{ github.event.issue.body || 'Manual analysis requested' }}
      repository: ${{ github.repository }}
      comment_id: ${{ github.event.comment.id || 0 }}
    
    secrets: inherit
    
    permissions:
      issues: write
      contents: read
EOF

git add .github/workflows/3ai-issue-analyzer.yml
git commit -m "feat: 3AI Issue分析ワークフローを追加"
git push
```

### 4. 動作確認

#### PR Reviewの確認
1. 新しいブランチを作成してPRを作成
2. 自動的にAIレビューが開始されることを確認

#### Issue Analyzerの確認
1. 新しいIssueを作成
2. コメントに `/analyze` と入力
3. 3つのAIによる分析結果が投稿されることを確認

### 5. トラブルシューティング

#### よくあるエラーと対処法

**「API key not found」エラー**
→ Secretsの設定を再確認

**レビューが開始されない**
→ Actionsタブで実行状況を確認

**タイムアウトエラー**
→ max_diff_linesを減らす

### 6. カスタマイズのヒント

必要に応じて以下を調整：
- `review_type`: quick/balanced/detailed から選択
- `max_diff_lines`: 大きなPRの場合は増やす
- パス除外設定: 不要なファイルをスキップ

---

以上で基本的な導入は完了です。問題が発生した場合は、Actionsタブのログを確認してください。