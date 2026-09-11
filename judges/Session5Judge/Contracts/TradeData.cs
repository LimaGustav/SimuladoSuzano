using System.Globalization;
using Nortrans.Contracts;

namespace Nortrans.Services;

internal static class TradeData
{
    private static readonly Lazy<Data> Current = new(Load);

    internal static IReadOnlyDictionary<string, ContainerOwner> Owners => Current.Value.Owners;
    internal static IReadOnlyDictionary<string, SizeTypeInfo> SizeTypes => Current.Value.SizeTypes;
    internal static IReadOnlyDictionary<string, int> CompanyPrefixes => Current.Value.CompanyPrefixes;
    internal static IReadOnlyDictionary<string, HsLookup> Headings => Current.Value.Headings;
    internal static IReadOnlyDictionary<int, int> Sections => Current.Value.Sections;

    private static Data Load()
    {
        var data = new Data();
        foreach (var row in ReadCsv("iso6346-owner-codes.csv"))
            if (row.Length >= 3 && row[0].Length is 3 or 4)
                data.Owners[row[0].ToUpperInvariant()] = new ContainerOwner(row[0].ToUpperInvariant(), row[1], row[2].ToUpperInvariant());

        foreach (var row in ReadCsv("iso6346-size-type.csv"))
            if (row.Length >= 6 && int.TryParse(row[1], NumberStyles.None, CultureInfo.InvariantCulture, out var length))
                data.SizeTypes[row[0].ToUpperInvariant()] = new SizeTypeInfo(row[0].ToUpperInvariant(), length, row[2], row[3], row[4], bool.TryParse(row[5], out var refrigerated) && refrigerated);

        foreach (var row in ReadCsv("gs1-company-prefixes.csv"))
            if (row.Length >= 2 && row[0].All(char.IsDigit) && int.TryParse(row[1], NumberStyles.None, CultureInfo.InvariantCulture, out var length))
                data.CompanyPrefixes[row[0]] = length;

        foreach (var row in ReadCsv("hs-sections.csv"))
            if (row.Length >= 3 && int.TryParse(row[0], out var section) && int.TryParse(row[1], out var from) && int.TryParse(row[2], out var to))
                for (var chapter = from; chapter <= to; chapter++) data.Sections[chapter] = section;

        foreach (var row in ReadCsv("hs-headings.csv"))
            if (row.Length >= 3 && (row[0].Length == 4 || row[0].Length == 6) && row[0].All(char.IsDigit))
                data.Headings[row[0]] = new HsLookup(row[0], row[1], row[2]);

        return data;
    }

    private static IEnumerable<string[]> ReadCsv(string fileName)
    {
        var file = new[]
        {
            Path.Combine(AppContext.BaseDirectory, fileName),
            Path.Combine(AppContext.BaseDirectory, "assets", fileName),
            Path.Combine(Directory.GetCurrentDirectory(), "assets", fileName)
        }.FirstOrDefault(File.Exists);
        if (file is null) yield break;

        using var reader = new StreamReader(file);
        _ = reader.ReadLine(); // header
        string? line;
        while ((line = reader.ReadLine()) is not null)
            yield return ParseCsvLine(line).Select(value => value.Trim()).ToArray();
    }

    private static List<string> ParseCsvLine(string line)
    {
        var fields = new List<string>();
        var value = new System.Text.StringBuilder();
        var quoted = false;
        for (var i = 0; i < line.Length; i++)
        {
            if (line[i] == '"')
            {
                if (quoted && i + 1 < line.Length && line[i + 1] == '"') { value.Append('"'); i++; }
                else quoted = !quoted;
            }
            else if (line[i] == ',' && !quoted) { fields.Add(value.ToString()); value.Clear(); }
            else value.Append(line[i]);
        }
        fields.Add(value.ToString());
        return fields;
    }

    private sealed class Data
    {
        internal Dictionary<string, ContainerOwner> Owners { get; } = new(StringComparer.Ordinal);
        internal Dictionary<string, SizeTypeInfo> SizeTypes { get; } = new(StringComparer.Ordinal);
        internal Dictionary<string, int> CompanyPrefixes { get; } = new(StringComparer.Ordinal);
        internal Dictionary<string, HsLookup> Headings { get; } = new(StringComparer.Ordinal);
        internal Dictionary<int, int> Sections { get; } = [];
    }
}

public static class CodeText
{
    internal static string Normalise(string? value) => value is null ? string.Empty : new string(value.Where(c => c is not (' ' or '-' or '.')).Select(char.ToUpperInvariant).ToArray());
    internal static bool IsDigits(string value) => value.All(char.IsDigit);
}
