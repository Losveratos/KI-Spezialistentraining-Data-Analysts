# Excel-Chaos – fünf typische „gewachsene“ Dateien

Übungsdateien für **Ü1.13** und den Prompt
[M1-14 · Excel-Chaos zu Power Query](../../prompts/modul1/M1-14_Excel-Chaos-zu-Power-Query.md).
Jede Datei zeigt Probleme, wie sie in SAP-Exporten, Planungsmappen und manuell gepflegten Listen vorkommen.
Ihre Aufgabe: Copilot die Probleme finden und eine Power-Query-Abfrage schreiben lassen, die das Zielschema liefert.

Alle Daten sind **fiktiv** und passen zum Übungsmodell (gleiche Regionen, Leistungsarten und Größenordnungen).

## Die Dateien

| Nr | Datei | Was es ist |
|---|---|---|
| 01 | `01_SAP-Kostenbericht_Q1-2026.xlsx` | Kostenstellenbericht aus dem ERP-System, 1. Quartal 2026 |
| 02 | `02_Kostenplanung_2026_Kreuztabelle.xlsx` | Kostenplanung 2026 als Planungsmappe mit Monaten in Spalten |
| 03 | `03_Massnahmenliste_manuell-gepflegt.xlsx` | von mehreren Personen von Hand gepflegte Maßnahmenliste |
| 04 | `04_Stunden_je-Monat-ein-Blatt.xlsx` | Ist- und Plan-Stunden, je Monat ein Tabellenblatt |
| 05 | `05_Qualitaetspruefungen_Export.csv` | Textexport aus einem Qualitätssicherungssystem |

Welche Probleme in welcher Datei stecken, steht hier absichtlich nicht – das herauszufinden ist Teil der Übung.

## Zielschema und Kontrollwerte

Ihre Abfrage ist richtig, wenn Spalten, Zeilenzahl und Summen stimmen.

### 01 · SAP-Kostenbericht – eine Zeile je Buchung

| Spalte | Typ | Hinweis |
|---|---|---|
| Kostenstelle | Text | mit führenden Nullen, z. B. `0001101` |
| Bezeichnung | Text | |
| Periode | Datum | Monatserster, z. B. 01.01.2026 |
| Kostenart | Text | z. B. `400000` |
| Kostenartenbezeichnung | Text | |
| Betrag | Dezimalzahl | Euro, Gutschriften negativ |

**Kontrollwerte:** 321 Zeilen · Summe Betrag 23.732.247,98 € · 35 Kostenstellen · 6 negative Beträge

### 02 · Kostenplanung – eine Zeile je Region, Leistungsart und Monat

| Spalte | Typ | Hinweis |
|---|---|---|
| Region | Text | |
| Leistungsart | Text | |
| Monat | Datum | Monatserster |
| Plan_Kosten | Dezimalzahl | in **Euro** (die Datei rechnet in T€) |

Monate ohne Planung („–“) kommen im Ergebnis nicht vor.
**Kontrollwerte:** 347 Zeilen · Summe Plan_Kosten 75.478.100,00 €

### 03 · Maßnahmenliste – eine Zeile je Maßnahme

| Spalte | Typ | Hinweis |
|---|---|---|
| MassnahmeID | Text | einheitlich `M-001` |
| Titel | Text | |
| Region | Text | Nord, Ost, Südost, Süd, Südwest, Mitte, West |
| Leistungsart | Text | Fahrzeugreinigung, Bahnhofsreinigung, Sicherheitsdienst, Facility Management, Winterdienst |
| Verantwortlich | Text | |
| Start, Zieltermin | Datum | |
| Status | Text | offen, in Umsetzung, verzögert, abgeschlossen |
| Fortschritt | Dezimalzahl | Anteil 0 bis 1 |
| Einsparung_Plan, Einsparung_Ist | Dezimalzahl | Euro pro Jahr; ohne Angabe 0 |

**Kontrollwerte:** 25 Zeilen · Summe Einsparung_Plan 1.216.000 € · Summe Einsparung_Ist 710.000 € ·
Status: 11 abgeschlossen, 8 in Umsetzung, 3 verzögert, 3 offen
(Das sind dieselben Werte wie in der Tabelle `Massnahmen` des Übungsmodells.)

### 04 · Stunden – eine Zeile je Monat, Region und Leistungsart

| Spalte | Typ | Hinweis |
|---|---|---|
| Monat | Datum | Monatserster |
| Region | Text | |
| Leistungsart | Text | |
| Ist_Stunden, Plan_Stunden | Dezimalzahl | |

Kommt ein neues Monatsblatt dazu, soll es ohne Änderung an der Abfrage mitgeladen werden.
**Kontrollwerte:** 140 Zeilen · Summe Ist_Stunden 826.372,0 · Summe Plan_Stunden 825.733,3

### 05 · Qualitätsprüfungen – eine Zeile je Datum, Region und Leistungsart

| Spalte | Typ | Hinweis |
|---|---|---|
| Datum | Datum | Monatsletzter |
| Region | Text | |
| Leistungsart | Text | |
| Pruefungen, Bestanden | Ganze Zahl | |

Die Quote wird nicht geladen – sie wird im Modell als Measure berechnet.
**Kontrollwerte:** 105 Zeilen · Summe Pruefungen 100.455 · Summe Bestanden 94.389

## So testen Sie eine Abfrage in Power BI Desktop

1. **Daten transformieren** öffnet den Power Query-Editor.
2. **Parameter verwalten › Neuer Parameter**: Name `pDatei`, Typ Text, Wert = vollständiger Pfad zur Datei.
3. **Neue Quelle › Leere Abfrage**, dann **Erweiterter Editor**: Copilots Code einfügen, **Fertig**.
4. Zeilenzahl unten links ablesen (bei Bedarf Spaltenprofil auf „gesamtes Dataset“ stellen), Summe über
   **Transformieren › Statistiken › Summe** in einer Kopie der Abfrage prüfen.

Tipp: Legen Sie die Dateien unter einem kurzen Pfad ab, z. B. `C:\Training\`.
