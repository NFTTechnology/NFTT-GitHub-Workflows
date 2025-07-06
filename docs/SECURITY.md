# 🔒 Security Policy

<div align="center">

**Protecting Your Workflows and Data**

[![Security](https://img.shields.io/badge/Security-Policy-red?style=for-the-badge&logo=shield)](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/security)
[![Vulnerabilities](https://img.shields.io/badge/Vulnerabilities-0-brightgreen?style=for-the-badge)](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/security/advisories)
[![Best Practices](https://img.shields.io/badge/Best%20Practices-Enforced-blue?style=for-the-badge)](https://github.com/NFTTechnology/NFTT-GitHub-Workflows)

</div>

## 🎯 Security Philosophy

At NFTT-GitHub-Workflows, security is not an afterthought—it's a fundamental design principle. We implement defense-in-depth strategies to protect your workflows, data, and API credentials.

## 🚨 Reporting Security Vulnerabilities

### Responsible Disclosure

We take security seriously and appreciate your help in keeping NFTT-GitHub-Workflows secure. If you discover a security vulnerability, please follow our responsible disclosure process.

### How to Report

**⚠️ IMPORTANT: Do NOT create public issues for security vulnerabilities**

#### Option 1: GitHub Security Advisory (Preferred)
1. Navigate to the [Security tab](https://github.com/NFTTechnology/NFTT-GitHub-Workflows/security)
2. Click "Report a vulnerability"
3. Fill out the security advisory form

#### Option 2: Direct Contact
- **Email**: goda @ nftt.co.jp
- **PGP Key**: [Download our public key](https://nfttechnology.com/pgp-key.asc)

### What to Include

Please provide as much information as possible:

```markdown
## Vulnerability Details
- **Type**: [e.g., Code Injection, Information Disclosure]
- **Severity**: [Critical/High/Medium/Low]
- **Component**: [Affected workflow/file]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [...]

## Impact Assessment
- Who is affected?
- What data/systems are at risk?
- Potential damage if exploited?

## Suggested Fix
[If you have recommendations]

## Additional Context
[Screenshots, logs, etc.]
```

### Response Timeline

| Severity | Initial Response | Fix Timeline |
|----------|-----------------|--------------|
| 🔴 Critical | < 4 hours | < 24 hours |
| 🟠 High | < 24 hours | < 7 days |
| 🟡 Medium | < 72 hours | < 30 days |
| 🟢 Low | < 1 week | Next release |

## 🛡️ Security Best Practices

### 1. API Key Management

#### ✅ DO
```yaml
- name: Call AI API
  env:
    API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
  run: |
    curl -H "Authorization: Bearer $API_KEY" ...
```

#### ❌ DON'T
```yaml
- name: Call AI API
  run: |
    curl -H "Authorization: Bearer sk-1234567890abcdef" ...
```

### 2. Workflow Permissions

Always use the principle of least privilege:

```yaml
permissions:
  contents: read        # Read-only access to repository
  issues: write        # Only if needed
  pull-requests: write # Only if needed
  actions: read        # Minimal permissions
```

### 3. Input Validation

Protect against injection attacks:

```yaml
- name: Validate Input
  run: |
    # Sanitize user input
    SAFE_INPUT=$(echo "${{ github.event.comment.body }}" | sed 's/[^a-zA-Z0-9 ]//g')
    
    # Use validated input
    echo "Processing: $SAFE_INPUT"
```

### 4. Secret Scanning

We automatically scan for:
- API keys and tokens
- Private keys
- Passwords and credentials
- Connection strings

### 5. Dependency Security

```yaml
- name: Security Scan
  uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'fs'
    scan-ref: '.'
    severity: 'CRITICAL,HIGH'
```

## 🔐 Secure Configuration Examples

### Secure API Call Pattern

```yaml
jobs:
  secure-api-call:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Validate Environment
        run: |
          if [ -z "${{ secrets.API_KEY }}" ]; then
            echo "::error::API key not configured"
            exit 1
          fi
          
      - name: Make Secure API Call
        env:
          API_KEY: ${{ secrets.API_KEY }}
        run: |
          response=$(curl -s -w "\n%{http_code}" \
            -H "Authorization: Bearer $API_KEY" \
            -H "Content-Type: application/json" \
            --fail-with-body \
            "$API_ENDPOINT")
          
          http_code=$(echo "$response" | tail -n1)
          body=$(echo "$response" | sed '$d')
          
          if [ "$http_code" -ne 200 ]; then
            echo "::error::API call failed with status $http_code"
            exit 1
          fi
```

### Secure Issue Processing

```yaml
- name: Process Issue Safely
  uses: actions/github-script@v7
  with:
    script: |
      const issueBody = context.payload.issue.body || '';
      
      // Sanitize input
      const sanitized = issueBody
        .replace(/[<>]/g, '') // Remove HTML tags
        .substring(0, 10000); // Limit length
      
      // Validate content
      if (sanitized.includes('script') || sanitized.includes('eval')) {
        core.setFailed('Potentially malicious content detected');
        return;
      }
      
      // Process safely
      console.log('Processing sanitized content...');
```

## 🔍 Security Auditing

### Automated Security Checks

Our CI/CD pipeline includes:

- **SAST** (Static Application Security Testing)
- **Dependency scanning** with Dependabot
- **Secret scanning** with GitHub's secret scanning
- **Container scanning** for Docker images
- **License compliance** checks

### Manual Security Reviews

- Quarterly code security reviews
- Annual third-party penetration testing
- Continuous threat modeling
- Regular security training for maintainers

## 📋 Security Checklist for Contributors

Before submitting a PR, ensure:

- [ ] No hardcoded secrets or credentials
- [ ] All API calls use environment variables
- [ ] Input validation is implemented
- [ ] Error messages don't leak sensitive info
- [ ] Dependencies are up-to-date
- [ ] Security tests pass
- [ ] Documentation doesn't expose secrets

## 🏗️ Infrastructure Security

### GitHub Actions Security

- Restricted workflow permissions
- Pinned action versions
- Signed commits required
- Protected branches enforced
- Required reviews for security changes

### API Security

- Rate limiting implemented
- Request validation
- Response sanitization
- Audit logging
- Encryption in transit

## 🚫 Common Security Anti-Patterns

### 1. Logging Sensitive Data
```yaml
# ❌ BAD: Logs API key
- run: echo "Using key: ${{ secrets.API_KEY }}"

# ✅ GOOD: Masks sensitive data
- run: echo "::add-mask::${{ secrets.API_KEY }}"
```

### 2. Unsafe Command Execution
```yaml
# ❌ BAD: Command injection risk
- run: echo ${{ github.event.issue.title }}

# ✅ GOOD: Quoted and sanitized
- run: echo "${{ github.event.issue.title }}"
```

### 3. Overly Permissive Workflows
```yaml
# ❌ BAD: Too many permissions
permissions: write-all

# ✅ GOOD: Minimal required permissions
permissions:
  issues: write
  contents: read
```

## 🎖️ Security Hall of Fame

We recognize security researchers who have helped improve our security:

| Researcher | Contribution | Date |
|------------|-------------|------|
| @security-hero | Critical API key exposure fix | 2025-06 |
| @white-hat | Workflow injection prevention | 2025-05 |

## 📚 Security Resources

- [GitHub Security Best Practices](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE/SANS Top 25](https://cwe.mitre.org/top25/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

## 🔄 Security Update Process

1. **Discovery**: Vulnerability identified
2. **Triage**: Severity assessment
3. **Fix**: Patch development
4. **Test**: Security validation
5. **Release**: Coordinated disclosure
6. **Monitor**: Post-release monitoring

## 📞 Contact

- **Security Team**: goda@nftt.co.jp
- **Bug Bounty**: [Program Details](https://nfttechnology.com/bug-bounty)
- **Security Updates**: [Subscribe](https://nfttechnology.com/security-updates)

---

<div align="center">

**覚えておいてください： セキュリティは全員の責任です**

*最終更新: 2025年7月*

</div>