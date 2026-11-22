# K02 · DAX-Styleguide

> **Wie nutzen?** Im Copilot Notebook hinterlegen oder an Formatierungs-, Kommentierungs- und
> Optimierungsprompts anhängen („Halte dich an den DAX-Styleguide (K02)“). Passen Sie die Regeln
> an Ihre Teamkonventionen an – Copilot übernimmt, was hier steht.

---

## Formatierung

- Formatierung nach SQLBI-Konvention (wie daxformatter.com): Funktionsnamen in GROSSBUCHSTABEN,
  ein Argument pro Zeile, wenn die Zeile sonst länger als ca. 80 Zeichen wäre.
- Einrückung mit 4 Leerzeichen. Öffnende Klammer am Zeilenende, schließende Klammer auf eigener Zeile
  auf Höhe der Funktion.
- Leerzeichen innerhalb von Klammern: `SUM ( Tabelle[Spalte] )`.
- Spalten **immer** mit Tabellennamen (`Fakt_Leistung[Ist_Kosten]`), Measures **nie** mit Tabellennamen (`[Ist Kosten]`).
- Tabellennamen mit Leer- oder Sonderzeichen in einfache Anführungszeichen: `'Fakt Leistung'[Monat]`.

## Aufbau von Measures

- Zwischenergebnisse als `VAR` mit sprechendem Namen, Ergebnis mit `RETURN`.
  Variablennamen ohne Präfix oder mit `_` (`_IstKosten`), einheitlich je Modell.
- Ausdruck, der mehrfach vorkommt → genau einmal als `VAR` berechnen.
- Vorhandene Measures wiederverwenden, statt deren Logik zu kopieren (`[Abw Kosten]` statt `[Ist Kosten] - [Plan Kosten]`).
- Division immer mit `DIVIDE ( Zähler, Nenner )`, nicht mit `/` – außer der Nenner ist eine Konstante.
- Schwellenwerte (z. B. 5 %, 90 %) nicht hart im Code verteilen: einmal als `VAR` am Anfang mit Kommentar.
- Zeitintelligenz nur über die Kalendertabelle (`Kalender[Datum]`), die als Datumstabelle markiert ist.
- `IF`-Kaskaden mit mehr als zwei Stufen → `SWITCH ( TRUE (), … )`.
- Filter in `CALCULATE` als Spaltenprädikat (`Tabelle[Spalte] = "x"`) statt `FILTER ( Tabelle, … )` über ganze Tabellen.

## Kommentare

- Kopfkommentar (`//`) bei jedem Measure mit mehr als drei Zeilen: Zweck in einem Satz, ggf. fachliche Definition.
- Kommentare erklären das **Warum**, nicht das Was („// Plan 0 → BLANK, damit keine Unendlich-Werte entstehen“).
- Deutsch, ohne Umgangssprache. Keine auskommentierten Altfassungen im Code lassen.

## Namen und Metadaten

- Measure-Namen sprechend und fachlich: `Qualitätsquote`, nicht `m_QQ`. Umlaute sind erlaubt.
- Abweichungen einheitlich benennen: `Abw <Kennzahl>` (absolut), `Abw <Kennzahl> %` (relativ).
  Vorjahr: `<Kennzahl> VJ`.
- Jedes Measure hat eine **Beschreibung** (1–2 Sätze, fachliche Definition + Einheit) und einen **Anzeigeordner**.
- Formatstring passend zur Einheit (`#,0 €`, `0.0 %`). Im Formatstring steht immer der Punkt als Dezimaltrenner; die Anzeige folgt der Modellkultur (de-DE zeigt 7,3 %).

## Beispiel

```dax
// Abweichung der Ist- von den Plankosten in Prozent der Plankosten.
// Ohne Plan (0 oder leer) bleibt das Ergebnis leer.
Abw Kosten % =
DIVIDE ( [Abw Kosten], [Plan Kosten] )
```

```dax
// Ampelstatus je Zeile für die Kennzahlenübersicht.
KPI Status =
VAR _SchwelleKosten = 0.05      // > 5 % über Plan gilt als Kostenüberschreitung
VAR _SchwelleKrankenquote = 0.08   // > 8 % Krankenquote gilt als Personalengpass
VAR _KostenUeberPlan = [Abw Kosten %] > _SchwelleKosten
VAR _KrankenquoteHoch = [Krankenquote] > _SchwelleKrankenquote
RETURN
    SWITCH (
        TRUE (),
        _KostenUeberPlan && _KrankenquoteHoch, "kritisch",
        _KostenUeberPlan || _KrankenquoteHoch, "beobachten",
        "im Plan"
    )
```
