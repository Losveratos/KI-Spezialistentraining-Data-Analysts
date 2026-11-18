# L02 · DAX mit Copilot

> **Wofür:** die wichtigsten DAX-Regeln zum Nachschlagen – und wie Microsoft 365 Copilot beim Erklären, Schreiben,
> Korrigieren und Testen hilft. **Für wen:** Data Analysts, die Measures in Power BI Desktop pflegen (Import und DirectQuery).
> **Bezug:** Modul 1, Übungen Ü1.2–Ü1.8 und Ü1.11 ([Übungen](../uebungen/Modul1_Uebungen.md), [Übungsmodell](../uebungsdaten/modell/README.md)).
> Formatierung und Benennung regelt der [DAX-Styleguide K02](../prompts/kontext/K02_DAX-Styleguide.md) – hier nicht wiederholt.
> Ausführliche Einzelprompts: [M1-03](../prompts/modul1/M1-03_DAX-formatieren-kommentieren.md) bis
> [M1-09](../prompts/modul1/M1-09_Measure-aus-TMDL-Kontext.md).

## Auf einen Blick

1. **Erst den Kontext klären, dann die Formel.** Ein Measure rechnet im Filterkontext der Visual-Zelle, eine berechnete Spalte im Zeilenkontext.
2. **Kennzahlen als explizite Measures** – nicht als berechnete Spalte, nicht als implizite Summe aus der Feldliste.
3. **CALCULATE ändert Filter; ein Measure-Aufruf in einem Iterator löst Kontextübergang aus.** Beides bewusst einsetzen.
4. **Filter als Spaltenprädikat** (`Region[Region] = "Nord"`), `FILTER` nur, wenn ein Measure in der Bedingung steht.
5. **`DIVIDE` statt `/`**, Zwischenergebnisse als `VAR`, vorhandene Measures wiederverwenden.
6. **BLANK nicht in 0 verwandeln.** Leere Werte blenden Zeilen aus und halten Visuals schnell.
7. **Zeitintelligenz nur über `Kalender[Datum]`**, die Kalendertabelle als Datumstabelle markiert.
8. **Anteile: Nenner bewusst wählen** – `REMOVEFILTERS` für das Gesamt, `ALLSELECTED` für die sichtbare Auswahl.
9. **DirectQuery: einfach bleiben.** Jedes Measure wird zu SQL; Rechenlogik gehört möglichst in die Quelle.
10. **Copilot-Code ist ein Vorschlag.** Erst in der DAX-Abfrageansicht testen, alt gegen neu vergleichen, dann übernehmen.

## Das Wichtigste kompakt

### Zeilen- und Filterkontext

**Filterkontext** sind die Filter einer Zelle: Zeile und Spalte im Visual, Slicer, Seiten- und Berichtsfilter. Measures werden
je Zelle neu ausgewertet. **Zeilenkontext** ist „die aktuelle Zeile“ in berechneten Spalten und Iteratoren (`SUMX`, `FILTER`,
`ADDCOLUMNS`) – er filtert nichts. Deshalb ist `Kosten je Stunde = DIVIDE ( [Ist Kosten], [Ist Stunden] )` als Measure in
jeder Zelle und in der Summenzeile richtig; als berechnete Spalte je Faktzeile summiert oder gemittelt ergibt sie Unsinn.

### CALCULATE und Kontextübergang

`CALCULATE` wertet einen Ausdruck in geändertem Filterkontext aus. Ein Prädikat **ersetzt** den Filter auf dieser Spalte;
`KEEPFILTERS ( … )` schneidet ihn stattdessen mit der Auswahl im Bericht.

```dax
Ist Kosten Winterdienst =
CALCULATE ( [Ist Kosten], Leistungsart[Leistungsart] = "Winterdienst" )
```

**Kontextübergang:** In einem Iterator wird jeder Measure-Aufruf intern in `CALCULATE` gehüllt – die aktuelle Zeile wird
zum Filter. Gewollt beim Iterieren über eine Dimension; über die **Faktentabelle** (`SUMX ( Fakt_Leistung, [Ist Kosten] )`)
dagegen teuer (ein Kontextübergang je Faktzeile) und bei doppelten Zeilen falsch.

