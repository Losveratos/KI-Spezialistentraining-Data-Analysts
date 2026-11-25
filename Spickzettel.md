# Spickzettel · Copilot in der Power-BI-Entwicklung

Alles Wichtige auf zwei Seiten. Details stehen in den [Leitfäden](leitfaeden/README.md) und
[Prompt-Dateien](prompts/). Stand: November 2026.

## 1 · Der Arbeitsablauf

```
Kontext geben  →  eine Aufgabe stellen  →  Ergebnis prüfen  →  erst dann übernehmen
(TMDL, Glossar)   (Prompt mit Regeln)      (ausführen, zählen, gegenlesen)
```

**Merksatz:** Copilot weiß nichts über Ihr Modell, das nicht im Prompt oder in einer angehängten Datei steht.
Den Rest errät es – und klingt dabei sicher.

## 2 · Ein guter Prompt hat sechs Bausteine

| Baustein | Beispiel |
|---|---|
| **Rolle** | „Du bist erfahrene*r Power-BI-Entwickler*in im Produktionscontrolling.“ |
| **Kontext** | TMDL-Ausschnitt, Code, Tabelle – echte Namen statt Beschreibung |
| **Aufgabe** | ein Verb: formatiere · erkläre · finde Fehler · schlage vor |
| **Regeln** | „Verwende nur Objekte aus dem Kontext. Ändere die Logik nicht.“ |
| **Ausgabeformat** | „Ein Codeblock, danach höchstens 5 Stichpunkte.“ |
| **Rückfrage-Klausel** | „Wenn Informationen fehlen, frag nach statt zu raten. Liste deine Annahmen auf.“ |

Eine Aufgabe pro Prompt. Wiederkehrende Regeln einmal als Datei im **Copilot Notebook** hinterlegen
([Kontextdateien K01–K05](prompts/kontext/README.md)).

## 3 · Welcher Copilot wofür

| Aufgabe | Erste Wahl | Voraussetzung |
|---|---|---|
| Code erklären, formatieren, verbessern (DAX, M, SQL, TMDL) | Microsoft 365 Copilot Chat oder Notebook | Microsoft-365-Copilot-Zugang mit Unternehmenskonto |
| Wiederkehrende Arbeit mit festen Regeln | Copilot Notebook mit Kontextdateien | Notebooks freigeschaltet |
| Daten rechnen: Profil, Korrelation, Plausibilität | Analyst-Agent oder Copilot in Excel | Microsoft-365-Copilot-Lizenz |
| DAX-Abfragen direkt am Modell, Berichtszusammenfassung | Copilot in Power BI | Arbeitsbereich auf bezahlter Fabric-Kapazität (ab F2) oder Premium (ab P1), Freigabe durch den Admin. **Testkapazitäten reichen nicht** – außer Ihnen ist eine Fabric-Copilot-Kapazität zugewiesen. |

Kein Zugang zu Copilot in Power BI? Jede Aufgabe aus diesem Training geht auch mit Microsoft 365 Copilot und eingefügtem Kontext.

## 4 · Halluzinationen erkennen – und verhindern

| Warnsignal | Gegenmittel |
|---|---|
| Spalten oder Measures, die es im Modell nicht gibt | TMDL mitgeben; Namen per Strg+F im TMDL suchen |
| Funktionen, die es nicht gibt (`DATEDIFFMONTH`, `PERCENTCHANGE`, `ISNULL`, `SUMIF`) | in der DAX-Abfrageansicht ausführen; in der DAX-Referenz nachschlagen |
| Glatte Zahlen ohne Quelle | rechnen lassen (Excel, Analyst) statt schätzen; jede Zahl nachsehen |
| Ursachen ohne Beleg („wegen der Tarifrunde“) | „Trenne Beobachtung und Vermutung“ in den Prompt |
| Sehr sichere Sprache („eindeutig“) | im **neuen Chat** gegenprüfen lassen ([M1-02](prompts/modul1/M1-02_Halluzinationen-gegenpruefen.md)) |

## 5 · TMDL – das Modell als Text

- **Holen:** Power BI Desktop › TMDL-Ansicht (TMDL view) › Objekte aus dem Datenbereich in den Editor ziehen › kopieren.
- **Geben:** Tabellen, Measures, Beziehungen – **ohne** `partition`- und `expression`-Blöcke (dort stecken Daten und Verbindungen).
- **Zurückschreiben:** kleines Skript › Vorschau (Preview) › Anwenden (Apply). Vorher sichern. Nie das ganze Modell auf einmal.
- **Fallen:** Einrückung mit Tabs · `///`-Beschreibung direkt über dem Objekt, keine Leerzeile dazwischen · `lineageTag` nie erfinden lassen ·
  `createOrReplace` ersetzt das ganze Objekt · Umbenennen im Datenbereich, nicht im Skript (Berichte hängen an den Namen).

