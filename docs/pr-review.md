# PR Review

プルリクエストをAIで多角的にレビューし、セキュリティ問題の検出やコード品質の向上を支援するワークフローです。

## 🎯 概要

このワークフローは、PR作成時や更新時に自動的に実行され、複数のAIエンジニアがそれぞれの専門分野から以下をレビューします：

- 🔒 **Security Engineer**: セキュリティ脆弱性の検出
- 🧪 **QA Engineer**: バグやエラーハンドリングの確認
- 🏗️ **Senior Architect**: コード品質と設計の評価
- 📱 **Product Manager**: ユーザー影響とビジネス価値

## 📋 前提条件

### 必須シークレット

各リポジトリで以下のシークレットを設定してください：

- `ANTHROPIC_API_KEY` - Claude API用
- `OPENAI_API_KEY` - OpenAI API用

### オプション
- `GH_PAT` - より詳細なPR情報取得用（なくても動作します）

## 🚀 使用方法

### 1. ワークフローの設定

リポジトリの `.github/workflows/` ディレクトリに以下のファイルを作成：

```yaml
name: PR Auto Review

on:
  pull_request:
    types: [opened, synchronize]
  
  workflow_dispatch:
    inputs:
      pr_number:
        description: 'PR番号（手動実行時）'
        required: true
        type: number
      review_type:
        description: 'レビューの深さ'
        required: false
        default: 'balanced'
        type: choice
        options:
          - quick
          - balanced
          - detailed

permissions:
  contents: read
  pull-requests: write

jobs:
  trigger-review:
    runs-on: ubuntu-latest
    outputs:
      number: ${{ steps.pr.outputs.number }}
      type: ${{ steps.pr.outputs.type }}
    steps:
      - name: Determine PR number and settings
        id: pr
        run: |
          if [[ "${{ github.event_name }}" == "workflow_dispatch" ]]; then
            echo "number=${{ inputs.pr_number }}" >> $GITHUB_OUTPUT
            echo "type=${{ inputs.review_type }}" >> $GITHUB_OUTPUT
          else
            echo "number=${{ github.event.pull_request.number }}" >> $GITHUB_OUTPUT
            # PRサイズに基づいてレビュータイプを決定
            PR_SIZE=${{ github.event.pull_request.additions }}
            if [[ $PR_SIZE -gt 500 ]] || [[ "${{ contains(github.event.pull_request.labels.*.name, 'security') }}" == "true" ]]; then
              echo "type=detailed" >> $GITHUB_OUTPUT
            else
              echo "type=balanced" >> $GITHUB_OUTPUT
            fi
          fi

      - name: Post start message
        uses: actions/github-script@v7
        with:
          script: |
            const pr_number = ${{ steps.pr.outputs.number }};
            const type = '${{ steps.pr.outputs.type }}';
            
            await github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: pr_number,
              body: `🤖 AI Code Review を開始します...\n- Type: ${type}\n- Repository: ${context.repo.repo}`
            });

  review:
    needs: trigger-review
    if: always()
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review.yml@main
    with:
      pr_number: ${{ needs.trigger-review.outputs.number }}
      repository: ${{ github.repository }}
      review_type: ${{ needs.trigger-review.outputs.type }}
      max_diff_lines: 10000
      enable_code_suggestions: true
    secrets: inherit
```

### 2. レビューの実行

#### 自動実行
- PR作成時・更新時に自動的に実行されます
- PRサイズやラベルに基づいて適切なレビュータイプが選択されます

#### 手動実行
Actions タブから手動でワークフローを実行し、PR番号とレビュータイプを指定

## 🔧 レビュータイプ

### quick（高速）
- 2名のレビュアー
- 主要な問題のみ指摘
- 小規模な変更向け

### balanced（バランス）
- 4名のレビュアー  
- 標準的な深さのレビュー
- デフォルト設定

### detailed（詳細）
- 4名のレビュアー
- 徹底的なレビュー
- 大規模変更やセキュリティ関連向け

## 🛡️ セキュリティパターン検出

以下のセキュリティ問題を自動検出：

- **Critical（重大）**
  - パスワードの平文保存
  - SQLインジェクション
  - ハードコードされた認証情報
  - 安全でない動的コード実行

- **High（高）**
  - 認証チェックの欠如
  - 機密情報のログ出力

- **Medium（中）**
  - 弱い暗号化アルゴリズム
  - セキュリティヘッダーの欠如

## 📊 出力例

```markdown
# 🤖 AI Multi-Role Code Review v2.2

**PR:** #123 新機能の追加
**Review Type:** Balanced (4 roles)
**Security Issues Detected:** 2
**Timestamp:** 2024-11-26 10:30 UTC

## 判定
⚠️ 条件付き承認

## 必須対応 (ブロッカー)
1. SQLインジェクションの脆弱性を修正
2. APIキーがハードコードされている

## 推奨対応
1. エラーハンドリングの改善
2. テストカバレッジの向上

---

### 💰 Token Usage & Cost

| Model | Input Tokens | Output Tokens | Cost (USD) |
|-------|-------------|---------------|------------|
| claude-3-5-sonnet | 5,234 | 1,256 | $0.0245 |
| gpt-4o-mini | 3,421 | 892 | $0.0012 |
| **Total** | **8,655** | **2,148** | **$0.0257** |
```

## 🎯 カスタマイズ

### レビュー対象の制限

特定のファイルパターンのみレビュー：

```yaml
with:
  pr_number: ${{ github.event.pull_request.number }}
  repository: ${{ github.repository }}
  review_type: 'balanced'
  max_diff_lines: 5000  # 差分の最大行数
  enable_code_suggestions: false  # コード提案を無効化
```

### AIモデルの変更

使用するAIモデルをカスタマイズ：

```yaml
with:
  models: '{"claude": "claude-3-opus-20240229", "openai": "gpt-4-turbo"}'
```

## 🏷️ 自動ラベル

レビュー結果に基づいて以下のラベルが自動付与されます：

- `ai-reviewed` - レビュー完了
- `security-review-needed` - セキュリティ問題検出
- `ready-to-merge` - 承認可能
- `needs-work` - 要修正

## 🛠️ トラブルシューティング

### レビューが投稿されない
→ `pull-requests: write` 権限があることを確認

### トークン使用量が表示されない
→ 最新のv2.2を使用していることを確認

### セキュリティパターンが検出されない
→ ソースコードファイルが含まれているか確認

## 📚 関連ドキュメント

- [NFTT-GitHub-Workflows README](../README.md)
- [セキュリティガイド](SECURITY.md)