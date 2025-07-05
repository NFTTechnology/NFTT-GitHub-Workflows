# PRレビューワークフローのセキュリティスキャン誤検知対策

## 問題の概要

PRレビューワークフローがドキュメント内のコード例に対してSQLインジェクションや弱い暗号化アルゴリズムを誤検知している問題。

## 原因

1. **セキュリティパターンが全ファイルに適用されている**
   - `reusable-pr-review-v2.2.yml` と `reusable-pr-review.yml` でセキュリティパターンチェックが全ての差分に実行
   - ドキュメントファイル（`.md`、`.txt`、`.rst`）のコード例も検査対象になっている

2. **ファイルタイプ判定が活用されていない**
   - ファイル優先度の分類はあるが、セキュリティスキャンで区別されていない

## 修正内容

### 1. ドキュメントのみの変更を検出

```python
# ドキュメントファイルのみの変更かチェック
is_docs_only = len(source_files) == 0 and len(config_files) == 0
```

### 2. ソースコードファイルのみをスキャン

```python
if not is_docs_only:
    # ソースコードファイルの差分のみを抽出
    source_code_diff = ""
    
    # ソースファイルと設定ファイルの差分を収集
    for file in source_files + config_files:
        file_pattern = rf"diff --git.*{re.escape(file['path'])}.*?(?=diff --git|$)"
        file_diff_match = re.search(file_pattern, diff_content, re.DOTALL)
        if file_diff_match:
            source_code_diff += file_diff_match.group(0) + "\n\n"
```

### 3. ファイル別の検出結果を記録

セキュリティ問題がどのファイルで検出されたかを明確にします：

```python
security_issues.append({
    'type': pattern_name,
    'severity': pattern_info['severity'],
    'message': pattern_info['message'],
    'count': len(file_matches),
    'samples': [fm['match'] for fm in file_matches[:3]],
    'files': list(set([fm['file'] for fm in file_matches]))  # 新規追加
})
```

### 4. レポートの改善

- ドキュメントのみの変更の場合、スキップしたことを明記
- セキュリティ問題が検出された場合、対象ファイルを表示

## 適用方法

### パッチファイルを使用する場合

```bash
# v2.2用のパッチを適用
git apply fix-security-scan-v2.2.patch

# 通常版用のパッチを適用
git apply fix-security-scan.patch
```

### 手動で修正する場合

1. `.github/workflows/reusable-pr-review-v2.2.yml` を開く
2. 200行目付近の「セキュリティパターンのチェック」セクションを修正
3. 同様に `reusable-pr-review.yml` も修正

## 効果

1. **誤検知の削減**
   - ドキュメントファイルのコード例が検査対象外になる
   - SQLやセキュリティ関連のサンプルコードによる誤検知を防止

2. **パフォーマンス向上**
   - ドキュメントのみの変更時はセキュリティスキャンをスキップ
   - 不要な処理を省略してレビュー時間を短縮

3. **レポートの明確化**
   - セキュリティ問題が検出されたファイルを明示
   - ドキュメントのみの変更であることを明記

## 対象ファイルタイプ

### セキュリティスキャン対象（high/medium priority）
- ソースコード: `.js`, `.ts`, `.jsx`, `.tsx`, `.py`, `.java`, `.go`, `.rb`, `.php`, `.cs`, `.cpp`, `.c`
- 設定ファイル: `.yml`, `.yaml`, `.json`, `.xml`, `.ini`, `.env`

### セキュリティスキャン対象外（low priority）
- ドキュメント: `.md`, `.txt`, `.rst`
- その他の拡張子

## 今後の改善案

1. **コードブロックの除外**
   - マークダウン内のコードブロック（```で囲まれた部分）を除外する追加ロジック

2. **ファイルパスベースの除外**
   - `docs/`、`examples/`、`samples/` ディレクトリを除外

3. **設定可能な除外パターン**
   - ワークフロー入力パラメータで除外パターンを指定可能にする

## 関連ファイル

- `/home/godamasato/projects/NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review-v2.2.yml`
- `/home/godamasato/projects/NFTTechnology/NFTT-GitHub-Workflows/.github/workflows/reusable-pr-review.yml`
- `/home/godamasato/projects/NFTTechnology/NFTT-GitHub-Workflows/fix-security-scan-v2.2.patch`
- `/home/godamasato/projects/NFTTechnology/NFTT-GitHub-Workflows/fix-security-scan.patch`