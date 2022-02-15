#Install-Module Az -AllowClobber
#Install-Module Az.Accounts -AllowClobber
#Install-Module Az.Storage -AllowClobber

#Connect-AzAccount -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47

 
# Define Variables
$subscriptionId = "a8108c2b-496c-424d-8347-ecc8afb6384c"
$storageAccount1Name = "netastorageaccount1"
$storageAccount2Name = "netastorageaccount2"
$resourceGroupName = "NetaTask"

Select-AzSubscription -SubscriptionId $SubscriptionId

# Get Storage Account 1
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccount1Name).Value[0]

# Set AzStorageContext
$ctx1 = New-AzStorageContext -StorageAccountName $storageAccount1Name -StorageAccountKey $storageAccountKey

$containerName1 = "sourcecontainer"

# Get Storage Account 2
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccount2Name).Value[0]

# Set AzStorageContext
$ctx2 = New-AzStorageContext -StorageAccountName $storageAccount2Name -StorageAccountKey $storageAccountKey
$containerName2 = "destcontainer"
#create 100 files to directory:
New-Item -Path blobsFolder -ItemType Directory
for ($num = 1 ; $num -le 100 ; $num++){
	New-Item -Path "100blobs\$num.jpg" -ItemType File
}

#upload 100 files to the storage account
for ($num = 1 ; $num -le 100 ; $num++){
	Set-AzStorageBlobContent -File "100blobs\$num.jpg" `
	  -Container $containerName1 `
	  -Blob "$num.jpg" `
	  -Context $ctx1 
 } 

# copy 100 file
New-Item -Path blobsFolder -ItemType Directory
for ($num = 1 ; $num -le 100 ; $num++){
	Get-AzStorageBlobContent `
		-Container $containerName1 `
		-Blob "$num.jpg" `
		-Context $ctx1 `
		-Destination "100blobs\"
		
	Set-AzStorageBlobContent -File "100blobs\$num.jpg" `
		  -Container $containerName2 `
		  -Blob "$num.jpg" `
		  -Context $ctx2
}