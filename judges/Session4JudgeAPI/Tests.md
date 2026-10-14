# API Testadora — Module 4: Track & Trace API

## 1. Objetivo

Criar uma API responsável por testar automaticamente a API desenvolvida pelo competidor na prova **Module 4 — Track & Trace API**.

A API testadora deverá:

1. Consumir os endpoints da API do competidor.
2. Consultar o mesmo banco PostgreSQL utilizado pela API do competidor.
3. Utilizar o `DbContext` existente para obter os dados esperados.
4. Comparar a resposta da API do competidor com o estado esperado do banco.
5. Registrar internamente o resultado de cada teste.
6. Expor um endpoint para consultar os resultados dos testes.

A prova possui 20 endpoints/test cases, cada um valendo 1 ponto.

---

# 2. Arquitetura proposta

A estrutura ficará aproximadamente assim:

```text
Test API
│
├── Controllers
│   └── TestController.cs
│
├── Services
│   └── TestService.cs
│
├── Models
│   └── [Models já existentes]
│
├── Data
│   └── [DbContext já existente]
│
├── DTOs
│   └── [DTOs necessários para testes]
│
└── Program.cs
```

A ideia é **não duplicar a camada de acesso ao banco**.

Se o projeto já possui:

* `DbContext`
* Models/Entities
* Configuração do PostgreSQL
* Connection String
* Mapeamentos Entity Framework

esses componentes deverão ser reutilizados.

A única camada nova necessária para executar os testes será principalmente:

```text
TestController
        ↓
TestService
        ↓
HttpClient
        ↓
API do competidor
        ↓
PostgreSQL
        ↑
DbContext
```

---

# 3. Componentes que já existem

## 3.1 DbContext

O `DbContext` existente deverá ser reutilizado para consultar o banco.

Exemplo conceitual:

```csharp
private readonly NortransContext _context;
```

Ele será utilizado principalmente para:

* descobrir registros existentes;
* obter dados esperados para GET;
* verificar se POST criou corretamente;
* verificar se PATCH atualizou corretamente;
* executar cleanup dos dados criados pelos testes.

Não criar uma segunda conexão ou um segundo `DbContext` específico para os testes sem necessidade.

---

# 4. Models

Os Models existentes também deverão ser reutilizados.

Entre as entidades previstas pela prova estão:

```text
Branch
Consignee
Shipment
Container
Event
```

A estrutura do banco contém:

* `branches`
* `consignees`
* `shipments`
* `containers`
* `events`

com os relacionamentos definidos na especificação.

Os testes deverão utilizar esses Models para verificar o estado real do banco.

---

# 5. Database Connection

A conexão existente com PostgreSQL deverá ser reutilizada.

O banco da prova é:

```text
Host: localhost
Port: 5433
Database: nortrans_tt
Username: nortrans
```

A API testadora deve utilizar exatamente o mesmo banco da API do competidor.

---

# 6. URL da API do competidor

A API testadora precisa saber para onde enviar as requisições.

Recomendação:

```json
{
  "CompetitorApi": {
    "BaseUrl": "http://localhost:4000"
  }
}
```

No código:

```csharp
var baseUrl = configuration["CompetitorApi:BaseUrl"];
```

Idealmente, utilizar `HttpClient` através de `IHttpClientFactory`.

Exemplo:

```csharp
builder.Services.AddHttpClient("CompetitorApi", client =>
{
    client.BaseAddress = new Uri("http://localhost:4000");
});
```

---

# 7. TestController

Criar:

```text
Controllers/TestController.cs
```

O controller será responsável por expor um endpoint de teste para cada endpoint da prova.

Exemplo:

```csharp
[ApiController]
[Route("test")]
public class TestController : ControllerBase
{
}
```

A API testadora terá endpoints como:

```text
GET /test/health
GET /test/branches
GET /test/branches/{id}
GET /test/consignees
...
```

Esses endpoints **não são os endpoints que o competidor precisa implementar**.

Eles são os endpoints utilizados para executar os testes contra a API do competidor.

---

# 8. Resultado dos testes

Deve existir uma lista interna contendo o resultado de cada teste.

Exemplo:

