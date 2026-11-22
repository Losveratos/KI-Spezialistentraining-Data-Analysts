# M2-02 · KPI-Export per DAX-Abfrage (SUMMARIZECOLUMNS aus TMDL-Kontext)

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | M365 Copilot Chat + DAX-Abfrageansicht (Power BI Desktop); optional Copilot in der DAX-Abfrageansicht* | Ü2.1 | 10 min |

\* Copilot direkt in der DAX-Abfrageansicht braucht einen Arbeitsbereich auf **bezahlter Fabric-Kapazität (ab F2)
oder Power BI Premium (ab P1)** und die Freigabe durch den Fabric-Admin; Testkapazitäten (Trial) werden nicht
unterstützt. In Desktop unter *Optionen › Vorschaufeatures* „DAX query view with Copilot“ aktivieren. Ist das
nicht gegeben, nehmen Sie den Weg über M365 Copilot Chat (unten) – er funktioniert immer.

## Wofür
Ein Visual-Export liefert nur, was auf der Seite steht. Eine DAX-Abfrage liefert genau die Kennzahlen,
Monate und Regionen, die Sie für Kommentar und Korrelation brauchen – reproduzierbar und mit den
Measures des Modells (also derselben Logik wie im Bericht). Copilot schreibt die Abfrage, Sie testen sie.

## Vorbereitung
- Power BI Desktop: Übungsmodell `DBS_Produktionscontrolling` öffnen › **TMDL-Ansicht** › Tabellen
  `Fakt_Leistung`, `Kalender`, `Region`, `Leistungsart` in den Editor ziehen › Skript kopieren.
  Für die Abfrage reichen Spaltennamen, Measure-Namen und Beziehungen – Partitionen/Daten werden nicht gebraucht.
- Optional Kontextdateien **K03** (TMDL-Kurzreferenz) und **K02** (DAX-Styleguide) anhängen.
- Keine Daten im Prompt → kein Datenschutzthema, solange das TMDL keine Klardaten enthält. Bei echten
  Modellen: Partitionen mit eingebetteten Daten (`#table(...)`, Base64) vor dem Kopieren entfernen.

## Prompt
```text
Du bist DAX-Expert*in für Power-BI-Semantikmodelle.

Kontext: Unten steht das TMDL-Skript unseres Modells (Tabellen, Spalten, Measures, Beziehungen).
[EINFÜGEN: TMDL-Skript aus der TMDL-Ansicht]

Aufgabe: Schreib eine DAX-Abfrage für die DAX-Abfrageansicht in Power BI Desktop, die eine flache Tabelle
für die Monatskommentierung liefert:
- Zeilen: [EINFÜGEN: z. B. Kalender[Monat] × Region[Region]]
- Kennzahlen: [EINFÜGEN: z. B. Ist Kosten, Plan Kosten, Abw Kosten %, Ist Stunden, Plan Stunden,
  Leistungseinheiten (Summe), Produktivitaet, m_QQ als „Qualitaetsquote“, Krankenquote, Ueberstundenquote]
- Zeitraum: [EINFÜGEN: z. B. alle Monate mit Daten / nur 2026]

Regeln:
- Verwende EVALUATE mit SUMMARIZECOLUMNS. Gruppiere nur nach Spalten der Dimensionstabellen
  (Kalender, Region, Leistungsart), nicht nach Fremdschlüsseln in Fakt_Leistung.
- Nutze vorhandene Measures mit genau dem Namen aus dem TMDL. Erfinde keine Measures und keine Spalten.
  Wo kein Measure existiert (z. B. Summe Leistungseinheiten), schreib den Ausdruck direkt in die Abfrage.
- Ergebnisspalten ohne Leerzeichen und Sonderzeichen benennen (z. B. "Abw_Kosten_Prozent"), damit Excel
  und Python sie problemlos lesen.
- Zeitfilter über Kalender-Spalten (z. B. TREATAS oder Filterargument in SUMMARIZECOLUMNS), nicht über Fakt_Leistung[Monat].
- Sortiere mit ORDER BY nach Monat und Region.
- Wenn ein Objekt fehlt oder ein Name mehrdeutig ist, frag nach statt zu raten.

Ausgabe: genau ein Codeblock mit Sprachangabe dax, danach maximal 5 Stichpunkte: welche Measures verwendet wurden,
welche Annahmen du getroffen hast und wie viele Zeilen ich ungefähr erwarten sollte.
```

