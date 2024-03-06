import { RateLimiterMemory } from 'rate-limiter-flexible';
import { Request, Response, NextFunction } from 'express';

const rateLimiter = new RateLimiterMemory({
  points: 5, // 5 запросов
  duration: 1, // за 1 секунду
});

export const rateLimiterMiddleware = (req: Request, res: Response, next: NextFunction) => {
  if (req.ip) {
    rateLimiter.consume(req.ip)
      .then(() => {
          next();
      })
      .catch(() => {
          res.status(429).send('Too Many Requests');
      });
  } else {
    res.status(400).send('IP Address is undefined');
  }
};
