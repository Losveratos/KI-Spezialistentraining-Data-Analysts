# M1-13 · Modell KI-fähig machen („Prepare your data for AI“)

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook (Review, Entwurf) + Power BI Desktop „Prep data for AI“ (Umsetzung, nur mit Kapazität) | Ü1.12 | 10 min |

## Wofür
Copilot in Power BI, Agenten und andere KI-Werkzeuge antworten nur so gut, wie das Modell sie lässt: klare Namen,
Beschreibungen, ausgeblendete Technikspalten, eine markierte Datumstabelle, eindeutige Kennzahlen. Dieser Prompt
prüft Ihr Modell gegen die Microsoft-Empfehlungen und entwirft die drei Bausteine von **Prep data for AI**:
AI data schema (welche Felder Copilot nutzen soll), AI instructions (Fachsprache und Regeln) und Vorschläge für
verified answers (geprüfte Antworten auf Standardfragen).

## Was es in Power BI gibt (Stand 11/2026, Preview)
- **Prep data for AI** (deutsche Oberfläche ggf. „Daten für KI vorbereiten“): Schaltfläche im Menüband **Start** in Desktop
  bzw. auf der Seite des semantischen Modells im Service. Drei Registerkarten:
  - **AI data schema** („Simplify data schema“): Teilmenge der Tabellen, Spalten, Measures, die Copilot bevorzugt.
  - **AI instructions**: freier Text mit Geschäftskontext und Regeln, max. 10.000 Zeichen, gespeichert im Modell,
    für Endnutzer unsichtbar. Keine Garantie, dass Copilot sich daran hält.
  - **Verified answers**: an einem Visual (… › „Set up a verified answer“) mit Triggerphrasen und bis zu drei Filtern;
    Slicer werden nicht unterstützt.
- Voraussetzungen: **Q&A** muss für das Modell aktiviert sein (sonst sind die Registerkarten deaktiviert); Copilot in Desktop
  braucht einen Arbeitsbereich auf **Fabric-Kapazität F2+ oder Premium P1+** (bzw. eine Fabric Copilot capacity), keine
  Testkapazität, und die Freigabe durch den Fabric-Admin. In Desktop ggf. unter Optionen › Vorschaufeatures „Prep data for AI“ aktivieren.
- Im Service lässt sich das Modell danach als **Approved for Copilot** markieren.
- **Sprache:** Q&A und die Copilot-Datenfragen sind offiziell nur für Englisch freigegeben; Q&A wird im Februar 2027 eingestellt.
  Für das deutschsprachige Übungsmodell (Kultur de-DE) vorab testen, ob die Registerkarten nutzbar sind.

**Ohne Kapazität (der Weg für dieses Training):** Review und Entwürfe entstehen im M365 Copilot. Umsetzen können Sie
alles, was im Modell selbst steht (Namen, Beschreibungen, Ausblenden, Datumstabelle, Sortierung) per TMDL-Ansicht oder
Modellansicht. Die AI-Instructions legen Sie als Textdatei zum Modell bzw. ins Glossar und tragen sie ein, sobald
Prep data for AI bei Ihnen freigeschaltet ist.

## Vorbereitung
- TMDL des Modells ohne Partitionen (wie M1-01) **oder** Ergebnisse der Abfragen 1–4 und 6 aus `INFO_Abfragen.dax`.
- **K05** (Kennzahlen-Glossar) als fachliche Grundlage, optional Ihre typischen Nutzerfragen (5–10 Stück).
- Datenschutz: nur Metadaten und Glossar; unternehmensfreigegebenen Copilot nutzen.

