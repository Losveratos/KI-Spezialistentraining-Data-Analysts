# M2-11 · Kommentar-Baustein als DAX-Measure (dynamischer Text) – optional

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | M365 Copilot Chat (mit K02) + Power BI Desktop (DAX-Abfrageansicht); optional Copilot in der DAX-Abfrageansicht* | Ü2.9 (optional) | 15 min |

\* Nur mit Arbeitsbereich auf bezahlter Fabric-Kapazität (ab F2) oder Power BI Premium (ab P1) und Admin-Freigabe;
Testkapazitäten (Trial) werden nicht unterstützt. Der Weg über M365 Copilot Chat funktioniert immer.

## Wofür
Wiederkehrende **Faktensätze** („Kosten Ost 2026-10: 1.234.567 € IST, +7,1 % ΔPL, +9,8 % ΔVJ“) muss niemand
jeden Monat tippen. Ein Text-Measure schreibt sie aus den Daten, reagiert auf Filter und ist immer aktuell.
Die **Einordnung** (Ursache, Handlungsbedarf) bleibt beim Menschen – ein Measure kennt keine Ursachen.
Copilot entwirft das Measure; Sie testen es in der DAX-Abfrageansicht.

## Vorbereitung
- TMDL-Ausschnitt der Tabelle `Fakt_Leistung` (Measures) sowie `Kalender` und `Region` aus der TMDL-Ansicht kopieren.
- Kontextdatei **K02** (DAX-Styleguide) anhängen.
- In einer **Kopie** des Übungsmodells arbeiten.
- Keine Daten im Prompt → kein Datenschutzthema (Metadaten des fiktiven Modells).

## Prompt
```text
Du bist DAX-Expert*in und baust Text-Measures für Management-Berichte. Halte dich an den DAX-Styleguide (K02).

Kontext: Unser Modell als TMDL-Ausschnitt:
[EINFÜGEN: TMDL Fakt_Leistung (Measures), Kalender, Region]
Modellkultur de-DE. Der Bericht hat einen Slicer auf Kalender[Monat] (Text, z. B. "2026-10") und eine Tabelle je Region[Region].

Aufgabe: Schreib ein Measure "Kommentar Kosten" für die Tabelle Fakt_Leistung, das je Filterkontext einen Satz liefert:
"Kosten <Region> <Monat>: <Ist Kosten> IST, <Abw ΔPL> ΔPL (<Einordnung>), <Abw ΔVJ> ΔVJ."
und, falls die Qualitätsquote (Measure m_QQ) unter dem Zielwert liegt, einen zweiten Satz
"Qualitätsquote <Wert> unter Zielwert <Zielwert>."

Vorgaben:
- Verwende die vorhandenen Measures [Ist Kosten], [Plan Kosten], [Ist Kosten VJ], [m_QQ]. Erfinde keine Measures.
- Abweichungen mit DIVIDE neu rechnen (nicht [Abw Kosten %] verwenden – es dividiert mit "/").
- Einordnung über Variablen für Schwellen: im Plan bis ±2 %, "deutlich über Plan" ab +5 %, sonst über/unter Plan.
  Zielwert Qualität 90 %. Keine Zahlen direkt im Code verstreut.
- Region: Name, wenn genau eine Region im Kontext ist; "Gesamt", wenn nicht nach Region gefiltert ist.
  Monat analog ("mehrere Monate").
- Zahlenformat deutsch mit FORMAT und Gebietsschema "de-DE": Beträge "#,0 €", Abweichungen mit Vorzeichen
  und einer Nachkommastelle, Quoten "0.0 %".
- ΔVJ-Teil weglassen, wenn kein Vorjahreswert existiert. Leeren Text (BLANK) zurückgeben, wenn keine Ist-Kosten vorliegen.
- Leere Qualitätsquote darf nicht als "unter Zielwert" gelten.
- Das Measure enthält keine Ursachen und keine Wertungen.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe: genau ein Codeblock mit Sprachangabe dax mit dem Measure, danach eine Testabfrage für die
DAX-Abfrageansicht (Kalender[Monat] = "2026-10", eine Zeile je Region plus die Spalten Ist Kosten und
Abw Kosten % zum Abgleich), danach höchstens 4 Stichpunkte zu Annahmen.
```