```dax
// Summe der Kostenüberschreitungen je Region: Unterschreitungen gleichen nichts aus
Kostenüberschreitung Regionen =
SUMX ( VALUES ( Region[Region] ), MAX ( 0, [Abw Kosten] ) )
```

### Iteratoren und Aggregatoren

`SUM`, `MAX`, `COUNTROWS` aggregieren eine Spalte. `SUMX`, `AVERAGEX` & Co. rechnen erst je Zeile, dann wird aggregiert.
Ein Iterator ist nötig, wenn Produkt oder Quotient **je Zeile** gebildet werden muss:

```dax
// Sollkosten: Plankostensatz der Zeile × Ist-Stunden (flexible Plankosten)
Soll Kosten =
SUMX (
    Fakt_Leistung,
    DIVIDE ( Fakt_Leistung[Plan_Kosten], Fakt_Leistung[Plan_Stunden] )
        * Fakt_Leistung[Ist_Stunden]
)
```

Quoten wie [m_QQ] (Qualitätsquote) dagegen als `DIVIDE ( SUM ( … ), SUM ( … ) )` – ein `AVERAGEX` über Zeilenquoten
wäre ungewichtet.

### Filter: Spaltenprädikat statt FILTER ( Tabelle )

```dax
CALCULATE ( [Ist Kosten], FILTER ( Fakt_Leistung, Fakt_Leistung[Ueberstunden] > 0 ) )   // schlecht: iteriert die Faktentabelle
CALCULATE ( [Ist Kosten], Fakt_Leistung[Ueberstunden] > 0 )                             // gut
CALCULATE ( [Ist Kosten], Leistungsart[Leistungsart] IN { "Winterdienst", "Sicherheitsdienst" } )
```

`FILTER` ist richtig, wenn die Bedingung ein Measure enthält – dann über eine kleine Spalte:
`CALCULATE ( [Ist Kosten], FILTER ( VALUES ( Region[Region] ), [Abw Kosten %] > 0.05 ) )`.

### VAR, RETURN und DIVIDE

Eine Variable wird **einmal** ausgewertet, im Kontext ihrer Definition – auch wenn `RETURN` später Filter ändert. Zum
Debuggen vorübergehend eine Variable zurückgeben. `DIVIDE` liefert bei Nenner 0 oder leer BLANK; ein dritter Parameter
(z. B. 0) ist fast nie sinnvoll. Beispiele: [K02](../prompts/kontext/K02_DAX-Styleguide.md).

### ALL, REMOVEFILTERS, ALLSELECTED – Anteile

| Funktion im Nenner | Wirkung | Typischer Einsatz |
|---|---|---|
| `REMOVEFILTERS ( Region )` | entfernt alle Filter der Tabelle | Anteil am Gesamt, unabhängig vom Slicer |
| `ALL ( Region[Region] )` | wie oben je Spalte; liefert auch eine Tabelle | zusätzlich als Tabelle in Iteratoren |
| `ALLSELECTED ( Region[Region] )` | stellt die Auswahl außerhalb des Visuals wieder her | Anteil an den sichtbaren Regionen (Summe 100 %) |
| `ALLEXCEPT ( Kalender, Kalender[Jahr] )` | entfernt alle Kalenderfilter außer Jahr | Anteil am Jahreswert |

```dax
Anteil Kosten Gesamt % =
DIVIDE ( [Ist Kosten], CALCULATE ( [Ist Kosten], REMOVEFILTERS ( Region ) ) )

Anteil Kosten Auswahl % =
DIVIDE ( [Ist Kosten], CALCULATE ( [Ist Kosten], ALLSELECTED ( Region[Region] ) ) )
```

Sortierspalten: Ist `Kalender[Monatsname]` nach `Kalender[MonatNr]` sortiert, filtert jede Visual-Zeile **beide** Spalten.
Den Filter nur auf `Monatsname` zu entfernen reicht nicht – beide Spalten oder die Tabelle nennen.