```csharp
public class TestResult
{
    public string TestName { get; set; } = "";
    public string Endpoint { get; set; } = "";
    public bool Passed { get; set; }
    public string Message { get; set; } = "";
    public DateTime ExecutedAt { get; set; }
}
```

A lista pode ser mantida inicialmente em memória:

```csharp
private readonly List<TestResult> _results = new();
```

Porém, o ideal é utilizar um serviço singleton:

```text
TestResultService
```

Assim todos os controllers/services compartilham a mesma lista.

---

# 9. Endpoint para visualizar resultados

Criar:

```http
GET /test/results
```

Resposta:

```json
[
  {
    "testName": "GET /branches",
    "endpoint": "/branches",
    "passed": true,
    "message": "Response matches database.",
    "executedAt": "2026-08-26T15:30:00Z"
  },
  {
    "testName": "POST /consignees",
    "endpoint": "/consignees",
    "passed": false,
    "message": "Created record does not match expected data.",
    "executedAt": "2026-08-26T15:31:00Z"
  }
]
```

A lista deve sempre retornar um array, mesmo que esteja vazia.

---

# 10. Fluxo dos testes GET

Para endpoints de leitura, seguir o seguinte fluxo:

```text
1. Executar TestController
        ↓
2. Obter dados esperados usando DbContext
        ↓
3. Consumir API do competidor
        ↓
4. Obter resposta HTTP
        ↓
5. Comparar resposta com banco
        ↓
6. Registrar PASS/FAIL
        ↓
7. Retornar resultado do teste
```

## Exemplo

Para:

```http
GET /branches
```

O tester executará:

```csharp
var expected = await _context.Branches
    .OrderBy(x => x.Id)
    .ToListAsync();
```

Depois:

```csharp
var response = await client.GetAsync("/branches");
```

Desserializa a resposta:

```csharp
var actual = await response.Content
    .ReadFromJsonAsync<List<BranchDto>>();
```

E compara:

```csharp
var passed = Compare(expected, actual);
```

---

# 11. Regra importante para GET

Não comparar simplesmente o JSON bruto.

A comparação deverá considerar o conteúdo.

Por exemplo:

```json
{
    "id": 1,
    "code": "CAL",
    "name": "Caldera CFS",
    "city": "Caldera",
    "phone": "..."
}
```

deve ser comparado com o objeto equivalente obtido do banco.

A ordem deverá ser considerada somente quando a especificação determinar uma ordenação.

Exemplos da prova:

### Containers

```text
container_no ascending
```

### Events

```text
occurred_at descending
```

### Search

```text
reference ascending
```

### Transit times

```text
branch_code ascending
```

### Top consignees

```text
shipment_count descending
legal_name ascending em caso de empate
```

## Essas regras estão explicitamente definidas na especificação.

# 12. Fluxo dos testes POST

Para endpoints POST:

```text
1. Criar dados de teste
        ↓
2. Consumir POST da API do competidor
        ↓
3. Verificar HTTP Status Code
        ↓
4. Buscar registro criado no banco
        ↓
5. Comparar registro com os dados esperados
        ↓
6. Se estiver correto:
       PASS
       ↓
       DELETE registro de teste
        ↓
7. Se estiver incorreto:
       FAIL
       ↓
       NÃO apagar
```

---

# 13. Exemplo POST /consignees

Dados utilizados pelo tester:

```json
{
  "legal_name": "TEST COMPANY",
  "tax_id": "TEST-999999",
  "country_code": "BR",
  "email": "test-999999@test.local",
  "active": true
}
```

Executar:

```http
POST /consignees
```

Depois:

```csharp
var created = await _context.Consignees
    .FirstOrDefaultAsync(x => x.TaxId == testData.TaxId);
```

Verificar:

```text
HTTP Status = 201
        +
registro existe
        +
legal_name correto
        +
tax_id correto
        +
country_code correto
        +
email correto
        +
active correto
        +
created_at preenchido
```

Se tudo estiver correto:

```text
PASS
```

Depois executar:

```csharp
_context.Consignees.Remove(created);
await _context.SaveChangesAsync();
```

---

# 14. Regra de cleanup

Essa regra é muito importante.

## Teste passou

