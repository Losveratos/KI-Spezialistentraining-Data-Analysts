# M1-04 · Power Query (M) formatieren und kommentieren

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook | Ü1.4 | 12 min |

## Wofür
Über die Oberfläche gewachsene Abfragen sind schwer zu lesen: Schrittnamen wie `#"Geänderter Typ2"`, alles in
einer Zeile, keine Begründungen. Copilot macht daraus eine lesbare, kommentierte Fassung und listet
Schwachstellen (Robustheit, Performance, Query Folding, Kultur) getrennt auf.

## Vorbereitung
- Abfrage kopieren: Power Query-Editor › Abfrage markieren › **Erweiterter Editor** › gesamten Text kopieren.
  Übung: `uebungsdaten/modul1/SAP_Export_Leistung.pq`.
- Wenn bekannt: Quelle (Datei, SQL, Dataflow), Format der Quelldaten (z. B. deutsches Zahlenformat), Ziel der Abfrage.
- Datenschutz: Pfade, Servernamen und Benutzerkennungen im Code vorher prüfen; bei echten Abfragen durch
  Platzhalter ersetzen (`\\server\freigabe\…`). Unternehmensfreigegebenen Copilot nutzen.

## Prompt
```text
Du bist Power-Query-Entwickler (M) und überarbeitest Abfragen für Power BI Desktop.

Kontext:
- Quelle: [EINFÜGEN: z. B. CSV-Export aus SAP CO (KSB1), Semikolon, Windows-1252, deutsches Zahlen- und Datumsformat]
- Zweck: [EINFÜGEN: z. B. Ist-Kosten und Ist-Stunden je Monat, Region und Leistungsart]
- Code aus dem Erweiterten Editor:
[EINFÜGEN: M-Code]

Aufgabe in zwei getrennten Teilen:
Teil A – Formatieren und kommentieren, Logik unverändert:
- Ein Schritt je Zeile, Argumente bei langen Aufrufen umbrechen, 4 Leerzeichen Einrückung.
- Über jedem Schritt ein // Kommentar: was und warum.
- Schrittnamen NICHT ändern (andere Abfragen können darauf verweisen).
Teil B – Schwachstellen (nicht umsetzen), je Punkt: Schritt, Problem, Risiko im Betrieb, Vorschlag.
Prüfe ausdrücklich: hart kodierte Pfade und Werte, Kultur bei Typumwandlungen, doppelte Typänderungen,
Table.Buffer, Spaltenzugriff über Position, Filter- und Spaltenauswahl erst nach Merge/Erweitern,
Robustheit bei geänderten Spaltennamen, Query Folding.

Regeln:
- Verwende nur M-Funktionen, die es gibt. Wenn du dir bei einer Funktion oder Option unsicher bist, schreib das dazu.
- Erfinde keine Spalten; nutze die Namen aus dem Code.

Ausgabe: Teil A als ein ```powerquery-Block, Teil B als Tabelle, danach „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn Sie eine verbesserte Fassung wollen (erst nach Teil A/B):
```text
Erstelle jetzt eine verbesserte Fassung, die die Punkte [EINFÜGEN: Nummern aus Teil B] umsetzt.
Ausgabe: gleiche Spaltennamen und Datentypen wie bisher (Monat, RegionID, LeistungsartID, Ist_Kosten, Ist_Stunden),
der Dateipfad kommt aus einem Parameter [EINFÜGEN: Parametername]. Liste am Ende jede Verhaltensänderung auf.
```
Wenn Copilot die Kultur-Problematik nicht erkennt:
```text
Die Quelldatei enthält Beträge wie "12.345,67" und Datumswerte wie "01.10.2026". Was passiert mit diesen Werten
im Schritt #"Geänderter Typ1"? Gib für beide Beispiele das Ergebnis an und begründe es.
```
Wenn Sie die Wirkung einzelner Schritte verstehen wollen:
```text
Erkläre für die Schritte mit Table.Buffer, ob sie in dieser Abfrage nützen oder schaden, und was sich ändern würde,
wenn die Quelle eine Azure-SQL-Tabelle statt einer CSV-Datei wäre.
```

## Ergebnis prüfen
- [ ] Teil A ist logisch identisch: in einer **Kopie** der Abfrage einfügen, Vorschau mit Original vergleichen (Zeilenzahl, Summe Ist_Kosten).
- [ ] Schrittnamen unverändert; der Ausdruck nach `in` verweist auf den letzten Schritt.
- [ ] Jede Funktion aus Copilots Vorschlägen existiert (Power-Query-M-Referenz auf Microsoft Learn); ausgedachte Optionen
      in Records (`[…]`) sind ein typischer Halluzinationsort.
- [ ] Kulturangaben stimmen mit der Quelle überein (deutsches Format → `"de-DE"`).
- [ ] Verbesserte Fassung: gleiche Ergebnistabelle wie vorher – Unterschiede nur dort, wo das Original nachweislich falsch war (z. B. Beträge, Datumswerte).

## Stolperfallen
- Copilot kann den Code nicht ausführen. Aussagen zu Query Folding sind Einschätzungen; prüfen Sie in Power Query
  per Rechtsklick auf den Schritt (**Native Abfrage anzeigen** bzw. Folding-Indikatoren).
- Kommentare in M: `//` und `/* */`. Werden Kommentare im Erweiterten Editor gespeichert, bleiben sie erhalten – über die
  Oberfläche hinzugefügte Schritte landen aber ohne Kommentar am Ende.
- Lange Abfragen in mehreren Teilen einfügen führt zu inkonsistenten Antworten. Lieber als `.txt` anhängen.
- „Optimierte“ Fassungen ändern gern still die Ergebnisspalten. Ausgabe-Schema immer im Prompt festlegen.
