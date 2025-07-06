# 🤝 Contributing to NFTT-GitHub-Workflows

<div align="center">

**Thank you for your interest in contributing to NFTT-GitHub-Workflows!**

Your contributions help make this project better for everyone in the community.

[![Contributors](https://img.shields.io/github/contributors/NFTTechnology/NFTT-GitHub-Workflows?style=for-the-badge)](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/graphs/contributors)
[![Issues](https://img.shields.io/github/issues/NFTTechnology/NFTT-GitHub-Workflows?style=for-the-badge)](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/NFTTechnology/NFTT-GitHub-Workflows?style=for-the-badge)](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/pulls)

</div>

## 📋 Table of Contents

- [Code of Conduct](#-code-of-conduct)
- [Getting Started](#-getting-started)
- [Development Process](#-development-process)
- [Contribution Types](#-contribution-types)
- [Pull Request Process](#-pull-request-process)
- [Style Guidelines](#-style-guidelines)
- [Testing](#-testing)
- [Recognition](#-recognition)

## 📜 Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- **Be Respectful**: Treat everyone with respect and kindness
- **Be Constructive**: Provide helpful feedback and suggestions
- **Be Inclusive**: Welcome contributors from all backgrounds
- **Be Professional**: Maintain professional conduct in all interactions

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

- GitHub account with 2FA enabled
- Git installed locally
- Basic understanding of GitHub Actions
- Familiarity with YAML syntax

### Setting Up Your Development Environment

1. **Fork the Repository**
   ```bash
   # Navigate to https://github.com/NFTTechnology/NFTT-GitHub-Workflows
   # Click the "Fork" button in the top-right corner
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/NFTT-GitHub-Workflows.git
   cd NFTT-GitHub-Workflows
   ```

3. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/NFTTechnology/NFTT-GitHub-Workflows.git
   git fetch upstream
   ```

4. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-amazing-feature
   ```

## 🔄 Development Process

### 1. Choose or Create an Issue

- Check existing [issues](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/issues)
- If none exist, create a new issue describing your proposed change
- Wait for maintainer approval before starting major changes

### 2. Branch Naming Convention

Use descriptive branch names following this pattern:

- `feature/` - New features or enhancements
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Test additions or fixes

Examples:
- `feature/add-golang-analyzer`
- `fix/token-counting-error`
- `docs/update-api-guide`

### 3. Make Your Changes

Follow these guidelines:

- Keep changes focused and atomic
- Write clear, descriptive commit messages
- Update relevant documentation
- Add tests where applicable

### 4. Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Test additions or modifications
- `chore`: Maintenance tasks

**Examples:**
```bash
feat(workflows): add support for Python code analysis
fix(v5): correct token calculation for large files
docs(readme): update installation instructions
```

## 🎯 Contribution Types

### 🐛 Bug Reports

When reporting bugs, include:

- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, versions)
- Relevant logs or screenshots

**Template:**
```markdown
### Bug Description
[Clear description of the bug]

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [...]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Environment
- OS: [e.g., Ubuntu 22.04]
- GitHub Actions Runner: [e.g., ubuntu-latest]
- Workflow Version: [e.g., v5]

### Additional Context
[Any other relevant information]
```

### ✨ Feature Requests

For new features, provide:

- Problem statement
- Proposed solution
- Alternative approaches considered
- Potential impact on existing users

### 📝 Documentation

Documentation improvements are always welcome:

- Fix typos or unclear explanations
- Add examples or use cases
- Translate documentation
- Improve code comments

### 🔧 Code Contributions

When contributing code:

- Follow existing patterns and conventions
- Ensure backward compatibility
- Add appropriate error handling
- Include unit tests for new functionality

## 🔄 Pull Request Process

### 1. Pre-PR Checklist

- [ ] Code follows project style guidelines
- [ ] Tests pass locally
- [ ] Documentation is updated
- [ ] Commits are clean and well-organized
- [ ] Branch is up-to-date with main

### 2. Creating the Pull Request

Use our PR template:

```markdown
## Description
[Describe your changes in detail]

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] New tests added (if applicable)
- [ ] Manual testing completed

## Checklist
- [ ] My code follows the project style guidelines
- [ ] I have performed a self-review
- [ ] I have added comments in hard-to-understand areas
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings

## Related Issues
Fixes #[issue number]

## Screenshots (if applicable)
[Add screenshots to demonstrate the changes]
```

### 3. Review Process

- Maintainers will review your PR within 48-72 hours
- Address feedback constructively
- Make requested changes in new commits (don't force-push)
- Once approved, maintainers will merge your PR

## 📐 Style Guidelines

### YAML Files

```yaml
# Use 2 spaces for indentation (not tabs)
name: Example Workflow
on:
  push:
    branches:
      - main

jobs:
  example:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
```

### Documentation

- Use clear, concise language
- Include code examples where helpful
- Keep line length under 120 characters
- Use proper markdown formatting

### Code Comments

```yaml
# Good: Explains why
# Calculate token usage to ensure we stay within API limits
max_tokens: 4000

# Bad: States the obvious
# Set max tokens to 4000
max_tokens: 4000
```

## 🧪 Testing

### Running Tests Locally

```bash
# Validate YAML syntax
yamllint .github/workflows/*.yml

# Test workflow execution
act -j test-workflow

# Run specific workflow
gh workflow run test-3ai-analyzer.yml
```

### Writing Tests

- Test both success and failure scenarios
- Mock external API calls
- Verify error handling
- Check edge cases

## 🏆 Recognition

### Contributors

All contributors are recognized in our:

- [Contributors page](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/graphs/contributors)
- README.md acknowledgments section
- Release notes

### Contribution Levels

- 🥉 **Bronze**: First-time contributor
- 🥈 **Silver**: 5+ merged PRs
- 🥇 **Gold**: 10+ merged PRs
- 💎 **Diamond**: Core maintainer

## 🆘 Getting Help

If you need assistance:

1. Check our [documentation](../README.md)
2. Search existing [issues](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/issues)
3. Join our [discussions](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/discussions)
4. Contact maintainers via [@NFTTechnology](https://twitter.com/nfttechnology)

## 🔒 Security

### Reporting Security Issues

**DO NOT** create public issues for security vulnerabilities. Instead:

1. Email goda@nftt.co.jp
2. Include detailed description and steps to reproduce
3. Allow 48 hours for initial response

### Security Best Practices

- Never commit secrets or API keys
- Use GitHub Secrets for sensitive data
- Validate all inputs
- Follow principle of least privilege

---

<div align="center">

**Thank you for contributing to NFTT-GitHub-Workflows!** 🎉

Your efforts help make automated code analysis accessible to developers worldwide.

</div>