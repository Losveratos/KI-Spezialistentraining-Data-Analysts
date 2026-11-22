# M1-03 · DAX formatieren und kommentieren

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook (alternativ Copilot in der DAX-Abfrageansicht, sofern Kapazität vorhanden) | Ü1.3 | 12 min |

## Wofür
Unlesbares DAX lesbar machen, ohne die Logik anzufassen: einheitliche Formatierung nach Styleguide,
Kopfkommentar mit Zweck, Kommentare zum **Warum**. Inhaltliche Verbesserungen kommen getrennt als Vorschlagsliste –
so können Sie Formatierung übernehmen, ohne ungeprüfte Logikänderungen einzuschleppen.

## Vorbereitung
- Measure-Code kopieren: TMDL-Ansicht (Measure in den Editor ziehen) oder Bearbeitungsleiste in Desktop.
  Gut geeignet im Übungsmodell: `KPI Status Text`, `Abw Kosten %`, `Kosten YTD`.
- **K02** (DAX-Styleguide) anhängen oder im Notebook hinterlegen.
- Datenschutz: Code enthält in der Regel keine Daten. Prüfen Sie trotzdem auf hart kodierte Namen, Kostenstellen
  oder Kundennamen in Filtern und anonymisieren Sie diese bei echten Modellen.
- **Variante Copilot in Power BI:** In der DAX-Abfrageansicht (Strg+I, Vorschau) kann Copilot eine DAX-*Abfrage* erklären,
  kommentieren und umbauen. Voraussetzung: Sie haben Schreibzugriff auf einen Arbeitsbereich auf bezahlter Fabric-Kapazität
  (F2+) oder Premium-Kapazität (P1+) – oder eine Fabric Copilot capacity –, und der Admin hat Copilot nicht abgeschaltet.
  Testkapazität (Trial) und Premium-Einzelbenutzer (PPU) reichen nicht.
  Dort das Measure als `DEFINE MEASURE … EVALUATE …` einfügen – Copilot arbeitet abfrageorientiert.

## Prompt
```text
Du bist DAX-Entwickler und arbeitest nach dem DAX-Styleguide (K02), falls er dir vorliegt; sonst nach
SQLBI-Formatierung (Funktionen groß, 4 Leerzeichen, ein Argument je Zeile bei langen Ausdrücken).

Kontext: Measure aus einem Power-BI-Modell für Produktionscontrolling.
Tabelle: [EINFÜGEN: Tabellenname, z. B. Fakt_Leistung]
Code:
[EINFÜGEN: Measure-Code inkl. Name]

Aufgabe:
1. Formatiere den Code.
2. Ergänze einen Kopfkommentar (// …): Zweck in einem Satz, fachliche Definition, Einheit.
3. Kommentiere nicht offensichtliche Stellen: warum dieser Filter, warum diese Schwelle, was bei leerem Nenner passiert.

Regeln:
- Ändere die Logik NICHT: gleiche Funktionen, gleiche Reihenfolge der Bedingungen, gleiche Konstanten.
  Auch offensichtliche Fehler bleiben im Code stehen.
- Verwende nur Namen, die im Code stehen. Erfinde keine Spalten oder Measures.
- Kommentare auf Deutsch, sachlich, ohne das Offensichtliche zu wiederholen („SUM summiert“).

Ausgabe:
1. Der formatierte, kommentierte Code in einem einzigen ```dax-Block.
2. Darunter „Verbesserungsvorschläge (nicht umgesetzt)“: nummerierte Liste mit Problem, Risiko, Vorschlag.
3. „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn Copilot trotz Verbot die Logik geändert hat:
```text
Vergleiche deine Fassung Zeile für Zeile mit dem Original. Nenne jede Stelle, an der sich Funktion,
Operator, Konstante oder Reihenfolge geändert hat, und mach diese Änderungen rückgängig.
```
Wenn die Kommentare zu lang werden:
```text
Kürze die Kommentare: Kopfkommentar höchstens 3 Zeilen, sonst nur dort kommentieren, wo ein Kollege ohne
Kommentar falsch verstehen würde, was passiert.
```
Wenn Sie den Code danach in die TMDL-Ansicht übernehmen wollen:
```text
Gib das Measure als TMDL-Ausschnitt aus (createOrReplace, ref table [EINFÜGEN: Tabelle], measure …),
Tab-Einrückung, DAX-Ausdruck mehrzeilig eingerückt, ohne lineageTag. Behalte formatString bei: [EINFÜGEN: Formatstring].
```

## Ergebnis prüfen
- [ ] Logik identisch: Original und neue Fassung in der DAX-Abfrageansicht nebeneinander auswerten (Vorlage: `INFO_Abfragen.dax`, Abfrage 8).
- [ ] Kommentare stimmen inhaltlich: Steht im Kommentar „Plan 0 → leer“, muss im Code `DIVIDE` stehen, nicht `/`.
- [ ] Keine neuen Namen im Code (Strg+F gegen TMDL).
- [ ] Verbesserungsvorschläge betreffen dieses Measure und sind konkret (z. B. `/` statt `DIVIDE`, `[Abw Kosten]` wiederverwenden).

## Stolperfallen
- „Nur formatieren“ wird von Copilot gern als Einladung zum Verbessern gelesen. Formatieren und Ändern immer trennen.
- DAX-Kommentare mit `//` oder `--` funktionieren im Measure; `///` im TMDL ist dagegen die **Beschreibung** des Objekts – nicht verwechseln.
- Copilot für Measure-Beschreibungen in Desktop ignoriert Kommentare im DAX – die Beschreibung ist ein eigenes Feld (siehe M1-12).
- Für reines Formatieren ist die Schaltfläche **Formatieren** (engl. *Format query*, Umschalt+Alt+F) der DAX-Abfrageansicht
  schneller und deterministisch (Measure als `DEFINE MEASURE` einfügen). Copilot lohnt sich vor allem für die Kommentare. Externe Formatierer im Web
  nur nutzen, wenn der Code nichts Vertrauliches enthält.
