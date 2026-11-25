# M3-08 · Office-Dateien gegeneinander prüfen (Präsentation gegen Excel-Quelle)

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | **Neuer** Copilot Chat mit zwei Dateianhängen; für Nachrechnungen Analyst*; Gegenprobe in Excel | Ü3.5 | 15 min |

\* Analyst (Copilot Chat › Tools) rechnet abgeleitete Werte mit Python nach. Ohne Analyst: normaler Copilot Chat
mit beiden Dateien im Anhang – das funktioniert immer.

## Wofür
Ein Kollege hat den Monatsbericht als Präsentation vorbereitet, die Zahlen stammen aus einem Excel-Export. Bevor
die Folien verschickt werden, wird **jede Zahl und jede Aussage einzeln** gegen die Quelle gelegt: belegt,
abweichend oder nicht belegbar. Copilot zerlegt die Folien in Behauptungen und sucht je Behauptung den Beleg.
Sie prüfen die Prüfung per Stichprobe. Der Entwurf enthält absichtlich Abweichungen – wie viele und wo, zeigt die Übung.

## Vorbereitung
- Beide Dateien aus [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/) an einen **neuen** Chat anhängen:
  `Monatsbericht_Okt-2026_Entwurf.pptx` (5 Folien) und `Kennzahlen_Okt-2026.xlsx` (Quelle:
  `tblRegionOkt`, `tblZeitreihe`, `tblMassnahmen`).
- Präsentation und Excel-Datei parallel öffnen – für die Stichprobe.
- Optional [K04 Kommentar-Leitfaden](../kontext/K04_Kommentar-Leitfaden-KPI.md) anhängen (Notation, Prozentpunkte).

> **Datenschutz:** Nur im unternehmensfreigegebenen Copilot arbeiten (Unternehmenskonto, grünes Schild). Entwürfe
> echter Berichte nur anhängen, wenn sie dafür freigegeben sind; keine personenbezogenen Daten. Im Training nur
> die fiktiven Übungsdateien verwenden.

## Prompt

Schritt 1 – was wurde gelesen?
```text
Du bist Revisor*in im Controlling. Du hast die Präsentation nicht erstellt und bist nicht an sie gebunden.

Angehängt sind [EINFÜGEN: Monatsbericht_Okt-2026_Entwurf.pptx] (zu prüfen) und
[EINFÜGEN: Kennzahlen_Okt-2026.xlsx] (einzige Quelle). Berichtsmonat: [EINFÜGEN: Oktober 2026].
Prozentspalten der Quelle sind Prozentwerte (6,87 bedeutet 6,87 %).

Bewerte noch nichts. Bestätige nur:
1. Präsentation: je Folie Nummer, Titel, Textinhalt, Tabellenwerte, Sprechernotizen. Nenne ausdrücklich, was du
   NICHT lesen konntest (Diagramme, Bilder, eingebettete Objekte).
2. Quelle: Blätter, Tabellen, Spalten, Zeilenzahl je Tabelle.
```

Schritt 2 – Behauptung für Behauptung prüfen:
```text
Prüfe jetzt die Präsentation gegen die Quelle.

Vorgehen:
1. Zerlege jede Folie in einzelne prüfbare Behauptungen: jede Zahl, jeder Vergleich (über/unter Plan, höher als
   Vorjahr), jede Rangaussage („höchste“, „alle“, „einzige“), jede Statusaussage zu Maßnahmen, jede Ursache,
   jede Empfehlung. Auch Titel, Tabellenzellen und Sprechernotizen zählen.
2. Suche je Behauptung den Beleg in der Quelle (Blatt, Tabelle, Spalte, Region/Monat/MassnahmeID). Abgeleitete
   Werte (Summen, Differenzen, Prozent, Ränge) rechnest du nach und zeigst die Rechnung.
3. Prüfe zusätzlich: Einheit (€, T€, %, Prozentpunkte), Zeitraum (Monat oder Jan–Okt), Vergleichsbasis (Plan oder
   Vorjahr), Vorzeichen und Wertung (Mehrkosten = ungünstig).

Regeln:
- Bewertung: „belegt“ (stimmt innerhalb der Toleranz), „abweichend“ (mit Wert laut Quelle und Differenz),
  „nicht belegbar“ (steht nicht in der Quelle – z. B. Ursachen).
- Toleranz: [EINFÜGEN: ±0,1 Prozentpunkte bei Quoten und Prozentwerten; Rundung auf T€ bei Beträgen].
- Was du nicht lesen konntest, führst du als „nicht geprüft“ auf – nicht als „belegt“.
- Ändere nichts an den Folien. Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
Tabelle „Nr | Behauptung (Zitat) | Folie | Quelle (Blatt, Spalte, Zeile) | Wert laut Quelle / Rechnung | Bewertung“.
Danach: Anzahl je Bewertung, je Folie ein Satz zum Gesamturteil und die Liste „nicht geprüft“.
```

