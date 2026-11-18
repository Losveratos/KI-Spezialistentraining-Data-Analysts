# M1-01 · Modellüberblick aus TMDL

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | Power BI Desktop (TMDL-Ansicht) + M365 Copilot Chat oder Notebook | Ü1.1 | 15 min |

## Wofür
Sie geben Copilot nicht eine Beschreibung des Modells, sondern **das Modell selbst** als Text. Copilot liefert
einen strukturierten Überblick (Tabellen, Beziehungen, Measures) und eine erste Liste von Schwachstellen –
mit Beleg aus dem TMDL. Das ist die Grundlage für alle weiteren Prompts in Modul 1.

## Vorbereitung
- Power BI Desktop › **TMDL-Ansicht** (linke Leiste). Im Datenbereich die Tabellen `Fakt_Leistung`, `Kalender`,
  `Region`, `Leistungsart`, `Massnahmen` mit gedrückter **Strg**-Taste markieren und in den Editor ziehen
  (oder Rechtsklick › TMDL skripten › Zwischenablage). Beziehungen ebenso aus dem Bereich **Beziehungen** ziehen.
- **Daten nicht mitkopieren:** Die Daten des Übungsmodells stecken in den Ausdrücken `Daten_Fakt_Leistung` und
  `Daten_Massnahmen` (Bereich **Ausdrücke**). Beim Skripten einzelner Tabellen sind sie nicht dabei. Skripten Sie das
  ganze Modell, löschen Sie die `expression Daten_…`-Blöcke aus der Kopie (nicht anwenden!) – sie sprengen sonst das
  Eingabelimit. Die `partition`-Blöcke können Sie ebenfalls löschen; in echten Modellen enthalten sie Server, Datenbanken
  und SQL – vorher prüfen.
- Längeren Text als `.txt` speichern und anhängen statt einfügen. Endungen wie `.tmdl` werden als Anhang
  nicht überall angenommen – im Zweifel in `.txt` umbenennen.
- Optional: **K03** (TMDL-Kurzreferenz) und **K05** (Kennzahlen-Glossar) anhängen bzw. im Notebook hinterlegen.
- Datenschutz: TMDL enthält Metadaten und DAX, bei eingebetteten Daten auch Werte. Nur im unternehmens-
  freigegebenen Copilot (Enterprise Data Protection) arbeiten. In echten Modellen vorher prüfen, ob Partitionen,
  Parameter oder Verbindungszeichenfolgen sensible Angaben enthalten.

## Prompt
```text
Du bist erfahrener Power-BI-Modellierer und prüfst ein semantisches Modell für ein Produktionscontrolling
(Dienstleister mit Reinigung, Sicherheit, Facility).

Kontext: Unten bzw. im Anhang steht das Modell als TMDL (Tabellen, Spalten, Measures, Beziehungen;
Datenausdrücke und Partitionen habe ich entfernt). [EINFÜGEN: TMDL-Text oder „siehe Anhang Modell.txt“]

Aufgabe:
1. Gib einen Überblick: je Tabelle Rolle (Fakt/Dimension/Sonstiges), Anzahl Spalten, wichtigste Spalten.
2. Liste alle Beziehungen als „Von-Tabelle[Spalte] → Nach-Tabelle[Spalte], Kardinalität, Filterrichtung“.
3. Liste alle Measures mit einem Satz zur Bedeutung. Wenn die Bedeutung aus Name und DAX nicht eindeutig
   ist, schreib „unklar“ statt zu raten.
4. Nenne Schwachstellen im Modell (Namen, Datentypen, Aggregation, Sortierung, Datumstabelle,
   Zeitintelligenz, DAX-Muster, fehlende Beschreibungen).

Regeln:
- Verwende ausschließlich Namen, die im TMDL stehen. Zitiere für jede Schwachstelle die betroffene
  TMDL-Zeile bzw. den Objektnamen als Beleg.
- Bewerte jede Schwachstelle mit Auswirkung (hoch/mittel/gering) und einem Satz „Warum“.
- Schlage noch keine Code-Änderungen vor.

Ausgabe: Markdown mit den Abschnitten „Tabellen“, „Beziehungen“, „Measures“, „Schwachstellen“
(Tabelle: Nr | Objekt | Schwachstelle | Beleg | Auswirkung | Warum), am Ende „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn die Schwachstellenliste zu allgemein ist (Lehrbuch statt Modell):
```text
Streiche alle Punkte, die du nicht mit einer konkreten Zeile aus meinem TMDL belegen kannst.
Prüfe zusätzlich gezielt: summarizeBy der ID-Spalten, sortByColumn bei Textspalten, dataCategory der
Kalendertabelle, welche Spalte in Zeitintelligenz-Funktionen verwendet wird, Divisionen mit "/".
```
Wenn Sie ein Bild der Struktur brauchen (z. B. für die Doku):
```text
Erstelle aus den Beziehungen ein Mermaid-erDiagram. Verwende exakt die Tabellen- und Spaltennamen aus dem TMDL.
```
Wenn Copilot Measures falsch deutet:
```text
Das Measure [m_QQ] bedeutet Qualitätsquote (bestandene / durchgeführte Prüfungen). Prüfe, welche weiteren
Measures du nur aus dem Namen gedeutet hast, und markiere sie.
```

## Ergebnis prüfen
- [ ] Jeder Tabellen-, Spalten- und Measure-Name im Ergebnis kommt im TMDL vor (Strg+F in der TMDL-Ansicht).
- [ ] Anzahl Measures und Beziehungen stimmt mit dem Modell überein (Gegenprobe: `INFO_Abfragen.dax`, Abfragen 3 und 4).
- [ ] Jede Schwachstelle hat einen Beleg aus dem TMDL; Punkte ohne Beleg sind Halluzinationsverdacht.
- [ ] Deutungen von Measures mit kryptischem Namen (`m_QQ`) sind als Annahme gekennzeichnet, nicht als Tatsache.
- [ ] Copilot hat keine Tabellen „ergänzt“, die es nicht gibt (z. B. eine Tabelle `Date` oder `Kostenstelle`).

## Stolperfallen
- Wird das Modell nur teilweise eingefügt, „vervollständigt“ Copilot gern fehlende Teile. Sagen Sie, was fehlt.
- Mit eingebetteten Daten (Ausdrücke `Daten_…`) wird der Text abgeschnitten – Copilot sieht dann nur einen Teil und merkt es nicht.
- Der Überblick ist ein Startpunkt, kein Review-Ersatz: Copilot erkennt Muster im Text, nicht das Verhalten im Visual.
- Kopieren Sie nichts aus Copilots Antwort zurück in die TMDL-Ansicht, ohne es zu prüfen (siehe M1-12).
