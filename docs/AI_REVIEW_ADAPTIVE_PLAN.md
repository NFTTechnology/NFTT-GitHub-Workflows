# AI PRレビュー適応的実装計画

## 背景
現在のPRレビューワークフローは、複数のAI APIが利用可能な前提で設計されていますが、実際の運用では以下の課題があります：

1. **API可用性の問題**
   - 一時的なサービス障害
   - APIキーの未設定または期限切れ
   - レート制限やコスト制限

2. **柔軟性の欠如**
   - 全てのAPIが利用可能でないと動作しない
   - 単一AIでの複数視点レビューができない

## 実装計画

### Phase 1: API可用性チェック機能（1週間）

#### 1.1 API健全性チェック
```yaml
- name: Check API Availability
  run: |
    # 各APIの可用性をチェック
    AVAILABLE_APIS=""
    
    # Claude API
    if [[ -n "${{ secrets.ANTHROPIC_API_KEY }}" ]]; then
      response=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "x-api-key: ${{ secrets.ANTHROPIC_API_KEY }}" \
        -H "anthropic-version: 2023-06-01" \
        https://api.anthropic.com/v1/messages \
        -d '{"model":"claude-3-haiku-20240307","messages":[{"role":"user","content":"test"}],"max_tokens":1}')
      if [[ "$response" == "200" ]]; then
        AVAILABLE_APIS="${AVAILABLE_APIS}claude,"
      fi
    fi
    
    # OpenAI API
    if [[ -n "${{ secrets.OPENAI_API_KEY }}" ]]; then
      response=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: Bearer ${{ secrets.OPENAI_API_KEY }}" \
        https://api.openai.com/v1/models)
      if [[ "$response" == "200" ]]; then
        AVAILABLE_APIS="${AVAILABLE_APIS}openai,"
      fi
    fi
    
    # Gemini API
    if [[ -n "${{ secrets.GEMINI_API_KEY }}" ]]; then
      response=$(curl -s -o /dev/null -w "%{http_code}" \
        "https://generativelanguage.googleapis.com/v1beta/models?key=${{ secrets.GEMINI_API_KEY }}")
      if [[ "$response" == "200" ]]; then
        AVAILABLE_APIS="${AVAILABLE_APIS}gemini,"
      fi
    fi
    
    echo "AVAILABLE_APIS=${AVAILABLE_APIS}" >> $GITHUB_ENV
```

#### 1.2 適応的モデル選択
```python
def select_review_strategy(available_apis, pr_type):
    """利用可能なAPIに基づいてレビュー戦略を選択"""
    
    api_count = len(available_apis)
    
    if api_count == 0:
        raise Exception("No AI APIs available")
    
    elif api_count == 1:
        # 単一AIで複数視点レビュー
        return {
            'mode': 'single_ai_multi_perspective',
            'api': available_apis[0],
            'roles': ['Security', 'QA', 'Architecture', 'Product']
        }
    
    elif api_count == 2:
        # 2つのAIで役割分担
        return {
            'mode': 'dual_ai_split',
            'apis': available_apis,
            'distribution': {
                available_apis[0]: ['Security', 'Architecture'],
                available_apis[1]: ['QA', 'Product']
            }
        }
    
    else:
        # 3つ以上のAIで通常動作
        return {
            'mode': 'standard',
            'apis': available_apis,
            'distribution': 'default'
        }
```

### Phase 2: 単一AI複数視点レビュー機能（2週間）

#### 2.1 プロンプトテンプレート
```python
SINGLE_AI_MULTI_PERSPECTIVE_PROMPT = """
あなたは経験豊富なソフトウェア開発チームのメンバーです。
以下の4つの異なる視点から、このPRをレビューしてください。

## 1. セキュリティエンジニアとして
- セキュリティ脆弱性の検出
- 認証・認可の問題
- データ保護の懸念
- 既知の攻撃パターンへの脆弱性

## 2. QAエンジニアとして
- エラーハンドリングの適切性
- 境界値テストの必要性
- 回帰リスクの評価
- テストカバレッジの評価

## 3. シニアアーキテクトとして
- 設計パターンの適切性
- コード品質と保守性
- パフォーマンスの懸念
- 技術的負債の評価

## 4. プロダクトマネージャーとして
- ユーザー影響の評価
- 要件との適合性
- ドキュメントの品質
- 移行計画の必要性

各視点から、以下の形式でレビューを提供してください：
- 問題点（ある場合）
- 改善提案
- 良い点
"""
```

