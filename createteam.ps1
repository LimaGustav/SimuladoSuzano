# --- Defina suas variáveis aqui ---
$GiteaUrl = "http://localhost:3000"
$Token = "c8e2ce3397618177bc54d6f613013c58f1de1f9d"
$OrgName = "Deliveries"
$Headers = @{
    "Authorization" = "token $Token"
    "Content-Type"  = "application/json"
}

# --- Lista de competidores (primeiro nome) ---
# Deve ser a mesma lista/nomes usados na criação dos usuários e dos repositórios (Session{a}_{Competidor})
$Competidores = @(
    "Miguel",
    "Jhonatan",
    "Fernanda",
    "Vinicius",
    "Nathalya",
    "Gabriel",
    "Daniel",
    "Bruno",
    "Thiago",
    "Nikollas"
)

foreach ($Competidor in $Competidores) {

    $TeamName = $Competidor

    Write-Host "--------------------------------------------------" -ForegroundColor Cyan
    Write-Host "Processando: $TeamName" -ForegroundColor Cyan
    Write-Host "--------------------------------------------------" -ForegroundColor Cyan

    # 1. CRIAR O TIME NA ORGANIZAÇÃO (nome = primeiro nome do competidor)
    $TeamBody = @{
        name                      = $TeamName
        description               = "Time do competidor $Competidor"
        permission                = "write"  # Pode ser: read, write, admin
        can_create_org_repo       = $false
        includes_all_repositories = $false
        # Força o acesso às ferramentas padrão do repositório (evita bug interno do Gitea)
        units                     = @("repo.code", "repo.issues", "repo.ext_issues", "repo.wiki", "repo.pulls", "repo.releases", "repo.projects", "repo.ext_wiki")
    } | ConvertTo-Json

    # Força o PowerShell a enviar em UTF-8 sem quebrar caracteres
    $TeamBodyBytes = [System.Text.Encoding]::UTF8.GetBytes($TeamBody)

    $TeamId = $null
    try {
        $CreateTeamResponse = Invoke-RestMethod -Uri "$GiteaUrl/api/v1/orgs/$OrgName/teams" -Method Post -Headers $Headers -Body $TeamBodyBytes
        $TeamId = $CreateTeamResponse.id
        Write-Host "=> Time '$TeamName' criado com ID: $TeamId" -ForegroundColor Green
    } catch {
        Write-Host "=> Erro ao criar o time '$TeamName'!" -ForegroundColor Red

        if ($_.Exception.Response) {
            $StatusCode = [int]$_.Exception.Response.StatusCode
            $StatusDescription = $_.Exception.Response.StatusDescription
            Write-Host "Código HTTP do Gitea: $StatusCode ($StatusDescription)" -ForegroundColor Yellow
        } else {
            Write-Host "Erro de conexão/rede: $_" -ForegroundColor Yellow
        }

        Write-Host "Tentando buscar o ID do time existente para continuar..." -ForegroundColor Cyan
        try {
            $AllTeams = Invoke-RestMethod -Uri "$GiteaUrl/api/v1/orgs/$OrgName/teams" -Method Get -Headers $Headers
            $TeamId = ($AllTeams | Where-Object { $_.name -eq $TeamName }).id
        } catch {
            Write-Host "=> Não foi possível obter o ID do time. Pulando..." -ForegroundColor Red
            continue
        }
    }

    if (-not $TeamId) {
        Write-Host "=> Sem ID de time válido para $TeamName. Pulando vinculação de repositórios." -ForegroundColor Red
        continue
    }

    # 2. ADICIONAR O USUÁRIO DO COMPETIDOR AO TIME (username = primeiro nome, igual ao script de criação de usuários)
    $AddMemberUrl = "$GiteaUrl/api/v1/orgs/$OrgName/teams/$TeamId/members/$Competidor"
    try {
        $null = Invoke-RestMethod -Uri $AddMemberUrl -Method Put -Headers $Headers
        Write-Host "   -> Usuário $Competidor adicionado ao time." -ForegroundColor Green
    } catch {
        Write-Host "   -> Erro ao adicionar $Competidor ao time (verifique se o usuário existe)." -ForegroundColor Red
    }

    # 3. VINCULAR TODOS OS REPOSITÓRIOS DO COMPETIDOR (Session1 a Session5) A ESTE TIME
    for ($a = 1; $a -le 5; $a++) {
        $RepoName = "Session${a}_${Competidor}"

        Write-Host "   Vinculando repositório $RepoName ao time..."

        # Endpoint do Gitea para adicionar repo ao time: /teams/{id}/repos/{org}/{repo}
        $AddRepoUrl = "$GiteaUrl/api/v1/teams/$TeamId/repos/$OrgName/$RepoName"

        try {
            # Esta chamada usa o método PUT e não precisa de corpo (Body)
            $null = Invoke-RestMethod -Uri $AddRepoUrl -Method Put -Headers $Headers
            Write-Host "   -> Sucesso: $RepoName adicionado!" -ForegroundColor Green
        } catch {
            Write-Host "   -> Erro ao vincular $RepoName (verifique se o repo existe)." -ForegroundColor Red
        }
    }
}

Write-Host "`nProcesso concluído." -ForegroundColor Green