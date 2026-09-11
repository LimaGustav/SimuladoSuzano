import React, { useState } from 'react';

const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:5180').replace(/\/$/, '');
const formatDate = value => value ? new Intl.DateTimeFormat('pt-BR', { dateStyle: 'short', timeStyle: 'medium' }).format(new Date(value)) : '—';

export default function App() {
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [competitor, setCompetitor] = useState("")

  async function loadResults() {
    setLoading(true); setError('');
    try {
      const response = await fetch(`${apiBaseUrl}/api/test-results?competitor=${competitor}`);
      if (!response.ok) throw new Error(`A API respondeu com ${response.status}.`);
      const data = await response.json();
      setResults(Object.values(data).sort((a, b) => a.testName.localeCompare(b.testName)));
    } catch (exception) { setError(exception instanceof Error ? exception.message : 'Não foi possível buscar os resultados.'); }
    finally { setLoading(false); }
  }
  const passed = results.filter(result => result.outcome?.toLowerCase() === 'passed').length;
  const failed = results.filter(result => result.outcome?.toLowerCase() === 'failed').length;
  return <main className="page">
    <section className="panel">
      <header>
        <div className="field">
          <label htmlFor="competitor-input">Competidor</label>
          <div className="input-wrap">
            <input
              id="competitor-input"
              type="text"
              placeholder="Competidor"
              value={competitor}
              onChange={(e) => setCompetitor(e.target.value)}
              autoComplete="off"
            />
            {competitor && (
              <button
                type="button"
                className="clear-btn"
                onClick={() => setCompetitor('')}
                aria-label="Limpar campo"
              >
                ×
              </button>
            )}
          </div>
        </div>
        <p className="eyebrow">NORTRANS ONE</p>
        <h1>Resultados dos testes</h1>
        <p className="subtitle">Consulte o último resultado enviado por cada teste automatizado.</p>
      </header>
      <div className="actions">
        <button type="button" onClick={loadResults} disabled={loading}>{loading ? 'Buscando…' : 'Buscar resultados'}</button>
        {results.length > 0 && <span className="summary">{passed} aprovados · {failed} falharam</span>}
      </div>
      {error && <p className="message error">{error}</p>}
      {!error && !loading && results.length === 0 && <p className="message">Ainda não há resultados. Execute os testes e clique em buscar novamente.</p>}
      {results.length > 0 && <div className="result-list">{results.map(result => { const passedResult = result.outcome?.toLowerCase() === 'passed'; return <article className="result" key={result.testName}><div><h2>{result.testName}</h2><p>{result.durationMs} ms · {formatDate(result.occurredAtUtc)}</p>{result.error && <pre>{result.error}</pre>}</div><span className={`status ${passedResult ? 'passed' : 'failed'}`}>{passedResult ? 'Passou' : 'Falhou'}</span></article>; })}
      </div>}

    </section></main>;
}
