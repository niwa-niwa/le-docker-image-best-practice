import { Injectable } from '@nestjs/common';
import { readFileSync } from 'fs';
import { join } from 'path';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }

  getChapters() {
    const jsonPath = join(process.cwd(), '..', 'assets', 'pages.json');

    const chapters = JSON.parse(readFileSync(jsonPath, 'utf8'));

    return chapters;
  }
}
