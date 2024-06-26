# Kubernetes Deployment Restart Automation

Automate Kubernetes deployment restarts with this script, enhancing operational efficiency and reliability across different environments.

## Overview

In Kubernetes management, ensuring deployment reliability and consistency is crucial. This script automates the process of selecting and restarting deployments categorized into Backend, Frontend, and Tools across Development, Staging, and Production environments.

## Features

- **Selective Restart**: Choose deployments by category (Backend, Frontend, Tools) and environment (Development, Staging, Production).
- **Efficient Management**: Streamline operations by automating repetitive tasks.
- **Customizable**: Easily customize deployment lists to fit your Kubernetes environment.

## How to Use

1. **Customization**:

   - Modify the script's arrays (`backend_development_deployments`, `backend_staging_deployments`, etc.) with your specific namespaces and deployment names.

2. **Execution**:
   - Save the script to a file (e.g., `restart_deployments.sh`) and make it executable using `chmod +x restart_deployments.sh`.
   - Run the script with `./restart_deployments.sh` in your terminal.
   - Follow the prompts to select categories, environments, and deployments to restart.

## Examples

```bash
# Example usage
./restart_deployments.sh
```

## Medium Article

For a detailed guide on how to use this script and understand its benefits, check out the accompanying article on Medium:

[Automating Kubernetes Deployment Restarts: A Practical Guide](https://medium.com/@mrdevx/automating-kubernetes-deployment-restarts-a-practical-guide-8fe90fc53c36)

## Contribution

Contributions are welcome! If you have ideas for improvements or feature requests, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
