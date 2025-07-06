const { APIRetryManager, providerConfigs } = require('../utils/api-retry');

/**
 * Enhanced AI client with improved error handling and retry logic
 * Addresses Issue #789: Claude API timeout problems
 */
class EnhancedAIClient {
  constructor(provider, apiKey, options = {}) {
    this.provider = provider;
    this.apiKey = apiKey;
    this.config = { ...providerConfigs[provider], ...options };
    this.retryManager = new APIRetryManager(this.config);
    this.metrics = {
      totalRequests: 0,
      successfulRequests: 0,
      failedRequests: 0,
      avgResponseTime: 0
    };
  }

  /**
   * Analyze issue with enhanced error handling
   * @param {Object} issueData - GitHub issue data
   * @returns {Promise<Object>} Analysis result
   */
  async analyzeIssue(issueData) {
    this.metrics.totalRequests++;
    const startTime = Date.now();

    try {
      const result = await this.retryManager.executeWithRetry(
        () => this.performAnalysis(issueData),
        {
          maxRetries: this.config.maxRetries,
          timeout: this.config.timeout
        }
      );

      if (result.success) {
        this.metrics.successfulRequests++;
        this.updateResponseTimeMetrics(Date.now() - startTime);
        
        return {
          provider: this.provider,
          analysis: result.data,
          metadata: {
            attempts: result.attempts,
            responseTime: Date.now() - startTime,
            success: true
          }
        };
      } else {
        this.metrics.failedRequests++;
        throw new Error(`${this.provider} API failed after ${result.attempts} attempts: ${result.error.message}`);
      }
    } catch (error) {
      this.metrics.failedRequests++;
      
      return {
        provider: this.provider,
        analysis: null,
        metadata: {
          success: false,
          error: error.message,
          responseTime: Date.now() - startTime
        }
      };
    }
  }

  /**
   * Perform the actual API analysis (provider-specific implementation)
   */
  async performAnalysis(issueData) {
    // This would be implemented differently for each provider
    switch (this.provider) {
      case 'claude':
        return await this.callClaudeAPI(issueData);
      case 'gpt':
        return await this.callGPTAPI(issueData);
      case 'gemini':
        return await this.callGeminiAPI(issueData);
      default:
        throw new Error(`Unknown provider: ${this.provider}`);
    }
  }

  /**
   * Claude API implementation with timeout handling
   */
  async callClaudeAPI(issueData) {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), this.config.timeout);

    try {
      const response = await fetch('https://api.anthropic.com/v1/messages', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
          'anthropic-version': '2023-06-01'
        },
        body: JSON.stringify({
          model: 'claude-3-5-sonnet-20241022',
          max_tokens: 2000,
          messages: [{
            role: 'user',
            content: `Analyze this GitHub issue: ${JSON.stringify(issueData)}`
          }]
        }),
        signal: controller.signal
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        throw new Error(`Claude API error: ${response.status} ${response.statusText}`);
      }

      const data = await response.json();
      return {
        summary: data.content[0].text,
        priority: this.extractPriority(data.content[0].text),
        tags: this.extractTags(data.content[0].text),
        estimatedTime: this.extractEstimatedTime(data.content[0].text)
      };
    } catch (error) {
      clearTimeout(timeoutId);
      if (error.name === 'AbortError') {
        throw new Error(`Claude API request timed out after ${this.config.timeout}ms`);
      }
      throw error;
    }
  }

  /**
   * Extract priority from AI response
   */
  extractPriority(text) {
    const priorityMatch = text.match(/priority[:\s]*([a-zA-Z]+)/i);
    return priorityMatch ? priorityMatch[1].toLowerCase() : 'medium';
  }

  /**
   * Extract tags from AI response
   */
  extractTags(text) {
    const tagsMatch = text.match(/tags?[:\s]*\[([^\]]+)\]/i);
    return tagsMatch ? tagsMatch[1].split(',').map(tag => tag.trim()) : [];
  }

  /**
   * Extract estimated time from AI response
   */
  extractEstimatedTime(text) {
    const timeMatch = text.match(/(\d+)\s*(hours?|days?|weeks?)/i);
    return timeMatch ? `${timeMatch[1]} ${timeMatch[2]}` : 'unknown';
  }

  /**
   * Update response time metrics
   */
  updateResponseTimeMetrics(responseTime) {
    const total = this.metrics.avgResponseTime * (this.metrics.successfulRequests - 1);
    this.metrics.avgResponseTime = (total + responseTime) / this.metrics.successfulRequests;
  }

  /**
   * Get current metrics
   */
  getMetrics() {
    return {
      ...this.metrics,
      successRate: this.metrics.totalRequests > 0 
        ? (this.metrics.successfulRequests / this.metrics.totalRequests * 100).toFixed(2) + '%'
        : '0%'
    };
  }

  // Placeholder methods for other providers
  async callGPTAPI(issueData) {
    // GPT-4 implementation would go here
    throw new Error('GPT API implementation pending');
  }

  async callGeminiAPI(issueData) {
    // Gemini implementation would go here
    throw new Error('Gemini API implementation pending');
  }
}

module.exports = { EnhancedAIClient };