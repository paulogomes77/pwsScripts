#
# criaUzEmMassa.ps1
#
# Descrição:
# 
# Criar utilizadores (uz) em massa na AD tendo como fonte de dados um ficheiro txt no seguinte formato:
#
# username, Display Name, title, Departament, Company
# username, Display Name, title, Departament, Company
# username, Display Name, title, Departament, Company
#


# Importa o módulo Active Directory se ainda não estiver carregado
Import-Module ActiveDirectory

#Vars globais - preencher confoante necessário
$ou = "OU=Utilizadores,DC=Dominio,DC=pt"
$dominio = "meu.dominio.pt"
# Caminho do arquivo de texto com informações das contas de uz
$filePath = ".\contas_de_utilizador_13-11-2023.txt"

Write-Host "`r`n"

# Verifica se o arquivo existe
if (Test-Path $filePath) {
    # Lê as linhas do arquivo
    $userList = Get-Content $filePath

    # Loop para criar contas de uz com base nas informações do arquivo
    foreach ($user in $userList) {
        # Divide a linha do arquivo em partes (pode ajustar conforme necessário)
        
        $userInfo = $user -split ","

        $username = $userInfo[0].Trim()
    
        $displayName = $userInfo[1].Trim()

        $title = $userInfo[2].Trim()

        $departamento = $userInfo[3].Trim()

        $company = $userInfo[4].Trim()

        $path = "OU="+$company+","+$ou
        #echo "debug-" $username $displayName $title $departamento $company $path

        #Gera uma senha eleatória
        $password = -Join("ABCDabcd&@#$%1234".tochararray() | Get-Random -Count 13 | % {[char]$_})

        # Cria um objeto de senha seguro
        $securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

        # Parâmetros para a criação de uz
        $userParams = @{
            SamAccountName = $username
            UserPrincipalName = "$username@$dominio"
            Name = $username
            #GivenName = $username
            #Surname = $username
            DisplayName = $displayName
            description = $displayName
            title = $title
            Company = $company
            Department = $departamento
            AccountPassword = $securePassword
            Enabled = $true
            Path = $path
        }
        
        echo "$username$dominio   $password"

        #echo $userParams
        
        
        # Cria o usuário
        #New-ADUser @userParams
    }

    Write-Host "`r`nAs contas de uz foram criadas com sucesso!"
} else {
    Write-Host "O arquivo $filePath não foi encontrado."
}