### Zeitintelligenz

- `TOTALYTD`, `DATESYTD`, `SAMEPERIODLASTYEAR`, `DATEADD` immer mit `Kalender[Datum]`, nie mit `Fakt_Leistung[Monat]`:
  `Kosten YTD = TOTALYTD ( [Ist Kosten], Kalender[Datum] )`. Kalender markieren, lückenlos, ganze Jahre.
- Im Übungsmodell sind genau das eingebaute Fehler: `Kosten YTD` nutzt `Fakt_Leistung[Monat]`, der Kalender ist nicht
  markiert ([INFO_Abfragen.dax](../uebungsdaten/modul1/INFO_Abfragen.dax), Abfragen 6 und 7).
- Der Kalender reicht bis 31.12.2026 – ohne Schutz zeigen YTD und Vorjahresvergleich Werte für Monate ohne Ist.

```dax
// Abweichung zum Vorjahr in %; leer, solange für den Monat kein Ist vorliegt
Abw Kosten VJ % =
VAR _Ist = [Ist Kosten]
VAR _VJ = [Ist Kosten VJ]
RETURN
    IF ( NOT ISBLANK ( _Ist ), DIVIDE ( _Ist - _VJ, _VJ ) )
```

Die neuere kalenderbasierte Zeitintelligenz (eigene Kalenderdefinition, laut Microsoft Learn Vorschau) behandelt dieser
Leitfaden nicht.

### SWITCH ( TRUE () ) und BLANK-Verhalten

`SWITCH ( TRUE (), … )` prüft der Reihe nach, die **erste** wahre Bedingung gewinnt. Leere Werte zuerst abfangen:

```dax
Kostenklasse =
VAR _Abw = [Abw Kosten %]
RETURN
    SWITCH (
        TRUE (),
        ISBLANK ( _Abw ), BLANK (),    // sonst landet "kein Plan" in "im Plan"
        _Abw > 0.05, "über Plan",
        _Abw < -0.05, "unter Plan",
        "im Plan"
    )
```

- `BLANK + 5 = 5`, aber `BLANK * 5 = BLANK`. Folge: `[Ist Kosten] - [Plan Kosten]` zeigt für einen noch nicht gebuchten
  Monat den ganzen Plan als negative Abweichung.
- `BLANK = 0` ist wahr, `BLANK == 0` falsch (`==` vergleicht streng).
- Visuals blenden Zeilen aus, in denen alle Measures BLANK sind. `COALESCE ( …, 0 )`, `+ 0` oder `IF ( ISBLANK ( … ), 0 )`
  machen dünne Ergebnisse dicht: lange Tabellen, langsame Abfragen.

### Measures statt berechneter Spalten – explizit statt implizit

- **Berechnete Spalten** werden beim Aktualisieren gespeichert, kosten Speicher und reagieren nicht auf Slicer. Nur für
  Attribute zum Filtern oder Gruppieren – und die besser in Power Query oder der SQL-View ([L01](L01_Power-Query.md)).
- **Implizite Measures** entstehen, wenn eine Spalte mit Σ ins Visual gezogen wird: keine zentrale Logik, kein Formatstring,
  keine Beschreibung. Berechnungsgruppen und „In Excel analysieren“ (MDX) brauchen explizite Measures.
- Umsetzen: numerische Faktspalten ausblenden, Measures mit Beschreibung anlegen, im Modell-Explorer die Modelleigenschaft
  „Implizite Measures vermeiden“ (engl. *Discourage implicit measures*) setzen. Bestehende Visuals funktionieren weiter.

### DirectQuery-Besonderheiten

- Jedes Visual schickt SQL an die Quelle (z. B. Azure SQL). Measures zunächst einfach halten (`SUM`, `COUNT`, `MIN`, `MAX`);
  komplexes `CALCULATE` und Iteratoren über die Faktentabelle erzeugen teure Abfragen.
- Berechnete Spalten nur zeilenweise und in SQL übersetzbar; `FILTER` ist in berechneten Spalten und RLS-Regeln nicht
  unterstützt. Besser in der View rechnen. Die Datumstabelle gehört ebenfalls in die Quelle.
