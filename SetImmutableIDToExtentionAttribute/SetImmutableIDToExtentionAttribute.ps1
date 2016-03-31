<#

	.SYNOPSYS
		Ce script a pour but de générer un ImmutableID pour des objets de l'AD 
		afin de contrôler la synchronisation avec AZURE

	.DESCIPTION
		Il est possible de générer un ImmutableID pour des utilisateurs ou pour des groupes.
		Une fois la cible choisi, le script va utiliser l'attribut OBJECTGUID pour le transformer en Base64
		et l'ingecter dans l'attribut ExtentionAttribute1.
		ATTENTION : Il est nécessaire d'indiquer à Azure Connect AD quel attribut il doit prendre en compte pour la synchronisation de l'annuaire.

	.EXEMPLE
		.\SetImmutableIDToExtentionAttribute "OU=monOU,DC=domain,DC=TLD" "Group" "ExtentionAttribute1"

		Premier argument : L'OU à scanner
		Deuxième argument : Le type d'object à scanner et à modifier
		Troisième argument : L'attribut cible pour l'ImmutableID

	.REMERCIEMENTS
		Ce script utilise lui même le script "GUID2ImmutableID" de Steve HALLIGAN https://gallery.technet.microsoft.com/office/Covert-DirSyncMS-Online-5f3563b1

	.NOTES
		Auteur : Matthieu ZILLIOX
		Créé le : 25 mars 2016
		Twitter : @matthieuzilliox

#>

Param (
    [Parameter(Mandatory=$true)]
    [string]$OU,
	[string]$ObjectType,
	[string]$adAttribute
)

# LIST OF used variables
# $Groups
# Group
#


#Setting up variables
Write-Host
Write-Host
Write-Host "Setting up initial variables... " -NoNewline

$Groups = GetADGroup -searchbase -Filter "*"

Write-Host
Write-Host
Write-Host "Start the procedure... " -ForegroundColor DarkGray



foreach ($Group in $Groups) {

    Write-Host
    Write-Host " Start with Group : $($Group.Name)"


}


function convertTheValue ($valuetoconvert) {
	
	try
	{
		$guid = [GUID]$valuetoconvert
	    $bytearray = $guid.tobytearray()
		$immutableID = [system.convert]::ToBase64String($bytearray)
    
		return  $immutableID
	}
	catch
	{
		return 0
	}
}