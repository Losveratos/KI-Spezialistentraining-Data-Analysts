# M3-07 · Prüfspalten und Prüfformeln in Excel erzeugen lassen

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | Copilot in Excel („Mit Copilot bearbeiten“ / Edit with Copilot); Rückfallweg: Copilot Chat liefert Formeln | Ü3.4 | 15 min |

## Wofür
Eine Verstoßliste aus dem Chat ([M3-06](M3-06_Excel-Validierung-Regelkatalog.md)) gilt für genau diese Datei an
genau diesem Tag. Prüfspalten als **Formeln** gelten weiter: Nächsten Monat fügen Sie den neuen Export ein, und
die Prüfung rechnet mit. Copilot schreibt die Formeln – ZÄHLENWENN für Dubletten und Stammdaten, XVERWEIS für die
Stundensatzspanne, eine Abweichungsformel für den Betrag – und Sie prüfen, ob sie die Regel wirklich abbilden.

## Vorbereitung
- `Leistungsnachweise_Export_Okt-2026.xlsx` aus [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/) als **Kopie**
  in OneDrive/SharePoint speichern, von dort öffnen, „Automatisches Speichern“ (AutoSave) einschalten.
- Tabellen: `tblLeistung` (Blatt Leistungsnachweise), `tblRegion` und `tblLeistungsart` (Blatt Stammdaten),
  Regelkatalog R1–R8 (Blatt Prüfregeln).
- Ohne Copilot in Excel: Datei an den Copilot Chat anhängen, Prompt unten mit dem Zusatz aus „Nachschärfen“
  (Rückfallweg) senden und die Formeln selbst in neue Tabellenspalten einfügen.

> **Datenschutz:** Nur mit Unternehmenskonto und freigegebenem Copilot arbeiten. Echte Exporte mit Personenbezug
> (Erfasser) vorher bereinigen. Im Training nur die fiktive Übungsdatei verwenden.

## Prompt
```text
Verwende die Tabelle tblLeistung (Blatt Leistungsnachweise) sowie tblRegion und tblLeistungsart (Blatt Stammdaten).
Der Regelkatalog R1–R8 steht im Blatt Prüfregeln. Berichtsmonat: [EINFÜGEN: Oktober 2026].

Aufgabe: Ergänze in tblLeistung rechts acht Prüfspalten P_R1 bis P_R8 und eine Spalte Pruefstatus.
- Jede Prüfspalte enthält eine Formel, die für die Zeile "" (bestanden), den Regelcode (z. B. "R5") bei Verstoß
  oder "n. p." liefert, wenn die Regel für diese Zeile nicht prüfbar ist (z. B. Text statt Zahl, Leistungsart
  nicht in den Stammdaten).
- P_R1: BelegNr mehrfach vorhanden (ZÄHLENWENN über die Spalte BelegNr).
- P_R2: Datum ist kein Datum oder liegt außerhalb des Berichtsmonats. Monatsanfang und Monatsende stehen in zwei
  Parameterzellen auf einem neuen Blatt „Pruefprotokoll“ (B1, B2), nicht fest in der Formel.
- P_R3 / P_R4: Region bzw. Leistungsart kommt in den Stammdaten nicht vor (ZÄHLENWENN gegen tblRegion bzw.
  tblLeistungsart).
- P_R5: Stunden nicht > 0 und ≤ 12.
- P_R6: Stundensatz außerhalb Stundensatz_min bis Stundensatz_max der Leistungsart (XVERWEIS gegen tblLeistungsart).
- P_R7: Betrag weicht um mehr als 0,01 € von Stunden × Stundensatz ab (Rundungsfehler abfangen).
- P_R8: ein Pflichtfeld ist leer oder hat den falschen Datentyp.
- Pruefstatus: alle Regelcodes der Zeile, durch Komma getrennt; "OK", wenn alle Prüfspalten leer sind.

Zusätzlich auf dem Blatt „Pruefprotokoll“ ab A4: Tabelle „Regel | Beschreibung | Verstöße | nicht prüfbar“ mit
Zählformeln über die Prüfspalten sowie Anzahl Belege gesamt und Anzahl Belege mit Pruefstatus "OK".

Regeln:
- Nur Formeln mit strukturierten Verweisen ([@Stunden], tblRegion[Region]); keine festen Bereiche, keine Werte.
- Deutsches Excel: deutsche Funktionsnamen, Semikolon als Trennzeichen.
- Ändere keine vorhandenen Werte, lösche und sortiere nichts.
- Nenne mir danach je Prüfspalte die Formel und in einem Satz, was sie prüft und was sie NICHT erkennt.
```

