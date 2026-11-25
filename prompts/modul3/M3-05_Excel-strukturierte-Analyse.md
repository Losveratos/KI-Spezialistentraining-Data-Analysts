# M3-05 · Copilot in Excel – strukturiert prompten für die Analyse

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | Copilot in Excel*, Rückfallweg: Copilot Chat mit Dateianhang (Formel selbst einfügen) | Ü3.3 | 15 min |

\* Der Bearbeitungsmodus heißt „Mit Copilot bearbeiten“ (Edit with Copilot, früher „Agent Mode“): Copilot legt
Tabellen, Formeln, PivotTables und Diagramme direkt in der Mappe an. Verfügbarkeit hängt von Lizenz und
Mandanteneinstellung ab. Ohne Copilot in Excel: Prompt im Copilot Chat stellen, Formel bzw. Anleitung übernehmen.

## Wofür
In Excel entscheidet die Genauigkeit des Prompts, ob Copilot die richtige Tabelle, die richtigen Spalten und den
richtigen Ort trifft. Mit sieben Bausteinen wird aus „Zeig mir die Kosten je Region“ ein Auftrag, dessen Ergebnis
als **Formel oder PivotTable in der Mappe** steht – und sich mit neuen Daten mitbewegt, statt als einmaliger Wert
im Chat zu veralten.

## Vorbereitung
- `Kennzahlen_Okt-2026.xlsx` aus [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/) als **Kopie** in OneDrive oder
  SharePoint speichern und von dort öffnen; „Automatisches Speichern“ (AutoSave) einschalten. Lokale Dateien
  unterstützt Copilot in Excel je nach Version nicht oder nur eingeschränkt.
- Die Daten liegen bereits als Excel-Tabellen vor (`tblRegionOkt`, `tblZeitreihe`, `tblMassnahmen`). Bei eigenen
  Exporten zuerst: Bereich markieren › **Strg+T** und der Tabelle einen sprechenden Namen geben.
- Copilot im Menüband öffnen; falls angeboten, „Mit Copilot bearbeiten“ (Edit with Copilot) wählen.

> **Datenschutz:** Nur mit Unternehmenskonto und freigegebenem Copilot arbeiten. Exporte mit personenbezogenen
> Spalten (z. B. Erfasser) vorher bereinigen. Im Training nur die fiktiven Übungsdateien verwenden.

**Die sieben Bausteine**

| Baustein | Frage | Beispiel |
|---|---|---|
| Tabelle | Welche Daten genau? | „Verwende die Tabelle `tblZeitreihe` auf dem Blatt Zeitreihe.“ |
| Spalten | Welche Felder, mit exaktem Namen? | `Region`, `Monat`, `Ist_Kosten`, `Plan_Kosten` |
| Filter | Welcher Ausschnitt? | „Monate Jan–Okt 2026, alle Regionen“ |
| Aggregation | Was wird wie zusammengefasst? | „Summe je Region“, „Mittelwert je Monat“ |
| Form | Formel, PivotTable oder Diagramm? | „als PivotTable“, „als Formel mit strukturierten Verweisen“ |
| Ausgabeort | Wohin? | „neues Blatt `Analyse`, ab Zelle A1“ |
| Schutz | Was bleibt unverändert? | „Ändere die Quelltabellen nicht.“ |

## Prompt

PivotTable:
```text
Verwende die Tabelle tblZeitreihe auf dem Blatt Zeitreihe.
Erstelle eine PivotTable auf einem neuen Blatt „Analyse_Pivot“ ab Zelle A3:
- Zeilen: Region
- Werte: Summe von Ist_Kosten, Summe von Plan_Kosten
- Filter: Monat (alle Monate Jan–Okt 2026 ausgewählt)
Ergänze rechts neben der PivotTable keine eigenen Spalten. Ändere tblZeitreihe nicht.
Sag mir danach, wie viele Zeilen der Quelle in die PivotTable eingegangen sind.
```

Formel statt Wert:
```text
Verwende die Tabellen tblRegionOkt und tblZeitreihe.
Lege auf einem neuen Blatt „Analyse_Formeln“ eine Übersicht an: Spalte A alle Regionen aus tblRegionOkt,
Spalte B Ist_Kosten Jan–Okt 2026 je Region, Spalte C Plan_Kosten Jan–Okt 2026 je Region, Spalte D Abweichung
absolut, Spalte E Abweichung in Prozent von Plan (als Prozentwert, 6,87 = 6,87 %).
Regeln:
- Schreib in jede Zelle eine Formel mit strukturierten Verweisen (z. B. SUMMEWENNS über tblZeitreihe), keine
  festen Werte. Die Übersicht muss sich aktualisieren, wenn in tblZeitreihe Zeilen dazukommen.
- Division durch null abfangen.
- Erkläre jede Formel in einem Satz und nenne die Zelle, in der sie steht.
```

