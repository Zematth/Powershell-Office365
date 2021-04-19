# Importe une liste de membres dans une liste de distribution

$Userslist = Import-CSV C:\Temp\Distribution-Groups-Members.csv
ForEach ($User in $Userslist)
{
	Add-DistributionGroupMember -Identity "NOM DE LA LISTE" -Member $User.userprincipalname
}