```text
POST
 ↓
Banco
 ↓
correto
 ↓
PASS
 ↓
DELETE dado criado
```

## Teste falhou

```text
POST
 ↓
Banco
 ↓
incorreto
 ↓
FAIL
 ↓
NÃO DELETE
```

A razão para não apagar quando falhar é permitir a inspeção posterior do banco e identificar o que a API do competidor fez de errado.

---

# 15. Dados de teste

Nunca utilizar valores que possam conflitar com os dados originais.

Recomendação:

```text
TEST-<timestamp>-<guid>
```

Exemplo:

```text
TEST-20260826-550e8400
```

Para email:

```text
test-550e8400@test.local
```

Para referência:

```text
TEST-SHIPMENT-550e8400
```

Para container:

```text
TEST1234567
```

Dessa maneira, cada execução gera dados únicos.

---

# 16. Testes de POST com Foreign Keys

Alguns POST dependem de registros existentes.

Por exemplo:

```http
POST /shipments
```

precisa de:

```text
consignee_id
branch_id
```

O tester deverá primeiro buscar registros válidos:

```csharp
var consignee = await _context.Consignees
    .FirstAsync();

var branch = await _context.Branches
    .FirstAsync();
```

Então montar:

```json
{
  "reference": "TEST-SHIPMENT-123",
  "bill_of_lading": "TEST-BOL-123",
  "consignee_id": 3,
  "branch_id": 1,
  "mode": "ocean",
  "etd": "2026-08-26T00:00:00.000Z",
  "eta": "2026-09-01T00:00:00.000Z"
}
```

Depois verificar o registro criado.

A especificação determina que novos shipments devem começar com:

```text
status = booked
```

independentemente de um status enviado no body.

Portanto o tester deverá verificar isso.

---

# 17. Testes PATCH

A prova possui:

```http
PATCH /shipments/:id/status
```

e não `PUT`.

O tester deverá:

```text
1. Encontrar shipment em estado conhecido
2. Obter status atual
3. Calcular próximo status
4. Fazer PATCH
5. Consultar banco
6. Verificar novo status
7. PASS
8. Cleanup / rollback
```

A sequência válida é:

```text
booked
   ↓
in_transit
   ↓
arrived
   ↓
cleared
   ↓
closed
```

Só é permitida a evolução de exatamente um passo.

---

# 18. Problema do PATCH e cleanup

Como PATCH modifica um registro existente, não devemos alterar permanentemente um registro seed.

Portanto, antes do teste:

```text
buscar shipment
        ↓
guardar status original
        ↓
PATCH
        ↓
validar banco
        ↓
restaurar status original
```

Exemplo:

```text
original:
booked

PATCH:
in_transit

verificar:
in_transit

restaurar:
booked
```

Se o teste falhar, a estratégia deve preservar o estado que permita diagnosticar o problema.

---

# 19. Lista completa de testes

O `TestController` deverá possuir um endpoint para cada um dos 20 testes da prova.

## Tier 1 — Reads

### 1. GET /health

Tester:

```http
GET /health
```

Esperado:

```json
{
  "status": "ok"
}
```

---

### 2. GET /branches

```http
GET /branches
```

Validar:

```text
status HTTP
+
array
+
conteúdo
```

---

### 3. GET /branches/:id

```http
GET /branches/{id}
```

Validar:

```text
registro existente
```

Também deverá existir um caso com ID inexistente:

```text
404
```

---

### 4. GET /consignees

```http
GET /consignees
```

Testar também:

```http
GET /consignees?active=true
GET /consignees?country=CR
GET /consignees?active=true&country=CR
```

A especificação determina que os filtros podem ser combinados.

---

### 5. GET /consignees/:id

```http
GET /consignees/{id}
```

Validar:

```text
200 para existente
404 para inexistente
```

---

### 6. GET /shipments

```http
GET /shipments
```

Testar:

```http
GET /shipments?status=booked
GET /shipments?branch=CAL
```

Também validar:

```text
status desconhecido → 400
```

---

### 7. GET /shipments/:id

```http
GET /shipments/{id}
```

Validar:

```text
200 existente
404 inexistente
```

---

# 20. Tier 2 — Writes and Relationships

## 8. POST /consignees

```http
POST /consignees
```