## Prompt
```text
Du bist Power-BI-Architekt und bereitest ein semantisches Modell für Copilot in Power BI und KI-Agenten vor.
Maßstab sind die Microsoft-Empfehlungen „Prepare your data for AI“ und „Update your data model to work well with Copilot“:
eindeutige, sprechende Namen; Beschreibungen für Tabellen, Spalten, Measures; technische Spalten ausblenden;
keine summierten IDs; markierte Datumstabelle; Sortierspalten; Sternschema; explizite Measures statt impliziter
Aggregation; AI data schema, AI instructions, verified answers.

Kontext:
- Modell (TMDL ohne Partitionen oder INFO.VIEW-Listen): [EINFÜGEN]
- Fachliche Definitionen und Begriffe: [EINFÜGEN: Glossar K05]
- Typische Fragen der Nutzer: [EINFÜGEN: 5–10 Fragen oder „keine, bitte vorschlagen“]

Aufgabe:
1. Review: Tabelle „Nr | Objekt | Befund | Empfehlung | Umsetzung in (Modellansicht / TMDL-Ansicht / Prep data for AI) | Priorität“.
   Belege jeden Befund mit dem Objekt aus dem Kontext.
2. AI data schema: Welche Tabellen, Spalten und Measures sollen in die Auswahl, welche nicht – mit Begründung.
3. AI instructions: Entwurf auf Deutsch, gegliedert in „Kennzahlen“, „Zeit“, „Begriffe und Synonyme“, „Mehrdeutigkeiten“,
   „Analyseregeln“. Kurze, eindeutige Sätze, Measure-Namen in eckigen Klammern, höchstens 3.000 Zeichen.
4. Verified answers: 3–5 Standardfragen, je mit Triggerphrasen, passendem Visual (Typ, Felder) und sinnvollen Filtern.

Regeln:
- Nur Objekte aus dem Kontext verwenden; Umbenennungen als Vorschlag „alt → neu“ kennzeichnen.
- Instructions dürfen keine Regeln enthalten, die das Modell nicht abbildet (z. B. keine Geschäftsjahre, wenn es keine gibt).
- Unterscheide, was ohne Kapazität im Modell umsetzbar ist und was Prep data for AI braucht.

Ausgabe: Abschnitte 1–4 in Markdown, AI instructions zusätzlich als ```text-Block zum Kopieren,
am Ende „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn Sie die Modell-Korrekturen direkt umsetzen wollen:
```text
Erstelle für die Befunde [EINFÜGEN: Nummern] ein TMDL-Skript für die TMDL-Ansicht (createOrReplace, ref table …).
Ändere nur die betroffenen Eigenschaften, behalte alle übrigen Eigenschaften und lineageTags aus meinem Skript bei.
Basis ist dieses Skript aus der TMDL-Ansicht: [EINFÜGEN: Skript der betroffenen Tabelle ohne Partition]
```
Wenn die Instructions zu allgemein sind:
```text
Streiche jede Anweisung, die nicht auf ein konkretes Measure, eine Spalte oder einen Begriff aus unserem Modell verweist.
Ergänze für jede Kennzahl mit Schwelle (Krankenquote, Qualitätsquote, Kostenabweichung), ob hoch oder niedrig gut ist.
```
Wenn Sie die Instructions testen wollen (mit Kapazität):
```text
Formuliere 8 Testfragen, die genau eine Regel aus den AI instructions prüfen, und schreib zu jeder Frage, woran ich in
der Antwort erkenne, dass die Regel gewirkt hat.
```

## Ergebnis prüfen
- [ ] Review deckt die bekannten Schwächen ab: kryptischer Name, fehlende Beschreibungen, summierte sichtbare IDs, fehlende
      Sortierspalte, keine Datumstabelle, Zeitintelligenz auf Faktspalte (Gegenprobe: Abfrage 6 in `INFO_Abfragen.dax`).
- [ ] AI instructions verwenden nur existierende Measure-Namen; jede Regel ist im Modell nachvollziehbar.
- [ ] Länge der Instructions unter 10.000 Zeichen (Grenze in Power BI), besser deutlich kürzer.
- [ ] Mit Kapazität: Copilot-Bereich in Desktop schließen und neu öffnen, im Skill-Picker „Answer questions about the data“
      wählen und die Testfragen stellen. Antworten mit DAX-Abfrage gegenprüfen.
- [ ] Ohne Kapazität: Modellkorrekturen angewendet, Abfrage 5 und 6 zeigen weniger Treffer.

## Stolperfallen
- Prep data for AI ersetzt kein sauberes Modell: Ein Feld mit schlechtem Namen wird durch eine Instruction nicht eindeutig.
  Erst Namen, Beschreibungen, Ausblenden – dann Instructions.
- Änderungen an Schema, Instructions und verified answers wirken erst, wenn der Copilot-Bereich neu geöffnet wurde.
- Bei Bereitstellung über Git oder Deployment-Pipelines muss das Modell im Service aktualisiert werden, damit die Einstellungen greifen.
- Instructions sind Text für ein Sprachmodell, keine Programmlogik. Widersprüchliche oder sehr viele Regeln verschlechtern die Antworten.

## Quellen (Microsoft Learn, geprüft 18.11.2026)
- Prepare your data for AI: https://learn.microsoft.com/power-bi/create-reports/copilot-prepare-data-ai
- AI instructions: https://learn.microsoft.com/power-bi/create-reports/copilot-prepare-data-ai-instructions
- AI data schema: https://learn.microsoft.com/power-bi/create-reports/copilot-prepare-data-ai-data-schema
- Verified answers: https://learn.microsoft.com/power-bi/create-reports/copilot-prepare-data-ai-verified-answers
- Copilot in Power BI Desktop (Voraussetzungen): https://learn.microsoft.com/power-bi/create-reports/copilot-power-bi-desktop
- Copilot mit semantischen Modellen: https://learn.microsoft.com/power-bi/create-reports/copilot-semantic-models
- Modell für Copilot optimieren: https://learn.microsoft.com/power-bi/create-reports/copilot-evaluate-data
- Q&A-Einstellung (Februar 2027): https://learn.microsoft.com/power-bi/natural-language/q-and-a-tooling-intro
