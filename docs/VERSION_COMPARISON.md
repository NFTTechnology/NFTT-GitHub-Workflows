# 3AI Issue Analyzer バージョン比較

## 📊 バージョン一覧

| バージョン | 状態 | 特徴 | 推奨用途 | コスト |
|-----------|------|------|----------|--------|
| **v5** | ✅ 推奨（デフォルト） | コスト最適化 | 通常使用、大量コメント | 💵💵 |
| **v4** | ✅ 利用可 | コメント履歴対応 | 詳細分析が必要な場合 | 💵💵💵💵 |
| **v3** | ✅ 利用可 | シンプル・高速 | 単純なIssue | 💵💵💵 |
| **v2** | ❌ 非推奨 | Base64実装（問題あり） | 使用しない | - |
| **v1** | ❌ 非推奨 | 初期実装（EOF問題） | 使用しない | - |

## 🎯 v5（推奨・デフォルト）の詳細

**注意**: `@main`を指定した場合、自動的にv5が使用されます。

### 処理フロー
```
1. コメント要約（Claude Haiku - 安価）
   ↓
2. 並列分析
   - メイン分析（Claude Sonnet - 高性能）
   - 技術分析（Gemini Flash - 高速）
   - UX分析（GPT-3.5 - 安価）
   ↓
3. 統合（Claude Sonnet - 高品質）
```

### コスト内訳
- 30件のコメント分析時
  - v3/v4: 約 $0.15～0.30
  - v5: 約 $0.05～0.10（50%削減）

### 利点
- ✅ 大量コメントでもコスト効率的
- ✅ 高品質な最終出力（Sonnetで統合）
- ✅ 各AIの得意分野を活用
- ✅ API制限を回避しやすい

## 📝 v4の詳細

### 特徴
- 最新20件のコメントを含めて分析
- 議論の経緯を考慮した分析
- 全て高性能モデルを使用

### 適した場面
- 長い議論があるIssue
- 詳細な技術検討が必要
- コストより品質を重視

## ⚡ v3の詳細

### 特徴
- Issue本文のみ分析
- 処理が高速（約1分）
- シンプルな実装

### 適した場面
- 新規作成されたIssue
- シンプルなバグ報告
- 素早い分析が必要

## 🔄 移行ガイド

### v1/v2からの移行
```yaml
# 変更前
uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer.yml@main

# 変更後（v5推奨）
uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-3ai-issue-analyzer-v5.yml@main
```

### バージョン選択の実装例
```yaml
# /analyze v3, v4, v5 を判定
- name: Determine version
  id: version
  run: |
    COMMENT="${{ github.event.comment.body }}"
    if echo "$COMMENT" | grep -q "/analyze v4"; then
      echo "version=v4" >> $GITHUB_OUTPUT
    elif echo "$COMMENT" | grep -q "/analyze v3"; then
      echo "version=v3" >> $GITHUB_OUTPUT
    else
      echo "version=v5" >> $GITHUB_OUTPUT  # デフォルト
    fi
```

## 💡 使い分けのコツ

### コスト重視なら
→ **v5を使用**（デフォルト推奨）

### 品質重視なら
→ **v4を使用**（全コメント分析）

### スピード重視なら
→ **v3を使用**（シンプル分析）

## 🚨 注意事項

1. **v1/v2は使用禁止**
   - EOF問題で正常動作しない
   - 必ずv3以降を使用

2. **APIキー必須**
   - ANTHROPIC_API_KEY
   - OPENAI_API_KEY
   - GEMINI_API_KEY

3. **コスト管理**
   - 定期的にAPI使用量を確認
   - 必要に応じてバージョンを選択