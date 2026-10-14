# Casos de Teste — Módulo 3: Duty & Charges Engine (Nortrans)

## 0. Casos transversais (aplicam-se aos 4 métodos)

- [ ] **Nenhum valor monetário é `double`/`decimal`** — checagem de assinatura/reflection: toda quantia exposta pelos contratos é inteira (céntimos/cents).
- [ ] **Nenhum método lança exceção** para entrada nula, malformada ou contraditória — rodar cada método com um "fuzzer" simples de nulls, negativos e HS codes malformados e garantir que sempre retorna um resultado com finding, nunca throw.
- [ ] **Arredondamento para longe de zero em cada ponto nomeado pela especificação** (não só no fim) — casos tabulados:
  - `0.5 → 1`, `-0.5 → -1`
  - `1.4 → 1`, `1.5 → 2`, `2.5 → 3` (não é banker's rounding)
  - `-1.5 → -2`, `-2.5 → -3`
- [ ] **Total = soma exata das partes** em todo resultado que agrega linhas (valuation e assessment) — nunca um total "arredondado à parte" que diverge da soma dos componentes.
- [ ] **Apenas a primeira classe em ordem alfabética por interface é usada** — mais um teste de projeto/build do que unitário; vale um teste de integração que registra duas implementações fake e confirma qual é escolhida (se a arquitetura de DI permitir testar isso).

---

## 1. `AirChargeableWeight(IReadOnlyList<CargoPiece>? pieces)`

**Já cobertos por você:**
- [ ] Lista nula → tudo zero, finding `NO_PIECES_SUPPLIED`
- [ ] Lista vazia → tudo zero, finding `NO_PIECES_SUPPLIED`
- [ ] Peça com dimensão negativa/zero → pulada, finding `INVALID_PIECE`
- [ ] Peça com peso negativo → pulada, finding `INVALID_PIECE`
- [ ] Peça com `Quantity < 1` → pulada, finding `INVALID_PIECE`

**Para adicionar:**
- [ ] **Todas as peças da lista são inválidas** (lista não vazia, mas 100% skip) — resultado deve ser zero em tudo, com `INVALID_PIECE` um por peça inválida, **sem** `NO_PIECES_SUPPLIED` (a lista não estava vazia). Para cada peça invalida adicionar 1 INVALID_PIECE.
- [ ] **Mistura de peças válidas e inválidas** — inválidas são puladas, válidas somadas normalmente, finding `INVALID_PIECE` presente mas resultado reflete só as válidas.
- [ ] **Peso volumétrico > peso bruto** → chargeable weight usa o volumétrico.
- [ ] **Peso bruto > peso volumétrico** → chargeable weight usa o bruto.
- [ ] **Empate exato** entre volumétrico e bruto → qualquer um serve como base (mesmo valor).
- [ ] **Arredondamento do peso volumétrico por peça**: `L×W×H/6000` caindo exatamente em `.5` grama → arredonda para longe de zero.
- [ ] **Arredondamento final para múltiplo de 500g**: valor já múltiplo de 500 → não arredonda mais (ex.: exatamente 2000g fica 2000g).
- [ ] **Valor logo acima de múltiplo de 500** (ex.: 2001g) → arredonda para o próximo múltiplo (2500g).
- [ ] **`Quantity > 1`** multiplica corretamente peso bruto e volumétrico da peça.
- [ ] **Múltiplas peças distintas somadas** (não só quantity repetida) — teste de soma com 3+ tipos de peça diferentes.
- [ ] **Dimensões/pesos grandes** — verificar que não há overflow de `int` no cálculo intermediário (`L×W×H` pode facilmente estourar `int` antes da divisão; vale testar com valores no limite realista de carga aérea).

---

## 2. `OceanMeasure OceanRevenueTons(IReadOnlyList<CargoPiece>? pieces)`

- [ ] Mesma bateria de null/vazia/inválida/mista do item 1 (`NO_PIECES_SUPPLIED`, `INVALID_PIECE`, todas inválidas, mistura).
- [ ] **Volume (m³ em milésimos) > peso (t em milésimos)** → revenue ton usa o volume.
- [ ] **Peso > volume** → revenue ton usa o peso.
- [ ] **Empate exato** entre volume e peso.
- [ ] **Mínimo de 1 revenue ton (1000 milésimos)**: consignação pequena onde `max(volume, peso) < 1000` → resultado é forçado para 1000, não para o valor calculado.
- [ ] **Consignação exatamente no limiar** (`max = 1000`) → não deveria ser afetada pelo piso (já está no mínimo).
- [ ] **Arredondamento para longe de zero** ao expressar volume (`÷1.000.000`) e peso (`÷1.000`) em milésimos, incluindo caso `.5` exato.
- [ ] **Múltiplas peças com `Quantity > 1`** somadas corretamente antes da divisão (a soma é sobre volume/peso brutos, não sobre valores já arredondados por peça — diferente do air chargeable weight, que arredonda por peça primeiro; vale um teste que comprova essa diferença de ordem de operações).

---

## 3. `ICustomsValuationService.Value(ValuationRequest? request)`

### Entrada inválida
- [ ] `request` nulo → tudo zero, `INVALID_REQUEST`
- [ ] Lista de linhas vazia → tudo zero, `INVALID_REQUEST`
- [ ] FOB, freight ou insurance negativos (em qualquer linha) → tudo zero, `INVALID_REQUEST`

### Câmbio (FX)
- [ ] Moeda `CRC` → sem conversão, sem consulta ao CSV.
- [ ] Moeda estrangeira com taxa exatamente na data da declaração.
- [ ] Moeda estrangeira sem taxa na data exata → usa a data anterior mais recente daquela moeda.
- [ ] Moeda estrangeira sem nenhuma taxa em ou antes da data → `FX_RATE_NOT_FOUND`, tudo zero (não "chuta" taxa).
- [ ] Arredondamento da conversão (`minorUnits × rate / 100`) para longe de zero, incluindo caso `.5`.

### Seguro
- [ ] `InsuranceAmountMinor == null` → prêmio nocional de 1,25% do FOB (arredondado para longe de zero), finding `NOTIONAL_INSURANCE_APPLIED`.
- [ ] `InsuranceAmountMinor == 0` **explicitamente informado** → usa zero como está, **sem** finding nocional (diferente de null — caso fácil de implementar errado com `??`).
- [ ] `InsuranceAmountMinor > 0` informado → usa o valor como está.

### Rateio (freight e insurance)
- [ ] Rateio normal por peso bruto (2+ linhas, pesos diferentes) — bate com o exemplo do enunciado.
- [ ] **Resíduo do rateio por peso** vai para a linha de maior peso bruto.
- [ ] **Empate de peso bruto entre duas linhas** → resíduo vai para a linha de **menor número**.
- [ ] **Peso bruto total = 0 em todas as linhas** → cai para rateio por valor FOB, finding `APPORTIONED_BY_VALUE`, resíduo para a linha de maior FOB (com mesmo desempate por menor número em caso de empate).
- [ ] **Peso bruto total = 0 E FOB total = 0** → rateio igualitário, finding `APPORTIONED_EQUALLY`, resíduo para a linha de menor número.
- [ ] **Freight e insurance rateados separadamente** — construir um caso onde o resíduo do freight e o do insurance caem em linhas diferentes (não assumir que são sempre a mesma linha).

### Resultado
- [ ] Cada linha: `FOB + freight rateado + insurance rateado = customs value da linha`.
- [ ] Customs value da declaração = soma exata dos customs values das linhas.
- [ ] **Teste de integração com o exemplo do enunciado** (NTX-2026-0417): reproduzir os valores intermediários dados (taxa FX 52340, seguro nocional 15500 cents, FOB em céntimos 649016000, freight 45012400, insurance 8112700, shares de freight 13503720/31508680, customs value linha 1 = 486997530) e derivar/validar a linha 2 e os totais — serve como teste de regressão fim a fim.

---

## 4. `IDutyAssessmentEngine.Assess(DutyAssessmentRequest? request)`

### Entrada inválida
- [ ] `request` nulo → tudo zero, `INVALID_REQUEST`
- [ ] `Valuation` nulo → tudo zero, `INVALID_REQUEST`
- [ ] `Valuation` sem linhas → tudo zero, `INVALID_REQUEST`

### De minimis (checado primeiro, para a declaração toda)
- [ ] Regime `Courier` + valor total ≤ ₡30.000 (3.000.000 céntimos) → tudo zero, `DE_MINIMIS_APPLIED`, **nenhum** outro finding calculado (nem `HS_CODE_NOT_IN_TARIFF` etc. — confirmar que o cálculo realmente para aí).
- [ ] Regime `Courier` + valor **exatamente** ₡30.000 → aplica (limite é "≤").
- [ ] Regime `Courier` + valor ₡30.000,01 (3.000.001 céntimos) → **não** aplica, segue fluxo normal.
- [ ] Regime diferente de `Courier` (ex.: `General`) com valor baixíssimo → de minimis nunca se aplica, independente do valor.

### DAI (direito de importação)
- [ ] HS-6 presente na tabela → taxa geral aplicada normalmente.
- [ ] HS-6 **ausente** da tabela → taxa DAI = 0, taxa SCT = 0, finding `HS_CODE_NOT_IN_TARIFF`, linha ainda é avaliada (demais encargos continuam sendo calculados).

### Preferência tarifária (árvore de decisão completa)
- [ ] Todas as 4 condições verdadeiras → taxa preferencial substitui a geral, finding `PREFERENCE_APPLIED`.
- [ ] Condições 1 e 4 verdadeiras, mas `HasOriginCertificate == false` → taxa geral, `PREFERENCE_DENIED_NO_CERTIFICATE`.
- [ ] Condições 1 e 4 verdadeiras, `HasOriginCertificate == true`, mas `CertificateIssuedUtc == null` → também deveria cair em "certificado ausente" — testar explicitamente essa combinação (é ambígua na leitura literal do enunciado; documentar a suposição).
- [ ] Certificado emitido **no futuro** em relação à data da declaração → `PREFERENCE_DENIED_CERTIFICATE_EXPIRED`.
- [ ] Certificado emitido há **mais de 365 dias** da data da declaração → `PREFERENCE_DENIED_CERTIFICATE_EXPIRED`.
- [ ] Certificado emitido **exatamente 365 dias** antes → limite, ainda válido (não expirado).
- [ ] Certificado emitido **no mesmo dia** da declaração (0 dias) → válido.
- [ ] País de origem **não é parte** de nenhum acordo em vigor (condição 1 falsa) → taxa geral, e **sem** finding de `PREFERENCE_DENIED_*` (só se aplica quando 1 e 4 já se sustentam — checar se a implementação não gera finding indevido aqui).
- [ ] Condição 1 verdadeira mas **sem linha em trade-preferences.csv** para aquele acordo+HS-6 (condição 4 falsa), mesmo com certificado válido → taxa geral, sem finding de denied.
- [ ] País parte de **dois ou mais acordos** cobrindo o mesmo HS-6 → usa a **menor** taxa preferencial disponível entre eles.
- [ ] Acordo existe mas **não está em vigor** na data da declaração → condição 1 falha, taxa geral.

### Lei 6946
- [ ] Cálculo normal: 1% do customs value da linha.
- [ ] HS-6 marcado como `law6946Exempt = true` → levy zero, finding `LAW6946_EXEMPT`.

### SCT (imposto seletivo de consumo)
- [ ] Base do SCT **inclui o DAI** já calculado (base em cascata) — teste que comprova que mudar o DAI muda o SCT mesmo com customs value fixo.
- [ ] HS-6 ausente da tabela → SCT = 0 (coberto por `HS_CODE_NOT_IN_TARIFF`, mas vale reafirmar aqui).

### Antidumping
- [ ] Medida corresponde a HS-6 + país de origem e data cai **dentro** de `[inForceFrom, inForceTo]` (ambos inclusive) → surcharge aplicado, `ANTIDUMPING_APPLIED`.
- [ ] `inForceTo` vazio (medida sem prazo) → aplica se a data ≥ `inForceFrom`, sem limite superior.
- [ ] Data da declaração **antes** de `inForceFrom` → não aplica.
- [ ] Data da declaração **depois** de `inForceTo` (quando preenchido) → não aplica.
- [ ] Data da declaração **exatamente igual** a `inForceFrom` ou a `inForceTo` → aplica (limites inclusive).
- [ ] Antidumping **não entra na base do VAT** — teste que remove o antidumping do cálculo do IVA mesmo quando presente.

### VAT (IVA)
- [ ] Base = customs value + DAI + Lei 6946 + SCT (sem antidumping), taxa 13%.

### Totais
- [ ] Total da linha = DAI + Lei 6946 + SCT + antidumping + VAT.
- [ ] Total da declaração por encargo = soma exata das linhas (sem novo arredondamento no nível de declaração).
- [ ] Total geral = soma exata dos totais de linha.
- [ ] **Múltiplas linhas com findings distintos na mesma declaração** (uma isenta de Lei 6946, outra com preferência aplicada, outra com HS não catalogado) — teste de integração garantindo que os findings não vazam entre linhas e que os totais continuam batendo.

---

## Observação para o README de submissão

Os pontos marcados acima como "ambíguos" (todas as peças inválidas → um finding ou vários; certificado com `HasOriginCertificate=true` mas `CertificateIssuedUtc=null`; ausência de finding quando só a condição 1 falha) valem uma linha explícita no README de suposições, como o enunciado pede — são exatamente os pontos onde a especificação deixa uma lacuna de interpretação.