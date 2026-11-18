# M2-03 · Datenprofil und Plausibilitätscheck vor jeder Kommentierung

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | M365 Copilot Chat mit Dateianhang, Analyst*, oder Copilot in Excel | Ü2.2 | 15 min |

\* Analyst ist ein vorinstallierter Agent in Microsoft 365 Copilot Chat (unter *Tools* bzw. *Agents*), Teil der
Microsoft-365-Copilot-Lizenz. Er führt Python aus und zeigt seine Rechenschritte. Ohne Lizenz/Freigabe:
gleichen Prompt im normalen Copilot Chat mit angehängter Datei verwenden.

## Wofür
Ein Kommentar ist nur so gut wie die Daten darunter. Bevor Copilot einen einzigen Satz zur Entwicklung
schreibt, lassen Sie ihn die Daten **profilieren**: Lücken, Dubletten, Ausreißer, unplausible Verhältnisse.
Typische Funde: ein Kommafehler (Wert × 10) und eine doppelt geladene Zeile. Beides würde sonst als
„Kostensprung“ kommentiert.

## Vorbereitung
- Datei anhängen: `KPI_Monat_Region_Leistungsart.csv` (beste Wahl: feinste Ebene) oder `KPI_Monat_Region.csv`.
  Eigener Export aus M2-02 geht ebenso.
- Optional **K05** (Kennzahlen-Glossar) anhängen – dann kennt Copilot die Definitionen und Normalbereiche.

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot (Enterprise Data Protection)
> arbeiten. Keine personenbezogenen Daten. Im Training ausschließlich die fiktiven Übungsdaten verwenden.

## Prompt
```text
Du bist Data-Quality-Analyst*in im Produktionscontrolling.

Kontext: Die angehängte Datei [EINFÜGEN: Dateiname] enthält Monatswerte je [EINFÜGEN: Region bzw.
Region × Leistungsart] von Jan 2025 bis Okt 2026. Trennzeichen Semikolon, Dezimalkomma.
Einheit der Prozentspalten: [EINFÜGEN: „Prozentwert, 7,12 = 7,12 %“ (Übungsexporte) oder „Anteil, 0,0712 = 7,12 %“ (eigene DAX-Abfrage)]. Kennzahlendefinitionen: [EINFÜGEN: „siehe K05“ oder Kurzliste].
Erwartete Normalbereiche: Abweichung Ist/Plan ±2 %, Qualitätsquote um 94 %, Krankenquote um 5,5 %,
Überstundenquote um 3 %. Winterdienst hat saisonal fast keine Stunden von Mai bis September.

Aufgabe: Erstelle ein Datenprofil und einen Plausibilitätscheck. Kommentiere die Entwicklung noch NICHT.
Prüfe mindestens:
1. Vollständigkeit: fehlende Monate je Region/Leistungsart, leere Zellen.
2. Dubletten: Kombinationen aus Monat und Dimensionen, die mehrfach vorkommen. Zusätzlich: Monate, in denen
   absolute Werte (Kosten, Stunden, Leistungseinheiten, Plan) gemeinsam sprunghaft steigen, die Quoten aber
   unverändert bleiben – Hinweis auf doppelt geladene Zeilen nach der Aggregation.
3. Ausreißer: je Kennzahl Werte, die stark vom Median derselben Region/Leistungsart abweichen
   (z. B. mehr als 3 robuste Standardabweichungen bzw. IQR-Regel). Vergleiche besonders Ist_Kosten mit Plan_Kosten
   und mit Ist_Stunden (Kosten je Stunde): Ein Faktor von etwa 10 deutet auf einen Komma- bzw. Erfassungsfehler.
4. Logik: Ist_Kosten ≤ 0, Quoten außerhalb 0–100 %, Plan = 0 bei Ist > 0.
5. Saisonmuster, die normal sind (Winterdienst), kennzeichnest du als „erwartet“, nicht als Fehler.

Regeln:
- Rechne mit dem Analysewerkzeug (Python o. Ä.), wenn verfügbar, und nenne die verwendete Regel.
- Jeder Fund mit Monat, Region, ggf. Leistungsart, Kennzahl, Wert und Vergleichswert (Median oder Vormonat).
- Unterscheide „wahrscheinlicher Datenfehler“, „fachlich auffällig, aber plausibel“ und „erwartet“.
- Spekuliere nicht über Ursachen außerhalb der Daten.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
1. Kurzprofil (Zeilen, Zeitraum, Dimensionen) in drei Zeilen.
2. Tabelle „Nr | Monat | Region | Leistungsart | Kennzahl | Wert | Vergleichswert | Faktor/Abweichung | Einstufung | Empfehlung“.
3. Drei Sätze: Welche Funde müssen vor der Kommentierung geklärt oder bereinigt werden, und welche
   Kennzahlen im Berichtsmonat bzw. YTD sind davon betroffen?
```