### Referenzlösung (zum Vergleich)
```dax
Kommentar Kosten =
VAR _SchwelleImPlan = 0.02
VAR _SchwelleDeutlich = 0.05
VAR _ZielQualitaet = 0.90
VAR _IstKosten = [Ist Kosten]
VAR _PlanKosten = [Plan Kosten]
VAR _IstKostenVJ = [Ist Kosten VJ]
VAR _Qualitaet = [m_QQ]
VAR _AbwPL = DIVIDE ( _IstKosten - _PlanKosten, _PlanKosten )
VAR _AbwVJ = DIVIDE ( _IstKosten - _IstKostenVJ, _IstKostenVJ )
VAR _Region =
    IF (
        ISFILTERED ( Region[Region] ),
        SELECTEDVALUE ( Region[Region], "Auswahl mehrerer Regionen" ),
        "Gesamt"
    )
VAR _Monat = SELECTEDVALUE ( Kalender[Monat], "mehrere Monate" )
VAR _Einordnung =
    SWITCH (
        TRUE (),
        ABS ( _AbwPL ) <= _SchwelleImPlan, "im Plan",
        _AbwPL >= _SchwelleDeutlich, "deutlich über Plan",
        _AbwPL > 0, "über Plan",
        "unter Plan"
    )
VAR _TextKosten =
    "Kosten " & _Region & " " & _Monat & ": "
        & FORMAT ( _IstKosten, "#,0 €", "de-DE" ) & " IST, "
        & FORMAT ( _AbwPL, "+0.0 %;-0.0 %;0.0 %", "de-DE" ) & " ΔPL (" & _Einordnung & ")"
VAR _TextVJ =
    IF (
        NOT ISBLANK ( _IstKostenVJ ),
        ", " & FORMAT ( _AbwVJ, "+0.0 %;-0.0 %;0.0 %", "de-DE" ) & " ΔVJ"
    )
VAR _TextQualitaet =
    IF (
        NOT ISBLANK ( _Qualitaet ) && _Qualitaet < _ZielQualitaet,
        " Qualitätsquote " & FORMAT ( _Qualitaet, "0.0 %", "de-DE" )
            & " unter Zielwert " & FORMAT ( _ZielQualitaet, "0 %", "de-DE" ) & "."
    )
RETURN
    IF (
        NOT ISBLANK ( _IstKosten ),
        _TextKosten & _TextVJ & "." & _TextQualitaet
    )
```

Testabfrage:
```dax
EVALUATE
SUMMARIZECOLUMNS (
    Region[Region],
    TREATAS ( { "2026-10" }, Kalender[Monat] ),
    "Ist_Kosten", [Ist Kosten],
    "Abw_Kosten_Prozent", [Abw Kosten %],
    "Kommentar", [Kommentar Kosten]
)
ORDER BY Region[Region]
```

## Nachschärfen

Wenn das Measure Fehler wirft oder Namen nicht passen:
```text
Die DAX-Abfrageansicht meldet: [EINFÜGEN: Fehlermeldung]. Prüf jeden Measure- und Spaltennamen gegen das TMDL
und gib das korrigierte Measure vollständig aus.
```

Wenn Sie einen zweiten Baustein für die Belastung brauchen (Krankenquote, Überstunden):
```text
Schreib nach demselben Muster ein Measure "Kommentar Belastung" mit Krankenquote und Ueberstundenquote
im Vergleich zum Vorjahresmonat, Veränderung in Prozentpunkten (Pp.). Schwellen als Variablen.
```

Wenn der Text im Visual abgeschnitten wird:
```text
Teile den Text in zwei Measures (Kosten-Satz, Qualitäts-Satz) und schlag vor, wie ich sie in einer Karte
(neue Karte, mehrere Zeilen) oder in einer Tabelle untereinander zeige.
```

## Ergebnis prüfen
- [ ] Testabfrage läuft; je Region ein Satz. Zahlen im Satz = Spalten `Ist_Kosten` und `Abw_Kosten_Prozent`.
- [ ] **Ost** im Okt 2026: „deutlich über Plan“ und Qualitätssatz erscheint (Übungsdaten).
- [ ] **Mitte**: „im Plan“, kein Qualitätssatz.
- [ ] Monat 2025-xx: kein ΔVJ-Teil (es gibt keine Daten 2024).
- [ ] Zahlen deutsch formatiert (Tausenderpunkt, Dezimalkomma, Vorzeichen).
- [ ] Keine Ursache und keine Wertung im Text.

## Stolperfallen
- **Ein Text-Measure prüft keine Daten.** Der Kommafehler im September landet ungefiltert im Satz für Südwest/Sep.
  Plausibilitätscheck (M2-03) bleibt Pflicht.
- **FORMAT mit Gebietsschema.** Das dritte Argument „de-DE“ legt Tausender- und Dezimaltrennzeichen fest. Ohne
  das Argument richtet sich FORMAT nach der Modellkultur (im Übungsmodell de-DE).
- **Leere Werte sind kleiner als jede positive Schwelle.** `BLANK() < 0.9` ist wahr, deshalb `NOT ISBLANK` vor jedem
  Vergleich. Gleiches gilt für `ABS ( _AbwPL ) <= _SchwelleImPlan`: Ohne Planwert meldet die Referenzlösung
  „im Plan“ – bei eigenen Daten vorher `ISBLANK ( _PlanKosten )` abfangen.
- **Text-Measures in großen Tabellen** werden für jede Zeile berechnet. Für Übersichten mit wenigen Zeilen
  unkritisch; nicht in Matrizen mit Tausenden Zellen einsetzen.
