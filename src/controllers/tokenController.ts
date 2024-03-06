import { Request, Response } from 'express';
import { getTokenData } from '../services/tokenService';

export const getTokenPrice = async (req: Request, res: Response) => {
  try {
    const { tokenIds, vsCurrencies, timePeriod } = req.query;
    const data = await getTokenData(tokenIds as string, vsCurrencies as string, timePeriod as string); // передайте timePeriod в getTokenData
    res.json(data);
    console.log(data);
  } catch (error) {
    res.status(500).send('Internal Server Error');
  }
};

