using Nortrans.Contracts;
using Nortrans.Services;
using Xunit;

namespace Nortrans.Tests;

/// <summary>
/// Testes do enunciado do Módulo 2. Os Traits "Module 2" permitem filtrar no Test Explorer
/// por exemplo: Section = "5.2 - Check digit".
/// </summary>
public sealed class TradeCodeTests : ResultReportingTestBase
{
    private readonly ContainerCodeService _containers = new();
    private readonly SsccService _sscc = new();
    private readonly HsCodeService _hs = new();

    // §5.2: ISO 6346 — valores das letras, pesos 2^i e resto módulo 11.
    [Fact]
    [Trait("Module 2", "5.2 - Container check digit")]
    public Task Container_CheckDigit_Uses_Iso6346_Weights_And_Skipped_Values() => ReportAsync(nameof(Container_CheckDigit_Uses_Iso6346_Weights_And_Skipped_Values), () =>
    {
        Assert.Equal(6, _containers.ComputeCheckDigit("MSCU123456"));
        Assert.Equal(1, _containers.ComputeCheckDigit("ABCU000000"));
        Assert.Equal(-1, _containers.ComputeCheckDigit("MSCU12345X"));
    });

    // §5.1 and §5.3: composição do número, normalização e validação do dígito final.
    [Theory]
    [Trait("Module 2", "5.1/5.3 - Container structure and validation")]
    [InlineData("msc u-123456.6", true)]
    [InlineData("MSCU1234567", false)]
    [InlineData("MSCA1234566", false)]
    [InlineData("MSCU12345A6", false)]
    [InlineData("MSCU123456", false)]
    [InlineData("MSCU12345666", false)]
    public Task Container_Validates_Structure_And_CheckDigit(string input, bool expected) => ReportAsync($"{nameof(Container_Validates_Structure_And_CheckDigit)}({input})", () => Assert.Equal(expected, _containers.IsValidContainerNumber(input)));

    // §4 and §5.3: remover somente espaços, hífens e pontos; não validar nesta operação.
    [Theory]
    [Trait("Module 2", "4/5.3 - Container normalisation")]
    [InlineData("MSCU 123456 6", "MSCU1234566")]
    [InlineData("a-b.c d-e.f-g", "ABCDEFG")]
    [InlineData("MSCU123456", "")]
    [InlineData(null, "")]
    public Task Container_Normalise_Applies_Module_Rule(string? input, string expected) => ReportAsync($"{nameof(Container_Normalise_Applies_Module_Rule)}({input ?? "null"})", () => Assert.Equal(expected, _containers.Normalise(input)));

    // §5.1 / §5.3: a quarta letra determina a categoria.
    [Theory]
    [Trait("Module 2", "5.1/5.3 - Container category")]
    [InlineData("MSCU", ContainerCategory.FreightContainer)]
    [InlineData("ABCJ", ContainerCategory.DetachableEquipment)]
    [InlineData("ABCZ", ContainerCategory.TrailerOrChassis)]
    [InlineData("ABCA", ContainerCategory.Unknown)]
    [InlineData("ABC", ContainerCategory.Unknown)]
    public Task Container_Identifies_Category(string input, ContainerCategory expected) => ReportAsync($"{nameof(Container_Identifies_Category)}({input})", () => Assert.Equal(expected, _containers.GetCategory(input)));

    // §5.3: apresentação apenas de número válido.
    [Theory]
    [Trait("Module 2", "5.3 - Container formatting")]
    [InlineData("MSCU1234566", "MSCU 123456 6")]
    [InlineData("MSCU1234567", "")]
    [InlineData(null, "")]
    public Task Container_Formats_Only_Valid_Numbers(string? input, string expected) => ReportAsync($"{nameof(Container_Formats_Only_Valid_Numbers)}({input ?? "null"})", () => Assert.Equal(expected, _containers.FormatContainerNumber(input)));

