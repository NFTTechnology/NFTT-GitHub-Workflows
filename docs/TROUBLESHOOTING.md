# トラブルシューティングガイド

## 🔍 よくある問題と解決方法

### 1. ワークフローが実行されない

#### 症状
- `/analyze` コメントを投稿してもワークフローが開始されない
- PR作成時に自動レビューが始まらない

#### 原因と解決方法

**1. 権限設定の確認**
```yaml
# 必要な権限が設定されているか確認
permissions:
  contents: read
  issues: write        # Issue分析に必要
  pull-requests: write # PRレビューに必要
```

**2. ワークフローの有効化**
- リポジトリの Actions タブを開く
- 「I understand my workflows, go ahead and enable them」をクリック

**3. ブランチ保護ルールの確認**
- Settings → Branches でmainブランチの保護ルールを確認
- 「Restrict who can dismiss pull request reviews」が有効な場合、ボットのコメントが制限される可能性

### 2. APIキーエラー

#### 症状
```
Error: Bad credentials
Error: Invalid API key
```

#### 解決方法

**1. シークレットの確認**
```bash
# 設定されているシークレットの確認（名前のみ）
gh secret list

# 必要なシークレット
- ANTHROPIC_API_KEY
- OPENAI_API_KEY
- GEMINI_API_KEY
```

**2. APIキーの有効性確認**
```bash
# Claude API
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-3-haiku-20240307","messages":[{"role":"user","content":"Hi"}],"max_tokens":10}'

# OpenAI API
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"

# Gemini API
curl "https://generativelanguage.googleapis.com/v1beta/models?key=$GEMINI_API_KEY"
```

### 3. トークン上限エラー

#### 症状
```
Error: maximum context length is 100000 tokens
Error: Request too large
```

#### 解決方法

**1. 差分の制限**
```yaml
with:
  max_diff_lines: 5000  # デフォルト10000から削減
```

**2. レビュータイプの変更**
```yaml
with:
  review_type: 'quick'  # detailedからquickに変更
```

**3. ファイルの除外**
```yaml
# .gitattributesでlinguist-generatedを設定
*.min.js linguist-generated
*.lock linguist-generated
```

### 4. レート制限エラー

#### 症状
```
Error: Rate limit exceeded
Error: Too many requests
```

#### 解決方法

**1. API使用量の確認**
- [Claude Console](https://console.anthropic.com/)
- [OpenAI Usage](https://platform.openai.com/usage)
- [Google AI Studio](https://makersuite.google.com/)

**2. 実行頻度の調整**
```yaml
# 条件付き実行の追加
if: |
  github.event.pull_request.additions < 1000 &&
  !contains(github.event.pull_request.labels.*.name, 'skip-ai-review')
```

**3. キャッシュの活用**
```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/ai-reviews
    key: ${{ runner.os }}-ai-${{ github.sha }}
```

### 5. タイムアウトエラー

#### 症状
```
Error: The operation was canceled
Error: Job was cancelled
```

#### 解決方法

**1. タイムアウト値の調整**
```yaml
jobs:
  analyze:
    timeout-minutes: 30  # デフォルト360から調整
```

**2. 処理の分割**
```yaml
# 大きなPRの場合、ファイルごとに分割
- name: Review part 1
  if: steps.check.outputs.file_count > 10
  run: |
    # 最初の10ファイルのみ処理
```

### 6. GitHub API制限

#### 症状
```
Error: API rate limit exceeded for installation ID
```

#### 解決方法

**1. GH_PATの使用**
```yaml
secrets:
  GH_PAT: ${{ secrets.GH_PAT }}  # より高い制限
```

**2. GraphQL APIの活用**
```javascript
// REST APIの代わりにGraphQLを使用
const query = `
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        files(first: 100) {
          nodes { path }
        }
      }
    }
  }
`;
```

## 🛠️ デバッグ方法

### 1. ワークフローログの確認

1. Actions タブを開く
2. 失敗したワークフローをクリック
3. 各ステップのログを展開

### 2. デバッグ出力の追加

```yaml
- name: Debug情報
  run: |
    echo "Event: ${{ github.event_name }}"
    echo "PR: ${{ github.event.pull_request.number }}"
    echo "Repo: ${{ github.repository }}"
```

### 3. ローカルでのテスト

```bash
# actを使用したローカル実行
act pull_request -e event.json
```

## 📊 パフォーマンス最適化

### 1. 並列実行の活用

```yaml
strategy:
  matrix:
    ai: [claude, openai, gemini]
```

### 2. 条件付き実行

```yaml
# ドキュメントのみの変更はスキップ
if: |
  !contains(join(github.event.pull_request.files.*.filename, ','), '.md')
```

### 3. キャッシュの最適化

```yaml
- uses: actions/cache@v4
  with:
    path: |
      ~/.cache/pip
      ~/.npm
    key: ${{ runner.os }}-${{ hashFiles('**/requirements.txt') }}
```

## 🆘 サポート

### Issue作成時の情報

問題が解決しない場合は、以下の情報を含めてIssueを作成してください：

```markdown
## 環境情報
- リポジトリ: [公開/プライベート]
- ワークフローバージョン: [v3/v4/v5]
- 発生日時: YYYY-MM-DD HH:MM (JST)

## エラー内容
```
[エラーメッセージをここに貼り付け]
```

## 再現手順
1. 
2. 
3. 

## 期待される動作

## 実際の動作

## ワークフローログ
[Actionsのログへのリンク]
```

### コミュニティサポート

- [GitHub Discussions](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/discussions)
- [Issue Tracker](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/issues)

## 🔗 関連リンク

- [GitHub Actions ドキュメント](https://docs.github.com/ja/actions)
- [Claude API ドキュメント](https://docs.anthropic.com/)
- [OpenAI API ドキュメント](https://platform.openai.com/docs)
- [Gemini API ドキュメント](https://ai.google.dev/)