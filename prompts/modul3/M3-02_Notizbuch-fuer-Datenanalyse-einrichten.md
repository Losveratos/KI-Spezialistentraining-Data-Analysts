# M3-02 · Notizbuch für die Datenanalyse einrichten

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | Copilot-Notizbuch (Copilot Notebook) in der Copilot-App oder in OneNote | Ü3.1 | 10 min |

## Wofür
Ein Notizbuch ist ein dauerhafter Arbeitsbereich: Referenzen (Dateien, Seiten, Links, Chats) und Regeln bleiben
erhalten, jeder Chat darin baut darauf auf. Für wiederkehrende Aufgaben wie den Monatsbericht ersparen Sie sich,
Glossar, Kommentar-Leitfaden und Export in jeden Prompt zu kopieren. Sie richten ein Notizbuch „Monatsbericht
Oktober 2026“ ein, geben ihm eine Anweisung und testen, ob Copilot die Referenzen wirklich verwendet.

## Vorbereitung
1. Copilot-App › **Notizbücher** (Notebooks) › **Neues Notizbuch**, Name: `Monatsbericht Okt 2026 – Training`.
2. **Referenzen hinzufügen** (Add reference). Dateien vorher in Ihr OneDrive legen oder direkt hochladen:
   - [K01 Arbeitsregeln](../kontext/K01_Arbeitsregeln-BI-Copilot.md),
     [K04 Kommentar-Leitfaden](../kontext/K04_Kommentar-Leitfaden-KPI.md),
     [K05 Kennzahlen-Glossar](../kontext/K05_Kennzahlen-Glossar.md)
   - `Kennzahlen_Okt-2026.xlsx` und `Leistungsnachweise_Export_Okt-2026.xlsx` aus
     [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/)
3. Wird `.md` nicht angenommen: Datei als `.txt` speichern oder den Inhalt in ein Word-Dokument kopieren.
   Welche Dateitypen Ihr Notizbuch annimmt, ist versionsabhängig – Word, Excel, PowerPoint und PDF funktionieren in
   der Regel; inzwischen sind auch Weblinks und Teams-Besprechungen als Referenz möglich.
4. Notizbücher fehlen bei Ihnen? Rückfallweg: Einzelchat, K01/K04/K05 und die Exportdatei anhängen und die
   Anweisung unten als erste Nachricht senden.

> **Datenschutz:** Nur im unternehmensfreigegebenen Copilot arbeiten (Unternehmenskonto, grünes Schild). Referenzen
> bleiben im Notizbuch gespeichert – keine Dateien mit personenbezogenen Daten hinterlegen, und vor dem Teilen eines
> Notizbuchs prüfen, wer dadurch Zugriff auf die Referenzen erhält. Im Training nur die fiktiven Übungsdateien.

**Was hinein gehört – und was nicht**

| Gehört hinein | Gehört nicht hinein |
|---|---|
| Regeln und Leitfäden (K01, K04), Glossar (K05) | Rohdaten mit Personenbezug (Erfasser, Personalnummern) |
| Der bereinigte Export des Berichtsmonats | Exporte mehrerer Monate mit gleichem Aufbau ohne Monatsangabe im Namen |
| Freigegebene Beispielkommentare aus früheren Berichten | Entwürfe, deren Zahlen noch nicht geprüft sind |
| Prüfregeln, Spaltenbeschreibungen, Berichtskalender | Alles „für alle Fälle“ – viele Referenzen verwässern die Antworten |

## Prompt

Notizbuch-Anweisung – in das Feld für Anweisungen eintragen (Copilot instructions, sofern vorhanden), sonst als
Textdatei `Notizbuch-Regeln.txt` zu den Referenzen legen und im ersten Prompt darauf verweisen:

