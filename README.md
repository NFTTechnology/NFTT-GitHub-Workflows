# NFTT-GitHub-Workflows

![GitHub release](https://img.shields.io/github/v/release/NFTTechnology/NFTT-GitHub-Workflows)
![License](https://img.shields.io/github/license/NFTTechnology/NFTT-GitHub-Workflows)
![GitHub issues](https://img.shields.io/github/issues/NFTTechnology/NFTT-GitHub-Workflows)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)

組織全体で使用する再利用可能なGitHub Actionsワークフローのリポジトリ。

## 🎯 目的

このリポジトリは、NFTTechnology組織のすべてのリポジトリで使用できる、標準化された再利用可能なワークフローを提供します。

## 📂 構成

```
NFTT-GitHub-Workflows/
├── .github/
│   ├── CODEOWNERS
│   └── workflows/
│       ├── 3ai-issue-analysis.yml                    # このリポジトリ用3AI分析
│       ├── reusable-3ai-issue-analyzer.yml           # デフォルト版 (v5実装)
│       ├── reusable-3ai-issue-analyzer-v4.yml        # v4 コメント履歴対応版
│       ├── reusable-3ai-issue-analyzer-v5.yml        # v5 コスト最適化版
│       ├── reusable-pr-review.yml                    # デフォルト版 (v2.2実装)
│       ├── reusable-pr-review-v2.2.yml               # v2.2 トークン使用量表示版
│       ├── workflow-template-3ai-issue-analyzer.yml  # 3AI実装テンプレート
│       └── workflow-template-pr-review.yml           # PRレビュー実装テンプレート
├── .gitignore
├── LICENSE                                           # MIT License
├── README.md
└── docs/
    ├── CONTRIBUTING.md
    ├── SECURITY.md
    ├── 3ai-issue-analyzer.md                         # 3AI Issue Analyzer詳細ガイド
    └── pr-review.md                                  # PR Review詳細ガイド
```

## 📁 ファイル構造の説明

### 再利用可能ワークフロー
- `reusable-*.yml`: 他のリポジトリから呼び出し可能なワークフロー
- 命名規則: `reusable-{機能名}.yml`

### テストワークフロー  
- `ci-*.yml`: このリポジトリでの自動テスト用
- 命名規則: `ci-{テスト種類}.yml`

### テンプレートワークフロー
- `workflow-template-*.yml`: 呼び出し側で使用するサンプル
- 命名規則: `workflow-template-{機能名}.yml`

## 🚀 Quick Start（5分で始める）

### 1️⃣ 最小構成での開始

```yaml
# .github/workflows/3ai-analyzer.yml
name: 3AI Analysis
on:
  issue_comment:
    types: [created]

jobs:
  analyze:
    if: contains(github.event.comment.body, '/analyze')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
    secrets: inherit
```

### 2️⃣ シークレット設定

Settings → Secrets and variables → Actions → New repository secret

- `ANTHROPIC_API_KEY` - [取得方法](https://console.anthropic.com/)
- `OPENAI_API_KEY` - [取得方法](https://platform.openai.com/api-keys)
- `GEMINI_API_KEY` - [取得方法](https://makersuite.google.com/app/apikey)

### 3️⃣ テスト

1. 任意のIssueを開く
2. コメントに `/analyze` と入力
3. 3つのAIによる分析結果が自動投稿されます

## 📖 詳細な使用方法

各ワークフローの使用方法については、リポジトリの `.github/workflows/` ディレクトリ内のテンプレートファイルを参照してください：

- **3AI Issue Analyzer**: [workflow-template-3ai-issue-analyzer.yml](.github/workflows/workflow-template-3ai-issue-analyzer.yml)
- **PR Review**: [workflow-template-pr-review.yml](.github/workflows/workflow-template-pr-review.yml)

詳細なドキュメント：
- [3AI Issue Analyzer ガイド](docs/3ai-issue-analyzer.md)
- [PR Review ガイド](docs/pr-review.md)

## 🔐 必要なシークレット

各リポジトリで以下のシークレットを設定してください：

- `ANTHROPIC_API_KEY` - Claude API用
- `OPENAI_API_KEY` - OpenAI API用
- `GEMINI_API_KEY` - Google Gemini API用

### 設定方法

1. リポジトリの Settings → Secrets and variables → Actions に移動
2. "New repository secret" をクリック
3. 各APIキーを追加

**注意**: 無料プランでは組織シークレットの共有に制限があるため、各リポジトリに個別に設定する必要があります。

## 💰 コスト見積もり

| 使用パターン | 月間コスト | 設定 |
|------------|-----------|------|
| 小規模（〜100 Issues/月） | $5-10 | v3推奨 |
| 中規模（〜500 Issues/月） | $20-50 | v5推奨 |
| 大規模（500+ Issues/月） | $50+ | カスタム設定推奨 |

詳細は[コスト最適化ガイド](docs/COST_OPTIMIZATION.md)を参照。

## ❓ よくある質問

### Q: 無料枠でも使えますか？
A: はい。v5（コスト最適化版）を使用すれば、月間約100回の分析が可能です。

### Q: プライベートリポジトリでも動作しますか？
A: はい。ただし、`GH_PAT`の設定を推奨します。

### Q: エラーが発生した場合は？
A: [トラブルシューティングガイド](docs/TROUBLESHOOTING.md)を参照してください。

## 📝 ライセンス

MIT License - NFTTechnology

## 🤝 コントリビュート

貢献ガイドラインは[CONTRIBUTING.md](docs/CONTRIBUTING.md)を参照してください。

---

*このリポジトリはNFTTechnology組織の公式ワークフロー集です*

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=NFTTechnology/NFTT-GitHub-Workflows&type=Date)](https://star-history.com/#NFTTechnology/NFTT-GitHub-Workflows&Date)