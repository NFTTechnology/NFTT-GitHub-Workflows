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
│       ├── 3ai-issue-analyzer.yml       # 再利用可能ワークフロー
│       └── test-reusable-workflows.yml  # 自己テスト用
├── .gitignore
├── LICENSE                              # MIT License
├── README.md
└── docs/
    ├── CONTRIBUTING.md
    ├── SECURITY.md
    └── workflows/
        └── 3ai-issue-analyzer.md
```

## 🚀 使用方法

各ワークフローの詳細な使用方法は、`docs/workflows/`ディレクトリ内のドキュメントを参照してください。

### 例: 3AI Issue Analyzer

```yaml
name: Issue Analysis
on:
  issue_comment:
    types: [created]

jobs:
  analyze:
    if: contains(github.event.comment.body, '/analyze')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      comment_id: ${{ github.event.comment.id }}
    secrets: inherit
```

## 🔐 必要なシークレット

各リポジトリで以下のシークレットを設定してください：

- `ANTHROPIC_API_KEY` - Claude API用
- `OPENAI_API_KEY` - OpenAI API用
- `GEMINI_API_KEY` - Google Gemini API用

## 📝 ライセンス

MIT License - NFTTechnology

## 🤝 コントリビュート

貢献ガイドラインは[CONTRIBUTING.md](docs/CONTRIBUTING.md)を参照してください。

---

*このリポジトリはNFTTechnology組織の公式ワークフロー集です*