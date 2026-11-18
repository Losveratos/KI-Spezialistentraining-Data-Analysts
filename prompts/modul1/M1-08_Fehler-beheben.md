# M1-08 · Fehler beheben aus Fehlermeldung

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook | Ü1.8 | 10 min |

## Wofür
Fehlermeldungen aus Power BI Desktop sind oft präzise, aber schwer zu deuten. Copilot erklärt die Ursache und
schlägt eine Korrektur vor – zuverlässig aber nur, wenn er **Meldung, Code und Modellkontext** zusammen bekommt.
Der Prompt zwingt zu Diagnose vor Lösung und zu einem Test, der den Fix belegt.

## Vorbereitung
- **Meldung vollständig und wörtlich** kopieren (Details aufklappen; im Aktualisierungsdialog den Text markieren).
  Ein Screenshot geht auch, Text ist zuverlässiger.
- Den Code, in dem der Fehler entsteht: DAX aus der Bearbeitungsleiste, M aus dem Erweiterten Editor, SQL aus der Quelle.
- Kontext: TMDL der betroffenen Tabelle (ohne Partition) bzw. bei Power Query die Kopfzeile der Quelldatei.
- Was sich zuletzt geändert hat (neuer Export, umbenannte Spalte, Desktop-Update).
- Übung: `uebungsdaten/modul1/Fehlerfaelle.md`, Fälle A–D.
- Datenschutz: Meldungen enthalten oft Pfade, Server, Benutzernamen oder Datenwerte – vor dem Einfügen prüfen und ersetzen.

## Prompt
```text
Du bist Power-BI-Entwickler (DAX, Power Query M, T-SQL) und hilfst bei der Fehlersuche in Power BI Desktop.

Kontext:
- Wo tritt der Fehler auf: [EINFÜGEN: z. B. Measure in Bearbeitungsleiste / Visual / Aktualisierung / Power-Query-Editor]
- Fehlermeldung (wörtlich): [EINFÜGEN: Meldung]
- Code: [EINFÜGEN: DAX / M / SQL]
- Modellkontext: [EINFÜGEN: TMDL der Tabelle oder Kopfzeile der Quelldatei]
- Zuletzt geändert: [EINFÜGEN: was sich geändert hat, oder „unbekannt“]

Aufgabe:
1. Übersetze die Meldung in einen Satz: Was genau stört die Engine?
2. Nenne die wahrscheinlichste Ursache mit Beleg aus Code oder Kontext, und bis zu zwei alternative Ursachen.
3. Gib die Korrektur als vollständigen Code an, mit möglichst kleiner Änderung.
4. Nenne einen Test, der zeigt, dass der Fehler behoben ist UND das Ergebnis stimmt (z. B. DAX-Abfrage, Vorschau-Prüfung).
5. Falls der Fehler auf ein Konstruktionsproblem hinweist (z. B. Spaltenzugriff über Namen, die sich ändern):
   Wie verhindert man, dass er wiederkommt?

Regeln:
- Erst Diagnose, dann Lösung. Keine Lösung ohne benannte Ursache.
- Verwende nur Namen aus dem Kontext. Wenn die Ursache außerhalb des gezeigten Codes liegen kann, sag, was du sehen musst.

Ausgabe: Abschnitte „Bedeutung“, „Ursache“, „Korrektur“ (Codeblock mit Sprachangabe), „Test“, „Vorbeugen“,
„Annahmen und offene Punkte“. Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn die Korrektur den Fehler beseitigt, aber das Ergebnis fachlich zweifelhaft ist:
```text
Die Korrektur läuft. Prüfe, ob sie fachlich dasselbe rechnet, was gemeint war: [EINFÜGEN: fachliche Definition,
z. B. aus K05]. Gibt es einen Unterschied zwischen „Summe der Quotienten“ und „Quotient der Summen“?
```
Wenn der Fehler nach der Korrektur weiter besteht:
```text
Nach deiner Korrektur kommt diese Meldung: [EINFÜGEN: neue Meldung]. Verwirf deine erste Ursache, wenn sie
dadurch widerlegt ist, und gehe die alternativen Ursachen durch.
```
Wenn Sie den Fall für das Team dokumentieren wollen:
```text
Fasse den Fall für ein Team-Wiki zusammen: Symptom, Ursache, Lösung, Vorbeugung – je höchstens zwei Sätze.
```

## Ergebnis prüfen
- [ ] Korrektur in Desktop angewendet, Fehlermeldung ist weg – in einer Kopie bzw. mit Sicherung der Datei.
- [ ] Ergebnis gegen einen bekannten Wert geprüft (Bericht, Quelle, DAX-Abfrage), nicht nur „kein Fehler mehr“.
- [ ] Die genannte Ursache passt zum Wortlaut der Meldung (Spaltenname, Typ, Tabelle in der Meldung = im Code).
- [ ] Keine Nebenwirkungen: andere Measures, Beziehungen oder Abfrageschritte unverändert.

## Stolperfallen
- Gekürzte Meldungen führen zu generischen Antworten („prüfen Sie die Datentypen“). Immer den Volltext mit Details.
- Copilot behebt das Symptom: `Kalender[Jahr] = "2026"` lässt sich mit `VALUE` „reparieren“ – richtig ist, den Typ der Spalte zu nutzen.
- Power-Query-Fehler zeigen nur den ersten fehlschlagenden Schritt. Nach der Korrektur kann der nächste Schritt scheitern.
- Englische Meldungen aus Foren passen nicht 1:1 zum deutschen Wortlaut – Copilot kennt beide, Suchen im Web eher die englische.
