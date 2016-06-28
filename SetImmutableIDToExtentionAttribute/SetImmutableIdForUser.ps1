<#

	.SYNOPSYS
		Ce script a pour but de g�n�rer un ImmutableID pour un object sp�cifique 
		afin de contr�ler la synchronisation avec AZURE

	.DESCIPTION
		Ce script g�n�re un ImmutableId pour un utilisateur sp�cifique fournis lors de l'ex�cution du script.
		Le script r�cup�re le l'ObjectGUID de l'utilisateur, le transforme en Base64 et enfin enregistre cet ImmutableId
		dans l'attribut 'ExtentionAttribute1' ou tout autre attribut sp�cifi�.

		ATTENTION : Il est n�cessaire d'indiquer � Azure Connect AD quel attribut il doit prendre en compte pour la synchronisation de l'annuaire.

	.EXEMPLE
		.\SetImmutableIDToExtentionAttribute "samAccountName"

		Premier argument : Obligatoire. Le SamAccountName de l'utilisateur cible.
		
	.NOTES
		Auteur : Matthieu ZILLIOX
		Cr�� le : 27 juin 2016
		Twitter : @matthieuzilliox

#>

Param (
    [Parameter(Mandatory=$true)]
    [String]$sama    )

Import-Module ActiveDirectory

Write-Host "Initialisation des variables..."
$Guid = ""
$iid = ""
$immutableID = ""

function ConvertObjectGuidToBase64 ($data)
{
    $Guid = $data
    $bytearray = $guid.tobytearray()
    $immutableID = [system.convert]::ToBase64String($bytearray)
}

try
{
	$var = Get-ADUser -Identity $sama

	$bytearray = $var.ObjectGUID.tobytearray()
	$immutableID = [system.convert]::ToBase64String($bytearray)

	Write-Host
	Write-Host "L'ObjectGUID de" $sama "est :" $var.ObjectGUID.ToString()
	Write-Host "L'immutable ID de" $sama "est :" $immutableID -ForegroundColor Cyan
	Write-Host 
	Write-Host "Enregistrement de l'immutableID... "

	Set-AdUser -Identity $sama -Add @{extensionAttribute1 = $immutableID}

	Write-host "Enregistrement effectu� avec succ�s." -ForegroundColor Green
	Write-Host "Fin du script..." -ForegroundColor Green
}
catch
{
	Write-Host "Une erreur s'est produite. La voici :"
	Write-Host $_.Exception.Message -ForegroundColor Red
}