- BLANK nicht in 0 umwandeln, Measure-Filter und Summenzeilen sparsam – jedes erzeugt zusätzliche Abfragen. Ergebnisse
  können von Import abweichen (SQL-Semantik, z. B. Collation). SAP BW per DirectQuery: keine berechneten Spalten,
  eingeschränktes DAX.

## Mit Copilot arbeiten

**Zwei Wege.** (1) **M365 Copilot Chat oder Notebook** – immer verfügbar, kennt nur, was Sie einfügen. K02 und
[K03](../prompts/kontext/K03_TMDL-Kurzreferenz.md) im Notebook hinterlegen, TMDL aus der TMDL-Ansicht einfügen.
(2) **Copilot in der DAX-Abfrageansicht** – nur mit Arbeitsbereich auf bezahlter Fabric- oder Premium-Kapazität (F2+/P1+),
vom Admin freigegeben, nicht mit Testkapazität. Er liest Modellmetadaten (Beschreibungen nur die ersten 200 Zeichen) und
einzelne Min/Max-Werte, aber keine fachlichen Definitionen; neue DAX-Funktionen kennt er evtl. nicht.

### 1 · Measure erklären

**Wann:** vor jeder Änderung an einem gewachsenen Measure. Ausführlich: [M1-06](../prompts/modul1/M1-06_Grosses-Measure-analysieren.md).

```text
Du bist DAX-Expert*in im Produktionscontrolling. Erkläre das Measure für Kolleg*innen aus dem Controlling.
Measure: [EINFÜGEN: DAX-Code]
Modellkontext (TMDL der beteiligten Tabellen und Beziehungen): [EINFÜGEN: TMDL-Ausschnitt]
Ausgabe: 1. Zweck in einem Satz. 2. Schritte: welcher Filterkontext gilt, wo CALCULATE Filter ändert, wo
Kontextübergang entsteht. 3. Verhalten bei leeren Werten, Nenner 0 und in der Summenzeile. 4. Risiken als Liste.
Ändere den Code nicht. Wenn eine Definition fehlt, frag nach, statt zu raten.
```

**Ergebnis prüfen:** Aussagen zur Summenzeile per Testabfrage nachrechnen · jede genannte Funktion auf dax.guide
nachschlagen · nur Objekte aus dem TMDL. Variante Copilot in Power BI: Measure › Schnellabfrage „Definieren und
auswerten“, dann **Diese Abfrage erklären**.

### 2 · Measure aus TMDL-Kontext schreiben

**Wann:** neue Kennzahl. Vollständig mit TMDL-Ausgabe: [M1-09](../prompts/modul1/M1-09_Measure-aus-TMDL-Kontext.md).

```text
Erstelle das Measure „[EINFÜGEN: Name]“ nach DAX-Styleguide K02.
Fachliche Definition mit Einheit: [EINFÜGEN: Definition]. Bei leerem Nenner/fehlendem Vorjahr: [EINFÜGEN: Verhalten].
Modell als TMDL (maßgeblich, andere Objekte gibt es nicht): [EINFÜGEN: TMDL]
Regeln: nur Objekte aus dem TMDL, vorhandene Measures wiederverwenden, Zeitintelligenz nur über Kalender[Datum], DIVIDE.
Ausgabe: Measure mit Kopfkommentar, Liste der verwendeten Objekte, Testabfrage, Annahmen.
```

**Ergebnis prüfen:** Objektliste gegen das TMDL abhaken · Testabfrage läuft, Wert für einen bekannten Monat stimmt ·
keine kopierte Logik vorhandener Measures.

### 3 · Fehler aus der Meldung beheben

**Wann:** rote Meldung in der Bearbeitungsleiste oder „Fehler beim Abrufen der Daten“. Ausführlich:
[M1-08](../prompts/modul1/M1-08_Fehler-beheben.md), Übungsfälle: [Fehlerfaelle.md](../uebungsdaten/modul1/Fehlerfaelle.md).

