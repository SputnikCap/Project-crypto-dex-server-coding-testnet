import axios from 'axios';
import NodeCache from 'node-cache';
//import { config } from '../config/config';

const myCache = new NodeCache({ stdTTL: 100, checkperiod: 120 });

export const getTokenData = async (tokenIds: string, vsCurrencies: string, timePeriod: string) => {
    const cacheKey = `tokenData-${tokenIds}-${vsCurrencies}-${timePeriod}`;
    const cachedData = myCache.get(cacheKey);

    if (cachedData) {
        console.log('Returning cached data:', cachedData);
        return cachedData;
    }

    try {
        const apiUrl = `https://api.coingecko.com/api/v3/simple/price?ids=${tokenIds}&vs_currencies=${vsCurrencies}`;
        console.log('Fetching from external API:', apiUrl);
        const response = await axios.get(apiUrl);

        console.log('Data from external API:', response.data);

        myCache.set(cacheKey, response.data, 60);
        return response.data;
    } catch (error) {
        console.error('Ошибка при получении данных о токене:', error);
        throw error;
    }
};
