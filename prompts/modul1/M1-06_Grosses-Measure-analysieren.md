# M1-06 · Großes Measure analysieren

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook (alternativ: „Diese Abfrage erklären“ in der DAX-Abfrageansicht, sofern Kapazität vorhanden) | Ü1.6 | 8 min |

## Wofür
Bevor Sie ein langes, gewachsenes Measure ändern, müssen Sie es verstehen: Welche Regeln stecken drin, in welcher
Reihenfolge greifen sie, was passiert bei leeren Werten, welche Measures gibt es schon für dieselbe Rechnung?
Copilot zerlegt das Measure in eine Entscheidungstabelle und markiert Risiken. Beispiel: `KPI Status Text`.

## Vorbereitung
- Code des Measures (TMDL-Ansicht oder Bearbeitungsleiste).
- **Liste der vorhandenen Measures mit DAX** (TMDL der Tabelle `Fakt_Leistung` ohne Partition, oder Abfrage 3 aus
  `INFO_Abfragen.dax`) – nur so kann Copilot Duplikate zu vorhandenen Measures erkennen.
- Optional: **K05** (Kennzahlen-Glossar) – dann kann Copilot die Logik mit der fachlichen Definition abgleichen.
- Datenschutz: nur Code und Metadaten; unternehmensfreigegebenen Copilot nutzen.

## Prompt
```text
Du bist DAX-Experte und analysierst ein bestehendes Measure, bevor es überarbeitet wird.

Kontext:
- Vorhandene Measures im Modell (Name und DAX): [EINFÜGEN: TMDL der Tabelle oder Measure-Liste]
- Fachliche Definition, falls vorhanden: [EINFÜGEN: Auszug aus K05 oder „keine“]
- Zu analysierendes Measure:
[EINFÜGEN: Code von KPI Status Text]

Aufgabe:
1. Beschreibe in 3–5 Sätzen, was das Measure fachlich liefert.
2. Erstelle eine Entscheidungstabelle: Reihenfolge | Bedingung (fachlich formuliert) | Ergebnis.
3. Liste jeden Teilausdruck, der mehrfach vorkommt, mit Anzahl der Vorkommen und dem vorhandenen Measure,
   das dasselbe berechnet (falls es eins gibt).
4. Liste alle Konstanten (Schwellenwerte, Texte) mit ihrer fachlichen Bedeutung.
5. Analysiere das Verhalten bei Sonderfällen: Plan Kosten = 0 oder leer, keine Qualitätsprüfungen, Monat ohne Daten,
   Gesamtzeile. Welches Ergebnis liefert das Measure jeweils, und ist das fachlich gewollt?
6. Prüfe den Filterkontext: Welche Tabellen filtern welche Teile der Rechnung (z. B. wirkt der Kalender auf Massnahmen)?

Regeln:
- Verändere den Code nicht. Erst verstehen, dann ändern.
- Wo du das Verhalten nicht sicher aus dem Code ableiten kannst, schreib „prüfen in der DAX-Abfrageansicht“
  und schlag eine kurze Testabfrage vor.

Ausgabe: Markdown mit den Abschnitten 1–6, danach „Risiken (priorisiert)“ und „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn die Sonderfälle oberflächlich bleiben:
```text
Rechne die Sonderfälle konkret durch: Welchen Wert hat jeder Teilausdruck, wenn Ist und Plan leer sind
(Monat ohne Faktdaten), und welcher Zweig des IF greift dann? Begründe mit dem Verhalten von BLANK in DAX
bei Vergleichen (BLANK < 0.9).
```
Wenn Sie das Ergebnis als Dokumentation brauchen:
```text
Formuliere aus der Entscheidungstabelle eine Beschreibung für das Measure (höchstens 2 Sätze, ohne DAX-Begriffe)
und einen Absatz für die Modelldokumentation.
```
Wenn Sie die Analyse mit Daten belegen wollen:
```text
Schreib eine DAX-Abfrage für die DAX-Abfrageansicht, die je Region für Oktober 2026 das Measure und alle
Teilergebnisse (Kostenabweichung in %, Qualitätsquote, Krankenquote, Anzahl verzögerter Maßnahmen) nebeneinander zeigt.
Verwende nur Namen aus dem Kontext.
```

## Ergebnis prüfen
- [ ] Entscheidungstabelle gegen den Code lesen: Reihenfolge der Zweige, `&&` vs. `||` richtig wiedergegeben?
- [ ] Zuordnung zu vorhandenen Measures stimmt: `[Abw Kosten %]`, `[m_QQ]`, `[Krankenquote]` rechnen exakt dasselbe?
- [ ] Sonderfall-Aussagen mit Testabfrage geprüft (`INFO_Abfragen.dax`, Abfrage 9, oder Copilots Vorschlag).
- [ ] Konstanten entsprechen dem Glossar (K05): 5 %, 90 %, 8 %.

## Stolperfallen
- Copilot beschreibt gern, was ein Measure tun *sollte*, statt was es tut. Darum Entscheidungstabelle und Sonderfälle erzwingen.
- BLANK-Verhalten wird häufig falsch erklärt: In Vergleichen wird BLANK wie 0 behandelt (`BLANK < 0.9` ist wahr).
- Ohne die Liste vorhandener Measures schlägt Copilot neue Hilfs-Measures vor, statt vorhandene wiederzuverwenden.
