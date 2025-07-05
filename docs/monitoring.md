# モニタリング・パフォーマンス最適化ガイド

## 📊 使用状況のモニタリング

### 1. GitHub Actions使用状況

#### ワークフロー実行統計
```bash
# 直近30日のワークフロー実行回数
gh run list --limit 1000 --json conclusion,startedAt | \
  jq '[.[] | select(.startedAt > (now - 2592000 | strftime("%Y-%m-%dT%H:%M:%SZ")))] | length'

# 成功率の確認
gh run list --limit 100 --json conclusion | \
  jq 'group_by(.conclusion) | map({conclusion: .[0].conclusion, count: length})'
```

#### 実行時間の分析
```yaml
# ワークフローに追加
- name: 実行時間レポート
  if: always()
  run: |
    echo "::notice title=実行時間::${{ steps.timer.outputs.time }}秒"
    echo "### ⏱️ パフォーマンスメトリクス" >> $GITHUB_STEP_SUMMARY
    echo "- 実行時間: ${{ steps.timer.outputs.time }}秒" >> $GITHUB_STEP_SUMMARY
    echo "- API呼び出し: ${{ steps.api.outputs.calls }}回" >> $GITHUB_STEP_SUMMARY
```

### 2. API使用量追跡

#### カスタムメトリクスの実装
```python
# メトリクス収集スクリプト
import json
import os
from datetime import datetime

class MetricsCollector:
    def __init__(self):
        self.metrics = {
            'timestamp': datetime.utcnow().isoformat(),
            'api_calls': {},
            'tokens': {},
            'costs': {}
        }
    
    def track_api_call(self, service, tokens_in, tokens_out, cost):
        if service not in self.metrics['api_calls']:
            self.metrics['api_calls'][service] = 0
            self.metrics['tokens'][service] = {'input': 0, 'output': 0}
            self.metrics['costs'][service] = 0
        
        self.metrics['api_calls'][service] += 1
        self.metrics['tokens'][service]['input'] += tokens_in
        self.metrics['tokens'][service]['output'] += tokens_out
        self.metrics['costs'][service] += cost
    
    def save_to_artifact(self):
        with open('metrics.json', 'w') as f:
            json.dump(self.metrics, f, indent=2)
```

#### GitHub Actionsでの活用
```yaml
- name: メトリクス収集
  id: metrics
  run: |
    python collect_metrics.py
    
- name: アーティファクトとして保存
  uses: actions/upload-artifact@v4
  with:
    name: usage-metrics-${{ github.run_id }}
    path: metrics.json
    retention-days: 90
```

### 3. コストダッシュボード

#### 月間サマリーの生成
```yaml
name: 月間コストレポート
on:
  schedule:
    - cron: '0 0 1 * *'  # 毎月1日

jobs:
  generate-report:
    runs-on: ubuntu-latest
    steps:
      - name: メトリクス集計
        run: |
          # 前月のメトリクスを集計
          gh api repos/${{ github.repository }}/actions/artifacts \
            --jq '.artifacts[] | select(.name | startswith("usage-metrics"))' | \
            jq -s 'map(.costs) | add'
          
      - name: レポート作成
        run: |
          cat > monthly-report.md << EOF
          # 月間使用状況レポート
          
          ## API使用量
          - Claude: $CLAUDE_CALLS 回 ($CLAUDE_COST)
          - OpenAI: $OPENAI_CALLS 回 ($OPENAI_COST)
          - Gemini: $GEMINI_CALLS 回 ($GEMINI_COST)
          
          ## 合計コスト: \$$TOTAL_COST
          EOF
```

## ⚡ パフォーマンス最適化

### 1. ワークフロー実行の最適化

#### 条件付き実行
```yaml
# サイズに基づく実行制御
- name: PRサイズチェック
  id: size
  run: |
    additions=${{ github.event.pull_request.additions }}
    if [ $additions -gt 5000 ]; then
      echo "skip=true" >> $GITHUB_OUTPUT
    fi

- name: AIレビュー
  if: steps.size.outputs.skip != 'true'
  uses: NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review.yml@main
```

#### ファイルタイプ別の処理
```yaml
# 特定ファイルのみ処理
- name: 対象ファイルの確認
  id: files
  run: |
    changed_files=$(gh pr view ${{ github.event.pull_request.number }} \
      --json files --jq '.files[].path' | \
      grep -E '\.(js|ts|py|java|go)$' || true)
    
    if [ -z "$changed_files" ]; then
      echo "skip=true" >> $GITHUB_OUTPUT
    fi
```

### 2. API呼び出しの最適化