    // §5.3: consultas nas duas tabelas CSV publicadas.
    [Fact]
    [Trait("Module 2", "5.3 - Container CSV lookups")]
    public Task Container_Uses_Published_Lookup_Tables() => ReportAsync(nameof(Container_Uses_Published_Lookup_Tables), () =>
    {
        Assert.Equal("Mediterranean Shipping Company", _containers.LookupOwner("msc u1234566")?.OwnerName);
        Assert.Null(_containers.LookupOwner("ZZZU1234566"));
        Assert.Null(_containers.LookupOwner("ABC"));
        var sizeType = _containers.LookupSizeType("22r1");
        Assert.Equal(20, sizeType?.LengthFt);
        Assert.True(sizeType?.Refrigerated);
        Assert.Null(_containers.LookupSizeType("99ZZ"));
    });

    // §6.2: GS1 modulo 10, com peso 3 no dígito de dados mais à direita.
    [Theory]
    [Trait("Module 2", "6.2 - SSCC check digit")]
    [InlineData("00000000000000000", 0)]
    [InlineData("11111111111111111", 5)]
    [InlineData("30614141123456789", 1)]
    public Task Sscc_Computes_Gs1_Modulo10_CheckDigit(string dataDigits, int expected) => ReportAsync($"{nameof(Sscc_Computes_Gs1_Modulo10_CheckDigit)}({dataDigits})", () => Assert.Equal(expected, _sscc.ComputeCheckDigit(dataDigits)));

    // §6.3: só 18 dígitos, normalizados, com check digit correto.
    [Theory]
    [Trait("Module 2", "6.3 - SSCC validation")]
    [InlineData("3 0614141-123456789.1", true)]
    [InlineData("306141411234567892", false)]
    [InlineData("30614141123456789", false)]
    [InlineData("3061414112345678910", false)]
    [InlineData("3061414112345678X1", false)]
    public Task Sscc_Validates_Length_Digits_And_CheckDigit(string input, bool expected) => ReportAsync($"{nameof(Sscc_Validates_Length_Digits_And_CheckDigit)}({input})", () => Assert.Equal(expected, _sscc.IsValidSscc(input)));

    // §6.3: prefixo conhecido é separado; prefixo ausente permanece no bloco central.
    [Fact]
    [Trait("Module 2", "6.3 - SSCC parsing and formatting")]
    public Task Sscc_Parses_And_Formats_Known_And_Unknown_Prefixes() => ReportAsync(nameof(Sscc_Parses_And_Formats_Known_And_Unknown_Prefixes), () =>
    {
        const string code = "306141411234567891";
        var parts = _sscc.Parse(code);
        Assert.Equal(3, parts?.ExtensionDigit);
        Assert.Equal("0614141", parts?.CompanyPrefix);
        Assert.Equal("123456789", parts?.SerialReference);
        Assert.Equal(1, parts?.CheckDigit);
        Assert.Equal("(00) 3 0614141 123456789 1", _sscc.FormatSscc(code));
        var unknownPrefixCode = _sscc.BuildSscc(0, "999999", 1);
        Assert.Equal($"(00) 0 {unknownPrefixCode.Substring(1, 16)} {unknownPrefixCode[17]}", _sscc.FormatSscc(unknownPrefixCode));
    });

    // §6.3: extensão, prefixo, serial negativo, limite e padding com zeros à esquerda.
    [Theory]
    [Trait("Module 2", "6.3 - SSCC build boundaries")]
    [InlineData(3, "0614141", 123456789L, "306141411234567891")]
    [InlineData(10, "0614141", 1L, "")]
    [InlineData(3, "06141", 1L, "")]
    [InlineData(3, "0614141", -1L, "")]
    [InlineData(3, "0614141", 1000000000L, "")]
    [InlineData(0, "040000", 1L, "004000000000000015")]
    public Task Sscc_Build_Enforces_Boundaries(int extension, string prefix, long serial, string expected) => ReportAsync($"{nameof(Sscc_Build_Enforces_Boundaries)}({extension},{prefix},{serial})", () => Assert.Equal(expected, _sscc.BuildSscc(extension, prefix, serial)));

