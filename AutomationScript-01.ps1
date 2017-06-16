﻿Login-AzureRmAccount 

$ResourceGrpName="rgExample"
$Location = "North Europe"

##Create the vnet and subnet
New-AzureRmResourceGroup -Name $ResourceGrpName -Location $Location
New-AzureRmResourceGroupDeployment -Name vnetDeployment -ResourceGroupName $ResourceGrpName ` -TemplateUri "https://raw.githubusercontent.com/manoj1976/NAVAzure/master/vnet-01.json"

##Create the network security group (NSG)
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGrpName -TemplateUri "https://raw.githubusercontent.com/manoj1976/NAVAzure/master/azuredeploy.json" -templateParameterUriFromTemplate "https://raw.githubusercontent.com/manoj1976/NAVAzure/master/vnet-01-nsg.json"

---to be done create Network Interface card(NIC)
-- to be created public IP -- not sure

##Create availabilityset
New-AzureRmAvailabilitySet -ResourceGroupName $ResourceGrpName -Name "avset01" -Location $Location  -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 5 -managed


#Begin*****Create VM******