```text
Diese DAX-Formel erzeugt einen Fehler.
Code: [EINFÜGEN: DAX]   Meldung im Wortlaut: [EINFÜGEN: Fehlermeldung]
Datentypen der beteiligten Spalten (TMDL): [EINFÜGEN: TMDL-Ausschnitt]
Erst Diagnose (Ursache in 2 Sätzen, betroffene Stelle), dann korrigierter Code, dann eine Testabfrage, die den Fix belegt.
Unterdrücke Fehler nicht mit IFERROR oder ISERROR.
```

**Ergebnis prüfen:** Ursache erklärt den Wortlaut der Meldung · der Fix ändert die fachliche Bedeutung nicht (Jahr bleibt
Zahl, statt per `FORMAT` Text zu werden) · Testabfrage ausgeführt.

### 4 · Performance verbessern – mit Begründung

**Wann:** Visual lädt langsam, die Leistungsanalyse zeigt hohe DAX-Zeit. Vergleichstest: [M1-07](../prompts/modul1/M1-07_Measure-refaktorisieren-und-testen.md).

```text
Prüfe das Measure auf Performance-Muster: FILTER über ganze Tabellen in CALCULATE, Measure-Aufrufe in Iteratoren über
die Faktentabelle, mehrfach berechnete Ausdrücke, IF statt DIVIDE, BLANK in 0 umgewandelt, IFERROR.
Measure: [EINFÜGEN: DAX]   Speichermodus: [EINFÜGEN: Import / DirectQuery]   TMDL: [EINFÜGEN: TMDL]
Ausgabe: Tabelle „Fundstelle | Muster | Warum langsam | Änderung“, dann die neue Fassung.
Das Ergebnis muss in jedem Filterkontext gleich bleiben. Schreib eine Vergleichsabfrage alt gegen neu.
```

**Ergebnis prüfen:** Vergleichsabfrage ohne unerklärte Abweichungen · Laufzeit vorher/nachher selbst messen
(Leistungsanalyse, Abfragezeit in der DAX-Abfrageansicht) – „schneller“ ohne Messung ist nur eine Behauptung.

### 5 · Testabfrage erzeugen

**Wann:** bei jedem neuen oder geänderten Measure und zum Abgleich mit einem Berichtswert.

```text
Schreib eine DAX-Abfrage für die DAX-Abfrageansicht von Power BI Desktop.
Measures: [EINFÜGEN: Code oder Namen]   Gruppierung: [EINFÜGEN: z. B. Region[Region], Kalender[Monat]]
Filter: [EINFÜGEN: z. B. Jahr 2026]   Modell: [EINFÜGEN: TMDL]
Aufbau: ein DEFINE-Block mit DEFINE MEASURE für neue/geänderte Measures, EVALUATE SUMMARIZECOLUMNS mit TREATAS für
Filter, die Basis-Measures als Kontrollspalten, ORDER BY. Nur Objekte aus dem TMDL.
```

**Ergebnis prüfen:** läuft fehlerfrei · Filterwerte passen zum Datentyp (`{ 2026 }` Zahl, `{ "2026-10" }` Text) · eine
Zeile gegen den Bericht abgeglichen. Variante Copilot in Power BI: die Abfrage in Worten in der DAX-Abfrageansicht anfordern.

### 6 · Anteils- und Zeitvergleichsmuster

**Wann:** Anteil am Gesamt oder an der Auswahl, Vorjahr, YTD, rollierende 12 Monate.

```text
Schreib ein Measure nach K02 für: [EINFÜGEN: z. B. Anteil der Region an den Ist Kosten der ausgewählten Regionen].
Filter, die bleiben: [EINFÜGEN: z. B. Leistungsart, Jahr]   Filter, die wegfallen: [EINFÜGEN: z. B. Region]
Zeitbezug: [EINFÜGEN: z. B. Vorjahresmonat]. Monate ohne Ist-Daten bleiben leer.
Begründe in zwei Sätzen die Wahl zwischen REMOVEFILTERS, ALL, ALLSELECTED, ALLEXCEPT bzw. der Zeitfunktion.
TMDL: [EINFÜGEN: TMDL mit Kalender und Beziehungen]
```