```text
Du unterstützt Data Analysts im Produktionscontrolling beim Monatsbericht [EINFÜGEN: Oktober 2026].

Arbeitsweise:
- Halte dich an K01 (Arbeitsregeln), K04 (Kommentar-Leitfaden) und K05 (Kennzahlen-Glossar) aus den Referenzen.
- Einzige Datenquelle für Zahlen ist [EINFÜGEN: Kennzahlen_Okt-2026.xlsx]. Prozentspalten sind Prozentwerte
  (6,87 bedeutet 6,87 %). Nenne zu jeder Zahl Blatt, Tabelle und Spalte.
- Rechne nicht im Kopf. Wenn eine Zahl berechnet werden muss, zeig die Rechnung oder sag, dass ich sie mit Analyst
  oder in Excel nachrechnen soll.
- Trenne Beobachtung und Vermutung. Ursachen nur nennen, wenn sie in den Referenzen belegt sind.
- Wenn eine Information in den Referenzen fehlt, sag „nicht in den Referenzen“ statt zu raten.
- Antworte auf Deutsch, sachlich, Ergebnis zuerst, am Ende „Annahmen und offene Punkte“.
```

Test – verwendet Copilot die Referenzen?

```text
Prüfe deine Arbeitsgrundlage, bevor wir starten:
1. Liste alle Referenzen dieses Notizbuchs mit Dateiname und einem Satz zum Inhalt.
2. Nenne aus K04 die Regel zur Notation von Quoten-Veränderungen und aus K05 die Definition von
   [EINFÜGEN: Kennzahl, z. B. Krankenquote] – jeweils mit Angabe der Referenz.
3. Nenne die Blätter und Tabellen von [EINFÜGEN: Kennzahlen_Okt-2026.xlsx] und je Tabelle die Spalten.
4. Was konntest du nicht lesen oder nur teilweise?
Erfinde nichts: Wenn etwas nicht in den Referenzen steht, schreib „nicht in den Referenzen“.
```

## Nachschärfen

Wenn Copilot eine Referenz ignoriert oder allgemein antwortet:
```text
Beantworte die Frage ausschließlich mit den Referenzen dieses Notizbuchs. Nenne nach jedem Absatz in Klammern die
Referenz, aus der die Aussage stammt. Aussagen ohne Referenz lässt du weg.
```

Wenn Sie den Stand der Daten festhalten wollen:
```text
Notiere als Seite in diesem Notizbuch: Berichtsmonat, Dateiname und Speicherdatum des Exports, Einheit der
Prozentspalten, offene Datenfragen. Halte dich kurz (höchstens 8 Zeilen).
```

Für den nächsten Monat:
```text
Ich ersetze den Export durch [EINFÜGEN: neue Datei]. Welche Aussagen aus früheren Antworten in diesem Notizbuch
beruhen auf der alten Datei und müssen neu erstellt werden?
```

## Ergebnis prüfen
- [ ] Alle hinterlegten Referenzen werden im Test aufgezählt – fehlt eine, wurde sie nicht verarbeitet.
- [ ] Die zitierten Regeln aus K04 und K05 stimmen wörtlich bzw. sinngemäß mit den Dateien überein (nachlesen).
- [ ] Blatt- und Tabellennamen der Excel-Datei sind richtig (`Regionen_Okt`/`tblRegionOkt`, `Zeitreihe`/`tblZeitreihe`,
      `Massnahmen`/`tblMassnahmen`).
- [ ] Auf eine Frage, die keine Referenz beantwortet, kommt „nicht in den Referenzen“ – testen Sie das einmal.
- [ ] Ein zweiter Chat im selben Notizbuch kennt die Regeln ohne erneutes Anhängen.

## Stolperfallen
- **Notizbuch rechnet nicht zuverlässig.** Referenzen werden als Text gelesen. Für Summen, Abgleiche und Rankings
  Analyst ([M3-04](M3-04_Analyst-Datenanalyse-nachvollziehbar.md)) oder Excel ([M3-05](M3-05_Excel-strukturierte-Analyse.md)) nutzen.
- **Zwei Stände derselben Datei.** Liegen September- und Oktober-Export im selben Notizbuch, mischt Copilot Zahlen.
  Ein Notizbuch je Berichtsmonat oder alte Exporte entfernen.
- **Aktualisierte Dateien.** Nach dem Ändern einer Referenzdatei prüfen, ob das Notizbuch den neuen Stand kennt
  (eine geänderte Zahl abfragen); im Zweifel Referenz entfernen und neu hinzufügen.
- **Anweisung zu lang.** Zehn klare Zeilen wirken besser als zwei Seiten. Details gehören in K01/K04/K05.

Mehr dazu: [Kontextdateien](../kontext/README.md) · [M3-01 Werkzeugwahl](M3-01_Chat-Notizbuch-oder-Agent.md)