#### バッチ処理
```python
# 複数ファイルをまとめて処理
def batch_review(files, batch_size=5):
    batches = [files[i:i+batch_size] for i in range(0, len(files), batch_size)]
    
    for batch in batches:
        # バッチ単位でAPI呼び出し
        combined_diff = "\n".join([f.content for f in batch])
        review = api.review(combined_diff)
        
        # 結果を個別ファイルに分配
        distribute_results(batch, review)
```

#### キャッシング戦略
```yaml
- name: キャッシュ確認
  id: cache
  uses: actions/cache@v4
  with:
    path: .ai-cache
    key: ai-review-${{ github.event.pull_request.head.sha }}
    restore-keys: |
      ai-review-${{ github.event.pull_request.base.sha }}
      ai-review-

- name: AIレビュー（キャッシュ利用）
  if: steps.cache.outputs.cache-hit != 'true'
  run: |
    # 新規または変更されたファイルのみ処理
```

### 3. 並列処理の活用

#### マトリックスビルド
```yaml
strategy:
  matrix:
    include:
      - service: claude
        model: claude-3-5-sonnet-20241022
      - service: openai
        model: gpt-4o-mini
      - service: gemini
        model: gemini-1.5-flash
  max-parallel: 3

steps:
  - name: AI分析 (${{ matrix.service }})
    run: |
      python analyze.py --service ${{ matrix.service }} --model ${{ matrix.model }}
```

## 📈 高度なモニタリング

### 1. Grafanaダッシュボード設定

```json
{
  "dashboard": {
    "title": "GitHub Actions AI Workflows",
    "panels": [
      {
        "title": "API呼び出し数",
        "targets": [{
          "expr": "sum(github_actions_api_calls_total) by (service)"
        }]
      },
      {
        "title": "平均実行時間",
        "targets": [{
          "expr": "avg(github_actions_workflow_duration_seconds)"
        }]
      },
      {
        "title": "コスト推移",
        "targets": [{
          "expr": "sum(github_actions_api_cost_dollars) by (service)"
        }]
      }
    ]
  }
}
```

### 2. アラート設定

```yaml
# .github/workflows/cost-alert.yml
name: コストアラート
on:
  schedule:
    - cron: '0 * * * *'  # 毎時実行

jobs:
  check-costs:
    runs-on: ubuntu-latest
    steps:
      - name: コスト確認
        run: |
          current_cost=$(cat metrics.json | jq '.costs | add')
          threshold=100  # $100
          
          if (( $(echo "$current_cost > $threshold" | bc -l) )); then
            gh issue create \
              --title "⚠️ APIコストが閾値を超過" \
              --body "現在のコスト: \$$current_cost (閾値: \$$threshold)" \
              --label cost-alert
          fi
```

### 3. 使用状況レポート

```markdown
## 📊 週間レポートテンプレート

### 実行統計
- 総実行回数: X回
- 成功率: X%
- 平均実行時間: X秒

### API使用量
| サービス | 呼び出し回数 | トークン使用量 | コスト |
|---------|------------|-------------|--------|
| Claude  | X回        | Xトークン    | $X     |
| OpenAI  | X回        | Xトークン    | $X     |
| Gemini  | X回        | Xトークン    | $X     |

### 最もレビューされたPR
1. PR #X - Y回のレビュー
2. PR #X - Y回のレビュー

### 改善提案
- [ ] 大きなPRの分割を推奨
- [ ] 特定時間帯への実行集中を分散
```

## 🎯 ベストプラクティス

### 1. コスト削減のヒント

1. **適切なモデル選択**
   - 簡単なタスク: Haiku/GPT-4o-mini
   - 複雑なタスク: Sonnet/GPT-4

2. **実行条件の最適化**
   - ドラフトPRはスキップ
   - WIPラベル付きはスキップ
   - 小さな変更は簡易レビュー

3. **キャッシュの活用**
   - 同一PRの再実行を防ぐ
   - 類似パターンの結果を再利用

### 2. パフォーマンス向上

1. **並列化**
   - 独立したタスクは並列実行
   - API制限内で最大化

2. **差分の最適化**
   - 関連ファイルのみ抽出
   - バイナリファイルは除外

3. **タイムアウト設定**
   - 適切なタイムアウト値
   - フェイルファスト戦略

## 🔗 関連ツール

- [GitHub Actions Usage API](https://docs.github.com/en/rest/actions/usage)
- [Cost Calculator Tool](https://github.com/marketplace/actions/github-actions-cost-calculator)
- [Workflow Telemetry](https://github.com/runforesight/workflow-telemetry-action)