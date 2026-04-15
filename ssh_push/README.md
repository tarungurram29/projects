
🔹 SSH Push Automation (Ansible)

This project demonstrates an automated solution for setting up passwordless SSH access across multiple servers using Ansible and Bash scripting.

📌 Project Overview
Ansible is used for remote configuration and automation
Bash script is used to dynamically generate host-specific configurations
The setup automatically:
Takes server details (IP, username, password) as input
Creates host_vars files for each server
Distributes SSH public keys to target machines
Configures passwordless login

🔄 Workflow
User provides server details via script
Script generates host-specific .yml files inside host_vars
Ansible playbook (ssh_push.yml) is executed
Ansible:
Creates ~/.ssh directory on remote servers
Adds public key to authorized_keys
Passwordless SSH access is established 🚀

🧠 Key Concepts Used
Ansible Inventory & host_vars
SSH Key-Based Authentication
Bash Scripting for Automation
Remote Server Configuration
Infrastructure Automation

🎯 Real-World Use Case

This setup is useful when:

Managing multiple servers
Avoiding repeated password-based logins
Automating secure access in DevOps environments
