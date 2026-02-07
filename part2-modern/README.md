# Part 2: Modern Infrastructure (Containerized)

This directory contains the Infrastructure as Code (IaC) and containerization assets used to deploy the modern Protochicken application into a secure, private Azure environment.

## Components
* **Dockerfile**: Packages the Nginx web server and custom "Welcome to Protochicken Modern" content into a portable image.
* **main.tf**: Terraform script that provisions the entire Azure stack, including Networking, Security, and Compute.

## Architecture Design
The architecture follows a "Jumpbox-to-Private-Service" pattern to ensure maximum security:
1. **Virtual Network (VNet)**: Provides a private address space for all resources.
2. **Container App Environment**: Hosted in a dedicated subnet with **Internal Ingress**, meaning the application is NOT reachable via the public internet.
3. **Jumpbox VM**: A Linux-based management server (Standard_D2s_v3) sitting in a separate subnet. This is the only entry point into the network via SSH.
4. **Network Security Group (NSG)**: Restricted to allow SSH traffic only from the administrator's whitelisted IP.

## Verification Process (Success Criteria)
To verify the deployment in a private environment, the following steps were taken:
1. SSH into the **Jumpbox** using the Public IP and private key.
2. Manually map the Container App's internal load balancer IP (`10.0.0.85`) to the App FQDN in `/etc/hosts`.
3. Execute `curl -i` against the private URL.

**Result**: The application responded with a `200 OK` status and rendered the "Welcome to Protochicken Modern" header.