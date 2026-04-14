⚙️ Jenkins + Ansible CI/CD Automation

This project demonstrates a fully automated deployment pipeline using Jenkins and Ansible to update and manage a web application on remote servers.

📌 Project Overview
Jenkins is used as the CI/CD orchestrator
Ansible is used for configuration management and deployment
The pipeline automatically:
Fetches updated code
Deploys it to a remote server
Restarts the web service

🔄 Workflow

Developer pushes code to GitHub
Jenkins pipeline is triggered
Jenkins executes Ansible playbook (web_update.yml)
Ansible:
Copies updated website files to the target server
Restarts the Apache server
Updated application is live 🚀

📜 Ansible Playbook Breakdown (web_update.yml)

🔹 Deployment Task
Uses synchronize module to copy files from Jenkins workspace
Source: Jenkins workspace directory
Destination: /var/www/html/ (Apache web root)
Recursive copy ensures full project deployment

🔹 Service Management
Restarts Apache (apache2) service
Ensures the service is always enabled and running
🧠 Key Concepts Used
CI/CD Pipeline Automation (Jenkins)
Configuration Management (Ansible)
Infrastructure as Code (IaC)
Remote Deployment via SSH
Service Management in Linux
🛠️ Tech Stack
Jenkins
Ansible
Apache (apache2)
Linux (Ubuntu)