#### 2.2 レスポンス統合機能
```python
def merge_perspectives(ai_response):
    """単一AIの複数視点レスポンスを統合"""
    
    sections = parse_response_sections(ai_response)
    
    issues = []
    for section in sections:
        issues.extend(extract_issues(section))
    
    # 重複除去と優先度付け
    unique_issues = deduplicate_issues(issues)
    prioritized_issues = prioritize_by_severity(unique_issues)
    
    return format_unified_review(prioritized_issues)
```

### Phase 3: AI固有の得意分野活用（1週間）

#### 3.1 AI特性マッピング
```yaml
ai_strengths:
  claude:
    - detailed_code_analysis
    - security_patterns
    - architectural_design
  openai:
    - natural_language_quality
    - documentation_review
    - api_design
  gemini:
    - performance_optimization
    - data_structure_efficiency
    - algorithm_complexity
```

#### 3.2 動的役割割り当て
```python
def assign_roles_by_strength(available_apis, required_roles):
    """AIの得意分野に基づいて役割を割り当て"""
    
    assignments = {}
    
    for api in available_apis:
        strengths = AI_STRENGTHS[api]
        suitable_roles = []
        
        for role in required_roles:
            if role_matches_strength(role, strengths):
                suitable_roles.append(role)
        
        assignments[api] = suitable_roles
    
    return balance_assignments(assignments)
```

### Phase 4: フォールバック機構（1週間）

#### 4.1 エラーハンドリング
```python
async def review_with_fallback(pr_data, primary_strategy):
    """プライマリ戦略が失敗した場合のフォールバック"""
    
    try:
        return await execute_review(pr_data, primary_strategy)
    
    except APIError as e:
        logger.warning(f"Primary strategy failed: {e}")
        
        # フォールバック戦略を試行
        fallback_apis = get_working_apis()
        
        if not fallback_apis:
            return generate_basic_review(pr_data)
        
        fallback_strategy = create_minimal_strategy(fallback_apis[0])
        return await execute_review(pr_data, fallback_strategy)
```

#### 4.2 基本レビュー生成
```python
def generate_basic_review(pr_data):
    """AI APIが利用できない場合の基本的なレビュー"""
    
    return {
        'summary': 'AI APIが利用できないため、基本的なチェックのみ実施',
        'checks': {
            'file_count': len(pr_data['files']),
            'additions': pr_data['additions'],
            'deletions': pr_data['deletions'],
            'large_files': find_large_files(pr_data),
            'security_patterns': run_static_security_checks(pr_data)
        }
    }
```

## 実装優先順位

1. **必須機能**（Phase 1）
   - API可用性チェック
   - 基本的なフォールバック

2. **重要機能**（Phase 2）
   - 単一AI複数視点レビュー
   - レスポンス統合

3. **最適化機能**（Phase 3-4）
   - AI特性に基づく役割割り当て
   - 高度なフォールバック機構

## 期待される成果

1. **可用性の向上**
   - API障害時でもレビュー継続可能
   - 部分的なAPI設定でも動作

2. **コスト最適化**
   - 必要最小限のAPI利用
   - 単一AIでの効率的なレビュー

3. **品質の維持**
   - API数に関わらず一定品質のレビュー
   - 各AIの得意分野を最大限活用

## テスト計画

1. **単体テスト**
   - API可用性チェックのモック
   - 各種フォールバックシナリオ

2. **統合テスト**
   - 1つ、2つ、3つのAPI利用パターン
   - API障害シミュレーション

3. **性能テスト**
   - レスポンス時間の測定
   - トークン使用量の最適化確認

## ロールアウト計画

1. **Week 1-2**: Phase 1実装とテスト
2. **Week 3-4**: Phase 2実装とドッグフーディング
3. **Week 5**: Phase 3-4実装
4. **Week 6**: 本番環境への段階的展開

## リスクと対策

| リスク | 影響 | 対策 |
|--------|------|------|
| 単一AIの品質低下 | レビュー精度の低下 | プロンプト最適化、複数回実行 |
| API切り替えの複雑性 | バグの増加 | 十分なテスト、段階的展開 |
| レスポンス時間増加 | 開発者体験の悪化 | 並列処理、キャッシュ活用 |

## 成功指標

1. **可用性**: 99%以上のPRでレビュー実行成功
2. **品質**: 単一AI使用時でも80%以上の問題検出率
3. **コスト**: 平均コスト20%削減
4. **満足度**: 開発者からのポジティブフィードバック率80%以上