**Ergebnis prüfen:** Anteile summieren sich im Visual dort zu 100 %, wo Sie es erwarten · VJ-Wert für 2026-10 gleich
Ist für 2025-10 · Monate ohne Ist bleiben leer · Sortierspalten im Nenner berücksichtigt.

### 7 · Beschreibungen erzeugen

**Wann:** vor der Veröffentlichung, auch als Grundlage für Copilot in Power BI. Ausführlich: [M1-12](../prompts/modul1/M1-12_Beschreibungen-als-TMDL.md).

```text
Schreib für jedes Measure im TMDL-Skript eine Beschreibung: fachliche Definition, Einheit, Verhalten bei leeren Werten.
Höchstens 200 Zeichen, Wichtigstes zuerst. Leite die Definition aus dem DAX-Code ab, nicht aus dem Namen.
Fachliche Definitionen: [EINFÜGEN: Glossar K05 oder eigene]   TMDL-Skript: [EINFÜGEN: createOrReplace-Skript]
Gib das Skript zurück, ergänzt nur um /// Beschreibung direkt über jeder measure-Zeile. Unklares als Frage auflisten.
```

**Ergebnis prüfen:** Beschreibung passt zum Code (`m_QQ` = bestandene durch durchgeführte Prüfungen) · keine erfundenen
Geschäftsregeln · ≤ 200 Zeichen. Ohne TMDL-Ansicht: `///` über `MEASURE` im `DEFINE`-Block der DAX-Abfrageansicht
schreiben und das Modell aktualisieren – die Beschreibung wird mitgespeichert.

## Testen in der DAX-Abfrageansicht

Eine Abfrage besteht aus optionalem `DEFINE` (Measures und Variablen nur für diese Abfrage) und mindestens einem
`EVALUATE`. Ein per `DEFINE MEASURE` definiertes Measure ersetzt in der Abfrage das gleichnamige Modell-Measure – so testen
Sie Änderungen, ohne das Modell anzufassen. Übernommen wird erst per CodeLens **Modell aktualisieren** bzw. Schaltfläche
**Modell mit Änderungen aktualisieren**. Pro Ausführung nur ein `DEFINE`-Block.

Vergleich alt gegen neu – `Abw Kosten %` rechnet im Übungsmodell mit `/`, die neue Fassung mit `DIVIDE`:

```dax
DEFINE
    MEASURE Fakt_Leistung[Abw Kosten % NEU] =
        DIVIDE ( [Abw Kosten], [Plan Kosten] )

    VAR _Vergleich =
        SUMMARIZECOLUMNS (
            Region[Region],
            Kalender[Monat],
            TREATAS ( { 2026 }, Kalender[Jahr] ),
            "Alt", [Abw Kosten %],
            "Neu", [Abw Kosten % NEU]
        )

EVALUATE
FILTER (
    _Vergleich,
    ISBLANK ( [Alt] ) <> ISBLANK ( [Neu] )
        || ABS ( [Alt] - [Neu] ) > 0.000001
)
ORDER BY Region[Region], Kalender[Monat]
```

- Leeres Ergebnis = keine Abweichung. Erwartet sind hier nur Zeilen mit Plan 0 oder leer (alt „Unendlich“, neu leer).
  **Abweichungen erklären, nicht nur zählen.**
- `SUMMARIZECOLUMNS` gruppiert wie ein Visual und lässt Zeilen weg, in denen alle Measures leer sind. `TREATAS` setzt
  einen Filter wie ein Slicer – Datentyp beachten (`Kalender[Jahr]` Zahl, `Kalender[Monat]` Text).
- Gerüst per Rechtsklick auf ein Measure › Schnellabfragen › „Definieren mit Verweisen und auswerten“; die Abfrage eines
  Visuals über die Leistungsanalyse. Fertige Vergleiche: [INFO_Abfragen.dax](../uebungsdaten/modul1/INFO_Abfragen.dax), 7–9.

