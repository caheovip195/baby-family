import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

import {
  generateResource,
  validateResourceName,
} from './tools/generators/resource.mjs';

export default function registerGenerators(plop) {
  plop.setGenerator('resource', {
    description:
      'Generate a controller, service and Prisma repository with DI contracts.',
    prompts: [
      {
        type: 'input',
        name: 'name',
        message:
          'Singular resource name (kebab-case, for example family-member):',
        validate: validateResourceName,
      },
    ],
    actions: [
      async (answers) => {
        const result = await generateResource(answers.name, {
          rootDir: dirname(fileURLToPath(import.meta.url)),
        });
        return `Created ${result.name}: ${result.files.length} files, Prisma model and AppModule registration. Run npm run prisma:generate and npm run db:migrate.`;
      },
    ],
  });
}
