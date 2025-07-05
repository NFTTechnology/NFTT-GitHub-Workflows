# 実装パターン集

このディレクトリには、様々なユースケースに対応した実装例が含まれています。

## 📚 カテゴリ別実装例

### 基本的な使い方
- [Issueコメントトリガー](issue-comment-trigger.yml) - `/analyze`コマンドで分析
- [Issue作成時トリガー](issue-opened-trigger.yml) - 特定ラベルで自動分析
- [手動実行](manual-analysis.yml) - workflow_dispatchで任意のタイミング
- [PR自動レビュー](pr-review-trigger.yml) - PR作成・更新時の自動レビュー
- [定期実行](scheduled-analysis.yml) - cronで定期的にIssue分析

### 高度な使い方
- [モノレポ対応](monorepo-setup.yml) - パス別の条件付き実行
- [大規模PR対応](large-pr-handling.yml) - 分割処理とバッチ実行
- [マルチ環境対応](multi-environment.yml) - 環境別の設定切り替え
- [セキュリティ特化](security-focused.yml) - セキュリティレビュー重視
- [コスト最適化](cost-optimized.yml) - 無料枠内での運用

## 🎯 ユースケース別推奨設定

### 小規模チーム（〜10人）
```yaml
# コスト重視、基本機能
uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer-v3.yml@main
with:
  review_type: 'quick'
```

### 中規模チーム（10-50人）
```yaml
# バランス重視
uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main
with:
  review_type: 'balanced'
```

### 大規模チーム（50人以上）
```yaml
# 詳細分析、並列処理
uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer-v4.yml@main
with:
  review_type: 'detailed'
  enable_parallel: true
```

## 💡 Tips & Tricks

### パフォーマンス向上
1. 不要なファイルの除外
2. 条件付き実行の活用
3. キャッシュの最大活用

### コスト削減
1. 適切なモデル選択
2. 実行条件の最適化
3. バッチ処理の活用

### セキュリティ強化
1. 最小権限の原則
2. シークレットの適切な管理
3. 監査ログの活用