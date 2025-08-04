# Azure SRE Lab – Infrastructure Overview

This lab demonstrates an end-to-end automated deployment of a monitoring-ready Linux VM in Azure using GitHub Actions, Terraform, and Ansible. It integrates Prometheus, Node Exporter, Fluent Bit, and Grafana for observability.

---

##  Deployment Pipeline

### 1. **GitHub Actions Workflows**

* **`Terraform + Ansible Deploy`**

  * Provisions Azure infrastructure via Terraform
  * Runs Ansible to install monitoring stack and NGINX
* **`Terraform Destroy`**

  * Tears down the entire environment

### 2. **Terraform Infrastructure**

* **Remote backend** stored in Azure Blob Storage
* **Resources created:**

  * Resource Group
  * Virtual Network + Subnet
  * NSG with open ports: 22, 80, 9100, 9090, 3000
  * Public IP
  * Linux Virtual Machine (Ubuntu 20.04)

### 3. **Ansible Configuration**

* **Installs:**

  * Docker (with NGINX container)
  * Node Exporter (system metrics)
  * Fluent Bit (systemd logs)
  * Prometheus (scraper)
  * Grafana (UI)
* **Starts and enables all services** via systemd

---

##  Azure VM Architecture

                            ┌────────────────────────┐
                            │    GitHub Actions CI   │
                            │  (Terraform + Ansible) │
                            └────────────┬───────────┘
                                         │
                                         ▼
                      ┌──────────────────────────────┐
                      │  Terraform Infrastructure     │
                      │ (Remote backend in Azure Blob)│
                      └────────────┬──────────────────┘
                                   │
        ┌──────────────────────────┴────────────────────────────┐
        │                      Azure Resources                   │
        │                                                       │
        │  ┌──────────────────────────────┐                      │
        │  │ azurerm_resource_group       │                      │
        │  ├──────────────────────────────┤                      │
        │  │ azurerm_virtual_network      │                      │
        │  │ └─ azurerm_subnet            │                      │
        │  │ └─ azurerm_nsg (rules: SSH, HTTP, 9100, 9090, 3000)│
        │  └────────────┬─────────────────┘                      │
        │               ▼                                        │
        │     ┌────────────────────────────────┐                 │
        │     │ azurerm_linux_virtual_machine │                 │
        │     │      ubuntu 20.04 LTS         │                 │
        │     └────────────┬──────────────────┘                 │
        │                  ▼                                     │
        └────────────────────────────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────────┐
              │      Ansible Playbook      │
              └────────────┬───────────────┘
                           ▼
      ┌────────────────────────────────────────────────────┐
      │             Inside the Azure VM                    │
      │                                                    │
      │  ┌──────────────┬─────────────┬──────────────────┐ │
      │  │  Docker      │  Prometheus │    Grafana       │ │
      │  │ (NGINX)      │  Port 9090  │    Port 3000     │ │
      │  │  Port 80     │ Scrapes     │    Visualizes    │ │
      │  └──────────────┘ node_exporter└────────┬─────────┘ │
      │                                         ▼           │
      │         ┌──────────────────────────────┐            │
      │         │     Node Exporter            │            │
      │         │   Port 9100 (System metrics) │            │
      │         └──────────────────────────────┘            │
      │                                                    │
      └────────────────────────────────────────────────────┘


---

##  Monitoring Stack

* **Prometheus:** Pulls metrics from `localhost:9100`
* **Grafana:** Uses Prometheus as a datasource
* **Node Exporter:** Provides CPU, memory, disk, and service metrics
* **Fluent Bit:** Logs collection via systemd (currently stdout)

---

##  Usage

### To deploy:

* Trigger the `Terraform + Ansible Deploy` workflow manually in GitHub Actions

### To destroy:

* Trigger the `Terraform Destroy` workflow

---

##  Notes

* Terraform state is securely stored in Azure Storage Account
* Secrets are injected via GitHub Actions environment variables
* VM uses SSH public key authentication for provisioning