Validar:

```text
201
registro criado
dados corretos
created_at preenchido
```

Depois:

```text
DELETE
```

somente se passar.

---

## 9. POST /shipments

```http
POST /shipments
```

Validar:

```text
201
reference
bill_of_lading
consignee_id
branch_id
mode
etd
eta
status = booked
```

Depois remover o shipment criado.

---

## 10. GET /shipments/:id/containers

```http
GET /shipments/{id}/containers
```

Validar:

```text
array
containers corretos
ordenação por container_no ASC
```

Shipment inexistente:

```text
404
```

---

## 11. POST /shipments/:id/containers

```http
POST /shipments/{id}/containers
```

Validar:

```text
201
container criado
shipment_id correto
dados corretos
```

Depois remover:

```text
container
```

---

## 12. POST /containers/:id/events

```http
POST /containers/{id}/events
```

Validar:

```text
201
event criado
container_id correto
event_type correto
occurred_at correto
location correto
note correto
```

Também verificar os side effects:

```text
discharged
    ↓
discharged_at = occurred_at
```

e:

```text
gate_out
    ↓
gated_out_at = occurred_at
```

Esses side effects são exigidos pela especificação.

---

## 13. GET /containers/:id/events

```http
GET /containers/{id}/events
```

Validar:

```text
array
container correto
ordenação por occurred_at DESC
```

---

## 14. PATCH /shipments/:id/status

```http
PATCH /shipments/{id}/status
```

Validar:

```text
200
status atualizado
```

E garantir:

```text
apenas próximo status permitido
```

---

# 21. Tier 3 — Aggregation

## 15. GET /shipments/search

```http
GET /shipments/search?q=...
```

O tester deverá reproduzir a regra da especificação utilizando o `DbContext`.

Pesquisar em:

```text
shipments.reference
shipments.bill_of_lading
consignees.legal_name
```

com comparação case-insensitive.

Ordenação:

```text
reference ASC
```

A busca com `q` ausente ou vazio deve resultar em:

```text
400
```

---

## 16. GET /consignees/:id/summary

```http
GET /consignees/{id}/summary
```

O tester deverá calcular o resultado diretamente do banco.

Validar:

```json
{
  "consignee_id": 3,
  "legal_name": "...",
  "shipments_by_status": {
    "booked": 0,
    "in_transit": 0,
    "arrived": 0,
    "cleared": 0,
    "closed": 0
  },
  "total_teu": 0,
  "last_shipment_at": null
}
```

Os cinco status devem sempre aparecer.

`total_teu` deve ser calculado através dos containers dos shipments daquele consignee.

`last_shipment_at` deve ser o maior `created_at`.

---

## 17. GET /reports/dwell

```http
GET /reports/dwell
```

Selecionar containers:

```text
discharged_at IS NOT NULL
AND
gated_out_at IS NULL
```

Calcular:

```text
dwell_days
```

como número de dias completos desde `discharged_at` até o momento da requisição.

Ordenar:

```text
dwell_days DESC
```

---

## 18. GET /reports/transit-times

```http
GET /reports/transit-times
```

Deve existir uma linha para cada branch.

Inclusive branches sem shipments.

Calcular:

```text
average_transit_days =
AVG(eta - etd)
```

arredondado para uma casa decimal.

Branch sem dados:

```json
{
  "shipment_count": 0,
  "average_transit_days": null
}
```

Ordenação:

```text
branch_code ASC
```

---

## 19. GET /reports/top-consignees

```http
GET /reports/top-consignees?limit=5
```

Validar:

```text
shipment_count DESC
legal_name ASC em caso de empate
```

Casos:

```text
sem limit → 5
limit positivo → valor informado
limit inválido → 400
```

A especificação determina que `limit` ausente usa 5 e que um valor não positivo ou inválido resulta em 400.

---

## 20. GET /reports/monthly-volume

```http
GET /reports/monthly-volume?year=2026
```

Deve retornar exatamente:

```text
12 objetos
```

na ordem:

```text
January
February
March
...
December
```

Mesmo que não existam dados para determinado mês:

```json
{
  "month": 4,
  "shipment_count": 0,
  "teu": 0
}
```

O ano deve ser obtido através do `created_at` dos shipments.

