# 使用パターン集

## 📋 概要

NFTT-GitHub-Workflowsの実践的な使用パターンを紹介します。プロジェクトの規模や目的に応じて、最適なパターンを選択してください。

## 🏗️ プロジェクト規模別パターン

### 小規模プロジェクト（〜10人チーム）

#### 推奨設定
```yaml
# .github/workflows/simple-3ai.yml
name: 3AI Analysis (Small Team)
on:
  issue_comment:
    types: [created]

jobs:
  analyze:
    if: |
      contains(github.event.comment.body, '/analyze') &&
      (github.event.comment.author_association == 'OWNER' ||
       github.event.comment.author_association == 'MEMBER')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      # v5使用でコスト最適化
      version: "v5"
    secrets: inherit
```

#### 特徴
- メンバーのみ分析実行可能
- コスト最適化版（v5）使用
- 手動トリガーで無駄な実行を防止

### 中規模プロジェクト（10〜50人チーム）

#### 推奨設定
```yaml
# .github/workflows/medium-3ai.yml
name: 3AI Analysis (Medium Team)
on:
  issue_comment:
    types: [created]
  issues:
    types: [opened, labeled]

jobs:
  analyze-comment:
    if: contains(github.event.comment.body, '/analyze')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
    secrets: inherit

  analyze-critical:
    if: |
      github.event_name == 'issues' &&
      contains(github.event.issue.labels.*.name, 'critical')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      # 重要なIssueはv4で詳細分析
      version: "v4"
    secrets: inherit
```

#### 特徴
- 重要度に応じたバージョン使い分け
- criticalラベルで自動分析
- 通常はコメントトリガー

### 大規模プロジェクト（50人以上）

#### 推奨設定
```yaml
# .github/workflows/enterprise-3ai.yml
name: 3AI Analysis (Enterprise)
on:
  issue_comment:
    types: [created]
  workflow_dispatch:
    inputs:
      issue_numbers:
        description: 'Issue numbers to analyze (comma-separated)'
        required: true
      ai_models:
        description: 'AI models to use'
        required: false
        default: 'all'
        type: choice
        options:
          - all
          - claude-only
          - gpt-only
          - gemini-only

jobs:
  check-permissions:
    runs-on: ubuntu-latest
    outputs:
      allowed: ${{ steps.check.outputs.allowed }}
    steps:
      - id: check
        uses: actions/github-script@v7
        with:
          script: |
            const teams = ['reviewers', 'maintainers'];
            const membership = await github.rest.teams.getMembershipForUserInOrg({
              org: context.repo.owner,
              team_slug: teams[0],
              username: context.actor
            });
            return membership.status === 200;

  analyze:
    needs: check-permissions
    if: needs.check-permissions.outputs.allowed == 'true'
    strategy:
      matrix:
        issue: ${{ fromJson(github.event.inputs.issue_numbers || '[]') }}
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ matrix.issue }}
      ai_models: ${{ github.event.inputs.ai_models }}
    secrets: inherit
```

#### 特徴
- チーム権限による制御
- バッチ処理対応
- AIモデル選択可能
- コスト管理機能

## 🎯 目的別パターン

### バグ修正の影響分析

```yaml
name: Bug Impact Analysis
on:
  issues:
    types: [labeled]

jobs:
  analyze-bug:
    if: contains(github.event.issue.labels.*.name, 'bug')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      # カスタムプロンプト
      custom_prompt: |
        このバグの影響範囲を分析してください：
        1. 影響を受けるコンポーネント
        2. ユーザーへの影響度
        3. 修正の緊急度
        4. 推奨される修正アプローチ
    secrets: inherit
```

### 新機能提案の評価

```yaml
name: Feature Proposal Evaluation
on:
  issues:
    types: [labeled]

jobs:
  evaluate-feature:
    if: contains(github.event.issue.labels.*.name, 'enhancement')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      version: "v4"  # コメント履歴も含めて評価
      custom_prompt: |
        この機能提案を評価してください：
        1. 技術的実現可能性
        2. 既存機能との整合性
        3. 実装工数の見積もり
        4. 潜在的なリスク
    secrets: inherit
```

### セキュリティ脆弱性の分析