    // §7.1 / §7.2: tamanhos permitidos, capítulo e códigos publicados de heading/subheading.
    [Theory]
    [Trait("Module 2", "7.1/7.2 - HS validation")]
    [InlineData("8471.30", true)]
    [InlineData("84713000", true)]
    [InlineData("8471300000", true)]
    [InlineData("771300", false)]
    [InlineData("001300", false)]
    [InlineData("981300", false)]
    [InlineData("847199", false)]
    [InlineData("8471300", false)]
    public Task Hs_Validates_Length_Chapter_And_Published_Levels(string input, bool expected) => ReportAsync($"{nameof(Hs_Validates_Length_Chapter_And_Published_Levels)}({input})", () => Assert.Equal(expected, _hs.IsValidHsCode(input)));

    // §7.2: pontos nos limites 4/6/8 e breakdown dos níveis nacionais/estatísticos.
    [Fact]
    [Trait("Module 2", "7.2 - HS breakdown and dotted format")]
    public Task Hs_Formats_And_Breaks_Down_All_Valid_Lengths() => ReportAsync(nameof(Hs_Formats_And_Breaks_Down_All_Valid_Lengths), () =>
    {
        Assert.Equal("8471.30", _hs.FormatDotted("847130"));
        Assert.Equal("8471.30.00", _hs.FormatDotted("84713000"));
        Assert.Equal("8471.30.00.00", _hs.FormatDotted("8471300000"));
        Assert.Equal("", _hs.FormatDotted("847199"));
        var sixDigits = _hs.Breakdown("090111");
        Assert.Equal("", sixDigits?.NationalLine);
        Assert.Equal("", sixDigits?.StatisticalLine);
        Assert.Equal(2, sixDigits?.Section);
        var tenDigits = _hs.Breakdown("8471300000");
        Assert.Equal("00", tenDigits?.NationalLine);
        Assert.Equal("00", tenDigits?.StatisticalLine);
        Assert.Equal(16, tenDigits?.Section);
    });

    // §7.2: subheading tem prioridade; heading é fallback; Search é ordinal/case-insensitive e ordenada.
    [Fact]
    [Trait("Module 2", "7.2 - HS lookup and search")]
    public Task Hs_Looks_Up_And_Searches_Published_Descriptions() => ReportAsync(nameof(Hs_Looks_Up_And_Searches_Published_Descriptions), () =>
    {
        Assert.Equal("subheading", _hs.Lookup("847130")?.Level);
        Assert.Equal("heading", _hs.Lookup("8471")?.Level);
        Assert.Null(_hs.Lookup("0000"));
        var results = _hs.Search("COFFEE");
        Assert.True(results.Count >= 3);
        Assert.Equal("0901", results[0].Code);
        Assert.All(results, result => Assert.Contains("coffee", result.Description, StringComparison.OrdinalIgnoreCase));
        Assert.Empty(_hs.Search(" "));
        Assert.Empty(_hs.Search(null));
    });

    // §4: todo membro público deve rejeitar entrada malformada, jamais lançar exceção.
    [Theory]
    [Trait("Module 2", "4 - Never throw on malformed input")]
    [MemberData(nameof(MalformedValues))]
    public Task All_Public_Methods_Reject_Malformed_Input_Without_Throwing(string? value) => ReportAsync($"{nameof(All_Public_Methods_Reject_Malformed_Input_Without_Throwing)}({value ?? "null"})", () =>
    {
        _ = _containers.IsValidContainerNumber(value); _ = _containers.ComputeCheckDigit(value); _ = _containers.Normalise(value); _ = _containers.GetCategory(value); _ = _containers.FormatContainerNumber(value); _ = _containers.LookupOwner(value); _ = _containers.LookupSizeType(value);
        _ = _sscc.IsValidSscc(value); _ = _sscc.ComputeCheckDigit(value); _ = _sscc.FormatSscc(value); _ = _sscc.BuildSscc(0, value, 0); _ = _sscc.Parse(value);
        _ = _hs.IsValidHsCode(value); _ = _hs.Breakdown(value); _ = _hs.FormatDotted(value); _ = _hs.Lookup(value); _ = _hs.Search(value);
    });

    public static IEnumerable<object?[]> MalformedValues => new object?[][]
    {
        new object?[] { null }, new object?[] { string.Empty }, new object?[] { " " }, new object?[] { "-." },
        new object?[] { "ABC" }, new object?[] { "💥" }, new object?[] { new string('9', 100) }
    };
}
