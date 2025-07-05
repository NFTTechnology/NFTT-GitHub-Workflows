# NFTT-GitHub-Workflows

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

## 🚀 使用方法

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

## 📝 ライセンス

MIT License - NFTTechnology

## 🤝 コントリビュート

貢献ガイドラインは[CONTRIBUTING.md](docs/CONTRIBUTING.md)を参照してください。

---

*このリポジトリはNFTTechnology組織の公式ワークフロー集です*