# 3AI Analyzer 使用パターン集

## 問題: Issue本文だけでは不十分な場合

### パターン1: サマリーコメントを使う

```markdown
# Issue本文
バグがある

# コメント
議論の結果、以下が判明：
- 原因: APIのタイムアウト
- 影響: 全ユーザーの30%
- 対策案: リトライ機能の実装

/analyze
```

### パターン2: Issue本文を更新してから分析

1. 議論が進んだらIssue本文を編集
2. 「Edit」で最新の情報を追加
3. その後 `/analyze` を実行

### パターン3: 分析用のサマリーを書く

```markdown
## 分析依頼

現在までの議論をまとめると：
1. 最初の問題: XXX
2. @user1 の指摘: YYY
3. @user2 の提案: ZZZ

これらを踏まえて分析をお願いします。

/analyze
```

## 推奨される運用方法

### 1. テンプレートを使う

```markdown
## 問題の概要
（明確に記載）

## 現在の動作
（具体例を含める）

## 期待する動作
（明確なゴールを設定）

## 技術的な詳細
- 環境:
- バージョン:
- エラーログ:
```

### 2. 段階的に分析

- **初回**: Issue作成時に基本分析
- **中間**: 議論が進んだらサマリー付きで再分析
- **最終**: 実装前に最終確認の分析

### 3. ラベルで制御

```yaml
# 自動分析が必要なIssue
labels: [bug, analyze]

# 手動分析のみ
labels: [discussion]
```

## v4（コメント履歴対応版）の使用

より高度な分析が必要な場合は、v4を使用：

```yaml
jobs:
  analyze:
    uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer-v4.yml@main
    with:
      issue_number: ${{ github.event.issue.number }}
      issue_title: ${{ github.event.issue.title }}
      issue_body: ${{ github.event.issue.body }}
      repository: ${{ github.repository }}
      include_comments: true  # コメント履歴を含める
      max_comments: 20       # 最新20件のコメントを分析
    secrets: inherit
```

## アンチパターン

### ❌ 避けるべき使い方

1. **情報不足のまま分析**
   ```
   タイトル: バグ
   本文: 動かない
   ```

2. **議論が発散している状態で分析**
   - まず議論を整理してから

3. **実装詳細が決まっていない段階で分析**
   - 方向性を決めてから

### ✅ 良い使い方

1. **具体的な情報を含める**
   ```
   タイトル: ユーザー登録API が 500 エラーを返す
   本文: 
   - 発生条件: メールアドレスに'+'を含む場合
   - エラーログ: [詳細]
   - 再現手順: [1, 2, 3]
   ```

2. **議論の結論を明記**
   ```
   ## 議論の結果
   - 採用案: A案（理由: パフォーマンス）
   - 却下案: B案（理由: 複雑性）
   
   /analyze
   ```