Mehr: [K03 TMDL-Kurzreferenz](prompts/kontext/K03_TMDL-Kurzreferenz.md) · [L03 TMDL](leitfaeden/L03_TMDL.md)

## 6 · DAX – die acht Regeln

1. Kennzahlen als **explizite Measures**, nicht als berechnete Spalte.
2. **`DIVIDE ( Zähler, Nenner )`** statt `/`.
3. Zwischenergebnisse als **`VAR`**, vorhandene Measures wiederverwenden.
4. Filter als **Spaltenprädikat** in `CALCULATE`, nicht `FILTER ( ganze Tabelle )`.
5. **Zeitintelligenz nur über die Kalendertabelle**, die als Datumstabelle markiert ist.
6. **BLANK nicht in 0 verwandeln** – sonst zeigen Visuals alle Kombinationen und werden langsam.
7. Mehr als zwei `IF`-Stufen → **`SWITCH ( TRUE (), … )`**; Schwellenwerte einmal als `VAR` mit Kommentar.
8. Jede Änderung in der **DAX-Abfrageansicht testen**: alt gegen neu, Zeile für Zeile.

```dax
DEFINE MEASURE Fakt_Leistung[Neu] = DIVIDE ( [Abw Kosten], [Plan Kosten] )
EVALUATE
SUMMARIZECOLUMNS ( Region[Region], Kalender[Monat], "Alt", [Abw Kosten %], "Neu", [Neu] )
```

Mehr: [K02 DAX-Styleguide](prompts/kontext/K02_DAX-Styleguide.md) · [L02 DAX](leitfaeden/L02_DAX.md)

## 7 · Power Query – die sechs Regeln

1. **Query Folding nachweisen** („Native Abfrage anzeigen“ / View Native Query) – bei DirectQuery muss alles falten.
2. Typumwandlung aus Text **immer mit Kultur** (`"de-DE"` für 1.234,56 aus SAP-Exporten).
3. Pfade, Server, Datenbanken als **Parameter**.
4. Spalten **per Name**, nie per Position; benötigte Spalten früh auswählen.
5. **Fehler sichtbar lassen** – keine stillen `try … otherwise null` über ganze Spalten.
6. `Table.Buffer` ist kein Turbo; gemeinsame Logik gehört in die Quelle (View) oder einen Dataflow.

Mehr: [L01 Power Query](leitfaeden/L01_Power-Query.md)

## 8 · KPI-Kommentar – erst prüfen, dann schreiben

**Vorher:** Datenprofil und Plausibilitätscheck (Ausreißer, Dubletten, Lücken) – [M2-03](prompts/modul2/M2-03_Datenprofil-und-Plausibilitaetscheck.md).

**Aufbau:** Aussage zuerst → Zahl mit Vergleich (IST gegen PL und VJ, absolut und in %) → Ursache nur mit Beleg →
Handlungsbedarf. Höchstens drei Punkte. Quoten in **Prozentpunkten** vergleichen.

**Danach:** Faktencheck im neuen Chat – jede Zahl gegen die Daten ([M2-10](prompts/modul2/M2-10_Faktencheck-Kommentar.md)).

Mehr: [K04 Kommentar-Leitfaden](prompts/kontext/K04_Kommentar-Leitfaden-KPI.md)

## 9 · Korrelation ist keine Ursache – fünf Fragen

| Frage | Prüfung |
|---|---|
| 1. Stabil? | Pearson gegen Spearman, mit und ohne Ausreißer |
| 2. Genug Daten? | bei rund 22 Monatswerten ist erst etwa \|r\| ≥ 0,42 von Zufall unterscheidbar – bei Trend oder Saison noch mehr nötig |
| 3. Drittvariable? | Saison, Trend, Größe – gemeinsame Ursache? |
| 4. Zeitliche Reihenfolge? | Lag-Analyse: Ursache vor oder mit der Wirkung |
| 5. Fachlicher Mechanismus? | plausible Kette, die der Fachbereich bestätigt |

Erst wenn alle fünf tragen: „passt zu“. Nie „verursacht“ ohne zusätzlichen Beleg.

## 10 · Vor dem Veröffentlichen – Kurzcheck

- [ ] Aktualisierung läuft, Datenstand im Bericht sichtbar
- [ ] Kalender als Datumstabelle markiert, ID-Spalten ausgeblendet, Measures mit Beschreibung und Format
- [ ] Zahlen gegen die Quelle abgeglichen (Summe, ein Monat, eine Region)
- [ ] Titel mit Aussage, Einheiten sichtbar, Filter nachvollziehbar
- [ ] Leistungsanalyse geprüft, RLS mit „Anzeigen als“ getestet
- [ ] Dokumentation und Ansprechperson hinterlegt

