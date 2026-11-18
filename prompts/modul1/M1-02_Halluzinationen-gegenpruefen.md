# M1-02 · Halluzinationen gegenprüfen

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat (neuer Chat) + DAX-Abfrageansicht | Ü1.2 | 10 min |

## Wofür
KI-generierter DAX-, M- oder SQL-Code sieht fast immer plausibel aus – auch wenn Spalten, Measures oder
Funktionen erfunden sind. Dieser Prompt lässt einen **zweiten, unabhängigen Copilot-Durchgang** jeden
Objektverweis gegen das TMDL abgleichen. Die endgültige Prüfung macht danach die Engine: die DAX-Abfrageansicht.

## Vorbereitung
- Den zu prüfenden Code (z. B. Ergebnis aus M1-09 oder ein Measure-Vorschlag aus einem anderen Chat).
- Das TMDL der betroffenen Tabellen (TMDL-Ansicht, Partitionen weglassen) **oder** die Ergebnisse der Abfragen
  2 und 3 aus `uebungsdaten/modul1/INFO_Abfragen.dax` (Spalten- und Measure-Liste, per „Kopieren“ aus dem Ergebnisraster).
- **Neuen Chat** öffnen: Im selben Chat verteidigt Copilot gern seine eigene Antwort.
- Datenschutz: nur Metadaten und Code einfügen, keine Daten mit Personenbezug; unternehmensfreigegebenen Copilot nutzen.

## Prompt
```text
Du bist Reviewer für Power-BI-Code und prüfst Code, den eine KI erzeugt hat, auf erfundene Objekte.

Kontext:
- Modell-Metadaten (maßgeblich, nichts anderes existiert):
  [EINFÜGEN: TMDL der Tabellen ODER kopierte Spalten- und Measure-Liste aus INFO.VIEW]
- Zu prüfender Code:
  [EINFÜGEN: DAX-Measure / DAX-Abfrage / M / SQL]

Aufgabe:
1. Liste JEDEN Verweis im Code auf Tabellen, Spalten und Measures.
2. Prüfe jeden Verweis gegen die Metadaten: exakte Schreibweise, Tabelle, Objektart (Spalte oder Measure).
3. Prüfe jede verwendete Funktion: gibt es sie in dieser Sprache, stimmen Anzahl und Reihenfolge der Argumente?
4. Prüfe fachliche Annahmen: Welche Spalte wird für Datum/Zeitintelligenz genutzt? Wird eine Spalte summiert,
   die man nicht summieren darf (IDs, Quoten)?

Regeln:
- Bewerte nur anhand der mitgegebenen Metadaten, nicht anhand von „üblichen“ Modellen.
- Korrigiere den Code noch nicht.

Ausgabe: Tabelle „Verweis | Art | Im Modell vorhanden (ja/nein/abweichende Schreibweise) | Richtiger Name | Bemerkung“,
danach Liste „Funktionen mit Problemen“ und „Fachliche Bedenken“. Am Ende ein Satz: „Code ist lauffähig: ja/nein/unklar“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn die Prüfung Fehler gefunden hat:
```text
Korrigiere den Code nur an den Stellen, die du als „nein“ oder „abweichende Schreibweise“ markiert hast.
Ändere nichts anderes. Gib danach eine DAX-Abfrage für die DAX-Abfrageansicht aus, die das Measure per
DEFINE MEASURE definiert und je Kalender[Monat] für 2026 auswertet.
```
Wenn Copilot behauptet, alles sei vorhanden, Sie aber zweifeln:
```text
Zitiere für jeden Verweis die Zeile aus den Metadaten, in der er vorkommt. Wo du keine Zeile zitieren kannst,
markiere den Verweis als „nicht gefunden“.
```

## Ergebnis prüfen
- [ ] Code in der **DAX-Abfrageansicht** ausführen (`DEFINE MEASURE Fakt_Leistung[Test] = … EVALUATE …`). Erfundene
      Namen meldet die Engine sofort – das ist der verbindliche Test, nicht Copilots Aussage.
- [ ] Jeden „vorhanden“-Verweis stichprobenartig mit Strg+F im TMDL gegenprüfen (Schreibweise: `Qualitaet_Bestanden`, nicht `Qualität_Bestanden`).
- [ ] Measure vs. Spalte: `[Ist Kosten]` ist ein Measure, `Fakt_Leistung[Ist_Kosten]` eine Spalte. Verwechslung = typischer Fehler.
- [ ] Zeitintelligenz verwendet `Kalender[Datum]`, nicht `Fakt_Leistung[Monat]` oder ein erfundenes `'Date'[Date]`.
- [ ] Werte plausibel? Ein lauffähiges Measure kann trotzdem falsch rechnen – mit einem bekannten Wert aus dem Bericht vergleichen.

## Stolperfallen
- Copilot prüft sich selbst nachsichtig. Darum neuer Chat und Metadaten als „maßgeblich“ deklarieren.
- Ähnliche Namen sind die gefährlichsten Halluzinationen: `[Qualitätsquote]` statt `[m_QQ]`, `Kalender[Monat]` (Text) statt `Kalender[Datum]`.
- Neue DAX-Funktionen kennt Copilot oft nicht und erklärt sie falsch; im Zweifel in der DAX-Referenz auf Microsoft Learn nachsehen.
- Copilot in der DAX-Abfrageansicht (nur mit Fabric-/Premium-Kapazität) prüft die Syntax mit einem DAX-Parser – fachliche
  Fehler findet aber auch er nicht.
