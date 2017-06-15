Login-AzureRmAccount 

$ResourceGrpName="rgNAV"
$Location = "North Europe"

##Create the vnet and subnet
New-AzureRmResourceGroup -Name $ResourceGrpName -Location $Location
New-AzureRmResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName $ResourceGrpName ` -TemplateUri "https://raw.githubusercontent.com/manoj1976/NAVAzure/master/vnet-01.json"

##Create the network security group (NSG)
#Create NSG 
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGrpName -TemplateUri "https://raw.githubusercontent.com/manoj1976/NAVAzure/master/azuredeploy.json" -templateParameterUriFromTemplate "https://raw.githubusercontent.com/manoj1976/NAVAzure/master/vnet-01-nsg.json"

##Create availabilityset
New-AzureRmAvailabilitySet -ResourceGroupName $ResourceGrpName -Name "avset01" -Location $Location  -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 5 -managed


_____
##https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-create-nsg-arm-ps
$rule1 = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
-Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
-SourceAddressPrefix Internet -SourcePortRange * `
-DestinationAddressPrefix * -DestinationPortRange 3389

$rule2 = New-AzureRmNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
-Access Allow -Protocol Tcp -Direction Inbound -Priority 110`
-SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * `
-DestinationPortRange 80

$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName ExampleResourceGroup -Location "North Europe" `
-Name "NSG-FrontEnd" -SecurityRules $rule1,$rule2

$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName ExampleResourceGroup -Name vnet01
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name Gatewaysubnet `
-AddressPrefix 10.0.255.224/27 -NetworkSecurityGroup $nsg



$nic = Get-AzureRmNetworkInterface -ResourceGroupName ExampleResourceGroup -Name TestNICWeb1
