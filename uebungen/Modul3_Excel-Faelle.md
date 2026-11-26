# Modul 3 · Excel mit Copilot – acht Übungsfälle

Eine Arbeitsmappe, acht typische Aufgaben: [`Excel-Copilot_Uebungsfaelle.xlsx`](../uebungsdaten/modul3/Excel-Copilot_Uebungsfaelle.xlsx)
in `uebungsdaten/modul3/`. Jedes Blatt hat oben die **Aufgaben** (gelb), **Beispiel-Prompts** (blau) und
**Kontrollwerte** (grün) – Sie sehen also selbst, ob das Ergebnis stimmt. Die Daten sind fiktiv
(Berichtsmonat Oktober 2026).

> **Datenschutz:** Nur im freigegebenen Unternehmens-Copilot arbeiten. Die Übungsdaten sind fiktiv; bei echten
> Dateien keine personenbezogenen Daten verwenden.

## So arbeiten Sie

- **Mit Copilot in Excel:** Datei in OneDrive oder SharePoint ablegen, AutoSpeichern einschalten, Copilot öffnen.
- **Ohne Copilot in Excel:** Datei im Copilot-Chat anhängen, nach der Formel fragen („deutsche Funktionsnamen,
  strukturierte Verweise“) und selbst einfügen.
- Prompt-Bausteine: [M3-05 · Strukturierte Analyse](../prompts/modul3/M3-05_Excel-strukturierte-Analyse.md) und
  [M3-07 · Prüfspalten und Formeln](../prompts/modul3/M3-07_Excel-Pruefspalten-und-Formeln.md).
- Reihenfolge frei wählbar. Für einen ersten Durchgang: Fall 1, 3 und 4.

## Die Fälle

| Blatt | Thema | Aufgabe in einem Satz | Zeit |
|---|---|---|---|
| `1_Formeln` | Formeln einfügen | Vier Formelspalten (Abweichung, Prozent, Kosten je Stunde, Status) und eine Summe je Region | 10 min |
| `2_Formatieren` | Tabelle formatieren | Aus einem rohen Bereich eine saubere Tabelle mit Formaten, bedingter Formatierung und Ergebniszeile | 8 min |
| `3_Auswertung_SVERWEIS` | Auswertung und SVERWEIS | Stammdaten aus `3_Stammdaten` nachschlagen, #NV erklären und abfangen, je Region auswerten | 12 min |
| `4_Kreuztabelle` | Kreuztabelle auflösen | Monate in Spalten zu Zeilen machen – mit Power Query und als Excel-Formel | 12 min |
| `5_Text_bereinigen` | Text zerlegen | Aus unsauberen Codes vier saubere Spalten machen | 8 min |
| `6_Datum` | Datum und Fristen | Text in Datum wandeln, Laufzeit und Arbeitstage rechnen, Überfälliges markieren | 8 min |
| `7_Pivot_Diagramm` | Pivot und Diagramm | Pivot-Tabelle, Liniendiagramm und Auffälligkeiten per Prompt | 10 min |
| `8_Formeln_erklaeren` | Formeln erklären und reparieren | Vorhandene Formeln verstehen, #DIV/0! und #NV beheben, vereinfachen | 10 min |

## Fünf Regeln für Prompts in Excel

1. **Tabelle und Spalten beim Namen nennen** (`tblFormeln`, `Ist_Kosten`) – nicht „die Tabelle“ und „die Kosten“.
2. **Die Rechnung beschreiben**, nicht nur das Ziel: „Abweichung = Ist_Kosten minus Plan_Kosten“.
3. **Den Ausgabeort sagen:** neue Spalte in der Tabelle, neues Blatt, bestimmte Zelle.
4. **Eine Formel verlangen, keinen festen Wert** – dann bleibt das Ergebnis bei neuen Daten gültig.
5. **Prüfen:** Kontrollwert vergleichen, eine Zeile von Hand nachrechnen, Sonderfälle ansehen (0, leer, Text).

## Typische Stolperfallen

- **Prozent als Zahl:** „größer als 2 %“ wird zu `> 2` statt `> 0,02` – dann ist jede Zeile „im Plan“.
- **Schlüssel als Text:** Kostenstellen mit führenden Nullen dürfen nicht in Zahlen umgewandelt werden.
- **#NV hat zwei Ursachen:** Leerzeichen im Schlüssel (technisch lösbar) oder der Schlüssel fehlt wirklich
  (fachlich klären). `WENNFEHLER` versteckt beides.
- **Fester Wert statt Formel:** Copilot schreibt manchmal Ergebnisse als Zahlen. Immer in die Zelle schauen.
- **HEUTE() statt Stichtag:** Das Ergebnis ändert sich dann jeden Tag.
- **Summen mit entpivotiert:** Wer Summenzeile und Summenspalte nicht entfernt, bekommt ein Vielfaches der Summe.

## Weitere Ideen: Was sich mit Copilot in Excel gut erledigen lässt

| Idee | Beispiel-Prompt |
|---|---|
| **Zwei Listen abgleichen** | „Welche BelegNr aus tblA fehlen in tblB und umgekehrt? Gib beide Listen als neue Tabellen aus.“ |
| **Dubletten finden und markieren** | „Markiere in tblBuchungen alle Zeilen, deren BelegNr mehrfach vorkommt, und zähle sie.“ |
| **Gegen einen Regelkatalog prüfen** | siehe Ü3.4 und [M3-06](../prompts/modul3/M3-06_Excel-Validierung-Regelkatalog.md) |
| **Ausreißer rechnen statt schätzen** | „Berechne je Leistungsart Median und Quartile von Kosten_je_Stunde und markiere Werte außerhalb des 1,5-fachen Quartilsabstands.“ |
| **Szenario-Spalten** | „Füge eine Spalte Plan_neu hinzu: Plan_Kosten plus 3 %, der Prozentsatz steht in Zelle H1.“ |
| **Wiederverwendbare Funktion (LAMBDA)** | „Erstelle eine benannte LAMBDA-Funktion ABW_PROZENT(ist; plan), die bei Plan 0 leer zurückgibt, und verwende sie in der Tabelle.“ |
| **Textbaustein aus Zahlen** | „Füge eine Spalte Kommentar hinzu: ‚Region X liegt Y % über/unter Plan‘, mit einer Nachkommastelle und deutschem Zahlenformat.“ |
| **Arbeitsmappe dokumentieren** | „Liste alle Blätter, Tabellen und Formelspalten dieser Mappe mit einem Satz zum Zweck.“ |
| **Formel in Power Query übersetzen** | „Diese Spalten berechne ich bisher per Formel. Schreibe die Schritte als Power-Query-Abfrage.“ |
| **Wiederkehrendes automatisieren** | „Schreibe ein Office-Skript, das Fall 2 (Tabelle anlegen, Formate, Ergebniszeile) auf das aktive Blatt anwendet.“ |
| **Trend und Prognose** | „Erstelle aus tblTrend für die Region Ost eine Prognose der Ist_Kosten für die nächsten drei Monate und zeige das Konfidenzintervall.“ |
| **Daten aus Fließtext strukturieren** | „Mache aus diesem eingefügten Text eine Tabelle mit den Spalten Datum, Region, Betrag.“ |

Nicht alle Funktionen sind in jedem Unternehmen freigeschaltet. Jede Idee funktioniert auch über den Copilot-Chat:
Datei anhängen, Formel oder Skript erzeugen lassen, selbst einfügen und prüfen.
