// файл: routes/tokenRoutes.ts
import { Router } from 'express';
import { getTokenPrice } from '../controllers/tokenController';

const router = Router();

router.get('/token-price', getTokenPrice);

export default router;
