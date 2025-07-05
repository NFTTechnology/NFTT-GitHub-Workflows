# NFTT-GitHub-Workflows 導入計画書
## 対象リポジトリ: share-manga-c2c-api, share-manga-c2c-admin

作成日: 2025-01-05

## 1. 前提確認事項

導入前に各リポジトリで確認すべき事項：

### 1.1 既存ワークフローの確認
各リポジトリの `.github/workflows/` ディレクトリ内のファイルを確認し、以下を調査：
- 既存のCIワークフロー（ビルド、テスト、リント等）
- PR自動レビューツール（ReviewDog、CodeClimate等）
- Issue管理ツール

### 1.2 必要なシークレットの確認
Settings → Secrets and variables → Actions で以下が設定されているか確認：
- `ANTHROPIC_API_KEY`
- `OPENAI_API_KEY`
- `GEMINI_API_KEY`

## 2. 導入優先度の提案

### 優先度1: PR Review ワークフロー
**理由：**
- PRレビューは開発フローに直接影響し、品質向上に即効性がある
- 既存のCI/CDワークフローと競合しにくい
- セキュリティや品質の観点から重要

### 優先度2: 3AI Issue Analyzer
**理由：**
- Issueの分析は開発計画の改善に有効
- /analyzeコマンドによる手動トリガーのため、既存フローへの影響が少ない

## 3. 実装手順

### Phase 1: PR Review ワークフローの導入（推奨開始）

#### Step 1: 事前準備
1. 各リポジトリの既存ワークフローをバックアップ
2. 必要なAPIキーをSecretsに設定
3. テスト用のブランチを作成

#### Step 2: share-manga-c2c-api への導入
```bash
# 1. ワークフローファイルをコピー
cp workflow-template-pr-review.yml ../share-manga-c2c-api/.github/workflows/pr-auto-review.yml

# 2. 必要に応じてカスタマイズ
# - review_typeの初期値調整
# - max_diff_linesの調整（APIの場合は5000程度を推奨）
# - 特定のパスを除外（例：generated/*, docs/*）
```

#### Step 3: share-manga-c2c-admin への導入
```bash
# 1. ワークフローファイルをコピー
cp workflow-template-pr-review.yml ../share-manga-c2c-admin/.github/workflows/pr-auto-review.yml

# 2. フロントエンド向けカスタマイズ
# - CSSやイメージファイルの除外設定
# - コンポーネントレビューの重視設定
```

### Phase 2: 3AI Issue Analyzer の導入

#### Step 1: share-manga-c2c-api への導入
```bash
# ワークフローファイルをコピー
cp workflow-template-3ai-issue-analyzer.yml ../share-manga-c2c-api/.github/workflows/3ai-issue-analyzer.yml
```

#### Step 2: share-manga-c2c-admin への導入
```bash
# ワークフローファイルをコピー  
cp workflow-template-3ai-issue-analyzer.yml ../share-manga-c2c-admin/.github/workflows/3ai-issue-analyzer.yml
```

## 4. カスタマイズ推奨事項

### 4.1 share-manga-c2c-api 向け
```yaml
# PR Reviewのカスタマイズ例
with:
  review_type: 'detailed'  # APIは詳細レビューを推奨
  max_diff_lines: 5000
  enable_code_suggestions: true
  # APIエンドポイントのセキュリティチェックを重視
  focus_areas: 'security,performance,api-design'
```

### 4.2 share-manga-c2c-admin 向け
```yaml
# PR Reviewのカスタマイズ例
with:
  review_type: 'balanced'
  max_diff_lines: 8000
  enable_code_suggestions: true
  # UIコンポーネントとアクセシビリティを重視
  focus_areas: 'ui-ux,accessibility,performance'
```

## 5. 競合回避のポイント

### 5.1 ワークフロー名の配慮
- 既存のPRチェックワークフローと区別できる名前を使用
- 例：`pr-auto-review.yml` ではなく `ai-pr-review.yml`

### 5.2 トリガー条件の調整
```yaml
# 既存のCIと競合しないよう、条件を追加
on:
  pull_request:
    types: [opened, synchronize]
    # 特定のパスのみトリガー（必要に応じて）
    paths-ignore:
      - 'docs/**'
      - '*.md'
      - 'package-lock.json'
```

### 5.3 権限の最小化
```yaml
permissions:
  contents: read      # 読み取りのみ
  pull-requests: write # コメント投稿用
  # 他の権限は付与しない
```

## 6. 段階的導入計画

### Week 1-2: 検証フェーズ
1. 各リポジトリでfeatureブランチで動作確認
2. 小規模なPRで動作テスト
3. APIキーの使用量モニタリング

### Week 3-4: 本格導入
1. mainブランチへの適用
2. チームへの使用方法説明
3. フィードバック収集

### Week 5-: 最適化
1. レビュー精度の調整
2. 除外パターンの最適化
3. コスト最適化

## 7. 注意事項

1. **APIキーの管理**
   - Organization Secretsで一元管理を推奨
   - 定期的なローテーション計画

2. **コスト管理**
   - 各AIサービスの使用量上限設定
   - 月次でのコストレビュー

3. **既存フローとの統合**
   - 既存のCI/CDパイプラインを妨げない設定
   - ステータスチェックの必須化は段階的に

## 8. トラブルシューティング

### よくある問題と対処法

1. **APIキーエラー**
   - Secretsの設定確認
   - APIキーの有効性確認

2. **タイムアウト**
   - max_diff_linesの調整
   - 大きなPRの分割推奨

3. **重複レビュー**
   - トリガー条件の見直し
   - 既存ツールとの調整

## 9. 成功指標

- PRレビュー時間の短縮（目標：30%削減）
- バグの早期発見率向上
- 開発者満足度の向上

---

この計画書に基づいて、段階的に導入を進めることを推奨します。
各フェーズでフィードバックを収集し、最適化を継続的に行ってください。