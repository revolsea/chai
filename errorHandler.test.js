const ErrorHandler = require('../utils/errorHandler');

test('throws an error if argument type is incorrect', () => {
    expect(() => ErrorHandler.validateArgument(123, 'string')).toThrowError(
        'Invalid argument type. Expected string but received number.'
    );
});

test('logs error with correct message format', () => {
    const consoleSpy = jest.spyOn(console, 'error');
    ErrorHandler.logError(new Error('Test error'));
    expect(consoleSpy).toHaveBeenCalledWith(expect.stringContaining('[Chai Error]'));
    consoleSpy.mockRestore();
});
