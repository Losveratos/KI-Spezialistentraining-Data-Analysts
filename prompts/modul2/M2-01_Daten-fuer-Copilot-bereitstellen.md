# M2-01 · Daten für Copilot bereitstellen

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | Power BI Desktop/Service + M365 Copilot Chat oder Notebook | Ü2.1 | 10 min |

## Wofür
Copilot kann nur kommentieren, was er sieht. Der Bericht selbst ist für M365 Copilot unsichtbar – Sie
müssen die Zahlen als Tabelle mitgeben. Diese Datei zeigt die drei Wege dorthin und einen Einstiegs-Prompt,
mit dem Copilot **zuerst bestätigt, was er bekommen hat**, bevor er irgendetwas interpretiert.

## Vorbereitung

**Weg A – Visual-Export (schnell, für eine Berichtsseite)**
- Power BI Desktop: Visual markieren › **Weitere Optionen (…)** › **Daten exportieren** › CSV speichern.
  Desktop exportiert nur *zusammengefasste* Daten als CSV, maximal 30.000 Zeilen, ohne Summenzeilen.
- Power BI Service: zusätzlich `.xlsx` (bis 150.000 Zeilen) oder `.xlsx` mit Liveverbindung (bis 500.000 Zeilen).
  Die erste Zeile der Excel-Datei nennt die angewendeten Filter – gut als Kontext für Copilot.
- Achtung: Die Spaltennamen im Export sind die Feldnamen des Visuals (z. B. `m_QQ`), nicht sprechende Namen.

**Weg B – DAX-Abfrage (genau, reproduzierbar, für mehrere Kennzahlen)** → siehe **M2-02**.
Ergebnisraster in der DAX-Abfrageansicht › **Kopieren** kopiert die ganze Tabelle tabulatorgetrennt mit
Überschriften. Achtung: Das Raster zeigt Werte **ohne** Formatstring (0,0712 statt 7,1 %).

**Weg C – vorbereitete Übungsexporte** (im Training der Standard)
- `uebungsdaten/modul2/KPI_Monat_Region.csv`, `KPI_Monat_Region_Leistungsart.csv`, `Massnahmen.csv`
  oder alles in `DBS_KPI_Export.xlsx`. CSV: Trennzeichen `;`, Dezimalkomma, UTF-8. Monat als Text `2026-10`,
  Datumsfelder der Maßnahmen als `TT.MM.JJJJ`.
- Prozentspalten der Übungsexporte sind **Prozentwerte** (`7,12` = 7,12 %), im Unterschied zur DAX-Abfrage
  (Anteile, `0,0712`). Das gehört in jeden Prompt.
- Die Exporte enthalten absichtlich dieselben Datenfehler wie der Bericht.

**Wohin mit den Daten?**
- **Datei anhängen** (Büroklammer im Copilot Chat) – bevorzugt für CSV/XLSX, Copilot kann damit rechnen.
- **Einfügen** in den Prompt – nur für kleine Tabellen (Faustregel: < 100 Zeilen, < 15 Spalten).
- **Copilot Notebook**: Export + Kontextdateien **K04** (Kommentar-Leitfaden) und **K05** (Kennzahlen-Glossar)
  als Referenzen hinterlegen. Dann müssen Sie Regeln und Begriffe nicht in jeden Prompt kopieren.

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot arbeiten (Anmeldung mit
> Firmenkonto, Hinweis „Enterprise Data Protection“ sichtbar). Keine personenbezogenen Daten einfügen
> oder anhängen. Angehängte Dateien werden von DLP-Richtlinien nicht inhaltlich geprüft – die
> Verantwortung liegt bei Ihnen. Exporte aus echten Berichten nur, wenn sie für diesen Zweck freigegeben sind.

