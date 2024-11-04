async function retryAsync(asyncFunction, retries = 3, delay = 1000) {
    let attempts = 0;
    while (attempts < retries) {
        try {
            return await asyncFunction();
        } catch (error) {
            attempts++;
            console.warn(`[Chai Retry] Attempt ${attempts} failed. Retrying in ${delay}ms...`);
            if (attempts === retries) throw error;
            await new Promise((resolve) => setTimeout(resolve, delay));
        }
    }
}

module.exports = retryAsync;
