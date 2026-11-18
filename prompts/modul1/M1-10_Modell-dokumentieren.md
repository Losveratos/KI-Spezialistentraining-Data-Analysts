# M1-10 · Modell dokumentieren (TMDL + INFO.VIEW → Markdown)

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | DAX-Abfrageansicht + M365 Copilot Chat oder Notebook (Ergebnis in Word/Loop/Wiki) | Ü1.9 | 10 min |

## Wofür
Eine Modelldokumentation, die aus den **tatsächlichen Metadaten** entsteht: Die INFO.VIEW-Funktionen liefern Tabellen,
Spalten, Measures und Beziehungen als Ergebnisraster, Copilot macht daraus ein lesbares Markdown-Dokument mit
fachlichen Erklärungen. Weil die Listen aus dem Modell kommen, ist die Doku vollständig; Copilot ergänzt nur Text.

## Vorbereitung
- DAX-Abfrageansicht › neue Registerkarte › `uebungsdaten/modul1/INFO_Abfragen.dax` einfügen.
  Abfragen 1–4 nacheinander ausführen und je Ergebnis **Kopieren** (kopiert tabulatorgetrennt mit Überschriften).
  Alles in eine Textdatei `Modell-Metadaten.txt` einfügen, je Abschnitt eine Überschrift („## Tabellen“ …).
- Alternativ oder ergänzend: TMDL der Tabellen ohne Partitionen.
- Optional: **K05** (Kennzahlen-Glossar) für fachliche Definitionen; vorhandene Doku-Vorlage Ihres Teams.
- Datenschutz: Metadaten, keine Datenwerte. Bei echten Modellen Partitions-/Quellausdrücke nicht ungeprüft mitgeben
  (Server, Pfade). Unternehmensfreigegebenen Copilot nutzen.

## Prompt
```text
Du bist technischer Redakteur für Power-BI-Modelle und schreibst eine Modelldokumentation für Data Analysts
und Berichtsersteller.

Kontext:
- Metadaten des Modells aus INFO.VIEW.TABLES/COLUMNS/MEASURES/RELATIONSHIPS (maßgeblich):
  [EINFÜGEN: Inhalt von Modell-Metadaten.txt oder „siehe Anhang“]
- Fachliche Definitionen, falls vorhanden: [EINFÜGEN: Glossar K05 oder „keine“]
- Modellname und Zweck: [EINFÜGEN: z. B. DBS_Produktionscontrolling, Monatssteuerung der Leistungserbringung]

Aufgabe: Erstelle eine Dokumentation in Markdown mit diesen Abschnitten:
1. Zweck und Inhalt (3–5 Sätze), Datenstand/Zeitraum, falls aus den Metadaten ableitbar.
2. Tabellen: Name, Rolle (Fakt/Dimension), Zeilenbedeutung („eine Zeile = …“), Speichermodus.
3. Beziehungen: als Tabelle und als Mermaid-erDiagram.
4. Measures: Tabelle Name | fachliche Bedeutung | Einheit/Format | DAX (gekürzt auf die erste Zeile) | Ordner.
5. Spalten je Tabelle: nur sichtbare Spalten, mit Datentyp und Bedeutung.
6. Hinweise zur Nutzung (z. B. welche Datumsspalte für Zeitvergleiche, welche Spalten nicht aggregieren).
7. Lücken: Objekte ohne Beschreibung, unklare Namen, Auffälligkeiten (z. B. fehlende Sortierspalte, keine Datumstabelle).

Regeln:
- Jede Tabelle, Spalte und jedes Measure aus den Metadaten kommt genau einmal vor; nichts weglassen, nichts hinzufügen.
- Fachliche Bedeutungen, die du nur aus Namen oder DAX ableitest, kennzeichnest du mit „(abgeleitet)“.
  Stammt die Bedeutung aus einer Beschreibung oder dem Glossar, ohne Kennzeichnung.
- Wo du die Bedeutung nicht ableiten kannst: „unklar – bitte ergänzen“.

Ausgabe: ein Markdown-Dokument; am Ende „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn die Doku zu lang wird:
```text
Erstelle zusätzlich eine Kurzfassung für Berichtsersteller (eine Seite): nur sichtbare Measures nach Themen
gruppiert, je Measure ein Satz, und die drei wichtigsten Nutzungshinweise.
```
Wenn Sie prüfen wollen, ob alles enthalten ist:
```text
Zähle je Abschnitt die Objekte in deiner Doku und in den Metadaten. Liste jedes Objekt, das fehlt oder zusätzlich vorkommt.
```
Wenn Sie die Doku als Word-Dokument brauchen:
```text
Gib die Dokumentation so aus, dass ich sie in Word einfügen kann: Überschriften als Überschriften, Tabellen als Tabellen,
das Mermaid-Diagramm als Codeblock am Ende im Anhang.
```

## Ergebnis prüfen
- [ ] Vollständigkeit: Anzahl Measures, Tabellen und Beziehungen in der Doku = Zeilenzahl der Abfragen 1, 3, 4.
- [ ] Alle „(abgeleitet)“-Bedeutungen fachlich gegengelesen, besonders `m_QQ`, `KPI Status Text`, `Produktivitaet`.
- [ ] DAX-Auszüge sind wörtlich aus den Metadaten, nicht „verbessert“.
- [ ] Mermaid-Diagramm verwendet die exakten Namen (in einem Mermaid-Viewer oder VS Code prüfen, falls verfügbar).
- [ ] Lückenliste stimmt mit Abfrage 5 und 6 aus `INFO_Abfragen.dax` überein.

## Stolperfallen
- Die Spalte `Expression` in INFO.VIEW.MEASURES ist nur mit Schreibrechten gefüllt – bei Liveverbindung zu einem
  veröffentlichten Modell bleibt sie leer, und Copilot rät dann die Logik.
- Ergebnisraster zeigen Rohwerte; lange DAX-Ausdrücke mit Zeilenumbrüchen können beim Kopieren Zeilen verschieben. Bei
  großen Modellen lieber das TMDL der Measures verwenden.
- Eine Doku, die nicht aus dem Modell erzeugt wird, veraltet. Halten Sie die Abfragen als gespeicherte Registerkarte im
  PBIP (`DAXQueries`-Ordner) – dann ist die Doku bei jeder Version reproduzierbar.
- Ohne Beschreibungen im Modell bleibt jede Doku eine Ableitung. Nachhaltig ist: Beschreibungen ins Modell schreiben (M1-12).
