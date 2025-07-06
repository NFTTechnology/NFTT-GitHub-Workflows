# 3AI Issue Analyzer 導入ガイド

## 📋 概要

3AI Issue Analyzerは、Claude、Gemini、OpenAIの3つのAIを使用してGitHub Issueを包括的に分析するツールです。

### 🌟 主な特徴
- **3AI並列分析**: 異なる視点からの包括的なコードレビュー
- **コスト最適化**: Claude 3.5 Sonnet採用でGPT-4比95%コスト削減
- **柔軟なトリガー**: コメント、ラベル、スケジュール実行に対応
- **カスタマイズ可能**: 目的に応じたバージョン選択

## 📊 バージョン情報

現在、3AI Issue Analyzerには5つのバージョンがあります：

- **v5**（推奨）: コスト最適化版 - デフォルト
- **v4**: コメント履歴対応版
- **v3**: シンプル版
- **v2**: 非推奨（Base64実装）
- **v1**: 非推奨（初期実装）

詳細は[バージョン比較ガイド](VERSION_COMPARISON.md)を参照してください。

## 🚀 クイックスタート

### 🎯 ワンクリックインストール（推奨）

プロジェクトルートで以下のコマンドを実行：

```bash
curl -fsSL https://raw.githubusercontent.com/NFTTechnology/NFTT-GitHub-Workflows/main/install.sh | bash
```

このスクリプトは以下を自動で行います：
- 環境チェック（Git、curlの確認）
- バージョン選択（v5推奨）
- ワークフローファイルの作成
- APIキー設定ガイドの表示

### 手動インストール

#### 1. シークレットの設定

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
    if: startsWith(github.event.comment.body, '/analyze')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
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

## 💰 コスト情報

### AIプロバイダー料金（2025年最新）

| AI | 入力トークン | 出力トークン | コスト効率 |
|-----|------------|------------|----------|
| Claude 3.5 Sonnet | $3/1M | $15/1M | ★★★★★ |
| GPT-4 Turbo | $10/1M | $30/1M | ★★★ |
| Gemini Pro | $1.25/1M | $10/1M | ★★★★ |

詳細は各AIプロバイダーの公式ドキュメントを参照：
- [Claude API料金](https://www.anthropic.com/api)
- [OpenAI API料金](https://openai.com/pricing)
- [Google AI料金](https://ai.google.dev/pricing)

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
   - v5実装では自動リトライ機能あり

2. **コスト**
   - API使用量に応じた課金が発生
   - 必要に応じてmax_tokensを調整
   - [コスト最適化ガイド](COST_OPTIMIZATION.md)を参照

3. **プライバシー**
   - センシティブな情報を含むIssueでは使用を控える
   - 各AIプロバイダーのデータ取り扱いポリシーを確認

4. **GitHub Actions制限**
   - パブリックリポジトリ：無料
   - プライベートリポジトリ：月間2,000分（Freeプラン）

## 🐛 トラブルシューティング

### よくある問題

1. **「Secret not found」エラー**
   - シークレットが正しく設定されているか確認
   - 名前が正確に一致しているか確認（大文字小文字も）

2. **「0秒で失敗」する場合**
   - ワークフローファイルの構文エラーをチェック
   - YAMLのインデントが正しいか確認
   - ブランチ名が`@main`であることを確認

3. **分析結果が投稿されない**
   - GitHub Actionsの実行ログを確認
   - APIキーが有効か確認
   - Issueの権限設定を確認

4. **「429 Rate Limit」エラー**
   - APIレート制限に到達
   - 時間をおいて再実行
   - v5使用で自動リトライ

### デバッグ方法

1. Actions タブで実行ログを確認
2. 各ステップの出力をチェック
3. エラーメッセージを確認

## 📚 関連リソース

### GitHub Actions
- [GitHub Actions ドキュメント](https://docs.github.com/actions)
- [再利用可能ワークフロー](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [ワークフローのベストプラクティス](https://earthly.dev/blog/github-actions-reusable-workflows/)

### AI APIドキュメント
- [Claude API](https://docs.anthropic.com/claude/reference/getting-started-with-the-api)
- [OpenAI API](https://platform.openai.com/docs/introduction)
- [Google Gemini API](https://ai.google.dev/tutorials/rest_quickstart)

### コミュニティ
- [test-workflow リポジトリ](https://github.com/NFTTechnology/test-workflow) - 実装例
- [GitHub Discussions](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/discussions) - Q&A、アイデア共有

## 💬 サポート

問題や質問がある場合は、[Issues](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/issues)で報告してください。

## 🎯 次のステップ

1. [バージョン比較ガイド](VERSION_COMPARISON.md)で最適なバージョンを選択
2. [使用パターン集](USAGE_PATTERNS.md)で具体的な実装例を確認
3. [コスト最適化ガイド](COST_OPTIMIZATION.md)で予算に合わせた設定を行う

---

**最終更新**: 2025年7月