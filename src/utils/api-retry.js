/**
 * API retry utility with exponential backoff
 * Supports multiple AI providers with different retry strategies
 */

class APIRetryManager {
  constructor(config = {}) {
    this.maxRetries = config.maxRetries || 3;
    this.baseDelay = config.baseDelay || 1000;
    this.maxDelay = config.maxDelay || 30000;
    this.enableLogging = config.enableLogging || true;
  }

  /**
   * Execute API call with retry logic
   * @param {Function} apiCall - Function that returns a Promise
   * @param {Object} options - Retry options
   */
  async executeWithRetry(apiCall, options = {}) {
    const retryConfig = { ...this.getDefaultConfig(), ...options };
    let lastError;

    for (let attempt = 0; attempt <= retryConfig.maxRetries; attempt++) {
      try {
        const startTime = Date.now();
        const result = await apiCall();
        
        if (this.enableLogging) {
          const duration = Date.now() - startTime;
          console.log(`API call succeeded on attempt ${attempt + 1} (${duration}ms)`);
        }
        
        return {
          success: true,
          data: result,
          attempts: attempt + 1,
          totalTime: Date.now() - startTime
        };
      } catch (error) {
        lastError = error;
        
        if (attempt === retryConfig.maxRetries) {
          break;
        }

        const delay = this.calculateDelay(attempt, retryConfig);
        
        if (this.enableLogging) {
          console.warn(`API call failed on attempt ${attempt + 1}:`, error.message);
          console.log(`Retrying in ${delay}ms...`);
        }
        
        await this.sleep(delay);
      }
    }

    return {
      success: false,
      error: lastError,
      attempts: retryConfig.maxRetries + 1
    };
  }

  /**
   * Calculate delay for next retry using exponential backoff
   */
  calculateDelay(attempt, config) {
    const exponentialDelay = config.baseDelay * Math.pow(2, attempt);
    const jitter = Math.random() * 0.1 * exponentialDelay;
    return Math.min(exponentialDelay + jitter, config.maxDelay);
  }

  /**
   * Sleep utility for delays
   */
  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  getDefaultConfig() {
    return {
      maxRetries: this.maxRetries,
      baseDelay: this.baseDelay,
      maxDelay: this.maxDelay
    };
  }
}

// Provider-specific configurations
const providerConfigs = {
  claude: {
    maxRetries: 3,
    baseDelay: 2000,
    maxDelay: 30000,
    timeout: 60000
  },
  gpt: {
    maxRetries: 2,
    baseDelay: 1000,
    maxDelay: 15000,
    timeout: 45000
  },
  gemini: {
    maxRetries: 4,
    baseDelay: 500,
    maxDelay: 10000,
    timeout: 30000
  }
};

module.exports = {
  APIRetryManager,
  providerConfigs
};