# --- Defina suas variáveis aqui ---
$GiteaUrl = "http://localhost:3000"
$Token = "c8e2ce3397618177bc54d6f613013c58f1de1f9d"
$OrgName = "Workshop09_Limeira"
$EmailDominio = "competidor.com" # Os e-mails serão primeiroNome@competidor.com
$Headers = @{
    "Authorization" = "token $Token"
    "Content-Type"  = "application/json"
}

# Arquivo onde as senhas serão salvas
$LogSenhasPath = ".\senhas_competidores.txt"
"--- LISTA DE ACESSO DOS COMPETIDORES ---" | Out-File -FilePath $LogSenhasPath -Encoding utf8

# Função simples para gerar uma senha aleatória para cada um
function Gerar-Senha {
    $caracteres = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789!@#"
    return (-join (1..8 | ForEach-Object { $caracteres[(Get-Random -Maximum $caracteres.Length)] }))
}

# --- Lista de competidores (nome completo) ---
$Competidores = @(
    "Miguel Mourão Picinin",
    "Jhonatan Augusto Barreto da Costa",
    "Fernanda Yuina Hirano da Silva",
    "Vinicius de Miranda Nascimento",
    "Nathalya Silva Monteiro",
    "Gabriel de Almeida dos Santos Silva",
    "Daniel Andrade Santos",
    "Bruno Ataide Lima Dourado",
    "Thiago Mazzi",
    "Nikollas Dheyvis de Paula Silva"
)

# Loop para criar um usuário para cada competidor, usando o primeiro nome
foreach ($NomeCompleto in $Competidores) {

    # Extrai o primeiro nome (primeira palavra do nome completo)
    $PrimeiroNome = ($NomeCompleto -split " ")[0]

    $Username = $PrimeiroNome
    $Password = Gerar-Senha
    $Email = "$($PrimeiroNome.ToLower())@${EmailDominio}"

    Write-Host "--------------------------------------------------"
    Write-Host "Criando usuário: $Username (nome completo: $NomeCompleto)..." -ForegroundColor Cyan

    # JSON com os dados exigidos pelo Gitea para novos usuários
    $UserBody = @{
        username   = $Username
        email      = $Email
        password   = $Password
        must_change_password = $false # Mude para $true se quiser que eles alterem a senha no primeiro login
        send_notify = $false
    } | ConvertTo-Json

    # Força a codificação UTF-8 para evitar problemas no envio do JSON
    $BodyBytes = [System.Text.Encoding]::UTF8.GetBytes($UserBody)

    try {
        # Endpoint de administração do Gitea para criar usuários: /admin/users
        $Response = Invoke-RestMethod -Uri "$GiteaUrl/api/v1/admin/users" -Method Post -Headers $Headers -Body $BodyBytes

        Write-Host "=> Sucesso! Usuário $Username criado." -ForegroundColor Green

        # Salva o usuário e a senha no arquivo de texto
        "Usuário: $Username | Senha: $Password | Email: $Email | Nome completo: $NomeCompleto" | Out-File -FilePath $LogSenhasPath -Append -Encoding utf8

    } catch {
        if ($_.Exception.Response) {
            $StatusCode = [int]$_.Exception.Response.StatusCode
            # Se der erro 422, geralmente é porque o usuário já existe no Gitea
            if ($StatusCode -eq 422) {
                Write-Host "=> Erro: O usuário $Username já existe no sistema." -ForegroundColor Yellow
            } else {
                Write-Host "=> Erro do Gitea (Código HTTP $StatusCode)" -ForegroundColor Red
            }
        } else {
            Write-Host "=> Erro de conexão ao criar $Username : $_" -ForegroundColor Red
        }
    }
}

Write-Host "`n==================================================" -ForegroundColor Green
Write-Host "PROCESSO CONCLUÍDO!" -ForegroundColor Green
Write-Host "As senhas foram salvas no arquivo: $LogSenhasPath" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green