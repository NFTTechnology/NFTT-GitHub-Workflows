# リポジトリ設定ガイド

このガイドに従って、GitHubリポジトリの設定を行ってください。

## 1. 基本設定（Settings → General）

### Description（説明）
```
エンタープライズグレードのAI駆動型GitHub Actionsワークフロー集。Claude、GPT-4、Geminiによる自動コードレビューとIssue分析。
```

### Website
```
https://nfttechnology.github.io/NFTT-GitHub-Workflows/
```

### Topics（トピック）
以下のトピックを追加：
- `github-actions`
- `ai`
- `code-review`
- `claude`
- `gpt-4`
- `gemini`
- `automation`
- `workflow`
- `japanese`

## 2. GitHub Pages設定（Settings → Pages）

1. **Source**: Deploy from a branch
2. **Branch**: main
3. **Folder**: /docs
4. **Save**をクリック

数分後に https://nfttechnology.github.io/NFTT-GitHub-Workflows/ でドキュメントが公開されます。

## 3. Features設定（Settings → General → Features）

- ✅ **Issues**: ON（問題報告を受け付ける）
- ✅ **Projects**: OFF（今は不要）
- ✅ **Wiki**: OFF（docsで十分）
- ✅ **Discussions**: ON（コミュニティディスカッション用）

## 4. Pull Requests設定（Settings → General → Pull Requests）

- ✅ **Allow merge commits**: ON
- ✅ **Allow squash merging**: ON（推奨）
- ✅ **Allow rebase merging**: OFF
- ✅ **Automatically delete head branches**: ON（マージ後にブランチ自動削除）

## 5. 推奨される追加設定

### Sponsorship（スポンサー）設定
もし支援を受け付ける場合は、Settings → General → Sponsorshipsから設定できます。

### Social Preview
リポジトリのプレビュー画像を設定すると、SNSでシェアされた時の見栄えが良くなります。

## 設定完了チェックリスト

- [ ] Description設定済み
- [ ] Website設定済み
- [ ] Topics追加済み
- [ ] GitHub Pages有効化済み
- [ ] Issues有効化済み
- [ ] 不要な機能（Wiki等）無効化済み
- [ ] PR設定済み

## 注意事項

- ブランチ保護は現在OFFです（素早い修正を優先）
- セキュリティアラートは現在OFFです（手動管理）
- コード分析は現在OFFです（必要に応じて後から有効化可能）