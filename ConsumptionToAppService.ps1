Param(
    [string] $AppService_RG = 'Premium',
	[string] $AppService_Name = 'Premium',
    [string] $LogicApp_RG = 'RSSCustomerSupport',
    [string] $LogicApp_Name = 'RSS-Reddit-Message',
    [string] $subscriptionId = '80d4fe69-c95b-4dd2-a938-9250f1c8ab03'
)

Login-AzureRmAccount 
$subscription = Get-AzureRmSubscription -SubscriptionId $subscriptionId
$appserviceplan = Get-AzureRmResource -ResourceType "Microsoft.Web/serverFarms" -ResourceGroupName $AppService_RG -ResourceName $AppService_Name
$logicapp = Get-AzureRmResource -ResourceType "Microsoft.Logic/workflows" -ResourceGroupName $LogicApp_RG -ResourceName $LogicApp_Name

$sku = @{
    "name" = $appservicePlan.Name;
    "plan" = @{
      "id" = $appserviceplan.ResourceId;
      "type" = "Microsoft.Web/ServerFarms";
      "name" = $appserviceplan.Name  
    }
}

$updatedProperties = $logicapp.Properties | Add-Member @{sku = $sku;} -PassThru

$updatedLA = Set-AzureRmResource -ResourceId $logicapp.ResourceId -Properties $updatedProperties -ApiVersion 2015-08-01-preview

Write-Output "Logic App now associated with App Service Plan: $appserviceplan.Name"
