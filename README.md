# NFTT-GitHub-Workflows

![GitHub release](https://img.shields.io/github/v/release/NFTTechnology/NFTT-GitHub-Workflows)
![License](https://img.shields.io/github/license/NFTTechnology/NFTT-GitHub-Workflows)
![GitHub issues](https://img.shields.io/github/issues/NFTTechnology/NFTT-GitHub-Workflows)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)
![Claude 3.5](https://img.shields.io/badge/Claude_3.5-Sonnet-blue)
![GPT-4](https://img.shields.io/badge/GPT--4-Turbo-green)
![Gemini](https://img.shields.io/badge/Gemini-Pro-orange)

組織全体で使用する再利用可能なGitHub Actionsワークフローのリポジトリ。3つのAI（Claude、GPT-4、Gemini）を活用した高度な自動化を実現。

## 🌟 なぜこのワークフローを使うべきか？

### 💰 コスト効率
- **95%のコスト削減**: Claude 3.5 Sonnetの採用により、GPT-4比で最大95%のAPI費用削減
- **無料枠の活用**: パブリックリポジトリでGitHub Actions無料枠を最大限活用
- **最適化されたトークン使用**: v5実装により、トークン消費を最小限に抑制

### 🚀 生産性向上
- **3AI並列分析**: 異なる視点からの包括的なコードレビュー
- **5分で導入**: Quick Startガイドに従えば即座に利用開始
- **20倍の効率化**: 手動レビューと比較して大幅な時間短縮

### 🔧 保守性
- **中央集約管理**: 組織全体のワークフローを一元管理
- **セマンティックバージョニング**: 安定したバージョン管理
- **自動更新通知**: 新バージョンリリース時の通知機能

## 🎯 ユースケース

| シナリオ | 推奨ワークフロー | 期待効果 |
|---------|----------------|----------|
| バグ修正の影響分析 | 3AI Issue Analyzer v5 | 3つのAIが異なる視点で潜在的影響を分析 |
| 新機能のPRレビュー | PR Review v2.2 | コード品質、セキュリティ、パフォーマンスを自動チェック |
| アーキテクチャ変更の評価 | 3AI Issue Analyzer v4 | 過去の議論を含めた包括的な分析 |
| 緊急hotfixの検証 | PR Review (fast mode) | 5分以内に基本的なレビューを完了 |

## 🏗️ アーキテクチャ

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│  Your Repository │      │ NFTT-Workflows  │      │   AI Providers  │
│                 │      │                 │      │                 │
│ ┌─────────────┐ │      │ ┌─────────────┐ │      │ ┌─────────────┐ │
│ │   Issue/PR  │ │─────▶│ │  Reusable   │ │─────▶│ │ Claude API  │ │
│ │   Trigger   │ │      │ │  Workflow   │ │      │ │ OpenAI API  │ │
│ └─────────────┘ │      │ └─────────────┘ │      │ │ Gemini API  │ │
│                 │      │                 │      │ └─────────────┘ │
│ ┌─────────────┐ │◀─────│ ┌─────────────┐ │◀─────│                 │
│ │   Comments  │ │      │ │   Results   │ │      │   Responses     │
│ │   Updates   │ │      │ │ Aggregation │ │      │                 │
│ └─────────────┘ │      │ └─────────────┘ │      │                 │
└─────────────────┘      └─────────────────┘      └─────────────────┘
```

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
    ├── CONTRIBUTING.md                               # 貢献ガイド
    ├── SECURITY.md                                   # セキュリティポリシー
    ├── 3AI_ANALYZER_GUIDE.md                         # 3AI Issue Analyzer詳細ガイド
    ├── pr-review.md                                  # PR Review詳細ガイド
    ├── VERSION_COMPARISON.md                         # バージョン比較表
    ├── COST_OPTIMIZATION.md                          # コスト最適化ガイド
    ├── TROUBLESHOOTING.md                            # トラブルシューティング
    └── USAGE_PATTERNS.md                             # 使用パターン集
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

## 🎨 バージョン選択ガイド

| バージョン | 特徴 | コスト | 推奨用途 |
|-----------|------|--------|----------|
| **v5** (推奨) | • 最もコスト効率的<br>• 基本的な分析機能<br>• 高速レスポンス | 低 | • 日常的な使用<br>• 小〜中規模プロジェクト |
| **v4** | • コメント履歴分析<br>• 文脈を考慮した分析<br>• 詳細な出力 | 中 | • 複雑な議論の分析<br>• 長期的なIssue |
| **v3** | • 基本実装<br>• シンプルな構成<br>• 安定動作 | 低 | • 初期導入<br>• テスト環境 |
| **v2** | • レガシー版<br>• 後方互換性 | 中 | • 既存プロジェクト |
| **v1** | • 初期版<br>• 非推奨 | 高 | • 使用非推奨 |

## 📖 実装例

### 基本的な使用例

#### Issueの自動分析（新規作成時）
```yaml
name: Auto Analyze New Issues
on:
  issues:
    types: [opened]

jobs:
  analyze:
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
    secrets: inherit
```

#### PRの自動レビュー
```yaml
name: PR Auto Review
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review.yml@main
    with:
      pr_number: ${{ github.event.pull_request.number }}
    secrets: inherit
```

### 高度なカスタマイズ

#### 特定のラベルでトリガー
```yaml
name: Analyze Critical Issues
on:
  issues:
    types: [labeled]

jobs:
  analyze:
    if: github.event.label.name == 'critical'
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      ai_models: "claude-only"  # Claudeのみ使用してコスト削減
    secrets: inherit
```

#### スケジュール実行
```yaml
name: Weekly Issue Review
on:
  schedule:
    - cron: '0 9 * * MON'  # 毎週月曜9時

jobs:
  review:
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      mode: "batch"  # バッチモードで全Issueを分析
      labels: "needs-review"
    secrets: inherit
```

詳細なドキュメント：
- [3AI Issue Analyzer ガイド](docs/3AI_ANALYZER_GUIDE.md)
- [PR Review ガイド](docs/pr-review.md)
- [使用パターン集](docs/USAGE_PATTERNS.md)

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

### API料金比較（2024年最新）

| AI Provider | 入力トークン | 出力トークン | 特徴 |
|------------|--------------|--------------|------|
| Claude 3.5 Sonnet | $3/1M | $15/1M | GPT-4比95%安価、高速 |
| GPT-4 Turbo | $10/1M | $30/1M | 高精度、マルチモーダル |
| Gemini Pro | $1.25/1M | $10/1M | コスト効率的、長文対応 |

### 使用パターン別コスト

| 使用パターン | 月間コスト | 設定 | 内訳 |
|------------|-----------|------|------|
| 小規模（〜100 Issues/月） | $5-10 | v5推奨 | • Claude中心<br>• 基本分析のみ |
| 中規模（〜500 Issues/月） | $20-50 | v5推奨 | • 3AI並列実行<br>• PRレビュー含む |
| 大規模（500+ Issues/月） | $50+ | カスタム設定推奨 | • 選択的AI使用<br>• バッチ処理活用 |

### GitHub Actions無料枠

| プラン | 月間無料分 | ストレージ | 追加料金 |
|--------|-----------|------------|----------|
| Free | 2,000分 | 500MB | Linux: $0.008/分 |
| Pro | 3,000分 | 1GB | Windows: $0.016/分 |
| Team | 50,000分 | 2GB | macOS: $0.08/分 |

詳細は[コスト最適化ガイド](docs/COST_OPTIMIZATION.md)を参照。

## ❓ よくある質問

### Q: 無料枠でも使えますか？
A: はい。v5（コスト最適化版）を使用すれば、月間約100回の分析が可能です。パブリックリポジトリならGitHub Actions料金は無料です。

### Q: プライベートリポジトリでも動作しますか？
A: はい。ただし、`GH_PAT`の設定を推奨します。GitHub Actions使用分は有料となります。

### Q: どのAIが最も優れていますか？
A: 用途によります。コスト重視ならClaude 3.5 Sonnet、精度重視ならGPT-4 Turbo、バランス重視ならGemini Proを推奨。

### Q: 複数のリポジトリで共有できますか？
A: はい。組織内のすべてのリポジトリから呼び出し可能です。

### Q: エラーが発生した場合は？
A: [トラブルシューティングガイド](docs/TROUBLESHOOTING.md)を参照してください。

### Q: レート制限はありますか？
A: 各AIプロバイダーのレート制限に準じます。v5実装では自動リトライ機能があります。

## 📝 ライセンス

MIT License - NFTTechnology

## 🔧 トラブルシューティング

### よくあるエラーと対処法

| エラー | 原因 | 解決方法 |
|--------|------|----------|
| `401 Unauthorized` | APIキー未設定 | シークレット設定を確認 |
| `429 Rate Limit` | レート制限 | 時間をおいて再実行 |
| `No analysis provided` | AI応答エラー | ログを確認、v5使用推奨 |
| `Workflow not found` | パス指定ミス | `@main`ブランチ指定を確認 |

詳細は[トラブルシューティングガイド](docs/TROUBLESHOOTING.md)を参照。

## 🚀 パフォーマンス最適化

### ベストプラクティス

1. **並列実行の活用**
   - 最大20個の再利用可能ワークフローを並列実行可能
   - ただし、ネスト制限は4レベルまで

2. **キャッシュの活用**
   - API応答を15分間キャッシュ
   - 重複リクエストを自動削減

3. **選択的AI使用**
   - 重要度に応じてAIモデルを選択
   - コスト最適化のため軽量タスクはClaude使用

## 📚 関連リソース

### 公式ドキュメント
- [GitHub Actions 再利用可能ワークフロー](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [GitHub Actions 料金](https://docs.github.com/billing/managing-billing-for-github-actions/about-billing-for-github-actions)
- [GitHub Actions 制限事項](https://docs.github.com/en/actions/administering-github-actions/usage-limits-billing-and-administration)

### AI Provider リソース
- [Claude API ドキュメント](https://docs.anthropic.com/claude/reference/getting-started-with-the-api)
- [OpenAI API ドキュメント](https://platform.openai.com/docs/introduction)
- [Google Gemini API ドキュメント](https://ai.google.dev/tutorials/rest_quickstart)

### ベストプラクティス
- [再利用可能ワークフローのベストプラクティス（2024年版）](https://earthly.dev/blog/github-actions-reusable-workflows/)
- [GitHub Actions コスト削減ガイド](https://www.blacksmith.sh/blog/how-to-reduce-spend-in-github-actions)

## 🤝 コントリビュート

貢献ガイドラインは[CONTRIBUTING.md](docs/CONTRIBUTING.md)を参照してください。

### 貢献の方法
1. Issueで改善提案
2. PRで実装
3. ドキュメント改善
4. バグ報告

## 📄 ライセンス

MIT License - NFTTechnology

詳細は[LICENSE](LICENSE)を参照。

---

*このリポジトリはNFTTechnology組織の公式ワークフロー集です*

**最終更新**: 2024年12月

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=NFTTechnology/NFTT-GitHub-Workflows&type=Date)](https://star-history.com/#NFTTechnology/NFTT-GitHub-Workflows&Date)