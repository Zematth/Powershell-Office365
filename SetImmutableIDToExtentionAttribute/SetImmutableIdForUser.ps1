 <#
	.SYNOPSYS
		Ce script a pour but de générer un ImmutableID pour un object spécifique 
		afin de contrôler la synchronisation avec AZURE
	.DESCIPTION
		Ce script génère un ImmutableId pour un utilisateur spécifique fournis lors de l'exécution du script.
		Le script récupère le l'ObjectGUID de l'utilisateur, le transforme en Base64 et enfin enregistre cet ImmutableId
		dans l'attribut 'ExtentionAttribute1' ou tout autre attribut spécifié.
		ATTENTION : Il est nécessaire d'indiquer à Azure Connect AD quel attribut il doit prendre en compte pour la synchronisation de l'annuaire.
	.EXEMPLE
		.\SetImmutableIDToExtentionAttribute "samAccountName"
		Premier argument : Obligatoire. Le SamAccountName de l'utilisateur cible.
		
	.ATTENTION
		Dans la variable $fullUpn, il est nécessaire de remplacer "@*.com" par votre domaine.
		
	.NOTES
		Auteur : Matthieu ZILLIOX
		Créé le : 27 juin 2016
        	Modifié le : 07 aoÛt 2018
		Twitter : @matthieuzilliox
#>

Param (
    [Parameter(Mandatory=$true)]
    [String]$upn    )

Import-Module ActiveDirectory

Write-Host "Initialisation des variables..."
$Guid = ""
$iid = ""
$immutableID = ""

try
{
	$fullUpn = "$upn@*.com"
	$var = Get-ADUser -Filter {UserPrincipalName -like $fullUpn}

	$bytearray = $var.ObjectGUID.tobytearray()
	$immutableID = [system.convert]::ToBase64String($bytearray)

	Write-Host
	Write-Host "L'ObjectGUID de" $var.UserPrincipalName "est :" $var.ObjectGUID.ToString()
	Write-Host "L'immutable ID de" $var.UserPrincipalName "est :" $immutableID -ForegroundColor Cyan
	Write-Host 
	Write-Host "Enregistrement de l'immutableID... "

	Set-AdUser -Identity $var.SamAccountName -Add @{extensionAttribute1 = $immutableID}

	Write-host "Enregistrement effectué avec succès." -ForegroundColor Green
	Write-Host "Fin du script..." -ForegroundColor Green
}
catch
{
	Write-Host
	Write-Host "--- ATTENTION ---"
	Write-Host "Une erreur s'est produite. La voici :"
	Write-Host $_.Exception.Message -ForegroundColor Red
} 
