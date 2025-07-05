# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Quick Start section in README for faster onboarding
- Cost estimation guide for different usage patterns
- FAQ section for common questions
- Badges for repository status
- Star History visualization
- Comprehensive documentation updates
- New `USAGE_PATTERNS.md` with extensive implementation examples
- Architecture diagram in README
- Latest AI model pricing comparison (2024)
- GitHub Actions best practices and limits information
- Links to official documentation for all technologies
- Use case examples by project size and purpose
- Integration patterns (Slack, PRs, etc.)
- Performance optimization strategies

### Changed
- Updated documentation with latest API versions
- Enhanced security best practices
- Improved troubleshooting guides
- Restructured README with 3AI approach (説明・実装・利用)
- Enhanced `3AI_ANALYZER_GUIDE.md` with cost information and latest links
- Added 2024 pricing comparison for Claude 3.5, GPT-4, and Gemini
- Updated GitHub Actions free tier information

### Removed
- Duplicate documentation files (`3ai-issue-analyzer.md`, `quick-setup-guide.md`)
- Project-specific files (`implementation-plan-share-manga.md`)
- Redundant `workflows` directory in docs

## [v2.2.0] - 2024-11-26

### Added
- Token usage tracking and cost display in PR reviews
- Enhanced security pattern detection with severity levels
- tiktoken integration for accurate token counting
- Cost calculation with detailed breakdown

### Changed
- Improved PR review output format
- Enhanced multi-role review coordination

## [v2.1.0] - 2024-11-25

### Added
- Debug mode for PR reviews
- File type prioritization for source code focus
- Security pattern detection (SQL injection, hardcoded secrets, etc.)

### Changed
- Merged v1.1 improvements into v2 multi-role review
- Enhanced role-specific security pattern assignment

## [v2.0.0] - 2024-11-24

### Added
- Multi-role AI review with 4 perspectives
- Security Engineer role (Claude)
- QA Engineer role (OpenAI)
- Senior Architect role (Claude)
- Product Manager role (OpenAI)

### Changed
- Complete rewrite of PR review logic
- Improved coordination between multiple AI reviewers

## [v1.1.0] - 2024-11-23

### Added
- Security pattern detection
- Source code extraction
- Debug mode

### Fixed
- PR review focusing on workflow files instead of source code

## [v1.0.0] - 2024-11-22

### Added
- Initial release of reusable workflows
- 3AI Issue Analyzer with Claude, OpenAI, and Gemini
- Basic PR review functionality
- Workflow templates

## [v5.0.0] - 2024-11-20 (3AI Issue Analyzer)

### Added
- Cost optimization with model selection
- Claude 3.5 Haiku for comment summarization
- Improved token usage tracking

### Changed
- Reduced analysis costs by 60-70%
- Optimized API calls

## [v4.0.0] - 2024-11-19 (3AI Issue Analyzer)

### Added
- Comment history analysis
- Context preservation across comments
- Enhanced issue understanding

## [v3.0.0] - 2024-11-18 (3AI Issue Analyzer)

### Added
- Simple version without Base64 encoding
- Direct API integration
- Cleaner implementation

[Unreleased]: https://github.com/NFTTechnology/NFTT-GitHub-Workflows/compare/v2.2.0...HEAD
[v2.2.0]: https://github.com/NFTTechnology/NFTT-GitHub-Workflows/compare/v2.1.0...v2.2.0
[v2.1.0]: https://github.com/NFTTechnology/NFTT-GitHub-Workflows/compare/v2.0.0...v2.1.0
[v2.0.0]: https://github.com/NFTTechnology/NFTT-GitHub-Workflows/compare/v1.1.0...v2.0.0
[v1.1.0]: https://github.com/NFTTechnology/NFTT-GitHub-Workflows/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/NFTTechnology/NFTT-GitHub-Workflows/releases/tag/v1.0.0