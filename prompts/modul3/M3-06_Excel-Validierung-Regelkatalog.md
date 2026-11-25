# M3-06 · Excel-Export gegen einen Regelkatalog validieren

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | Analyst* oder Copilot Chat mit Dateianhang; alternativ Copilot in Excel | Ü3.4 | 15 min |

\* Analyst (Copilot Chat › Tools) rechnet mit Python und zeigt die Schritte – für eine vollständige Prüfung aller
Zeilen die beste Wahl. Ohne Analyst: gleicher Prompt im normalen Copilot Chat mit angehängter Datei.

## Wofür
Bevor ein Export in den Bericht oder ins Modell geht, wird er gegen feste Regeln geprüft – nicht „schau mal, ob
dir etwas auffällt“, sondern Regel für Regel, Zeile für Zeile, mit Belegnummer. Copilot liefert je Regel eine
Verstoßliste und eine Anzahl und sagt ausdrücklich, was er **nicht prüfen konnte**. Das Ergebnis vergleichen Sie
anschließend mit den Prüfformeln aus [M3-07](M3-07_Excel-Pruefspalten-und-Formeln.md): Zwei unabhängige Wege
müssen dieselben Anzahlen liefern.

## Vorbereitung
- Datei anhängen: `Leistungsnachweise_Export_Okt-2026.xlsx` aus [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/).
  Aufbau: Blatt `Leistungsnachweise` (`tblLeistung`: BelegNr, Datum, Region, Leistungsart, Objekt, Stunden,
  Stundensatz, Betrag, Erfasst_von, Status), Blatt `Stammdaten` (`tblRegion`, `tblLeistungsart` mit
  Stundensatz_min/_max), Blatt `Prüfregeln` (Regelkatalog R1–R8).
- Den Regelkatalog im Blatt `Prüfregeln` einmal selbst lesen – Sie müssen beurteilen, ob Copilot ihn richtig anwendet.

> **Datenschutz:** Nur im unternehmensfreigegebenen Copilot arbeiten (Unternehmenskonto, grünes Schild). Echte
> Leistungsnachweise enthalten Personenbezug (Erfasser, ggf. Objektadressen): Spalten vor dem Anhängen entfernen
> oder pseudonymisieren. Die Übungsdatei ist fiktiv.

## Prompt
```text
Du bist Data-Quality-Analyst*in im Produktionscontrolling und prüfst einen Export vor der Weiterverarbeitung.

Kontext: Angehängt ist [EINFÜGEN: Leistungsnachweise_Export_Okt-2026.xlsx].
- Blatt Leistungsnachweise, Tabelle tblLeistung: eine Zeile je Leistungsnachweis.
- Blatt Stammdaten: tblRegion (gültige Regionen), tblLeistungsart (gültige Leistungsarten mit Stundensatz_min
  und Stundensatz_max).
- Blatt Prüfregeln: Regelkatalog R1–R8. Berichtsmonat: [EINFÜGEN: Oktober 2026]. Zahlenformat deutsch.

Regelkatalog (maßgeblich ist das Blatt Prüfregeln; melde Abweichungen zu dieser Liste):
R1 BelegNr ist eindeutig.
R2 Datum liegt im Berichtsmonat.
R3 Region kommt in tblRegion vor (exakte Schreibweise).
R4 Leistungsart kommt in tblLeistungsart vor (exakte Schreibweise).
R5 Stunden > 0 und ≤ 12.
R6 Stundensatz liegt innerhalb der Spanne Stundensatz_min bis Stundensatz_max der Leistungsart.
R7 Betrag = Stunden × Stundensatz, Toleranz ±0,01 €.
R8 Pflichtfelder sind gefüllt und haben den richtigen Datentyp (Datum ist Datum, Zahlen sind Zahlen).

Aufgabe: Prüfe ALLE Zeilen von tblLeistung gegen jede Regel. Rechne mit Python bzw. dem Analysewerkzeug.

Regeln für die Prüfung:
- Bestätige zuerst: Zeilenzahl von tblLeistung, gelesene Stammdaten (Anzahl Regionen, Anzahl Leistungsarten),
  gelesener Regelkatalog. Wenn du ein Blatt nicht lesen konntest, brich ab und sag es.
- Ein Beleg kann mehrere Regeln verletzen – jede Verletzung ist eine eigene Zeile.
- Bei R1 alle Vorkommen der mehrfachen BelegNr nennen, nicht nur das zweite.
- Kann eine Regel für eine Zeile nicht geprüft werden (z. B. R6 bei unbekannter Leistungsart, R7 bei Text statt
  Zahl), dann Einstufung „nicht prüfbar“ mit Grund – nicht „bestanden“ und nicht weglassen.
- Melde Verstöße, korrigiere nichts. Keine Vermutungen über Ursachen.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
1. Übersicht „Regel | Beschreibung | geprüfte Zeilen | Verstöße | nicht prüfbar“ – eine Zeile je Regel R1–R8,
   auch wenn die Anzahl 0 ist.
2. Verstoßliste „Regel | BelegNr | Excel-Zeile | Feld | Ist-Wert | erwartet | Einstufung (Verstoß / nicht prüfbar)“,
   sortiert nach Regel und BelegNr.
3. Anzahl Belege ohne jeden Verstoß und Anzahl Belege mit mindestens einem Verstoß.
4. Der verwendete Code in einem Block.
```

