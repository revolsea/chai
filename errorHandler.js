class ErrorHandler {
    static logError(error) {
        console.error(`[Chai Error] ${new Date().toISOString()}: ${error.message}`);
    }

    static throwError(message) {
        const error = new Error(message);
        this.logError(error);
        throw error;
    }

    static validateArgument(argument, type) {
        if (typeof argument !== type) {
            this.throwError(`Invalid argument type. Expected ${type} but received ${typeof argument}.`);
        }
    }
}

module.exports = ErrorHandler;