Ano ausente ou inválido:

```text
400
```

---

# 22. Tabela final de endpoints

| #  | Tester endpoint                        | Competitor endpoint               | Tipo  |
| -- | -------------------------------------- | --------------------------------- | ----- |
| 1  | `GET /test/health`                     | `GET /health`                     | GET   |
| 2  | `GET /test/branches`                   | `GET /branches`                   | GET   |
| 3  | `GET /test/branches/{id}`              | `GET /branches/{id}`              | GET   |
| 4  | `GET /test/consignees`                 | `GET /consignees`                 | GET   |
| 5  | `GET /test/consignees/{id}`            | `GET /consignees/{id}`            | GET   |
| 6  | `GET /test/shipments`                  | `GET /shipments`                  | GET   |
| 7  | `GET /test/shipments/{id}`             | `GET /shipments/{id}`             | GET   |
| 8  | `POST /test/consignees`                | `POST /consignees`                | POST  |
| 9  | `POST /test/shipments`                 | `POST /shipments`                 | POST  |
| 10 | `GET /test/shipments/{id}/containers`  | `GET /shipments/{id}/containers`  | GET   |
| 11 | `POST /test/shipments/{id}/containers` | `POST /shipments/{id}/containers` | POST  |
| 12 | `POST /test/containers/{id}/events`    | `POST /containers/{id}/events`    | POST  |
| 13 | `GET /test/containers/{id}/events`     | `GET /containers/{id}/events`     | GET   |
| 14 | `PATCH /test/shipments/{id}/status`    | `PATCH /shipments/{id}/status`    | PATCH |
| 15 | `GET /test/shipments/search`           | `GET /shipments/search`           | GET   |
| 16 | `GET /test/consignees/{id}/summary`    | `GET /consignees/{id}/summary`    | GET   |
| 17 | `GET /test/reports/dwell`              | `GET /reports/dwell`              | GET   |
| 18 | `GET /test/reports/transit-times`      | `GET /reports/transit-times`      | GET   |
| 19 | `GET /test/reports/top-consignees`     | `GET /reports/top-consignees`     | GET   |
| 20 | `GET /test/reports/monthly-volume`     | `GET /reports/monthly-volume`     | GET   |

Além desses:

```http
GET /test/results
```

retorna o histórico interno dos testes executados.

---

# 23. TestService

Recomenda-se não colocar toda a lógica dentro do Controller.

Criar:

```text
Services/TestService.cs
```

O controller apenas dispara o teste:

```csharp
[HttpGet("branches")]
public async Task<IActionResult> TestBranches()
{
    var result = await _testService.TestBranches();

    return Ok(result);
}
```

O Service fica responsável por:

```text
DbContext
HttpClient
comparação
resultado
cleanup
```

---

# 24. Estrutura recomendada do TestService

```csharp
public class TestService
{
    private readonly NortransContext _context;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly TestResultService _resultService;

    public TestService(
        NortransContext context,
        IHttpClientFactory httpClientFactory,
        TestResultService resultService)
    {
        _context = context;
        _httpClientFactory = httpClientFactory;
        _resultService = resultService;
    }
}
```

---

# 25. Método padrão para GET

Criar uma estrutura semelhante:

```csharp
public async Task<TestResult> TestBranches()
{
    try
    {
        var expected = await GetExpectedBranches();

        var client = _httpClientFactory
            .CreateClient("CompetitorApi");

        var response = await client.GetAsync("/branches");

        if (!response.IsSuccessStatusCode)
        {
            return Fail(
                "GET /branches",
                $"Expected 200 but received {(int)response.StatusCode}");
        }

        var actual = await response.Content
            .ReadFromJsonAsync<List<BranchDto>>();

        if (!Compare(expected, actual))
        {
            return Fail(
                "GET /branches",
                "Response does not match database.");
        }

        return Pass(
            "GET /branches",
            "Response matches database.");
    }
    catch (Exception ex)
    {
        return Fail(
            "GET /branches",
            ex.Message);
    }
}
```

---

# 26. Método padrão para POST

A estrutura deverá ser:

