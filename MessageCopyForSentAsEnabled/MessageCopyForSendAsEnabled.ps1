<#

    .SYNOPSYS
        Script modifiant le comportement d'une boite aux lettres partagée

    .DESCRIPTION
        Ce script se connecte à Office 365 et modifie la propriété "MessageCopyForSentAsEnabled".
        Tout email envoyé depuis une boîte aux lettres partagée sera placé dans le dossier "Elements envoyés" de la boîte partagée en question.

    .PARAMETER
		Un tableau comportant les noms des boîtes emails à modifier

	.EXAMPLE
		.\MessageCopyForSendAsEnabled.ps1 -mailBox sharedBox1, sharedBox2, sharedBox3 [...]
 
#>


Param(
[parameter(Mandatory=$true)][string[]]$mailBox)

function Set-MessageCopyForSentAsEnabled($mailBox)
{

    # Connexion à Office 365
    $LiveCred = Get-Credential

    # Connexion à Exchange Online et Import de PSSession
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
    Import-PSSession $Session


    foreach ($i in $mailBox)
    {
        # Modification de la boîte au lettre partagée saisie par l'utilisateur
        Set-mailbox $i -MessageCopyForSentAsEnabled $true

        Write-Host "Mise à jour de '$i' effectué avec succès" -ForegroundColor DarkGreen
        Write-Host
    }

    Write-Host
    Write-Host "L'ensemble des modifications ont été opérées avec succès !" -ForegroundColor Green
    Write-Host

    Remove-PSSession $Session
	
	Write-Host
	Write-Host "Déconnexion d'Office 365." -ForegroundColor Red
	Write-Host
	Write-Host "Fin du script." -ForegroundColor Red
}


Set-MessageCopyForSentAsEnabled($mailBox)
