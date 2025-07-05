# 既知の問題と解決方法

## 1. gh issue create で /analyze が消える問題

### 症状
```bash
gh issue create --body "本文に/analyzeを含める"
```
実行時に以下のエラーが発生：
```
/bin/bash: line XX: /analyze: No such file or directory
```

### 原因
bashが `/analyze` をコマンドとして解釈しようとするため。

### 解決方法

#### 方法1: ファイルから読み込む（推奨）
```bash
cat > issue_body.md << 'EOF'
## 概要
テスト用Issue

/analyze
EOF

gh issue create --title "タイトル" --body-file issue_body.md
```

#### 方法2: echoを使用
```bash
BODY=$(echo -e "## 概要\nテスト用Issue\n\n/analyze")
gh issue create --title "タイトル" --body "$BODY"
```

#### 方法3: プログラムから作成
```bash
gh api repos/{owner}/{repo}/issues \
  --method POST \
  --field title="タイトル" \
  --field body="本文に/analyzeを含める"
```

## 2. workflow_call での secrets 名前衝突

### 症状
```yaml
secrets:
  GITHUB_TOKEN:
    required: false
```
でエラー：`secret name GITHUB_TOKEN within workflow_call can not be used`

### 解決方法
`GITHUB_TOKEN` は予約語なので、`secrets` セクションから削除し、`github.token` を直接使用：
```yaml
github-token: ${{ github.token }}
```