Vollständig: [L05 Checkliste Berichtsveröffentlichung](leitfaeden/L05_Checkliste-Berichtsveroeffentlichung.md)

## 11 · Prompt-Finder

| Ich will … | Datei |
|---|---|
| das Modell verstehen | [M1-01](prompts/modul1/M1-01_Modellueberblick-aus-TMDL.md) |
| DAX / M / SQL formatieren und kommentieren | [M1-03](prompts/modul1/M1-03_DAX-formatieren-kommentieren.md) · [M1-04](prompts/modul1/M1-04_M-formatieren-kommentieren.md) · [M1-05](prompts/modul1/M1-05_SQL-formatieren-kommentieren.md) |
| ein langes Measure verstehen und umbauen | [M1-06](prompts/modul1/M1-06_Grosses-Measure-analysieren.md) · [M1-07](prompts/modul1/M1-07_Measure-refaktorisieren-und-testen.md) |
| einen Fehler beheben | [M1-08](prompts/modul1/M1-08_Fehler-beheben.md) |
| aus einer unsauberen Excel- oder CSV-Datei eine Power-Query-Abfrage bauen | [M1-14](prompts/modul1/M1-14_Excel-Chaos-zu-Power-Query.md) |
| ein neues Measure schreiben lassen | [M1-09](prompts/modul1/M1-09_Measure-aus-TMDL-Kontext.md) |
| Modell oder Bericht dokumentieren | [M1-10](prompts/modul1/M1-10_Modell-dokumentieren.md) · [M1-11](prompts/modul1/M1-11_Bericht-dokumentieren.md) · [L04](leitfaeden/L04_Dokumentation-aus-TMDL.md) |
| Beschreibungen ins Modell bringen, Modell KI-fähig machen | [M1-12](prompts/modul1/M1-12_Beschreibungen-als-TMDL.md) · [M1-13](prompts/modul1/M1-13_Modell-KI-faehig-machen.md) |
| Daten an Copilot geben | [M2-01](prompts/modul2/M2-01_Daten-fuer-Copilot-bereitstellen.md) · [M2-02](prompts/modul2/M2-02_KPI-Export-per-DAX-Abfrage.md) |
| einen Kommentar entwerfen | [M2-04](prompts/modul2/M2-04_Kommentar-Kennzahlenuebersicht.md) · [M2-05](prompts/modul2/M2-05_Kommentar-Detailbericht.md) |
| Korrelationen finden und bewerten | [M2-06](prompts/modul2/M2-06_Korrelationen-finden.md) · [M2-07](prompts/modul2/M2-07_Korrelationen-bewerten.md) |
| Maßnahmen prüfen und kommentieren | [M2-08](prompts/modul2/M2-08_Massnahmentracking-Konsistenzcheck.md) · [M2-09](prompts/modul2/M2-09_Massnahmen-Statuskommentar-und-Wirkung.md) |
| das richtige Copilot-Werkzeug wählen, ein Notizbuch einrichten | [M3-01](prompts/modul3/M3-01_Chat-Notizbuch-oder-Agent.md) · [M3-02](prompts/modul3/M3-02_Notizbuch-fuer-Datenanalyse-einrichten.md) |
| mit Researcher recherchieren, mit Analyst rechnen | [M3-03](prompts/modul3/M3-03_Researcher-Recherche-mit-Quellen.md) · [M3-04](prompts/modul3/M3-04_Analyst-Datenanalyse-nachvollziehbar.md) |
| in Excel analysieren und gegen Regeln prüfen | [M3-05](prompts/modul3/M3-05_Excel-strukturierte-Analyse.md) · [M3-06](prompts/modul3/M3-06_Excel-Validierung-Regelkatalog.md) · [M3-07](prompts/modul3/M3-07_Excel-Pruefspalten-und-Formeln.md) |
| einen Bericht oder Foliensatz gegen seine Quelle prüfen | [M3-08](prompts/modul3/M3-08_Office-Dateien-gegeneinander-pruefen.md) |
| aus Excel-Daten Folien machen und prüfen | [M3-09](prompts/modul3/M3-09_Excel-zu-PowerPoint.md) · [M3-10](prompts/modul3/M3-10_PowerPoint-pruefen-und-nachschaerfen.md) |

---

**Datenschutz:** nur im freigegebenen Unternehmens-Copilot arbeiten, keine personenbezogenen Daten, keine
Verbindungszeichenfolgen in den Prompt. **Verantwortung:** Copilot schlägt vor, Sie prüfen und entscheiden.