Bedingte Formatierung:
```text
Formatiere in tblLeistung jede Zeile, deren Pruefstatus nicht "OK" ist, mit hellroter Füllung, und Zeilen, deren
Pruefstatus "n. p." enthält, mit hellgelber Füllung. Verwende eine formelbasierte Regel der bedingten Formatierung,
die für neue Tabellenzeilen automatisch gilt. Füge einen Datenschnitt für Pruefstatus hinzu.
```

## Nachschärfen

Rückfallweg im Copilot Chat (Datei anhängen):
```text
Führe die Änderungen nicht aus. Gib mir je Prüfspalte nur die Formel für deutsches Excel (Tabellenspalte in
tblLeistung, strukturierte Verweise) und einen Satz Erklärung. Ich füge sie selbst ein.
```

Wenn eine Formel einen Fehler (`#NV`, `#WERT!`) statt „n. p.“ liefert:
```text
P_R[EINFÜGEN: Nummer] liefert in Zeilen mit [EINFÜGEN: z. B. unbekannter Leistungsart / Text in Stunden] einen
Fehlerwert. Ändere die Formel so, dass sie in diesem Fall "n. p." ausgibt, und zeig die neue Formel.
```

Wenn Sie die Formeln testen wollen:
```text
Erstelle auf einem neuen Blatt „Formeltest“ eine kleine Testtabelle mit je einer Zeile, die genau eine Regel
verletzt, einer fehlerfreien Zeile und je einem Grenzfall (Stunden = 12, Abweichung genau 0,01 €, Datum am
letzten Tag des Monats). Wende dieselben Prüfformeln an und zeig erwartetes und tatsächliches Ergebnis nebeneinander.
```

## Ergebnis prüfen
So kann eine tragfähige Lösung aussehen (zum Vergleichen, nicht zum Abschreiben):
```text
P_R1: =WENN(ZÄHLENWENN([BelegNr];[@BelegNr])>1;"R1";"")
P_R3: =WENN(ZÄHLENWENN(tblRegion[Region];[@Region])=0;"R3";"")
P_R6: =LET(mn;XVERWEIS([@Leistungsart];tblLeistungsart[Leistungsart];tblLeistungsart[Stundensatz_min];"");
           mx;XVERWEIS([@Leistungsart];tblLeistungsart[Leistungsart];tblLeistungsart[Stundensatz_max];"");
           WENN(ODER(mn="";NICHT(ISTZAHL([@Stundensatz])));"n. p.";
           WENN(UND([@Stundensatz]>=mn;[@Stundensatz]<=mx);"";"R6")))
P_R7: =WENN(UND(ISTZAHL([@Stunden]);ISTZAHL([@Stundensatz]);ISTZAHL([@Betrag]));
           WENN(RUNDEN(ABS([@Betrag]-[@Stunden]*[@Stundensatz]);2)>0,01;"R7";"");"n. p.")
```
- [ ] In jeder Prüfspalte steht eine Formel; sie füllt sich in einer neu angefügten Tabellenzeile automatisch.
- [ ] Die Grenzfälle verhalten sich wie im Regelkatalog: Stunden = 12 besteht, Abweichung 0,01 € besteht,
      letzter Tag des Monats besteht.
- [ ] Keine Fehlerwerte (`#NV`, `#WERT!`) in den Prüfspalten – filtern Sie jede Spalte einmal.
- [ ] Die Anzahlen im Blatt `Pruefprotokoll` stimmen je Regel mit der Übersicht aus M3-06 überein.
- [ ] Die Originalspalten sind unverändert (Summe Betrag und Zeilenzahl vorher/nachher vergleichen).

## Stolperfallen
- **ZÄHLENWENN und XVERWEIS ignorieren Groß-/Kleinschreibung.** „nord“ gilt als Treffer für „Nord“. Verlangt die
  Regel exakte Schreibweise: `SUMMENPRODUKT(--IDENTISCH(tblRegion[Region];[@Region]))=0`.
- **Gleitkomma.** `ABS(Betrag − Stunden × Stundensatz) > 0,01` meldet Abweichungen von exakt einem Cent wegen
  Rundungsresten – deshalb vor dem Vergleich runden.
- **Datum als Text.** Ein Text wie „31.10.2026“ ist für Excel größer als jede Zahl und rutscht durch Vergleiche.
  Erst `ISTZAHL`, dann vergleichen; Monatsende mit „kleiner als erster Tag des Folgemonats“ prüfen.
- **Feste Werte statt Formeln.** Copilot trägt manchmal Ergebnisse ein. Jede Spalte in der Bearbeitungsleiste ansehen.
- **Prüfspalten im Export.** Die Datei mit Prüfspalten ist ein Arbeitsstand – nicht als Datenquelle weitergeben.

Mehr dazu: [M3-05 Strukturierte Analyse in Excel](M3-05_Excel-strukturierte-Analyse.md)