Diagramm:
```text
Erstelle aus dem Bereich A1:E[EINFÜGEN: letzte Zeile] auf dem Blatt „Analyse_Formeln“ ein Balkendiagramm
„Abweichung Ist/Plan in % je Region, Jan–Okt 2026“. Sortierung absteigend nach Abweichung, Datenbeschriftung mit
einer Nachkommastelle, keine Gitternetzlinien, Diagramm auf demselben Blatt ab Zelle G2.
```

## Nachschärfen

Wenn Copilot einen festen Wert statt einer Formel geschrieben hat:
```text
In [EINFÜGEN: Zelle/Bereich] stehen feste Werte. Ersetze sie durch Formeln mit strukturierten Verweisen auf
tblZeitreihe und zeig mir die Formel der ersten Zeile.
```

Wenn die falsche Tabelle oder Spalte verwendet wurde:
```text
Du hast [EINFÜGEN: falsche Tabelle/Spalte] verwendet. Verwende ausschließlich tblZeitreihe[Ist_Kosten] und
tblZeitreihe[Plan_Kosten]. Mach die letzte Änderung rückgängig und erstelle das Ergebnis neu.
```

Wenn Sie eine Formel verstehen oder dokumentieren wollen:
```text
Erkläre die Formel in [EINFÜGEN: Zelle] Schritt für Schritt. Nenne, bei welchen Eingabedaten sie ein falsches
oder leeres Ergebnis liefert, und schlage eine robustere Fassung vor.
```

Rückfallweg im Copilot Chat (Datei anhängen):
```text
Schreib mir für deutsches Excel (Funktionsnamen deutsch, Semikolon als Trennzeichen) die Formel für
[EINFÜGEN: Aufgabe] mit strukturierten Verweisen auf [EINFÜGEN: Tabelle und Spalten]. Nur die Formel und ein Satz
Erklärung. Ich füge sie selbst ein.
```

## Ergebnis prüfen
- [ ] In den Ergebniszellen steht eine **Formel** (Zelle anklicken, Bearbeitungsleiste) – kein eingetippter Wert.
- [ ] Die Formel verweist auf Tabellennamen (`tblZeitreihe[...]`), nicht auf feste Bereiche wie `B2:B71`.
- [ ] Test: in einer **Kopie** eine Zeile in `tblZeitreihe` ergänzen – ändert sich die Übersicht? Danach rückgängig.
- [ ] Gegenprobe: Summe der PivotTable = Summe der Formelübersicht = Statusleisten-Summe der gefilterten Spalte.
- [ ] Die Quelltabellen sind unverändert (Zeilenzahl, keine neuen Spalten).
- [ ] Diagrammtitel, Einheit und Sortierung stimmen; die Werte im Diagramm entsprechen der Übersicht.

## Stolperfallen
- **Copilot ändert die Mappe wirklich.** Immer in einer Kopie arbeiten; Rückgängig und der Versionsverlauf helfen.
- **Antwort im Chat ≠ Inhalt der Zelle.** Eine genannte Zahl im Chatfenster ist nicht reproduzierbar. Entscheidend
  ist, was in der Zelle steht.
- **Englische Formeln im Chattext.** Im Blatt erscheinen Funktionen in Ihrer Excel-Sprache; im erklärenden Text
  stehen oft englische Namen und Kommas (SUMIFS statt SUMMEWENNS). Nicht aus dem Chat abtippen, sondern einfügen lassen.
- **Quoten summiert oder gemittelt.** Eine Summe von `Qualitaetsquote` ist sinnlos, ein Mittelwert ungewichtet.
  Aggregation je Spalte ausdrücklich vorgeben.
- **Monat als Text oder Datum.** Je nach Datentyp sortiert und filtert Excel anders. Vor dem Filtern nachsehen.
- **`=COPILOT()` in Zellen** wurde nach Berichten von Fachmedien zum 14.09.2026 eingestellt (nicht bei Microsoft gegengeprüft). Nicht einplanen; ältere Videos zeigen die Funktion noch.

Mehr dazu: [M3-07 Prüfspalten und Formeln](M3-07_Excel-Pruefspalten-und-Formeln.md) · [M3-04 Analyst](M3-04_Analyst-Datenanalyse-nachvollziehbar.md)
