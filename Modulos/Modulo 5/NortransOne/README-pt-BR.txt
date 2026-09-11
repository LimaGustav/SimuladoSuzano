NORTRANS ONE - solução esqueleto

Solução fornecida para Module 2 - Trade Codes Library.

Projetos:
- Contracts : As interfaces e records contra os quais você programa. FIXO - não modificar.
- Services  : Onde ficam as suas implementações.

Para começar:

    dotnet restore
    dotnet build

Se o build for bem-sucedido, os pacotes NuGet estão no lugar. Se o restore falhar, avise o
organizador imediatamente - não instale pacotes por conta própria.

Regras tiradas do documento do módulo:
- Implemente exatamente uma classe por interface. Se várias classes implementarem a mesma interface,
  apenas a primeira em ordem alfabética é usada.
- Você pode escrever classes helper livremente.
- Nenhum membro lança exceção diante de entrada malformada. Retorne o valor de rejeição documentado.
- O dinheiro é um número inteiro de unidades menores. Os pesos são gramas, as dimensões milímetros.
- Todos os instantes são UTC.
- Não renomeie nem mova as pastas.
