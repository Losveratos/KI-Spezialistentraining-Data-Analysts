# M1-11 · Bestehenden Bericht dokumentieren – mit heute verfügbaren Mitteln

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | Power BI Desktop (Screenshot, Leistungsanalyse) + M365 Copilot Chat oder Notebook | Ü1.10 | 10 min |

## Wofür
M365 Copilot kann eine `.pbix`-Datei nicht öffnen und sieht den Bericht nicht. Sie geben ihm drei Dinge, die Sie in
Desktop ohne Zusatzlizenz bekommen: **Bild** der Seite (was der Nutzer sieht), **Visual-Abfragen** aus der
Leistungsanalyse (welche Felder und Filter wirklich gebunden sind) und **Measure-Definitionen** (was gerechnet wird).
Copilot verbindet das zu einer Seitendokumentation.

## Vorbereitung
1. **Screenshot je Seite:** Berichtsseite öffnen, Filterbereich aufklappen, mit Win+Umschalt+S ausschneiden, als PNG speichern.
   Testdaten bzw. freigegebene Daten verwenden – der Screenshot enthält Zahlen.
2. **Visual-Abfragen:** Optimieren › **Leistungsanalyse** › Aufzeichnung starten › **Visuals aktualisieren** ›
   je Visual aufklappen › **Abfrage kopieren**. Abfragen mit dem Visual-Titel in eine Textdatei `Seite_Abfragen.txt` einfügen.
   Die Abfragen zeigen gebundene Spalten, Measures, Sortierung und Filter (auch Slicer-Auswahl) als DAX.
3. **Measure-Definitionen:** `INFO_Abfragen.dax`, Abfrage 3 (Ergebnis kopieren) oder TMDL der Measures.
4. Optional für PBIP-Projekte: `<Bericht>.Report/definition/pages/<Seite>/page.json` und die `visual.json` der Visuals
   als `.txt` anhängen – dort stehen Visualtyp, Position und gebundene Felder exakt.
5. Datenschutz: Screenshots und Abfragen können Kennzahlen, Namen und Filterwerte enthalten. Nur freigegebene bzw.
   anonymisierte Inhalte im unternehmensfreigegebenen Copilot verwenden.

**Mit Kapazität (optional):** Copilot im Berichtsbereich von Power BI kann Seiten zusammenfassen und Fragen zu Visuals
beantworten. Voraussetzung: Arbeitsbereich auf bezahlter Fabric-Kapazität (F2+) oder Premium-Kapazität (P1+), keine
Testkapazität; der Admin hat Copilot nicht abgeschaltet. Diese Zusammenfassung
beschreibt Inhalte und Zahlen, ersetzt aber keine technische Doku (Felder, Filter, Definitionen).

## Prompt
```text
Du bist BI-Analyst und dokumentierst einen bestehenden Power-BI-Bericht für Kolleginnen und Kollegen, die ihn
übernehmen oder prüfen.

Kontext:
- Bericht und Seite: [EINFÜGEN: z. B. DBS_Produktionscontrolling, Seite „Kennzahlenübersicht“]
- Zielgruppe des Berichts: [EINFÜGEN: z. B. Bereichsleitung, monatliche Steuerung]
- Anhang 1: Screenshot der Seite (zeigt, was Nutzer sehen)
- Anhang 2: DAX-Abfragen der Visuals aus der Leistungsanalyse, je Abfrage mit Visual-Titel (maßgeblich für Felder und Filter)
- Anhang 3: Measure-Definitionen (Name und DAX)

Aufgabe: Erstelle eine Seitendokumentation:
1. Zweck der Seite in 2–3 Sätzen.
2. Tabelle der Visuals: Titel | Visualtyp (aus dem Bild) | Kategorien/Achsen | Measures | Filter und Sortierung (aus der Abfrage).
3. Slicer und Filter auf Seiten-/Berichtsebene, soweit sichtbar oder aus den Abfragen ableitbar.
4. Kennzahlen der Seite: Name, Definition in einem Satz (aus dem DAX), Einheit.
5. Lesehilfe für Nutzer: Wie liest man die Seite in 5 Schritten?
6. Auffälligkeiten: z. B. kryptische Feldnamen in Überschriften, fehlende Einheiten, Sortierung, Werte, die nicht zur Definition passen.

Regeln:
- Felder und Filter nur aus den Abfragen übernehmen; das Bild dient zur Zuordnung von Titel, Visualtyp und Anordnung.
- Wenn Bild und Abfrage nicht zusammenpassen oder ein Visual keine Abfrage hat, schreib das ausdrücklich.
- Keine Zahlen aus dem Screenshot interpretieren oder kommentieren – es geht um Aufbau und Logik, nicht um den Monatsstand.

Ausgabe: Markdown mit den Abschnitten 1–6 und „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn Sie mehrere Seiten dokumentieren:
```text
Hier folgt Seite [EINFÜGEN: Name] mit denselben drei Anhängen. Gleiche Struktur. Ergänze am Ende eine
Berichtsübersicht: Seiten, Navigationsfluss (soweit erkennbar) und Measures, die auf mehreren Seiten vorkommen.
```
Wenn Copilot Felder aus dem Bild „liest“ statt aus der Abfrage:
```text
Gleiche die Tabelle der Visuals Zeile für Zeile mit den Abfragen ab. Markiere jede Angabe, die nur aus dem Bild stammt, mit „(Bild)“.
```
Wenn Sie aus der Doku eine Prüfliste für das Berichts-Review machen wollen:
```text
Leite aus den Auffälligkeiten eine Prüfliste für das nächste Review ab: Punkt, betroffenes Visual, Vorschlag, Aufwand (S/M/L).
```

## Ergebnis prüfen
- [ ] Jedes Visual auf dem Screenshot kommt in der Tabelle vor (Anzahl zählen), keines ist erfunden.
- [ ] Felder in der Tabelle stehen so in den Abfragen (Strg+F in `Seite_Abfragen.txt`).
- [ ] Kennzahl-Definitionen passen zum DAX – nicht zur Vermutung aus dem Namen (`m_QQ`, `KPI Status Text`).
- [ ] Copilot hat keine Zahlen aus dem Bild übernommen oder interpretiert.
- [ ] Filterangaben: Slicer-Auswahl zum Zeitpunkt der Aufzeichnung ist als Momentaufnahme gekennzeichnet.

## Stolperfallen
- Bilder werden „gelesen“, aber nicht exakt: Kleine Achsenbeschriftungen, Tooltips, ausgeblendete Visuals, Lesezeichen und
  Drillthrough-Seiten sind auf dem Screenshot nicht oder falsch zu erkennen.
- Die Leistungsanalyse erfasst nur Visuals, die beim Aktualisieren abgefragt werden. Textfelder, Bilder und Schaltflächen fehlen.
- Abfragen enthalten die **aktuelle** Slicer-Auswahl als Filter – das ist kein fester Seitenfilter.
- Berichtsseiten-Zusammenfassungen von Copilot in Power BI beschreiben Daten, nicht Aufbau. Für Übergabe-Dokus reicht das nicht.