### Referenzlösung (zum Vergleich, nicht zum Abschreiben vor der Übung)
```dax
EVALUATE
SUMMARIZECOLUMNS (
    Kalender[Monat],
    Region[Region],
    "Ist_Kosten", [Ist Kosten],
    "Plan_Kosten", [Plan Kosten],
    "Abw_Kosten_Prozent", [Abw Kosten %],
    "Ist_Stunden", [Ist Stunden],
    "Plan_Stunden", [Plan Stunden],
    "Leistungseinheiten", SUM ( Fakt_Leistung[Leistungseinheiten] ),
    "Produktivitaet", [Produktivitaet],
    "Qualitaetsquote", [m_QQ],
    "Krankenquote", [Krankenquote],
    "Ueberstundenquote", [Ueberstundenquote]
)
ORDER BY
    Kalender[Monat],
    Region[Region]
```
Erwartung: 22 Monate × 7 Regionen = 154 Zeilen. Monate ohne Daten (Nov/Dez 2026) fallen weg, weil
SUMMARIZECOLUMNS Zeilen entfernt, in denen alle Kennzahlen leer sind. Für die Leistungsart-Ebene
`Leistungsart[Leistungsart]` als dritte Gruppierungsspalte ergänzen (erwartet 770 Zeilen).

## Nachschärfen

Wenn die Abfrage einen Fehler wirft (Fehlertext aus dem Ergebnisraster kopieren):
```text
Die Abfrage liefert diesen Fehler: [EINFÜGEN: Fehlermeldung inkl. Zeile/Spalte].
Erklär in einem Satz die Ursache und gib die korrigierte Abfrage vollständig aus. Prüf jeden Namen gegen das TMDL.
```

Wenn Sie nur den Berichtsmonat und den Vorjahresmonat brauchen:
```text
Ändere die Abfrage so, dass nur Kalender[Monat] = "2026-10" ausgewertet wird, und ergänze je Region
[Ist Kosten VJ] als "Ist_Kosten_VJ" und [Abw VJ %] als "Abw_VJ_Prozent".
```

Wenn Sie einen Dubletten-Check direkt im Modell wollen (Vorbereitung für M2-03):
```text
Schreib eine zweite DAX-Abfrage, die alle Kombinationen aus Fakt_Leistung[Monat], Fakt_Leistung[RegionID]
und Fakt_Leistung[LeistungsartID] mit mehr als einer Zeile in Fakt_Leistung auflistet, inklusive Anzahl Zeilen.
```

Wenn Copilot `Kosten YTD` verwendet:
```text
Verwende Kosten YTD nicht. Es rechnet über Fakt_Leistung[Monat] statt über den Kalender
und liefert mit einem Kalenderfilter möglicherweise falsche Werte. Berechne YTD bei Bedarf in der Abfrage
mit CALCULATE ( [Ist Kosten], DATESYTD ( Kalender[Datum] ) ).
```

## Ergebnis prüfen
- [ ] Abfrage läuft in der DAX-Abfrageansicht ohne Fehler (**Ausführen** bzw. F5).
- [ ] Jeder Measure-Name existiert im TMDL – besonders `m_QQ`, `Krankenquote`, `Ueberstundenquote`
      (Copilot „korrigiert“ gern zu `Qualitätsquote` oder `Überstundenquote`).
- [ ] Zeilenzahl plausibel (154 bzw. 770). Deutlich mehr Zeilen → es wurde nach einer Faktspalte gruppiert.
- [ ] Stichprobe: Ist Kosten einer Region im Okt 2026 = Wert in der Tabelle der Kennzahlenübersicht.
- [ ] Ergebnisraster **Kopieren** › in Excel einfügen. Prozentwerte sind Anteile (0,07 = 7 %) – anders als in den
      Übungs-CSV, die Prozentwerte enthalten (7,12 = 7,12 %). Wer beides mischt, muss umrechnen.

## Stolperfallen
- **Gruppieren nach Fremdschlüssel** (`Fakt_Leistung[RegionID]`) liefert IDs statt Namen; außerdem sind die
  ID-Spalten im Modell summierbar. Immer nach `Region[Region]` gruppieren.
- **Formatstrings fehlen im Raster.** Die DAX-Abfrageansicht zeigt Rohwerte. Wer kopiert, muss Prozent
  selbst formatieren – oder Copilot im Prompt sagen, dass es Anteile sind.
- **Copilot in der DAX-Abfrageansicht sieht nur Metadaten** (Tabellen, Spalten, Measures, die ersten 200 Zeichen
  jeder Beschreibung; im Import-Modus höchstens Min/Max als Beispielwerte). Er kennt Ihre Daten nicht und kann
  `m_QQ` ohne Beschreibung nicht deuten (vgl. Befunde aus Ü1.1: kryptische Namen, fehlende Beschreibungen).
- **Monat als Text.** `Kalender[Monat]` ist Text („2026-10“) und sortiert dadurch richtig. `Monatsname`
  („Oktober“) sortiert ohne Sortierspalte alphabetisch – für Zeitreihen ungeeignet.
