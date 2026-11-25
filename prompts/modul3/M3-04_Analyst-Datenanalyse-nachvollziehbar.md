# M3-04 · Analyst – Datenanalyse mit nachvollziehbarer Rechnung

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | Analyst* (Copilot Chat › Tools) mit Dateianhang, Rückfallweg: Copilot Chat mit Dateianhang | Ü3.2 | 15 min |

\* Analyst ist ein von Microsoft bereitgestellter Agent in Copilot Chat (unter *Tools* bzw. *Agents*), Teil der
Microsoft-365-Copilot-Lizenz. Er kann Python ausführen und zeigt seine Analyseschritte. Ohne Lizenz/Freigabe:
gleichen Prompt im normalen Copilot Chat mit angehängter Datei verwenden und Rechenweg ausdrücklich verlangen.

## Wofür
Eine Zahl, deren Herkunft niemand nachvollziehen kann, gehört nicht in den Monatsbericht. Analyst rechnet
tatsächlich (statt Summen aus dem Dateitext zu schätzen) und legt Code und Zwischenschritte offen. Sie lassen den
Kennzahlenexport einlesen, die abgeleiteten Spalten nachrechnen, zwei Blätter gegeneinander abstimmen und ein
Ranking erstellen – jeweils mit sichtbarer Rechnung und Ergebnis als Tabelle.

## Vorbereitung
- Datei anhängen: `Kennzahlen_Okt-2026.xlsx` aus [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/).
  Aufbau: Blatt `Regionen_Okt` (`tblRegionOkt`), Blatt `Zeitreihe` (`tblZeitreihe`, Jan–Okt 2026 je Region),
  Blatt `Massnahmen` (`tblMassnahmen`).
- Optional [K05 Kennzahlen-Glossar](../kontext/K05_Kennzahlen-Glossar.md) anhängen.
- Datei parallel in Excel öffnen – für die Stichprobe am Ende.

> **Datenschutz:** Nur im unternehmensfreigegebenen Copilot arbeiten (Unternehmenskonto, grünes Schild). Keine
> personenbezogenen Daten anhängen. Im Training ausschließlich die fiktiven Übungsdaten verwenden.

## Prompt
```text
Du bist Controller*in im Produktionscontrolling und bereitest die Zahlen für den Monatsbericht
[EINFÜGEN: Oktober 2026] vor. Jede Zahl muss nachrechenbar sein.

Kontext: Angehängt ist [EINFÜGEN: Kennzahlen_Okt-2026.xlsx] mit den Blättern Regionen_Okt (eine Zeile je Region
für den Berichtsmonat), Zeitreihe (eine Zeile je Monat und Region, Jan–Okt 2026) und Massnahmen.
Prozentspalten sind Prozentwerte: 6,87 bedeutet 6,87 %. Zahlenformat deutsch.
Kennzahlendefinitionen: [EINFÜGEN: „siehe K05“ oder Kurzliste].

Aufgabe – arbeite die Schritte nacheinander ab und rechne mit Python:
1. Einlesen bestätigen: je Blatt Zeilenzahl, Spalten mit Datentyp, vorkommende Regionen und Monate. Zeig eine
   Beispielzeile aus Regionen_Okt so, wie du sie gelesen hast.
2. Nachrechnen in Regionen_Okt: Abw_Kosten = Ist_Kosten − Plan_Kosten und
   Abw_Prozent = Abw_Kosten / Plan_Kosten × 100. Vergleiche deine Werte mit den gelieferten Spalten.
   Toleranz: [EINFÜGEN: 0,5 € bzw. 0,05 Prozentpunkte].
3. Abstimmung der Blätter: Vergleiche je Region die Oktober-Zeile der Zeitreihe mit Regionen_Okt
   (Ist_Kosten, Plan_Kosten, Qualitaetsquote, Krankenquote).
4. Laufendes Jahr: Summe Ist_Kosten und Plan_Kosten Jan–Okt je Region, Abweichung absolut und in Prozent,
   Rang nach Abweichung in Prozent (ungünstigste zuerst).
5. Vorjahr: Veränderung Ist_Kosten gegenüber Ist_Kosten_VJ je Region in Prozent.

Regeln:
- Zeig nach jedem Schritt den verwendeten Code und das Ergebnis. Keine Zahl ohne Rechnung.
- Verwende nur Spalten, die in der Datei vorhanden sind. Fehlt etwas, sag es, statt eine Spalte zu erfinden.
- Quoten werden nicht summiert. Wenn du Quoten über Monate zusammenfasst, sag, dass der Mittelwert ungewichtet ist.
- Melde Auffälligkeiten als Beobachtung. Korrigiere keine Werte und spekuliere nicht über Ursachen.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
A. Tabelle „Region | Ist Okt | Plan Okt | Abw | Abw % | Ist VJ | Veränd. VJ % | Ist YTD | Plan YTD | Abw YTD % | Rang“.
B. Tabelle „Prüfung | Anzahl geprüfter Zeilen | Anzahl Differenzen | betroffene Regionen“ für Schritt 2 und 3.
C. Der vollständige Code in einem Block, sodass ich ihn erneut ausführen lassen kann.
D. „Annahmen und offene Punkte“.
```