## Häufige Fehler und erfundene Funktionen

| Symptom | Ursache | Lösung |
|---|---|---|
| „Ein einzelner Wert für die Spalte … kann nicht ermittelt werden“ | Spalte im Measure ohne Aggregation | `DIVIDE ( SUM ( … ), SUM ( … ) )` oder vorhandene Measures |
| „… Vergleiche von Werten des Typs Integer mit Werten des Typs Text …“ | `Kalender[Jahr] = "2026"` | Zahl ohne Anführungszeichen: `Kalender[Jahr] = 2026` |
| YTD oder VJ leer bzw. gleich dem Monatswert | Zeitfunktion auf `Fakt_Leistung[Monat]`, Kalender nicht markiert/lückenhaft | `Kalender[Datum]`, Kalender als Datumstabelle markieren |
| „Unendlich“ oder „NaN“ im Visual | Division mit `/` bei Nenner 0 | `DIVIDE` |
| Visual zeigt plötzlich alle Kombinationen mit 0 | BLANK per `COALESCE`, `+ 0` oder `IF` in 0 verwandelt | BLANK zurückgeben lassen |
| Anteil überall 100 % | Nenner entfernt den Filter nicht (falsche Spalte, Sortierspalte) | `REMOVEFILTERS` auf Tabelle oder beide Spalten |
| Summenzeile „stimmt nicht“ | nicht additive Kennzahl oder fehlender Iterator | fachlich entscheiden; ggf. `SUMX ( VALUES ( … ), [Measure] )` |
| Measure sehr langsam | `FILTER ( Fakt_Leistung, … )` oder Measure-Aufruf je Faktzeile | Spaltenprädikat, Iteration über Dimension |
| DirectQuery-Visual läuft in Zeitüberschreitung | komplexes Measure wird zu teurem SQL | vereinfachen, Logik in die View |
| „Es wurde eine zirkuläre Abhängigkeit erkannt“ | Sortierspalte aus der sortierten Spalte berechnet | Sortierspalte aus der Quelle (`Kalender[MonatNr]`) |
| Mehrere Abfragen auf einmal scheitern | mehr als ein `DEFINE`-Block | Abfragen einzeln markieren oder je Registerkarte |

**Typische KI-Halluzinationen** – diese Funktionen gibt es in DAX nicht:

- `DATEDIFFMONTH`, `DATEDIF` → `DATEDIFF ( Datum1, Datum2, MONTH )` · `PERCENTCHANGE`, `YOY` → `DIVIDE ( [Neu] - [Alt], [Alt] )`
- `SAMEPERIODPREVIOUSYEAR`, `PREVIOUSPERIOD` → `SAMEPERIODLASTYEAR`, `DATEADD`, `PREVIOUSMONTH`
- aus Excel: `SUMIF(S)`, `COUNTIFS`, `AVERAGEIF` → `CALCULATE ( [Measure], Prädikat )` · `VLOOKUP`, `XLOOKUP` → `RELATED`,
  `LOOKUPVALUE` · `TEXTJOIN` → `CONCATENATEX`
- aus SQL: `ISNULL`, `NVL`, `NULLIF` → `ISBLANK`, `COALESCE` · `CASE WHEN` → `SWITCH` · `GETDATE` → `TODAY`, `NOW` ·
  `DATEPART` → `YEAR`, `MONTH`, `QUARTER` · `SUBSTRING` → `MID` · `STRING_AGG` → `CONCATENATEX` · `LAG`, `LEAD` → `OFFSET`
  oder Zeitintelligenz · `GROUP BY` → `SUMMARIZECOLUMNS` · `NULL` → `BLANK ()`
- SQL-Syntax: `!=` → `<>`, `IN ('a', 'b')` → `IN { "a", "b" }`; Text immer in doppelten Anführungszeichen
- aus Power Query: `Text.Combine`, `Date.Year` usw. sind M, nicht DAX
- `RUNNINGSUM`, `MOVINGAVERAGE`, `PREVIOUS`, `NEXT` gibt es – aber **nur in Visualberechnungen**, nicht in Measures
- echt, obwohl sie erfunden wirken: `COALESCE`, `NETWORKDAYS`, `OFFSET`, `WINDOW`, `RANK`

