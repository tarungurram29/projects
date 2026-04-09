## 🏗️ Project Architecture (Actual Flow)

```text
Developer → GitHub (Code)
        ↓
   Jenkins Pipeline (CI)
        ↓
Build Docker Image → Push to DockerHub
        ↓
Update Kubernetes Manifests (Git Repo)
        ↓
        ArgoCD (GitOps CD)
        ↓
Sync with Kubernetes Cluster
        ↓
Deploy Blue & Green Pods
        ↓
Kubernetes Service routes traffic
        ↓
User Access Application

⚙️ Tech Stack
☸️ Kubernetes (Deployments & Services)
⚙️ Jenkins (CI Pipeline)
🐳 Docker (Containerization)
🔄 ArgoCD (GitOps CD)

🐧 Linux
📂 Project Structure
blue-green-deployment/
│── Jenkinsfile
│── blue-deployment.yaml
│── green-deployment.yaml
│── service.yaml
│── images/
│── README.md

🔁 Complete Deployment Flow (CI + CD + GitOps)
Developer pushes code to GitHub
Jenkins pipeline is triggered
Jenkins builds Docker image
Image is pushed to DockerHub
Jenkins updates Kubernetes YAML files (image tag)
Updated manifests are pushed to Git repository
ArgoCD continuously monitors the Git repo
ArgoCD detects changes and syncs automatically
Kubernetes cluster gets updated deployment

🔵🟢 Blue-Green Deployment Flow
Blue deployment is live (current version)
Green deployment is created with new version
Green environment is tested
Kubernetes Service selector is updated
Traffic shifts from Blue → Green
Blue is kept as backup for rollback

📜 Kubernetes Files Explained
🔵 blue-deployment.yaml
Runs current production version
🟢 green-deployment.yaml
Runs new version for testing
🌐 service.yaml
Uses labels to route traffic
Switches between Blue & Green

⚙️ Jenkins vs ArgoCD Responsibilities
Jenkins (CI)
Build Docker image
Push to DockerHub
Update Kubernetes manifests
ArgoCD (CD)
Watches Git repository
Syncs changes to cluster
Maintains desired state

🎯 Key Benefits
✅ Zero downtime deployment
✅ GitOps-based CD (ArgoCD)
✅ Automated pipeline (CI + CD)
✅ Easy rollback
✅ Production-ready setup
🔥 Use Case

Used in real-world production systems where:

Downtime is not acceptable
Continuous delivery is required
Safe deployments are critical
📸 Screenshots

(Add Jenkins pipeline, ArgoCD dashboard, kubectl outputs)

👨‍💻 Author
Tarun Gurram
🔗 https://www.linkedin.com/in/tgurram8
