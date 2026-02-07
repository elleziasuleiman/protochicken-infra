# Protochicken Infrastructure Migration: Legacy to Modern

This repository contains the complete migration of the Protochicken web application from a standalone Legacy VM to a modern, secure, and containerized Azure environment.

## Repository Structure
* **/part1-legacy**: Contains setup documentation for the standalone VM.
* **/part2-modern**: Contains the Dockerfile and Terraform IaC scripts.
* **/screenshots**: Contains the "Success Criteria" evidence for the migration.

## Project Overview
* **Legacy Environment**: A single Azure VM (Standard_D3) running a manual web server.
* **Modern Environment**: 
    * **Containerization**: Application packaged via Docker.
    * **IaC**: Automated deployment via Terraform.
    * **Security**: Private Container App Environment isolated within a VNet.
    * **Access**: Secure Jumpbox for administrative tasks and private connectivity.

## Success Criteria (Part 2)
The modern application was successfully verified by SSHing into the Jumpbox and performing a local `curl` to the internal Container App URL. 
* **Response Received**: HTTP/2 200 OK
* **Payload**: `<h1>Welcome to Protochicken Modern</h1>`