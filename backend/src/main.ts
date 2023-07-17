require('dotenv').config();

import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as express from 'express';
import * as serveStatic from 'serve-static';
import { Request, Response, NextFunction } from 'express';
import { readFileSync } from 'fs';
import { join } from 'path';

console.log('Backend Start ', process.env.MESSAGE);

const STATIC_PATH =
  process.env.NODE_ENV === 'production'
    ? join(process.cwd(),"..", 'frontend', 'dist')
    : join(process.cwd(),"..", 'frontend');

async function bootstrap() {
  const nestApp = await NestFactory.create(AppModule);

  await nestApp.init();

  const app = express();

  app.use('/api', nestApp.getHttpAdapter().getInstance());

  app.use(serveStatic(STATIC_PATH, { index: false }));

  app.use('/*', async (_req: Request, res: Response, _next: NextFunction) => {
    return res
      .status(200)
      .set('Content-Type', 'text/html')
      .send(readFileSync(join(STATIC_PATH, 'index.html')));
  });

  await app.listen(process.env.PORT || 3000);
}
bootstrap();
