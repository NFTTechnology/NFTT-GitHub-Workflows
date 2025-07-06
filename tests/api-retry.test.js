const { APIRetryManager } = require('../src/utils/api-retry');

describe('APIRetryManager', () => {
  let retryManager;

  beforeEach(() => {
    retryManager = new APIRetryManager({
      maxRetries: 3,
      baseDelay: 100,
      enableLogging: false
    });
  });

  describe('executeWithRetry', () => {
    it('should succeed on first attempt', async () => {
      const mockApiCall = jest.fn().mockResolvedValue('success');
      
      const result = await retryManager.executeWithRetry(mockApiCall);
      
      expect(result.success).toBe(true);
      expect(result.data).toBe('success');
      expect(result.attempts).toBe(1);
      expect(mockApiCall).toHaveBeenCalledTimes(1);
    });

    it('should retry on failure and eventually succeed', async () => {
      const mockApiCall = jest.fn()
        .mockRejectedValueOnce(new Error('First failure'))
        .mockRejectedValueOnce(new Error('Second failure'))
        .mockResolvedValue('success');
      
      const result = await retryManager.executeWithRetry(mockApiCall);
      
      expect(result.success).toBe(true);
      expect(result.data).toBe('success');
      expect(result.attempts).toBe(3);
      expect(mockApiCall).toHaveBeenCalledTimes(3);
    });

    it('should fail after max retries', async () => {
      const mockApiCall = jest.fn().mockRejectedValue(new Error('Persistent failure'));
      
      const result = await retryManager.executeWithRetry(mockApiCall);
      
      expect(result.success).toBe(false);
      expect(result.error.message).toBe('Persistent failure');
      expect(result.attempts).toBe(4); // 1 initial + 3 retries
      expect(mockApiCall).toHaveBeenCalledTimes(4);
    });
  });

  describe('calculateDelay', () => {
    it('should calculate exponential backoff correctly', () => {
      const config = { baseDelay: 1000, maxDelay: 30000 };
      
      // First retry (attempt 0)
      const delay1 = retryManager.calculateDelay(0, config);
      expect(delay1).toBeGreaterThanOrEqual(1000);
      expect(delay1).toBeLessThanOrEqual(1100); // with jitter
      
      // Second retry (attempt 1)
      const delay2 = retryManager.calculateDelay(1, config);
      expect(delay2).toBeGreaterThanOrEqual(2000);
      expect(delay2).toBeLessThanOrEqual(2200);
    });

    it('should respect max delay limit', () => {
      const config = { baseDelay: 1000, maxDelay: 5000 };
      
      const delay = retryManager.calculateDelay(10, config); // Very high attempt
      expect(delay).toBeLessThanOrEqual(5000);
    });
  });
});

// Integration test for enhanced AI client
describe('EnhancedAIClient Integration', () => {
  const { EnhancedAIClient } = require('../src/ai-providers/enhanced-client');
  
  it('should handle timeout gracefully', async () => {
    const client = new EnhancedAIClient('claude', 'test-key', {
      timeout: 100, // Very short timeout for testing
      maxRetries: 1,
      enableLogging: false
    });

    // Mock a slow API call
    client.callClaudeAPI = jest.fn().mockImplementation(() => 
      new Promise(resolve => setTimeout(resolve, 200))
    );

    const result = await client.analyzeIssue({ title: 'Test issue' });
    
    expect(result.metadata.success).toBe(false);
    expect(result.metadata.error).toContain('timed out');
  });
});