```csharp
public async Task<TestResult> TestCreateConsignee()
{
    var testData = GenerateUniqueConsignee();

    try
    {
        var client = _httpClientFactory
            .CreateClient("CompetitorApi");

        var response = await client.PostAsJsonAsync(
            "/consignees",
            testData);

        if (response.StatusCode != HttpStatusCode.Created)
        {
            return Fail(
                "POST /consignees",
                $"Expected 201 but received {(int)response.StatusCode}");
        }

        var created = await _context.Consignees
            .FirstOrDefaultAsync(x => x.TaxId == testData.TaxId);

        if (created == null)
        {
            return Fail(
                "POST /consignees",
                "API returned success but record was not created.");
        }

        if (!Matches(created, testData))
        {
            return Fail(
                "POST /consignees",
                "Created record does not match expected data.");
        }

        _context.Consignees.Remove(created);

        await _context.SaveChangesAsync();

        return Pass(
            "POST /consignees",
            "Record created correctly.");
    }
    catch (Exception ex)
    {
        return Fail(
            "POST /consignees",
            ex.Message);
    }
}
```

---

# 27. Importante: resposta HTTP não é suficiente

O tester **não deve considerar um POST aprovado apenas porque recebeu 201**.

Por exemplo:

```text
API retorna 201
        ↓
mas não cria no banco
        ↓
FAIL
```

Também:

```text
API retorna 201
        ↓
cria registro
        ↓
mas dados estão incorretos
        ↓
FAIL
```

O critério principal para POST/ PATCH será o estado real do banco.

---

# 28. Resultado do teste

Criar métodos auxiliares:

```csharp
private TestResult Pass(
    string endpoint,
    string message)
{
    var result = new TestResult
    {
        TestName = endpoint,
        Endpoint = endpoint,
        Passed = true,
        Message = message,
        ExecutedAt = DateTime.UtcNow
    };

    _resultService.Add(result);

    return result;
}
```

E:

```csharp
private TestResult Fail(
    string endpoint,
    string message)
{
    var result = new TestResult
    {
        TestName = endpoint,
        Endpoint = endpoint,
        Passed = false,
        Message = message,
        ExecutedAt = DateTime.UtcNow
    };

    _resultService.Add(result);

    return result;
}
```

---

# 29. Endpoint /test/results

Controller:

```csharp
[HttpGet("results")]
public IActionResult Results()
{
    return Ok(_resultService.GetAll());
}
```

Exemplo:

```http
GET /test/results
```

Resposta:

```json
[
  {
    "testName": "GET /health",
    "endpoint": "/health",
    "passed": true,
    "message": "Health check passed.",
    "executedAt": "2026-08-26T15:00:00Z"
  },
  {
    "testName": "GET /branches",
    "endpoint": "/branches",
    "passed": true,
    "message": "Branches match database.",
    "executedAt": "2026-08-26T15:01:00Z"
  }
]
```

---

# 30. Não armazenar apenas PASS/FAIL

Durante o desenvolvimento da prova, é muito útil armazenar informações de diagnóstico.

Recomendação:

```csharp
public class TestResult
{
    public string TestName { get; set; } = "";
    public string Endpoint { get; set; } = "";

    public bool Passed { get; set; }

    public int? ExpectedStatusCode { get; set; }
    public int? ActualStatusCode { get; set; }

    public string Message { get; set; } = "";

    public DateTime ExecutedAt { get; set; }
}
```

Exemplo de falha:

```json
{
  "testName": "POST /consignees",
  "passed": false,
  "expectedStatusCode": 201,
  "actualStatusCode": 200,
  "message": "Expected HTTP 201 Created."
}
```

Isso torna a API muito mais útil para avaliar o candidato.

---

# 31. Comparação de objetos

Evitar:

```csharp
expected == actual
```

ou comparação de JSON bruto.

Criar métodos específicos:

```text
CompareBranches()
CompareConsignees()
CompareShipments()
CompareContainers()
CompareEvents()
```

Para cada endpoint, comparar somente os campos relevantes à especificação.

Por exemplo, em `POST /consignees`, `created_at` não pode ser comparado com um valor exato porque é gerado pela API.

Deve ser validado:

```text
created_at != null
```

e:

```text
created_at <= now
```

---

# 32. Timestamps