Gegenmittel: Funktion auf dax.guide oder Microsoft Learn nachschlagen, in einem neuen Chat gegenprüfen lassen
([M1-02](../prompts/modul1/M1-02_Halluzinationen-gegenpruefen.md)), Code immer ausführen.

## Checkliste vor dem Veröffentlichen

- [ ] Alle Kennzahlen sind explizite Measures; numerische Faktspalten ausgeblendet, implizite Measures unterbunden
- [ ] Jedes Measure nach [K02](../prompts/kontext/K02_DAX-Styleguide.md): Kopfkommentar, Formatstring, Anzeigeordner
- [ ] Jedes Measure hat eine Beschreibung, das Wichtigste in den ersten 200 Zeichen
- [ ] Kein `/` außer bei konstantem Nenner; keine BLANK-zu-0-Umwandlung ohne fachlichen Grund
- [ ] Zeitintelligenz nur über `Kalender[Datum]`; Kalender markiert und lückenlos; Monate ohne Ist bleiben leer
- [ ] Anteile: Nenner geprüft (Gesamt oder Auswahl), Sortierspalten berücksichtigt
- [ ] Kein `FILTER ( Faktentabelle, … )` in `CALCULATE`, keine Measure-Aufrufe je Faktzeile
- [ ] Geänderte Measures per Vergleichsabfrage alt gegen neu geprüft, Abweichungen erklärt
- [ ] Mindestens eine Zahl je Seite gegen Quelle oder Vorbericht abgeglichen
- [ ] DirectQuery: Laufzeit der wichtigsten Visuals in der Leistungsanalyse gemessen
- [ ] Keine von Copilot vorgeschlagene Funktion ungeprüft übernommen, Annahmen geklärt

## Weiterführend

- **Microsoft Learn:** [DAX-Funktionsreferenz](https://learn.microsoft.com/dax/dax-function-reference) ·
  [DAX-Abfragen](https://learn.microsoft.com/dax/dax-queries) ·
  [DAX-Abfrageansicht](https://learn.microsoft.com/power-bi/transform-model/dax-query-view) ·
  [DAX-Abfragen mit Copilot schreiben](https://learn.microsoft.com/dax/dax-copilot) ·
  [Copilot mit semantischen Modellen](https://learn.microsoft.com/power-bi/create-reports/copilot-semantic-models)
- **Best Practices (Learn):** [Variablen](https://learn.microsoft.com/dax/best-practices/dax-variables) ·
  [DIVIDE statt /](https://learn.microsoft.com/dax/best-practices/dax-divide-function-operator) ·
  [FILTER nicht als Filterargument](https://learn.microsoft.com/dax/best-practices/dax-avoid-avoid-filter-as-filter-argument) ·
  [BLANK nicht umwandeln](https://learn.microsoft.com/dax/best-practices/dax-avoid-converting-blank) ·
  [Spalten- und Measure-Verweise](https://learn.microsoft.com/dax/best-practices/dax-column-measure-references)
- **Zeit und DirectQuery (Learn):** [Datumstabellen](https://learn.microsoft.com/power-bi/transform-model/desktop-date-tables) ·
  [Zeitbezogene Berechnungen](https://learn.microsoft.com/power-bi/transform-model/desktop-time-intelligence) ·
  [DirectQuery-Modelle](https://learn.microsoft.com/power-bi/guidance/directquery-model-guidance)
- **SQLBI:** [dax.guide](https://dax.guide/) · [DAX Formatter](https://www.daxformatter.com/) ·
  [DAX Patterns](https://www.daxpatterns.com/) ·
  [Row Context and Filter Context](https://www.sqlbi.com/articles/row-context-and-filter-context-in-dax/) ·
  [Understanding Context Transition](https://www.sqlbi.com/articles/understanding-context-transition/) ·
  [The definitive guide to ALLSELECTED](https://www.sqlbi.com/articles/the-definitive-guide-to-allselected/)
