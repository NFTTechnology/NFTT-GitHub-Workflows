# 3AI Issue Analyzer 導入ガイド

## 📋 概要

3AI Issue Analyzerは、Claude、Gemini、OpenAIの3つのAIを使用してGitHub Issueを包括的に分析するツールです。

## 🚀 クイックスタート

### 1. シークレットの設定

各リポジトリで以下のシークレットを設定してください：

```
Settings → Secrets and variables → Actions → New repository secret
```

必要なシークレット：
- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY`
- `GEMINI_API_KEY`

### 2. ワークフローファイルの作成

`.github/workflows/`ディレクトリに以下のファイルを作成：

```yaml
name: 3AI Issue Analysis

on:
  issue_comment:
    types: [created]

jobs:
  analyze:
    if: contains(github.event.comment.body, '/analyze')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer-v3.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      comment_id: ${{ github.event.comment.id }}
    secrets: inherit
```

### 3. 使用方法

Issueで `/analyze` とコメントすると3AI分析が開始されます。

## 📝 トリガー別実装例

### Issue コメントトリガー（推奨）

- **ファイル**: [issue-comment-trigger.yml](examples/issue-comment-trigger.yml)
- **動作**: Issueで `/analyze` コメントで分析開始
- **特徴**: 🚀 リアクション付き、必要な時だけ実行

### Issue 作成時トリガー

- **ファイル**: [issue-opened-trigger.yml](examples/issue-opened-trigger.yml)
- **動作**: `analyze` ラベル付きIssue作成時に自動分析
- **特徴**: 新規Issueの自動分析

### 定期実行トリガー

- **ファイル**: [scheduled-analysis.yml](examples/scheduled-analysis.yml)
- **動作**: 毎週月曜日に `needs-analysis` ラベルのIssueを分析
- **特徴**: バッチ処理、API制限考慮

### 手動実行トリガー

- **ファイル**: [manual-analysis.yml](examples/manual-analysis.yml)
- **動作**: Actions タブから Issue 番号を指定して実行
- **特徴**: 任意のタイミングで実行可能

## 🔧 カスタマイズ

### コマンドの変更

`/analyze` を別のコマンドに変更：

```yaml
if: contains(github.event.comment.body, '/ai-check')  # お好みのコマンドに
```

### ラベルの変更

自動分析のラベルを変更：

```yaml
if: contains(github.event.issue.labels.*.name, 'ai-review')  # お好みのラベルに
```

### API制限の調整

定期実行の処理数を変更：

```yaml
per_page: 10  # 一度に処理する数（デフォルト: 5）
max-parallel: 2  # 並列実行数（デフォルト: 1）
```

## 📊 分析内容

3つのAIがそれぞれ異なる観点から分析：

1. **Claude** 🤖
   - 問題の本質的な理解
   - 実装の具体的なステップ
   - 成功基準の明確化

2. **Gemini** 🔮
   - 技術的な詳細分析
   - パフォーマンスとセキュリティ
   - ベストプラクティス

3. **OpenAI** 💡
   - ユーザー体験への影響
   - ドキュメント戦略
   - 移行計画

## ⚠️ 注意事項

1. **API制限**
   - 各AIプロバイダーのレート制限に注意
   - 大量のIssueを一度に処理しない

2. **コスト**
   - API使用量に応じた課金が発生
   - 必要に応じてmax_tokensを調整

3. **プライバシー**
   - センシティブな情報を含むIssueでは使用を控える
   - 各AIプロバイダーのデータ取り扱いポリシーを確認

## 🐛 トラブルシューティング

### よくある問題

1. **「Secret not found」エラー**
   - シークレットが正しく設定されているか確認
   - 名前が正確に一致しているか確認（大文字小文字も）

2. **「0秒で失敗」する場合**
   - ワークフローファイルの構文エラーをチェック
   - YAMLのインデントが正しいか確認

3. **分析結果が投稿されない**
   - GitHub Actionsの実行ログを確認
   - APIキーが有効か確認

### デバッグ方法

1. Actions タブで実行ログを確認
2. 各ステップの出力をチェック
3. エラーメッセージを確認

## 📚 関連リソース

- [GitHub Actions ドキュメント](https://docs.github.com/actions)
- [test-workflow リポジトリ](https://github.com/NFTTechnology/test-workflow) - 実装例

## 💬 サポート

問題や質問がある場合は、[Issues](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/issues)で報告してください。