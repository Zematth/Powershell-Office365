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

		Premier argument : Obligatoire. L'OU à scanner
		Deuxième argument : Obligatoire. Le type d'object à scanner et à modifier. Ne peut être que "Users" ou "Groups"
		Troisième argument : Obligatoire. L'attribut cible pour l'ImmutableID

	.REMERCIEMENTS
		Ce script utilise lui même le script "GUID2ImmutableID" de Steve HALLIGAN https://gallery.technet.microsoft.com/office/Covert-DirSyncMS-Online-5f3563b1

	.NOTES
		Auteur : Matthieu ZILLIOX
		Créé le : 25 mars 2016
		Twitter : @matthieuzilliox

#>

Write-Host
Write-Host "Initialisation... ... ..."
Write-Host

function ConvertTheValue ($valueToConvert) {
	
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

function SetImmutableIdForUsers($users)
{
	foreach ($user in $user) {

		Write-Host
		Write-Host " Start with Group : $($Group.Name)"


	}
}


function SetImmutableIdForGroups()
{
	foreach ($group in $groups) {

		Write-Host
		Write-Host "Group name : $($Group.Name)"

		$immutableId = ConvertTheValue($group.objectGuid)

		set-adgroup -identity '$group.Name' set extentionAttribute1 = 
	}
}


Param (
    [Parameter(Position=0, Mandatory=$true)]
    [string]$ou,

	[Parameter(Position=1, Mandatory=$true)]
	[ValidateSet('Users', 'Groups')]
	[string]$objectType,

	[Parameter(Position=2, Mandatory=$true)]	
	[string]$adAttribute
)

# LIST OF used variables
# $Groups
# Group
#

Write-Host
Write-Host
Write-Host "Start of the procedure... " -ForegroundColor DarkGray

#Setting up variables
Write-Host
Write-Host
Write-Host "Setting up initial variables... " -NoNewline

if ($objectType == "Groups")
{
	$groups = Get-ADGroup -Filter {name -like "ML SkillCenter BigData"} | select Name, objectGUID

	SetImmutableIdForGroups($groups)
}