## Nachschärfen

Wenn die Tabelle Lücken hat:
```text
Zähle auf Folie [EINFÜGEN: Nr] alle Zahlen im Titel, im Text, in Tabellen und in den Notizen. Wie viele sind es,
und welche fehlen in deiner Prüftabelle? Ergänze die fehlenden Zeilen.
```

Wenn Diagramme nicht gelesen wurden:
```text
Die Werte des Diagramms auf Folie [EINFÜGEN: Nr] lauten: [EINFÜGEN: Werte aus „Daten bearbeiten“ kopiert].
Prüfe sie gegen die Quelle wie die übrigen Behauptungen.
```

Wenn eine Abweichung unklar ist (Rundung, anderer Zeitraum, andere Basis):
```text
Behauptung [EINFÜGEN: Nr]: Welche Erklärungen sind möglich (Rundung, YTD statt Monat, Vorjahr statt Plan,
falsche Region, Zahlendreher)? Rechne jede Variante nach und sag, welche zum Folienwert passt.
```

Für die Rückmeldung an den Ersteller:
```text
Schreib eine Korrekturliste für den Ersteller: je abweichender oder nicht belegbarer Behauptung Folie, Stelle,
alter Text, vorgeschlagener neuer Text mit Wert laut Quelle. Sachlich, ohne Wertung der Person. Sortiert nach Folie.
```

## Ergebnis prüfen
- [ ] Schritt 1 nennt alle **fünf Folien** und sagt offen, was nicht gelesen wurde.
- [ ] Jede Zahl der Folien hat eine Zeile in der Prüftabelle (eine Folie selbst durchzählen).
- [ ] **Stichprobe:** drei als „belegt“ und alle als „abweichend“ markierten Zeilen in Excel nachsehen
      (Filter in `tblRegionOkt` bzw. `tblZeitreihe`, Summe in der Statusleiste).
- [ ] Rang- und Allaussagen („höchste“, „alle im Plan“) sind nachgerechnet, nicht nur abgenickt.
- [ ] Ursachen und Empfehlungen sind „nicht belegbar“, sofern die Quelle sie nicht trägt.
- [ ] Vergleich mit der Auflösung im Training: Haben Sie alle eingebauten Abweichungen gefunden – und keine erfunden?

## Stolperfallen
- **Diagramme und Bilder sind oft unsichtbar.** Copilot liest Text und Tabellen einer Präsentation zuverlässiger
  als Diagrammdaten; Zahlen in Bildern gar nicht. Deshalb Schritt 1 und die Liste „nicht geprüft“.
- **Prüfen im selben Chat, der die Folien geschrieben hat,** führt zu „alles korrekt“. Immer neuer Chat.
- **Falsch-positive Abweichungen.** Ohne Toleranz wird 7,1 % gegen 7,08 % als Fehler gemeldet. Toleranz vorgeben.
- **Richtige Zahl, falsches Etikett.** Der Wert stimmt, gehört aber zu einer anderen Region, zum Vorjahr oder zu
  Jan–Okt. Deshalb Zeitraum, Basis und Einheit als eigene Prüfpunkte.
- **Quelle ist nicht die Wahrheit.** Die Prüfung zeigt nur, ob Folien und Export übereinstimmen. Ob der Export
  stimmt, klärt die Validierung ([M3-06](M3-06_Excel-Validierung-Regelkatalog.md)).

Mehr dazu: [M2-10 Faktencheck eines Kommentars](../modul2/M2-10_Faktencheck-Kommentar.md) · [M3-10 PowerPoint prüfen und nachschärfen](M3-10_PowerPoint-pruefen-und-nachschaerfen.md)