## Nachschärfen

Wenn nur Beispiele statt aller Verstöße kommen („unter anderem“, „z. B.“):
```text
Die Liste ist unvollständig. Gib für Regel [EINFÜGEN: R-Nummer] alle Verstöße aus – jede BelegNr. Wenn die Liste
zu lang für die Antwort ist, erstelle eine Excel- oder CSV-Datei zum Herunterladen und nenne die Zeilenzahl.
```

Wenn eine Regel falsch verstanden wurde:
```text
Du hast [EINFÜGEN: Regel] so angewendet: [EINFÜGEN: was Copilot getan hat]. Gemeint ist: [EINFÜGEN: richtige
Auslegung, z. B. Grenzen einschließlich; Vergleich ohne Rücksicht auf führende/nachgestellte Leerzeichen NICHT
erlaubt]. Prüfe diese Regel neu und gib nur die geänderten Zeilen der Übersicht und der Verstoßliste aus.
```

Wenn Sie die Auswirkung kennen müssen:
```text
Summiere Betrag und Stunden einmal über alle Belege und einmal nur über Belege ohne Verstoß. Zeig beide Summen
je Region und die Differenz. Keine Korrekturen an den Daten.
```

Für die Rückmeldung an die Datenlieferanten:
```text
Fasse die Verstöße je Regel in einem Satz zusammen (Anzahl, typisches Muster, betroffene Regionen) und formuliere
je Regel eine konkrete Bitte an die erfassende Stelle. Sachlich, höchstens zehn Zeilen, keine Schuldzuweisung.
```

## Ergebnis prüfen
- [ ] Die bestätigte Zeilenzahl von `tblLeistung` stimmt mit Excel überein (Tabelle markieren, Statusleiste).
- [ ] Die Übersicht enthält **alle acht Regeln** – auch die mit 0 Verstößen und mit „nicht prüfbar“.
- [ ] Je Regel zwei gemeldete Belege in Excel nachsehen (Filter auf BelegNr): Stimmt der Verstoß wirklich?
- [ ] Gegenrichtung: Für eine Regel selbst einen Filter setzen (z. B. Stunden > 12) – hat Copilot alle gefunden?
- [ ] Die Anzahlen je Regel stimmen mit den Prüfspalten aus [M3-07](M3-07_Excel-Pruefspalten-und-Formeln.md)
      überein. Weichen sie ab, ist eine der beiden Prüfungen falsch – klären, nicht mitteln.
- [ ] Es wurde nichts „korrigiert“ oder stillschweigend ausgeschlossen.

## Stolperfallen
- **Stichprobe statt Vollprüfung.** Ohne Analysewerkzeug liest Copilot oft nur einen Teil der Zeilen und klingt
  trotzdem vollständig. Zeilenzahl und Code einfordern.
- **„Nicht prüfbar“ verschwindet.** Zeilen mit Text statt Zahl fallen bei Rechenregeln still heraus. Deshalb die
  eigene Spalte in der Übersicht.
- **Toleranz und Grenzen.** „≤ 12“ und „±0,01 €“ werden gern als „< 12“ bzw. exakte Gleichheit umgesetzt.
- **Großzügiger Abgleich.** Copilot „normalisiert“ Schreibweisen gern (Leerzeichen, Groß-/Kleinschreibung) und
  übersieht so genau die Fehler, die im Stammdatenabgleich auffallen sollen.
- **Regelkatalog im Prompt ≠ Regelkatalog in der Datei.** Maßgeblich ist das Blatt `Prüfregeln`; Abweichungen
  melden lassen.

Mehr dazu: [M2-03 Datenprofil und Plausibilitätscheck](../modul2/M2-03_Datenprofil-und-Plausibilitaetscheck.md)