A prova exige timestamps em ISO 8601:

```text
YYYY-MM-DDTHH:MM:SS.sssZ
```

O tester deve tratar timestamps como `DateTimeOffset`/UTC.

Evitar comparar strings diretamente.

Preferir:

```csharp
DateTimeOffset.Parse(...)
```

e comparar os valores temporais.

---

# 33. Booleanos

A especificação exige:

```json
true
```

ou:

```json
false
```

e não:

```json
1
```

ou:

```json
0
```

O DTO utilizado pelo tester deverá utilizar:

```csharp
bool
```

---

# 34. Arrays

Toda resposta que representa coleção deve ser:

```json
[]
```

quando vazia.

Nunca:

```json
null
```

Portanto os testes de GET devem verificar isso.

---

# 35. Status HTTP

Os testes devem validar os códigos HTTP definidos na especificação:

```text
200 OK
201 Created
400 Bad Request
404 Not Found
409 Conflict
422 Unprocessable Entity
```

Esses códigos fazem parte explicitamente dos requisitos gerais da prova.

---

# 36. Ordem de implementação

Para não complicar a implementação inicialmente, seguir esta ordem:

## Etapa 1

Verificar que já existem:

```text
DbContext
Models
Connection String
Program.cs
```

---

## Etapa 2

Criar:

```text
TestResult
TestResultService
```

---

## Etapa 3

Configurar:

```text
HttpClient
```

apontando para:

```text
http://localhost:4000
```

---

## Etapa 4

Criar:

```text
TestService
```

---

## Etapa 5

Criar:

```text
TestController
```

---

## Etapa 6

Implementar primeiro:

```text
GET /health
GET /branches
GET /branches/{id}
GET /consignees
GET /consignees/{id}
GET /shipments
GET /shipments/{id}
```

---

## Etapa 7

Implementar POST:

```text
POST /consignees
POST /shipments
POST /shipments/{id}/containers
POST /containers/{id}/events
```

---

## Etapa 8

Implementar:

```text
PATCH /shipments/{id}/status
```

---

## Etapa 9

Implementar os endpoints de agregação:

```text
GET /shipments/search
GET /consignees/{id}/summary
GET /reports/dwell
GET /reports/transit-times
GET /reports/top-consignees
GET /reports/monthly-volume
```

---

# 37. Ponto de atenção: banco compartilhado

Como a API testadora e a API do competidor usam o mesmo banco:

```text
                  PostgreSQL
                     ↑
          ┌──────────┴──────────┐
          │                     │
   API Testadora          API Competidor
          │                     │
     DbContext              DbContext
```

isso é proposital.

Porém, os testes precisam ser projetados para não depender de um estado específico que possa ser destruído por testes anteriores.

A própria prova alerta que o script cria registros e não os remove, portanto não devemos assumir que o seed permanecerá intocado.

---

# 38. Princípio principal do avaliador

A regra geral deve ser:

## GET

```text
Banco = fonte da verdade

Banco
 ↓
expected

API Competidor
 ↓
actual

expected == actual
 ↓
PASS/FAIL
```

## POST

```text
Dados conhecidos
 ↓
API Competidor
 ↓
Banco
 ↓
Banco contém dados corretos?
 ↓
PASS
 ↓
DELETE
```

ou:

```text
Banco contém dados incorretos?
 ↓
FAIL
 ↓
NÃO DELETE
```

## PATCH

```text
Estado original
 ↓
API Competidor
 ↓
Banco
 ↓
Estado atualizado corretamente?
 ↓
PASS
 ↓
RESTORE
```

---

# 39. Resultado esperado

Ao final, a API testadora deverá permitir algo como:

```text
GET /test/health
        ↓
Teste GET /health executado

GET /test/branches
        ↓
Teste GET /branches executado

POST /test/consignees
        ↓
Teste POST /consignees executado

...

GET /test/monthly-volume
        ↓
Teste GET /reports/monthly-volume executado

GET /test/results
        ↓
Resultado de todos os testes
```

O resultado final poderá ser utilizado para determinar:

```text
20 testes
+
PASS = 1 ponto
+
FAIL = 0 pontos
```

mantendo também uma mensagem de diagnóstico para cada teste.
