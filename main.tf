#AzureRM Provider in Terraform
provider   "azurerm"   {    
   features   {} 
 } 
## Resource Group
resource   "azurerm_resource_group"   "rg"   { 
   name   =   "my-first-terraform-rg" 
   location   =   "uksouth" 
 }
## Virtual Network and Subnet
resource   "azurerm_virtual_network"   "myvnet"   { 
   name   =   "my-vnet" 
   address_space   =   [ "192.168.0.0/24" ] 
   location   =   "uksouth" 
   resource_group_name   =   azurerm_resource_group.rg.name 
 } 

 resource   "azurerm_subnet"   "frontendsubnet"   { 
   name   =   "frontendSubnet" 
   resource_group_name   =    azurerm_resource_group.rg.name 
   virtual_network_name   =   azurerm_virtual_network.myvnet.name 
   address_prefixes   =    [ "192.168.0.0/28" ] 
 } 
## Public IP Address
resource   "azurerm_public_ip"   "myvm1publicip"   { 
   name   =   "pip1" 
   location   =   "uksouth" 
   resource_group_name   =   azurerm_resource_group.rg.name 
   allocation_method   =   "Dynamic" 
 }
## Network Interface
resource   "azurerm_network_interface"   "myvm1nic"   { 
   name   =   "myvm1-nic" 
   location   =   "uksouth" 
   resource_group_name   =   azurerm_resource_group.rg.name 

   ip_configuration   { 
     name   =   "ipconfig1" 
     subnet_id   =   azurerm_subnet.frontendsubnet.id 
     private_ip_address_allocation   =   "Dynamic" 
     public_ip_address_id   =   azurerm_public_ip.myvm1publicip.id
      
   } 
 }
##Virtual Machine SKU, Image and Disk
resource   "azurerm_windows_virtual_machine"   "example"   { 
   name                    =   "myvm1"   
   location                =   "uksouth" 
   resource_group_name     =   azurerm_resource_group.rg.name 
   network_interface_ids   =   [ azurerm_network_interface.myvm1nic.id ]
   #network_interface_ids   =   [ azurerm_public_ip.myvm1publicip.id ]
   size                    =   "Standard_D2s_v3" 
   admin_username          =   "currys" 
   admin_password          =   "Currys!2341234" 

   source_image_reference   { 
     publisher   =   "MicrosoftWindowsDesktop" 
     offer       =   "Windows-10" 
     sku         =   "win10-21h2-pro-g2" 
     version     =   "latest"      
   } 

   os_disk   { 
     caching             =   "ReadWrite" 
     storage_account_type   =   "Standard_LRS" 
   } 
 }