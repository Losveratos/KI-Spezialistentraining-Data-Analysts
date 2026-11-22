# M1-09 · Neues Measure metadatengetrieben aus TMDL-Kontext

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook + DAX-Abfrageansicht (alternativ Copilot in der DAX-Abfrageansicht, sofern Kapazität vorhanden) | Ü1.2 | 10 min |

## Wofür
Ein neues Measure entsteht aus **Ihrer** Modellbeschreibung, nicht aus Copilots Vorstellung eines typischen Modells.
Mit TMDL als Kontext stimmen Tabellen-, Spalten- und Measurenamen, die Zeitintelligenz läuft über die richtige
Datumsspalte, und vorhandene Measures werden wiederverwendet. Ergebnis: Measure plus Testabfrage plus TMDL-Ausschnitt.

## Vorbereitung
- TMDL der relevanten Tabellen (TMDL-Ansicht, Partitionen weglassen) und der Beziehungen.
- Fachliche Definition der neuen Kennzahl in eigenen Worten – mit Einheit und Verhalten bei leerem Nenner.
- Optional: **K02** (DAX-Styleguide), **K03** (TMDL-Kurzreferenz), **K05** (Kennzahlen-Glossar).
- **Variante Copilot in Power BI:** In der DAX-Abfrageansicht liest Copilot die Modellmetadaten selbst (Namen,
  Ausdrücke, Beschreibungen bis 200 Zeichen). Bitten Sie dort um eine **Abfrage** mit `DEFINE MEASURE`, nicht um ein
  Measure. Voraussetzung: Arbeitsbereich auf bezahlter Fabric-Kapazität (F2+) oder Premium-Kapazität (P1+) bzw. Fabric
  Copilot capacity; keine Testkapazität (Details in M1-03).
- Datenschutz: nur Metadaten und Definitionen; unternehmensfreigegebenen Copilot nutzen.

## Prompt
```text
Du bist DAX-Entwickler und erweiterst ein bestehendes Power-BI-Modell. Halte dich an den DAX-Styleguide (K02),
falls er vorliegt.

Kontext – das Modell als TMDL (maßgeblich, andere Objekte gibt es nicht):
[EINFÜGEN: TMDL der Tabellen und Beziehungen]

Aufgabe: Erstelle das Measure „[EINFÜGEN: Name]“.
Fachliche Definition: [EINFÜGEN: z. B. Qualitätsquote der gleichen Periode im Vorjahr]
Einheit und Format: [EINFÜGEN: z. B. Prozent, eine Nachkommastelle]
Verhalten bei leerem Nenner / fehlenden Vorjahreswerten: [EINFÜGEN: z. B. leer lassen]

Regeln:
- Verwende ausschließlich Tabellen, Spalten und Measures aus dem TMDL. Wenn du ein Objekt brauchst, das fehlt,
  nenne es als Annahme und schreib das Measure nicht, bevor ich es bestätigt habe.
- Nutze vorhandene Measures, wenn sie die benötigte Teilrechnung schon liefern.
- Zeitintelligenz nur über die Datumsspalte der Kalendertabelle, die per Beziehung mit der Faktentabelle verbunden ist.
- Division mit DIVIDE.

Ausgabe:
1. Measure-Code (```dax), mit Kopfkommentar.
2. Tabelle „Verwendetes Objekt | Art | Fundstelle im TMDL“.
3. Testabfrage für die DAX-Abfrageansicht: DEFINE MEASURE … EVALUATE SUMMARIZECOLUMNS ( Kalender[Monat], … )
   für das Jahr 2026, mit dem neuen Measure und den Measures, aus denen es sich ableitet.
4. TMDL-Ausschnitt zum Anlegen (createOrReplace, ref table …, measure … mit formatString und /// Beschreibung,
   Tab-Einrückung, ohne lineageTag).
5. „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn Copilot ein Objekt verwendet, das es nicht gibt:
```text
[EINFÜGEN: Objektname] gibt es im TMDL nicht. Zeig mir die Zeile im TMDL, die du dafür gehalten hast, und schreib
das Measure nur mit vorhandenen Objekten neu.
```
Wenn das Measure läuft, die Werte aber nicht plausibel sind:
```text
Die Testabfrage liefert für [EINFÜGEN: Monat] den Wert [EINFÜGEN: Wert], erwartet habe ich etwa [EINFÜGEN: Wert].
Welche Filter wirken in dieser Zeile auf das Measure, und wo kann die Abweichung entstehen?
```
Wenn Sie mehrere ähnliche Measures brauchen:
```text
Erstelle nach demselben Muster die Measures [EINFÜGEN: Namen]. Gleiche Regeln, eine gemeinsame Testabfrage, ein TMDL-Skript.
```

## Ergebnis prüfen
- [ ] Testabfrage in der DAX-Abfrageansicht ausführen – läuft sie, existieren alle Namen. Läuft sie nicht, Meldung zurück an Copilot (M1-08).
- [ ] Werte plausibel: Vorjahreswert für Oktober 2026 = Wert Oktober 2025 aus derselben Abfrage ohne Zeitverschiebung.
- [ ] Fundstellen-Tabelle stichprobenartig mit Strg+F im TMDL geprüft.
- [ ] TMDL-Ausschnitt: Einrückung mit Tabs, `///` direkt über `measure`, kein erfundener `lineageTag`. Erst in der TMDL-Ansicht
      **Anwenden**, wenn die Testabfrage stimmt.

## Stolperfallen
- Ein kryptischer Measure-Name (`m_QQ`) wird nicht als Qualitätsquote erkannt – Copilot rechnet dann die Quote neu aus
  oder erfindet `[Qualitätsquote]`. Gute Namen und Beschreibungen sind der beste Halluzinationsschutz (siehe M1-12).
- `Kalender[Monat]` ist hier Text („2026-10“), `Fakt_Leistung[Monat]` ein Datum. Copilot verwechselt beide gern.
- Mit Teil-TMDL ohne Beziehungen weiß Copilot nicht, welche Datumsspalte verbunden ist, und rät.
- Copilot in der DAX-Abfrageansicht sieht das Modell selbst – aber nur, wenn Sie dort arbeiten. Im M365-Chat sieht er nur, was Sie einfügen.