```yaml
name: Security Vulnerability Analysis
on:
  issues:
    types: [labeled]

jobs:
  analyze-security:
    if: contains(github.event.issue.labels.*.name, 'security')
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      # セキュリティ分析に特化
      custom_prompt: |
        セキュリティの観点から分析してください：
        1. 脆弱性の深刻度（CVSS）
        2. 攻撃ベクトル
        3. 影響範囲
        4. 緊急対応策
        5. 根本的な修正方法
      # プライベートコメントで結果を投稿
      private_comment: true
    secrets: inherit
```

## 🔄 統合パターン

### Slack通知との連携

```yaml
name: 3AI with Slack Notification
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

  notify:
    needs: analyze
    if: always()
    runs-on: ubuntu-latest
    steps:
      - name: Slack Notification
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: |
            3AI分析完了
            Issue: #${{ github.event.issue.number }}
            結果: ${{ needs.analyze.result }}
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

### PRレビューとの組み合わせ

```yaml
name: Comprehensive Review
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  # 関連Issueの分析
  analyze-linked-issues:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/github-script@v7
        id: get-issues
        with:
          script: |
            const pr = context.payload.pull_request;
            const body = pr.body || '';
            const issueRefs = body.match(/#(\d+)/g) || [];
            return issueRefs.map(ref => ref.substring(1));

      - name: Analyze Issues
        if: steps.get-issues.outputs.result != '[]'
        uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
        with:
          issue_numbers: ${{ steps.get-issues.outputs.result }}
        secrets: inherit

  # PRのコードレビュー
  pr-review:
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review.yml@main
    with:
      pr_number: ${{ github.event.pull_request.number }}
    secrets: inherit
```

## 🚀 高度な使用例

### カスタムAI設定

```yaml
name: Custom AI Configuration
on:
  workflow_dispatch:
    inputs:
      issue_number:
        required: true

jobs:
  custom-analysis:
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.inputs.issue_number }}
      # AI個別設定
      claude_config: |
        model: claude-3-opus-20240229
        max_tokens: 4000
        temperature: 0.3
      openai_config: |
        model: gpt-4-turbo-preview
        max_tokens: 3000
        temperature: 0.5
      gemini_config: |
        model: gemini-pro
        max_output_tokens: 2048
        temperature: 0.4
    secrets: inherit
```

### 多言語対応

```yaml
name: Multilingual Analysis
on:
  issue_comment:
    types: [created]

jobs:
  detect-language:
    runs-on: ubuntu-latest
    outputs:
      language: ${{ steps.detect.outputs.language }}
    steps:
      - id: detect
        uses: actions/github-script@v7
        with:
          script: |
            // 簡易的な言語検出
            const body = context.payload.issue.body;
            if (/[\u3040-\u309F\u30A0-\u30FF]/.test(body)) return 'ja';
            if (/[\u4E00-\u9FAF]/.test(body)) return 'zh';
            return 'en';

  analyze:
    needs: detect-language
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      language: ${{ needs.detect-language.outputs.language }}
      custom_prompt: |
        言語: ${{ needs.detect-language.outputs.language }}
        この言語で分析結果を提供してください。
    secrets: inherit
```

## 📊 パフォーマンス最適化

### 並列処理パターン

```yaml
name: Parallel Analysis
on:
  schedule:
    - cron: '0 2 * * *'  # 毎日深夜2時

jobs:
  get-issues:
    runs-on: ubuntu-latest
    outputs:
      matrix: ${{ steps.set-matrix.outputs.matrix }}
    steps:
      - uses: actions/github-script@v7
        id: set-matrix
        with:
          script: |
            const issues = await github.rest.issues.listForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
              labels: 'needs-analysis',
              state: 'open',
              per_page: 20
            });
            return { issues: issues.data.map(i => i.number) };

  analyze:
    needs: get-issues
    strategy:
      matrix: ${{ fromJson(needs.get-issues.outputs.matrix) }}
      max-parallel: 3  # 同時実行数を制限
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    with:
      issue_number: ${{ matrix.issues }}
    secrets: inherit
```

## 🎯 ベストプラクティス

1. **コスト管理**
   - 定期実行は深夜帯に設定
   - 重要度に応じてAIモデルを選択
   - 不要な再実行を防ぐキャッシュ活用

2. **セキュリティ**
   - 権限チェックを必須化
   - センシティブ情報は環境変数で管理
   - 実行履歴の定期監査

3. **保守性**
   - ワークフローの共通化
   - 設定値の外部化
   - エラーハンドリングの充実

---

**最終更新**: 2025年7月