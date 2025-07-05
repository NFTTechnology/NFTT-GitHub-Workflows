# Contributing to NFTT-GitHub-Workflows

🎉 NFTT-GitHub-Workflowsへの貢献に興味を持っていただきありがとうございます！

## 📝 貢献の方法

### 1. Issueの作成

新機能の提案やバグ報告は、まずIssueを作成してください。

### 2. ForkとClone

```bash
# ForkしたリポジトリをClone
git clone https://github.com/YOUR_USERNAME/NFTT-GitHub-Workflows.git
cd NFTT-GitHub-Workflows
```

### 3. ブランチの作成

```bash
git checkout -b feature/your-feature-name
```

### 4. 変更の実施

#### ワークフローの追加

1. `workflows/`ディレクトリに新しいYAMLファイルを作成
2. `docs/workflows/`にドキュメントを追加
3. README.mdを更新

#### コーディング規約

- YAMLファイルは2スペースインデント
- コメントは日本語で記載
- ワークフロー名はkebab-case

### 5. テスト

```bash
# セルフテストの実行
gh workflow run test-reusable-workflows.yml
```

### 6. コミット

```bash
git add .
git commit -m "feat: 新しいワークフローの追加"
```

### 7. Pull Request

1. ForkしたリポジトリにPush
2. Pull Requestを作成
3. テンプレートに従って記入

## 🎯 Pull Requestガイドライン

### PRテンプレート

```markdown
## 概要
[変更内容の簡潔な説明]

## 変更種別
- [ ] 新機能
- [ ] バグ修正
- [ ] ドキュメント更新
- [ ] リファクタリング

## テスト
- [ ] セルフテスト実行
- [ ] ドキュメント更新

## 関連Issue
Closes #[issue number]
```

## 🛡️ セキュリティ

- APIキーやシークレットをコミットしない
- セキュリティ上の懸念がある場合は非公開で報告

## 💬 コミュニケーション

- IssueやPRでの議論は日本語または英語OK
- コードレビューは建設的に
- 質問は気軽に

## 🎆 貢献者への感謝

すべての貢献者はREADMEに名前が載ります！

---

ありがとうございます！ 🚀