# Azure VM Terraform Deployment

This repository contains Terraform configurations to deploy a **Linux VM on Azure** with basic DevOps monitoring, alerts, and cost tracking.

---

## 🚀 Features

1. **Azure VM Deployment**
   - Creates a Linux VM (`azurerm_linux_virtual_machine`) with SSH access
   - Configures a public IP (`azurerm_public_ip`) and network interface (`azurerm_network_interface`)
   - Assigns a Network Security Group (`azurerm_network_security_group`) with HTTP/HTTPS access

2. **Key Vault Integration**
   - Creates an Azure Key Vault (`azurerm_key_vault`)
   - Stores secrets like Cloudflare API token (`azurerm_key_vault_secret`)
   - Configures VM access policy (`azurerm_key_vault_access_policy`) for reading secrets

3. **Monitoring & Alerts**
   - Creates a Log Analytics Workspace (`azurerm_log_analytics_workspace`) for metrics
   - Configures Application Insights (`azurerm_application_insights`) for monitoring
   - Sets up Azure Monitor action groups (`azurerm_monitor_action_group`) for alert notifications
   - Configures metric alerts (`azurerm_monitor_metric_alert`) for:
     - VM CPU usage
     - Website uptime
     - Disk space

4. **Budget Tracking**
   - Creates a Resource Group-level budget (`azurerm_consumption_budget_resource_group`)
   - Allows monitoring of costs for the deployed VM and associated resources

5. **Website Deployment**
   - Installs NGINX on the VM
   - Deploys a sample HTML site for testing HTTP/HTTPS access
   - Supports self-signed SSL certificates (optional)

---

## ⚡ Prerequisites

- Terraform >= 1.14
- Azure CLI (`az`) logged in with sufficient permissions
- SSH keys generated locally (`~/.ssh/id_rsa.pub` and `id_rsa`)
- Git for version control (optional for pushing to GitHub)

---

## 📁 Files in This Repo

- `main.tf` – Core Terraform resources (VM, network, NSG, Key Vault)
- `monitoring.tf` – Monitoring, alerts, and Application Insights
- `variables.tf` – Input variables for resource customization
- `outputs.tf` – Terraform outputs (VM public IP, hostname, etc.)
- `providers.tf` – Terraform provider configuration
- `.gitignore` – Ignored files (e.g., `.terraform/`, local state)

---

## ⚙️ Deployment Steps

1. Clone the repo:

```bash
git clone https://github.com/YShah-RNAO/azure-vm-terraform.git
cd azure-vm-terraform