## Nachschärfen

Wenn Copilot nur „Winterdienst schwankt stark“ meldet und echte Fehler übersieht:
```text
Schließ Winterdienst und die Monate Mai bis September beim Ausreißertest aus bzw. vergleiche Winterdienst
nur mit denselben Kalendermonaten des Vorjahres. Wiederhole den Test für alle anderen Leistungsarten und
zeig mir die fünf größten Abweichungen von Kosten je Stunde zum Median.
```

Wenn eine Dublette vermutet, aber nicht belegt ist:
```text
Vergleiche für [EINFÜGEN: Region, Monat] Ist_Stunden, Plan_Stunden, Ist_Kosten, Plan_Kosten und
Leistungseinheiten mit Vor- und Folgemonat. Ist der Sprung bei allen absoluten Werten etwa gleich groß und
bleiben die Quoten gleich? Was spricht für eine doppelte Zeile, was dagegen?
```

Wenn Sie die Auswirkung auf den Bericht kennen müssen:
```text
Rechne für die gefundenen Datenfehler die betroffenen Kennzahlen zweimal: wie geliefert und bereinigt
(Ausreißer: Wert durch 10 teilen; Dublette: Wert halbieren). Zeig je Kennzahl beide Werte und die Differenz
für den betroffenen Monat und für das laufende Jahr (Jan–Okt 2026).
```

Gegenprobe im Modell (DAX-Abfrageansicht, ohne Copilot):
```text
Schreib eine DAX-Abfrage, die für Fakt_Leistung je Monat, RegionID und LeistungsartID die Anzahl Zeilen
und Ist_Kosten / Ist_Stunden ausgibt und nur Zeilen mit Anzahl > 1 oder Kosten je Stunde über dem
Dreifachen des Gesamtmedians zeigt.
```

## Ergebnis prüfen
- [ ] Der Kommafehler ist gefunden: **Südwest, Fahrzeugreinigung, Sep 2026, Ist_Kosten etwa × 10**
      (Kosten je Stunde springt, Stunden normal). Im Bericht nachsehen: Matrix im Detailbericht, Südwest/Sep.
- [ ] Die Dublette ist gefunden: **Nord, Bahnhofsreinigung, Mai 2026** – alle absoluten Werte doppelt,
      Quoten (Krankenquote, Qualitätsquote) unauffällig, Abw Kosten % unauffällig (Ist **und** Plan doppelt).
- [ ] Winterdienst im Sommer ist als „erwartet“ eingestuft, nicht als Fehler.
- [ ] Jede genannte Zahl findet sich in der Datei wieder (Stichprobe: zwei Zeilen in Excel filtern).
- [ ] Copilot sagt, nach welcher Regel er Ausreißer bestimmt hat. Ohne Regel ist der Befund nicht reproduzierbar.

## Stolperfallen
- **Quoten verstecken Dubletten.** Krankenquote = Krankheitstage / Sollarbeitstage – beide doppelt, Quote
  gleich. Auch Abw Kosten % bleibt unauffällig. Nur absolute Werte (und Zeilenzählung) zeigen die Dublette.
- **Aggregierte Exporte zeigen keine doppelten Zeilen.** In `KPI_Monat_Region_Leistungsart.csv` steht
  Nord/Bahnhofsreinigung/Mai nur einmal – mit doppelten Werten. Die Zeilenzählung gelingt nur im Modell
  (DAX-Abfrage, siehe Nachschärfen) oder in den Rohdaten.
- **Ein Ausreißer wirkt weiter.** Der Kommafehler im September steckt im YTD-Wert, im Quartal und in jedem
  Durchschnitt, auch wenn der Berichtsmonat Oktober „sauber“ ist.
- **Copilot „bereinigt“ ungefragt.** Lassen Sie Fehler melden, nicht stillschweigend korrigieren. Bereinigt wird
  in der Quelle – im Kommentar wird der Datenfehler offen benannt.
