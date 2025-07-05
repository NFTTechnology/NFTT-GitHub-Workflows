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
│       ├── reusable-3ai-issue-analyzer.yml           # 再利用可能ワークフロー
│       ├── ci-test-reusable-workflows.yml            # 自己テスト用
│       └── workflow-template-3ai-issue-analyzer.yml  # テンプレート
├── .gitignore
├── LICENSE                                           # MIT License
├── README.md
└── docs/
    ├── CONTRIBUTING.md
    ├── SECURITY.md
    └── workflows/
        └── 3ai-issue-analyzer.md
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
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
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