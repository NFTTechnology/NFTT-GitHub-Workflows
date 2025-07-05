# 3AI Issue Analyzer

## 概要

Issueに対して3つのAI（Claude、Gemini、OpenAI）による協調分析を実行し、総合的な実装提案を生成します。

## 🔍 機能

- **Claude**: 要件分析、実装計画、統合レポート作成
- **Gemini**: 技術分析、ベストプラクティス、パフォーマンス考慮
- **OpenAI**: UX分析、ドキュメント戦略、ユーザー影響評価

## 🔐 必要なシークレット

呼び出し側のリポジトリで以下のシークレットを設定してください：

- `ANTHROPIC_API_KEY` - Claude APIキー（必須）
- `OPENAI_API_KEY` - OpenAI APIキー（必須）
- `GEMINI_API_KEY` - Google Gemini APIキー（必須）
- `GITHUB_TOKEN` - GitHub APIトークン（オプション、デフォルトで`github.token`を使用）

## 🚀 使用方法

### 基本的な使用例

```yaml
name: Issue Analysis
on:
  issue_comment:
    types: [created]

jobs:
  analyze:
    if: |
      github.event.issue.pull_request == null &&
      contains(github.event.comment.body, '/analyze')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      comment_id: ${{ github.event.comment.id }}
      repository: ${{ github.repository }}
    secrets: inherit
```

### 手動トリガーの例

```yaml
name: Manual Issue Analysis
on:
  workflow_dispatch:
    inputs:
      issue_number:
        description: 'Issue number to analyze'
        required: true
        type: number

jobs:
  get-issue-details:
    runs-on: ubuntu-latest
    outputs:
      title: ${{ steps.get-issue.outputs.title }}
      body: ${{ steps.get-issue.outputs.body }}
    steps:
      - name: Get issue details
        id: get-issue
        uses: actions/github-script@v7
        with:
          script: |
            const issue = await github.rest.issues.get({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: ${{ inputs.issue_number }}
            });
            core.setOutput('title', issue.data.title);
            core.setOutput('body', issue.data.body);

  analyze:
    needs: get-issue-details
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ inputs.issue_number }}
      issue_title: ${{ needs.get-issue-details.outputs.title }}
      issue_body: ${{ needs.get-issue-details.outputs.body }}
      repository: ${{ github.repository }}
    secrets: inherit
```

## 📥 入力パラメータ

| パラメータ | 説明 | 必須 | タイプ |
|-----------|------|------|------|
| `issue_number` | 分析対象のIssue番号 | ✅ | number |
| `issue_title` | Issueのタイトル | ✅ | string |
| `issue_body` | Issueの本文 | ✅ | string |
| `comment_id` | 分析をトリガーしたコメントID | ❌ | number |
| `repository` | リポジトリ名 (owner/repo) | ✅ | string |

## 📤 出力

| 出力 | 説明 |
|------|------|
| `analysis_report` | 3AI分析レポート（Markdown形式） |

## 🔧 カスタマイズ

### AIモデルの変更

ワークフローファイル内の以下の部分を編集して、使用するAIモデルを変更できます：

```python
# Claudeモデル
model="claude-3-5-sonnet-20241022"

# Geminiモデル
gemini_model = genai.GenerativeModel('gemini-2.0-flash-exp')

# OpenAIモデル
model="gpt-4"
```

### プロンプトのカスタマイズ

各AIのプロンプトはワークフローファイル内で直接編集可能です。

## 🐛 トラブルシューティング

### エラー: `Resource not accessible by integration`

**原因**: GitHub Actionsの権限不足

**解決方法**:
```yaml
jobs:
  analyze:
    permissions:
      issues: write
      contents: read
```

### エラー: APIキーエラー

**原因**: シークレットが設定されていないか無効

**解決方法**:
1. Settings > Secrets and variables > Actionsへ移動
2. 必要なシークレットを追加
3. `secrets: inherit`を使用してシークレットを継承

### エラー: ワークフローが見つからない

**原因**: パスまたはブランチ名が間違っている

**解決方法**:
```yaml
# 正しいパスを確認
uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/3ai-issue-analyzer.yml@main
```

## 📊 パフォーマンス

- **実行時間**: 約1-2分（APIレスポンス時間に依存）
- **コスト**: 各AI APIの使用料金に基づく
  - Claude: ~$0.01-0.02/分析
  - OpenAI: ~$0.02-0.03/分析
  - Gemini: ~$0.001-0.002/分析

## 🔄 更新履歴

### v1.0.0 (2025-01-05)
- 初回リリース
- Pu5h-Remindからの移植
- 再利用可能ワークフローとして最適化

## 🔗 関連リンク

- [GitHub Actions Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Claude API Documentation](https://docs.anthropic.com/claude/reference/getting-started-with-the-api)
- [OpenAI API Documentation](https://platform.openai.com/docs/introduction)
- [Google AI Documentation](https://ai.google.dev/docs)