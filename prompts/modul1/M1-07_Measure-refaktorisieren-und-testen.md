# M1-07 · Measure refaktorisieren und alt gegen neu testen

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook + DAX-Abfrageansicht | Ü1.7 | 15 min |

## Wofür
Ein langes Measure in eine lesbare, wartbare Fassung bringen: Variablen, `DIVIDE`, Wiederverwendung vorhandener
Measures, benannte Schwellenwerte, `SWITCH ( TRUE (), … )`. Entscheidend ist der zweite Teil: eine
**Vergleichsabfrage**, die beweist, dass alte und neue Fassung dieselben Ergebnisse liefern. Erst dann wird ersetzt.

## Vorbereitung
- Analyse aus M1-06 (im selben Chat weiterarbeiten oder Ergebnis einfügen).
- Code des Measures und Liste der vorhandenen Measures (TMDL der Tabelle ohne Partition).
- **K02** (DAX-Styleguide) anhängen bzw. im Notebook hinterlegen.
- In Desktop eine neue Registerkarte in der **DAX-Abfrageansicht** öffnen. Vorlage für den Vergleich:
  `INFO_Abfragen.dax`, Abfrage 8.
- Datenschutz: nur Code und Metadaten; unternehmensfreigegebenen Copilot nutzen.

## Prompt
```text
Du bist DAX-Entwickler und refaktorisierst ein Measure nach dem DAX-Styleguide (K02), falls er vorliegt.

Kontext:
- Vorhandene Measures (Name und DAX): [EINFÜGEN: TMDL der Tabelle oder Measure-Liste]
- Analyse des Measures (falls vorhanden): [EINFÜGEN: Ergebnis aus M1-06 oder „siehe oben“]
- Original:
[EINFÜGEN: Code des Measures]

Aufgabe:
1. Schreib eine refaktorisierte Fassung:
   - mehrfach berechnete Teilausdrücke genau einmal als VAR,
   - vorhandene Measures wiederverwenden statt deren Logik zu kopieren,
   - Schwellenwerte als benannte VAR am Anfang mit Kommentar,
   - verschachtelte IF als SWITCH ( TRUE (), … ),
   - Kopfkommentar mit Zweck.
2. Schreib eine Vergleichsabfrage für die DAX-Abfrageansicht von Power BI Desktop:
   - DEFINE MEASURE [EINFÜGEN: Tabelle][[EINFÜGEN: Measure-Name] NEU] mit der neuen Fassung,
   - SUMMARIZECOLUMNS über [EINFÜGEN: z. B. Region[Region], Kalender[Monat]] mit Spalten "Alt" und "Neu",
   - eine Abfrage, die nur die Zahl der Abweichungen ausgibt (Textvergleich mit EXACT), und eine, die alle Zeilen zeigt.

Regeln:
- Das Ergebnis muss für jede Zeile identisch zum Original sein – auch in Sonderfällen (leere Monate, Gesamtzeile).
  Wenn du eine fachliche Verbesserung für nötig hältst, setze sie NICHT um, sondern liste sie getrennt auf.
- Ein wiederverwendetes Measure darf nur eingesetzt werden, wenn es exakt dasselbe rechnet. Begründe jede Ersetzung.
- Verwende nur Namen aus dem Kontext.

Ausgabe: 1. Measure in einem ```dax-Block. 2. Vergleichsabfrage in einem ```dax-Block. 3. Tabelle
„Ersetzter Teilausdruck | ersetzt durch | warum gleichwertig“. 4. „Fachliche Verbesserungen (nicht umgesetzt)“.
5. „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn die Vergleichsabfrage Abweichungen zeigt:
```text
Die Vergleichsabfrage zeigt [EINFÜGEN: Anzahl] Abweichungen, z. B. [EINFÜGEN: 2–3 Zeilen aus dem Ergebnisraster].
Erkläre die Ursache anhand des Codes und korrigiere nur die neue Fassung, bis sie gleich rechnet.
```
Wenn Sie danach bewusst eine Verbesserung einbauen wollen (z. B. leere Monate leer lassen):
```text
Setze jetzt nur die Verbesserung [EINFÜGEN: Nr.] um. Passe die Vergleichsabfrage so an, dass sie die Zeilen
ausgibt, in denen sich das Ergebnis dadurch ändert, und begründe, warum genau diese Zeilen betroffen sind.
```
Wenn Sie wissen wollen, ob die neue Fassung schneller ist:
```text
Welche Teile der neuen Fassung werden pro Zelle weniger oft ausgewertet als im Original? Begründe mit der Anzahl
der Storage-Engine-Abfragen, die du erwartest. Schreib dazu, wie ich das mit der Leistungsanalyse in Desktop messe.
```

## Ergebnis prüfen
- [ ] Vergleichsabfrage läuft und zeigt **0 Abweichungen** (Abfrage 8a in `INFO_Abfragen.dax`). Keine Übernahme ohne diesen Nachweis.
- [ ] Vergleich auch auf einer zweiten Granularität (z. B. Leistungsart × Monat oder Gesamt), nicht nur auf der, die Copilot vorschlägt.
- [ ] Wiederverwendete Measures rechnen wirklich dasselbe (`[m_QQ]` = `DIVIDE ( SUM ( …Bestanden ), SUM ( …Pruefungen ) )`).
- [ ] Textvergleich mit `EXACT`: `"Kritisch" = "kritisch"` ist in DAX wahr.
- [ ] Neue Fassung erst danach im Modell ersetzen: Code in die Bearbeitungsleiste des Original-Measures kopieren,
      oder in der DAX-Abfrageansicht im `DEFINE MEASURE` den Namen auf das Original setzen und die CodeLens
      **Modell aktualisieren** über der Zeile nutzen (überschreibt das Measure). Danach Berichtsseite stichprobenartig ansehen.

## Stolperfallen
- Wiederverwendung kann das Verhalten ändern: Wird `[Abw Kosten %]` vorher auf `DIVIDE` umgestellt, liefert es bei
  Plan = 0 BLANK statt unendlich – das ist gewollt, muss aber im Vergleich sichtbar und erklärt sein.
- Copilot „verbessert“ beim Refaktorisieren gern still mit (z. B. `IF ( ISBLANK ( … ) )` am Anfang). Darum Verbesserungen getrennt.
- Variablen werden im Kontext ihrer Definition ausgewertet. Eine VAR außerhalb von `CALCULATE` ändert sich nicht durch
  spätere Filter – bei Refaktorisierungen mit `CALCULATE` genau hinsehen.
- Der Measure-Name `KPI Status Text` bleibt gleich; Berichte verweisen auf den Namen. Die Testfassung heißt `… NEU` und wird danach gelöscht.
