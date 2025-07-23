# [Project Name]

> [Brief description of what this project does]

## Overview

[Detailed project description and goals]

## Lab Heritage 🧪

This project was incubated in [The Lab](../../../docs-hub/THE_LAB_README.md), an AI-powered development workspace.

- **Started**: [YYYY-MM-DD]
- **Lab Path**: `projects/[YYYY-MM-project-slug]/`
- **TaskMaster Tag**: `[project-slug]`

## Quick Start

```bash
# Development with Docker
docker build -t [project-slug] .
docker run -p 8000:8000 [project-slug]

# Local development
npm install
npm run dev
```

## Features

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3

## Tech Stack

- **Frontend**: [Technology]
- **Backend**: [Technology]
- **Database**: [Technology]
- **Deployment**: Azure Container Apps
- **Containerization**: Docker

## Project Structure

```
[project-slug]/
├── src/              # Source code
├── tests/            # Unit & integration tests
├── docs/             # Project documentation
├── Dockerfile        # Container configuration
├── package.json      # Dependencies
└── README.md         # This file
```

## Development Workflow

### 1. TaskMaster Integration
```bash
# View current tasks
task-master next

# Update progress
task-master update-subtask --id [id] --prompt "[progress notes]"

# Mark complete
task-master set-status --id [id] --status done
```

### 2. Docker Development
```bash
# Build and test
docker build -t [project-slug] .
docker run -p 8000:8000 [project-slug]

# Development with live reload
docker run -p 8000:8000 -v $(pwd)/src:/app/src [project-slug]
```

### 3. Azure Deployment
```bash
# Tag for Azure Container Registry
docker tag [project-slug] [registry].azurecr.io/[project-slug]:latest

# Deploy to Azure
az containerapp create \
  --name [project-slug] \
  --resource-group [rg-name] \
  --environment [env-name] \
  --image [registry].azurecr.io/[project-slug]:latest
```

## Testing

```bash
# Run all tests
npm test

# Run specific test suite
npm test -- --grep "feature"

# Coverage report
npm run test:coverage
```

## Documentation

- [API Documentation](docs/api.md)
- [Development Guide](docs/development.md)
- [Deployment Guide](docs/deployment.md)

## Contributing

This project follows [The Lab workflow](../../../docs-hub/THE_LAB_README.md#-the-lab-workflow):

1. Update TaskMaster with progress
2. Use Docker for isolation
3. Follow naming conventions
4. Document decisions

## Graduation Plan

When ready for production:

```bash
# Use Lab graduation script
../../core-tools/scripts/lab-graduate.ps1 -ProjectSlug "[project-slug]" -NewRepoName "[new-repo-name]"
```

## License

[License Type] - See LICENSE file for details

---

*Developed in The Lab - Where ideas become reality* 🧪✨ 