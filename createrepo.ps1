# --- Defina suas variáveis aqui ---
$GiteaUrl = "http://localhost:3000"
$Token = "c8e2ce3397618177bc54d6f613013c58f1de1f9d"
$OrgName = "Deliveries"

# Configuração dos cabeçalhos da requisição
$Headers = @{
    "Authorization" = "token $Token"
    "Content-Type"  = "application/json"
}

# --- Lista de competidores (primeiro nome) ---
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

# Loop externo: sessões de 1 até 5
for ($a = 1; $a -le 5; $a++) {

    # Loop interno: um repositório por competidor
    foreach ($Competidor in $Competidores) {

        # Define o nome do repositório baseado no padrão Session{a}_{Competidor}
        $RepoName = "Session${a}_${Competidor}"

        Write-Host "Tentando criar o repositório: $RepoName..."

        # Corpo da requisição (JSON)
        $Body = @{
            name      = $RepoName
            private   = $true   # Altere para $false se quiser repositórios públicos
            auto_init = $false  # Cria o repositório sem um README.md padrão
        } | ConvertTo-Json

        # Executa a chamada de API com tratamento de erros simples
        try {
            $Response = Invoke-RestMethod -Uri "$GiteaUrl/api/v1/orgs/$OrgName/repos" -Method Post -Headers $Headers -Body $Body
            Write-Host "=> Sucesso! $RepoName criado." -ForegroundColor Green
        } catch {
            Write-Host "=> Erro ao criar $RepoName. Detalhes: $_" -ForegroundColor Red
        }

        Write-Host "--------------------------------------------------"
    }
}

Write-Host "`nProcesso concluído." -ForegroundColor Green