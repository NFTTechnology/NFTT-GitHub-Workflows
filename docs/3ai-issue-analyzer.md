# 3AI Issue Analyzer

GitHub IssueをClaude、OpenAI、Geminiの3つのAIで多角的に分析するワークフローです。

## 🎯 概要

このワークフローは、Issueに投稿された `/analyze` コマンドをトリガーに、3つのAIがそれぞれ異なる観点から分析を行い、統合された結果を提供します。

## 📋 前提条件

### 必須シークレット

各リポジトリで以下のシークレットを設定してください：

- `ANTHROPIC_API_KEY` - Claude API用
- `OPENAI_API_KEY` - OpenAI API用  
- `GEMINI_API_KEY` - Google Gemini API用

### 設定方法

1. リポジトリの Settings → Secrets and variables → Actions に移動
2. "New repository secret" をクリック
3. 各APIキーを追加

## 🚀 使用方法

### 1. ワークフローの設定

リポジトリの `.github/workflows/` ディレクトリに以下のファイルを作成：

```yaml
name: 3AI Issue Analysis

on:
  issue_comment:
    types: [created]
  
  workflow_dispatch:
    inputs:
      issue_number:
        description: '分析するIssue番号'
        required: true
        type: number

jobs:
  analyze-issue:
    if: |
      (github.event_name == 'issue_comment' && 
       github.event.issue.pull_request == null &&
       contains(github.event.comment.body, '/analyze')) ||
      github.event_name == 'workflow_dispatch'
    
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
    
    with:
      issue_number: ${{ github.event_name == 'workflow_dispatch' && github.event.inputs.issue_number || github.event.issue.number }}
      issue_title: ${{ github.event.issue.title || 'Manual Analysis' }}
      issue_body: ${{ github.event.issue.body || 'Manual analysis requested' }}
      repository: ${{ github.repository }}
      comment_id: ${{ github.event.comment.id || 0 }}
    
    secrets: inherit
    
    permissions:
      issues: write
      contents: read
```

### 2. 分析の実行

#### コマンドで実行
Issueにコメントで `/analyze` と入力

#### 手動実行
Actions タブから手動でワークフローを実行し、Issue番号を指定

## 📊 バージョン比較

### デフォルト版（推奨）
- `reusable-3ai-issue-analyzer.yml` を使用
- 最新のv5実装（コスト最適化版）が自動的に使用されます

### 特定バージョンの使用

特定のバージョンを使用したい場合：

#### v4（コメント履歴対応版）
```yaml
uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer-v4.yml@main
```

#### v5（コスト最適化版）
```yaml
uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer-v5.yml@main
```

## 🔧 カスタマイズ

### トリガーの追加

他のイベントでも分析を実行したい場合：

```yaml
on:
  issues:
    types: [opened, labeled]  # Issue作成時やラベル追加時
  issue_comment:
    types: [created]
  schedule:
    - cron: '0 9 * * 1'  # 毎週月曜9時
```

### 条件の変更

特定のラベルが付いたIssueのみ分析：

```yaml
if: |
  github.event_name == 'issues' && 
  contains(github.event.issue.labels.*.name, 'needs-analysis')
```

## 📝 出力例

分析結果は以下の形式でIssueにコメントされます：

```markdown
## 🤖 3AI Analysis Results

### 🌟 Claude (Technical Analyst)
[技術的な観点からの分析]

### 🔍 OpenAI (Solution Architect) 
[解決策の観点からの分析]

### 🎯 Gemini (Risk Assessor)
[リスク評価の観点からの分析]

### 📊 Analysis Summary
- 優先度: [High/Medium/Low]
- 推定工数: [時間/日数]
- 主な課題: [要約]
```

## 🛠️ トラブルシューティング

### エラー: "Bad credentials"
→ APIキーが正しく設定されているか確認

### 分析が実行されない
→ Issueコメントの場合、PRではなくIssueであることを確認

### 権限エラー
→ ワークフローに `issues: write` 権限があることを確認

## 📚 関連ドキュメント

- [NFTT-GitHub-Workflows README](../README.md)
- [コントリビューションガイド](CONTRIBUTING.md)