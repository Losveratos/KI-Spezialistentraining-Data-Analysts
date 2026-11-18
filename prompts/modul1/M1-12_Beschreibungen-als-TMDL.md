# M1-12 · Beschreibungen und Synonyme erzeugen, als TMDL zurückschreiben

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook + TMDL-Ansicht (alternativ „Mit Copilot erstellen“ in der Modellansicht, sofern Kapazität vorhanden) | Ü1.11 | 10 min |

## Wofür
Beschreibungen sind Metadaten, die jede KI liest: Copilot in Power BI (DAX-Abfrageansicht nutzt die ersten 200 Zeichen),
Q&A, Agenten, Berichtsersteller im Datenbereich. Copilot entwirft Beschreibungen und Synonyme aus TMDL und Glossar
und gibt sie als **TMDL-Skript** zurück, das Sie in der TMDL-Ansicht anwenden – für viele Objekte auf einmal, ohne Klickarbeit.

## Vorbereitung
- TMDL-Ansicht › im Datenbereich die Measures von `Fakt_Leistung` (bzw. die zu beschreibenden Spalten) mit Strg markieren
  und in den Editor ziehen. Desktop erzeugt ein `createOrReplace`-Skript mit `ref table` – **nur** diese Objekte, keine Partition.
- **K05** (Kennzahlen-Glossar) und **K03** (TMDL-Kurzreferenz) anhängen bzw. im Notebook hinterlegen.
- **Vorher die Datei sichern** (PBIP-Ordner kopieren oder PBIX speichern unter).
- **Umbenennen** (z. B. `m_QQ` → `Qualitätsquote`) nicht per TMDL-Skript, sondern im Datenbereich (Doppelklick auf den Namen):
  Desktop passt dann DAX-Verweise und Visuals an. Ein umbenanntes Measure im `createOrReplace`-Skript legt dagegen ein
  **neues** Measure an, Visuals verlieren das alte.
- Datenschutz: nur Metadaten und Glossar; unternehmensfreigegebenen Copilot nutzen.
- **Variante Copilot in Power BI:** Modellansicht › Measure markieren › Eigenschaften › Beschreibung › **Mit Copilot erstellen**.
  Erzeugt die Beschreibung aus dem DAX (ohne Kommentare und Texte in Anführungszeichen), nur je Measure, nur mit
  Fabric-/Premium-Kapazität. Fachliche Bedeutung kennt diese Variante nicht – das Glossar schon.

## Prompt
```text
Du bist Power-BI-Modellierer und ergänzt Beschreibungen im Modell. Halte dich an die TMDL-Kurzreferenz (K03).

Kontext:
- TMDL-Skript aus der TMDL-Ansicht (createOrReplace mit ref table): [EINFÜGEN: Skript]
- Fachliche Definitionen: [EINFÜGEN: Glossar K05 oder eigene Definitionen]

Aufgabe:
1. Schreib für jedes Objekt im Skript eine Beschreibung: 1–2 Sätze, fachliche Definition, Einheit, Besonderheit
   (z. B. „leer, wenn kein Plan vorhanden“). Höchstens 200 Zeichen, das Wichtigste zuerst.
2. Gib das vollständige Skript zurück, in dem NUR die Beschreibungen ergänzt sind: je Objekt eine Zeile
   /// Beschreibung direkt über der Zeile mit measure bzw. column, ohne Leerzeile dazwischen.
3. Schlag je Measure 2–4 Synonyme vor, wie Fachleute danach fragen würden (z. B. „QQ“, „Prüfquote“).

Regeln:
- Alles andere bleibt Zeichen für Zeichen gleich: Namen, DAX, formatString, lineageTag, Einrückung mit Tabs.
- Keine neuen Objekte, keine Umbenennungen, keine neuen Eigenschaften.
- Wenn die Bedeutung weder aus Glossar noch DAX eindeutig ist: Beschreibung „TODO: fachlich klären“ und in der Liste offener Punkte nennen.
- Beschreibung beschreibt die fachliche Bedeutung, nicht den DAX-Code („Summe von …“ nur, wenn das die Bedeutung ist).

Ausgabe: 1. Skript in einem ```tmdl-Block. 2. Tabelle „Objekt | Synonyme“. 3. „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn die TMDL-Ansicht beim Anwenden einen Fehler meldet:
```text
Die TMDL-Ansicht meldet beim Anwenden: [EINFÜGEN: Meldung aus dem Bereich Probleme, mit Zeile].
Korrigiere nur diese Stelle. Prüfe dabei Einrückung (Tabs), Leerzeilen zwischen /// und Objekt und Anführungszeichen bei Namen.
```
Wenn die Beschreibungen zu technisch sind:
```text
Formuliere die Beschreibungen für Berichtsnutzer ohne DAX-Kenntnis: Was bedeutet die Zahl, wann ist sie gut, welche
Einheit. Keine Funktionsnamen.
```
Wenn Sie auch Spalten und Tabellen beschreiben wollen:
```text
Mach dasselbe für dieses Skript mit Spalten und Tabellen: [EINFÜGEN: Skript]. ID-Spalten beschreibst du als
„technischer Schlüssel, nicht für Auswertungen“.
```

## Ergebnis prüfen
- [ ] Vor dem Anwenden: Skript mit dem Original vergleichen – nur `///`-Zeilen dürfen neu sein (z. B. in VS Code: Vergleich zweier Dateien).
- [ ] TMDL-Ansicht › **Anwenden** › Bereich **Probleme** leer, Bereich **Ausgabe** meldet Erfolg.
- [ ] Stichprobe in der Modellansicht: Beschreibung erscheint im Eigenschaftenbereich und als Tooltip im Datenbereich.
- [ ] Bericht und Measures funktionieren unverändert (Seite Kennzahlenübersicht öffnen).
- [ ] Beschreibungen fachlich gegengelesen – besonders Schwellen und Einheiten (8 %, 90 %, €).
- [ ] Gegenprobe mit `INFO_Abfragen.dax`, Abfrage 5: Liste der Objekte ohne Beschreibung ist kürzer geworden.

## Stolperfallen
- Leerzeichen statt Tabs nach dem Kopieren aus dem Chat: Die TMDL-Ansicht lehnt das Skript ab. Notfalls im Editor Strg+H, Regex.
- Eine Leerzeile zwischen `///` und `measure` lässt die Beschreibung verschwinden – ohne Fehlermeldung.
- `createOrReplace` ersetzt das ganze Objekt. Fehlt im zurückgegebenen Skript eine Eigenschaft (z. B. `formatString`), ist sie danach weg.
- **Synonyme** gehören nicht ins TMDL-Measure, sondern ins linguistische Schema (Modellansicht › Eigenschaften › Synonyme, bzw.
  Q&A-Einrichtung). Q&A unterstützt offiziell nur Englisch und wird laut Microsoft im Februar 2027 eingestellt; in einem
  de-DE-Modell ist das Feld daher evtl. nicht nutzbar. Robuster Weg: Synonyme als Begriffsliste in die **AI-Instructions**
  (M1-13) und ins Glossar übernehmen.