## Prompt
```text
Du bist Controller*in im Produktionscontrolling eines Dienstleisters (Reinigung, Sicherheit, Facility,
Winterdienst) und bereitest eine Monatskommentierung vor.

Kontext: Im Anhang bzw. unten findest du einen Export aus unserem Power-BI-Bericht.
Quelle: [EINFÜGEN: z. B. „Visual-Export Kennzahlenübersicht, Tabelle je Region“ oder „Datei KPI_Monat_Region.csv“]
Berichtsmonat: [EINFÜGEN: z. B. Oktober 2026]
Bedeutung der Spalten: [EINFÜGEN: kurze Liste oder „siehe Kennzahlen-Glossar K05“]

Aufgabe: Analysiere noch nichts. Bestätige mir nur, was du erhalten hast:
1. Liste aller Spalten mit Datentyp (Zahl, Text, Datum) und Einheit, soweit erkennbar.
2. Granularität: Was ist eine Zeile (z. B. Monat × Region)? Wie viele Zeilen gibt es?
3. Zeitraum: erster und letzter Monat, fehlende Monate.
4. Dimensionen: alle vorkommenden Werte von Region (und ggf. Leistungsart) mit Anzahl Zeilen.
5. Zahlenformat: Wie hast du Dezimal- und Tausendertrennzeichen gelesen? Nenne eine Beispielzeile so,
   wie du sie verstanden hast.

Regeln:
- Rechne mit dem Code-/Analysewerkzeug, wenn es verfügbar ist, und sag mir, ob du gerechnet oder geschätzt hast.
- Interpretiere keine Spalte, deren Bedeutung nicht aus Name oder Kontext eindeutig ist – markiere sie als „unklar“.
- Wenn Informationen fehlen, frag nach statt zu raten.

[EINFÜGEN: Tabelle, falls nicht als Datei angehängt]

Ausgabe: Eine Tabelle „Spalte | Typ | Einheit | Bedeutung (laut Kontext) | unklar?“, danach die Punkte 2–5
als kurze Liste.
```

## Nachschärfen

Wenn Copilot Prozentwerte falsch gelesen hat (z. B. 7,12 als 712 oder als Anteil 7,12 = 712 %):
```text
Die Spalten Abw_Kosten_Prozent, Qualitaetsquote, Krankenquote und Ueberstundenquote sind
[EINFÜGEN: „Prozentwerte (7,12 = 7,12 %)“ bei den Übungsexporten bzw. „Anteile (0,0712 = 7,12 %)“ bei einer
DAX-Abfrage]. Das Dezimaltrennzeichen ist das Komma, das Feldtrennzeichen das Semikolon.
Lies die Datei neu ein und zeig mir dieselbe Beispielzeile noch einmal.
```

Wenn die Zeilenzahl nicht zur Erwartung passt:
```text
Ich erwarte [EINFÜGEN: Anzahl] Zeilen (Monate × Regionen). Zähle nach und nenne Kombinationen aus Monat
und Region, die fehlen oder mehrfach vorkommen.
```

Wenn Sie den Export für spätere Prompts „festnageln“ wollen:
```text
Merke dir für diesen Chat: Diese Tabelle ist die einzige Datenquelle. Jede Zahl, die du später nennst,
muss aus ihr stammen oder aus ihr berechnet sein. Zeig bei berechneten Zahlen die Rechnung.
```

## Ergebnis prüfen
- [ ] Zeilenzahl stimmt mit dem Export überein (Excel: Zeilen zählen; Erwartung bei `KPI_Monat_Region`:
      22 Monate × 7 Regionen = 154 Zeilen).
- [ ] Eine Beispielzeile mit Prozentwert stimmt mit dem Bericht überein (Dezimalkomma richtig gelesen?).
- [ ] Alle 7 Regionen und der Zeitraum Jan 2025 – Okt 2026 werden genannt.
- [ ] `m_QQ` bzw. `Qualitaetsquote` wird nicht als „Qualitätsquartal“ o. Ä. gedeutet (kryptischer Name).
- [ ] Copilot sagt, ob er gerechnet oder geschätzt hat. „Geschätzt“ heißt: Zahlen später nicht übernehmen.

## Stolperfallen
- **Exporte vergessen den Filterkontext.** Ein CSV aus Desktop enthält keine Filterzeile. Schreiben Sie
  Berichtsmonat und Filter immer in den Prompt.
- **Prozent als Anteil oder als Text?** Je nach Exportweg kommen Prozentwerte als Anteil (0,0712), als
  Zahl (7,12) oder als Text mit `%`. Prüfen Sie eine Zeile in Excel und schreiben Sie die Einheit in den
  Prompt. Für Analysen im Service „Zusammengefasste Daten“ statt „Daten mit aktuellem Layout“ wählen.
- **Zu große Tabelle eingefügt.** Lange eingefügte Tabellen werden abgeschnitten oder nur überflogen –
  Copilot kommentiert dann die ersten Zeilen. Lieber als Datei anhängen.
- **Summen fehlen.** CSV-Exporte enthalten keine Gesamtzeile. Für Gesamtaussagen Copilot rechnen lassen
  und gegen die Karte im Bericht prüfen.
