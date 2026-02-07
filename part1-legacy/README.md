# Part 1: Legacy PC Setup Notes

## VM Details
* **Resource Group**: CURRENT_PC
* **VM Size**: Standard_D3
* **Location**: East US
* **Public IP**: 20.85.137.197

## Configuration Steps
1. **VM Provisioning**: Manually deployed a Windows/Linux VM (as per requirements) in the `CURRENT_PC` resource group.
2. **Web Server Setup**: Installed and configured the Nginx/Apache web server.
3. **Application Deployment**: Uploaded the initial Protochicken source files to the web root.
4. **Networking**: Configured Network Security Group (NSG) to allow inbound traffic on Port 80 (HTTP) and Port 22/3389 for management.

## Access Link
The legacy site can be accessed publicly via: `http://20.85.137.197`