# 🧪 The Lab Testing Infrastructure

> Ensuring quality and reliability in your rapid development workflow

## Overview

The Lab Framework encourages test-driven development while maintaining the speed advantage of AI-enhanced workflows. This directory contains global testing utilities and patterns that can be used across all projects.

## Testing Philosophy

1. **Test What Matters**: Focus on business logic and integration points
2. **AI-Assisted Testing**: Use TaskMaster to generate test cases
3. **Fast Feedback**: Run tests continuously during development
4. **Progressive Coverage**: Start with critical paths, expand over time

## Directory Structure

```
tests/
├── utils/              # Shared testing utilities
│   ├── mockData.js     # Common mock data generators
│   ├── testHelpers.js  # Helper functions for tests
│   └── setupTests.js   # Global test setup
├── fixtures/           # Test data fixtures
├── integration/        # Framework integration tests
└── README.md          # This file
```

## Testing Patterns

### Unit Testing Pattern

```javascript
// Example: src/auth/jwt.test.js
import { generateToken, verifyToken } from './jwt';
import { mockUser } from '@tests/utils/mockData';

describe('JWT Authentication', () => {
  it('should generate valid token', () => {
    const user = mockUser();
    const token = generateToken(user);
    
    expect(token).toBeDefined();
    expect(token.split('.')).toHaveLength(3);
  });

  it('should verify valid token', async () => {
    const user = mockUser();
    const token = generateToken(user);
    const decoded = await verifyToken(token);
    
    expect(decoded.id).toBe(user.id);
  });
});
```

### Integration Testing Pattern

```javascript
// Example: tests/integration/taskmaster.test.js
import { execSync } from 'child_process';

describe('TaskMaster Integration', () => {
  it('should initialize project', () => {
    const result = execSync('tm init --name=test-project -y', {
      encoding: 'utf8'
    });
    
    expect(result).toContain('TaskMaster initialized');
    expect(fs.existsSync('.taskmaster')).toBe(true);
  });
});
```

### AI-Generated Test Pattern

```bash
# Use TaskMaster to generate tests
tm add-task --prompt="Generate comprehensive tests for auth module"
tm expand --id=<task-id> --research

# The AI will create subtasks for:
# - Unit tests for each function
# - Integration tests for auth flow
# - Edge case testing
# - Security testing
```

## Testing Stack Recommendations

### For Node.js Projects
- **Jest** - Fast, zero-config testing
- **Vitest** - Vite-native, blazing fast
- **Supertest** - API endpoint testing

### For React Projects
- **React Testing Library** - User-centric testing
- **Jest** + **jsdom** - Component testing
- **Cypress** - E2E testing

### For Python Projects
- **pytest** - Simple, powerful testing
- **unittest** - Built-in testing framework
- **tox** - Multi-environment testing

## CI/CD Integration

### GitHub Actions Example

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm test
      - run: npm run test:coverage
      
      # Upload coverage reports
      - uses: codecov/codecov-action@v3
```

### Docker Testing

```dockerfile
# Dockerfile.test
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
CMD ["npm", "test"]
```

```bash
# Run tests in Docker
docker build -f Dockerfile.test -t project-tests .
docker run --rm project-tests
```

## Best Practices

### 1. TaskMaster Integration

```bash
# Track test coverage in tasks
tm update-subtask --id=5.2 --prompt="Implemented auth module. Test coverage: 85%"

# Create testing tasks
tm add-task --prompt="Increase test coverage to 90%" --priority=medium
```

### 2. Test Organization

- Group tests by feature/module
- Use descriptive test names
- Keep tests focused and isolated
- Mock external dependencies

### 3. Continuous Testing

```json
// package.json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:ci": "jest --ci --coverage --maxWorkers=2"
  }
}
```

### 4. AI-Enhanced Testing

Use MCP tools for test generation:

```bash
# In Cursor chat
"Generate unit tests for the authentication module"
"Create integration tests for the API endpoints"
"What edge cases should I test for user registration?"
```

## Common Testing Utilities

### Mock Data Generator

```javascript
// tests/utils/mockData.js
export const mockUser = (overrides = {}) => ({
  id: faker.datatype.uuid(),
  email: faker.internet.email(),
  name: faker.name.fullName(),
  createdAt: new Date(),
  ...overrides
});

export const mockProject = (overrides = {}) => ({
  id: faker.datatype.uuid(),
  name: faker.company.name(),
  slug: faker.helpers.slugify(name),
  ...overrides
});
```

### Test Helpers

```javascript
// tests/utils/testHelpers.js
export const waitForAsync = (ms = 100) => 
  new Promise(resolve => setTimeout(resolve, ms));

export const setupTestDb = async () => {
  await db.migrate.latest();
  await db.seed.run();
};

export const cleanupTestDb = async () => {
  await db('users').truncate();
  await db('projects').truncate();
};
```

## Debugging Tests

### VSCode Launch Configuration

```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug Jest Tests",
  "program": "${workspaceFolder}/node_modules/.bin/jest",
  "args": ["--runInBand"],
  "console": "integratedTerminal",
  "internalConsoleOptions": "neverOpen"
}
```

### Common Issues

1. **Async Timeout**: Increase Jest timeout for integration tests
   ```javascript
   jest.setTimeout(30000); // 30 seconds
   ```

2. **Module Resolution**: Configure Jest module paths
   ```javascript
   // jest.config.js
   moduleNameMapper: {
     '@tests/(.*)': '<rootDir>/tests/$1',
     '@/(.*)': '<rootDir>/src/$1'
   }
   ```

3. **Environment Variables**: Use test-specific env
   ```javascript
   // tests/setup.js
   process.env.NODE_ENV = 'test';
   process.env.DATABASE_URL = 'sqlite::memory:';
   ```

## Resources

- [Jest Documentation](https://jestjs.io/)
- [Testing Library](https://testing-library.com/)
- [Cypress Guides](https://docs.cypress.io/)
- [pytest Documentation](https://docs.pytest.org/)

---

*Remember: Good tests enable confident refactoring and faster development. Use AI to generate comprehensive test suites, but always review and understand what's being tested.* 