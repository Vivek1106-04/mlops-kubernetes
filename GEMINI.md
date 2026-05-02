# Project Overview
This project is an experimental, self-contained MLOps platform deployed on a local Kubernetes cluster (Minikube). It demonstrates the complexity of setting up a complete machine learning lifecycle, from data ingestion to model serving.

## Core Technologies
- **Orchestration**: Metaflow
- **Infrastructure**: Terraform, Kubernetes (Minikube), Helm
- **Feature Store**: Feast (using Postgres as an offline store)
- **Model Registry & Tracking**: MLflow
- **Model Serving**: Seldon Core
- **Storage**: Minio (S3-compatible storage for models)
- **Database**: PostgreSQL

# Building and Running

## Prerequisites
- Docker, Minikube, Terraform, Helm, and Poetry installed locally.

## Setup Instructions
1.  **Start Minikube**:
    ```bash
    minikube start
    ```
2.  **Provision Infrastructure**:
    ```bash
    export KUBE_CONFIG_PATH=~/.kube/config
    terraform init
    terraform apply
    ```
3.  **Build Workflow Image**:
    Enable the Minikube Docker environment and build the pipeline image:
    ```bash
    eval $(minikube docker-env)
    docker build -t pipeline .
    ```
4.  **Run Workflows**:
    *   **Data Pipeline (ETL & Feast)**:
        ```bash
        kubectl apply -f metaflow_dataflow_pod.yaml
        ```
    *   **Model Pipeline (Training & MLflow)**:
        ```bash
        kubectl apply -f metaflow_modelflow_pod.yaml
        ```
5.  **Serve Models**:
    Deploy a model to Seldon:
    ```bash
    kubectl apply -f model.yaml
    ```

# Development Conventions

## Code Style & Linting
- **Formatter**: [Black](https://github.com/psf/black)
- **Linter**: [Ruff](https://github.com/astral-sh/ruff)
- Configured via `pyproject.toml`. Run `ruff check .` for linting.

## Dependency Management
- Uses **Poetry**. Main dependencies include `pandas`, `scikit-learn`, `metaflow`, `mlflow`, `feast[postgres]`, and `psycopg2-binary`.
- Python version target: `^3.11`.

## Deployment Notes
- **Hardcoded Values**: Currently, `POSTGRES_HOST` and `POSTGRES_PASSWORD` in `metaflow_*_pod.yaml` and some script defaults are hardcoded. These must be updated manually after the Terraform-provisioned Postgres service is assigned an IP in the cluster.
- **Minio Hack**: Seldon's rclone configuration requires a manual update within the pod to point to the local Minio instance for model artifact retrieval (see `README.md` for details).

## Testing
- Automated tests are primarily triggered via Kubernetes Pod manifests (`metaflow_*_pod.yaml`).
- Sample requests can be tested using `python app/sample_requests.py` after port-forwarding the Seldon mesh service.
