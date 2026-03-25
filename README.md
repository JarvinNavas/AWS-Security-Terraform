# AWS Secure Networking with Terraform 🛡️🕸️

## 📋 Scenario
Manual configuration of cloud environments (ClickOps) introduces human error, leading to misconfigured perimeters and security breaches. To ensure consistent, auditable, and secure deployments, infrastructure must be defined as code.

## 🎯 Objectives
* **Infrastructure as Code (IaC):** Leverage Terraform to programmatically deploy a foundational AWS network architecture.
* **Network Isolation:** Establish a Virtual Private Cloud (VPC) with explicit routing and internet gateways.
* **Perimeter Defense:** Implement strict Security Groups (Firewalls) enforcing the principle of least privilege for remote access.

## ⚙️ Architecture Deployed
This repository automates the deployment of the following resources:
1.  **VPC (`10.0.0.0/16`):** The isolated network boundary.
2.  **Public Subnet (`10.0.1.0/24`):** An internet-facing segment designed to host a Bastion Server.
3.  **Internet Gateway & Route Table:** Enabling controlled outbound/inbound traffic to the public subnet.
4.  **Bastion Security Group:** A strict firewall rule allowing SSH (`port 22`) access *only* from a designated, trusted IP address, preventing global exposure (`0.0.0.0/0`).

## 🛠️ Tech Stack
* **Provider:** AWS (Amazon Web Services)
* **IaC Tool:** HashiCorp Terraform
* **Language:** HCL (HashiCorp Configuration Language)

---
*Built as part of an intensive 30-Day DevSecOps Engineering sprint.*