## Nachschärfen

Wenn kein Code gezeigt wird oder Copilot „überschlägt“:
```text
Hast du gerechnet oder geschätzt? Führe die Schritte 2 bis 5 jetzt mit Python aus und zeig den Code. Gib zu
jeder Zahl in Tabelle A die Formel an (Spalten und Filter), aus der sie entsteht.
```

Wenn Prozentwerte falsch gelesen wurden (z. B. 6,87 als 687 % oder 0,0687):
```text
Die Spalten Abw_Prozent, Qualitaetsquote, Krankenquote und Ueberstundenquote enthalten Prozentwerte
(6,87 = 6,87 %). Lies die Datei neu ein, zeig dieselbe Beispielzeile erneut und wiederhole die Schritte 2 bis 5.
```

Für die Weiterverwendung in Excel oder PowerPoint:
```text
Gib Tabelle A als Excel-Datei oder, falls das nicht möglich ist, als tabulatorgetrennten Text zum Einfügen in
Excel aus. Zahlen ungerundet, Dezimalkomma, keine Tausenderpunkte, keine Einheiten in den Zellen.
```

Für eine Abbildung:
```text
Erstelle ein Balkendiagramm „Abweichung Ist/Plan in % je Region, Okt 2026“, sortiert absteigend, Achse in %,
Datenbeschriftung mit einer Nachkommastelle. Zeig den Code dazu.
```

## Ergebnis prüfen
- [ ] Zeilenzahlen und Regionen aus Schritt 1 stimmen mit der geöffneten Datei überein.
- [ ] Zu jedem Schritt ist Code bzw. ein Rechenweg sichtbar. Kein Code = Zahl nicht übernehmen.
- [ ] **Stichprobe in Excel:** für zwei Regionen Abw_Kosten und Abw_Prozent selbst nachrechnen; für eine Region
      Ist YTD per Filter und Statusleisten-Summe prüfen.
- [ ] Tabelle B nennt geprüfte Zeilen und Differenzen ausdrücklich – auch „0 Differenzen“ ist ein Ergebnis.
- [ ] Rang und Vorzeichen passen zur Wertung: Mehrkosten sind ungünstig (siehe [K04](../kontext/K04_Kommentar-Leitfaden-KPI.md)).
- [ ] Keine Ursachenbehauptungen im Ergebnis – nur Beobachtungen.

## Stolperfallen
- **Ergebnis ohne Code ist eine Behauptung.** Auch Analyst antwortet bei kurzen Fragen gelegentlich direkt.
  Den Rechenweg immer einfordern.
- **Blattwahl.** Bei mehreren Blättern liest Copilot manchmal nur das erste. Schritt 1 deckt das auf.
- **Prozent von Prozent.** Abw_Prozent liegt als Prozentwert vor – nicht noch einmal mit 100 multiplizieren lassen.
- **Ergebnis bleibt im Chat.** Die Rechnung ist nachvollziehbar, aber nicht mit Ihrer Datei verbunden. Für
  Kennzahlen, die monatlich wiederkehren, die Formel in Excel bauen ([M3-05](M3-05_Excel-strukturierte-Analyse.md)).
- **Gleiche Frage, anderer Tag, anderer Code.** Speichern Sie den Code aus Ausgabe C zusammen mit dem Ergebnis –
  das ist Ihre Dokumentation.

Mehr dazu: [M2-03 Datenprofil](../modul2/M2-03_Datenprofil-und-Plausibilitaetscheck.md) · [M3-08 Office-Dateien gegeneinander prüfen](M3-08_Office-Dateien-gegeneinander-pruefen.md)
