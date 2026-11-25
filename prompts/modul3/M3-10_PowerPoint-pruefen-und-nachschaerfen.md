# M3-10 · Erzeugte Folien prüfen und nachschärfen

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | **Neuer** Copilot Chat mit Dateianhang (Prüfung); Copilot in PowerPoint (Überarbeitung) | Ü3.6 | 10 min |

## Wofür
Der Foliensatz aus [M3-09](M3-09_Excel-zu-PowerPoint.md) sieht fertig aus – ist er es auch? Vor dem Versand prüfen
Sie fünf Dinge: Zahlen gegen die Quelle, Titel als Aussage, Einheiten und Notation, eine Botschaft je Folie und
brauchbare Sprechernotizen. Die Prüfung läuft in einem **neuen** Chat (Copilot verteidigt sonst seinen Entwurf),
die Korrekturen setzen Sie gezielt je Folie um.

## Vorbereitung
- Die erzeugte Präsentation speichern (OneDrive/SharePoint) und zusammen mit `Kennzahlen_Okt-2026.xlsx` aus
  [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/) an einen **neuen** Chat anhängen.
- [K04 Kommentar-Leitfaden](../kontext/K04_Kommentar-Leitfaden-KPI.md) anhängen.
- Storyline aus M3-09 bereithalten – sie ist der Soll-Stand.
- Ohne Copilot in PowerPoint: Korrekturen aus der Prüftabelle von Hand übernehmen; der Prüf-Chat funktioniert immer.

> **Datenschutz:** Nur im unternehmensfreigegebenen Copilot arbeiten (Unternehmenskonto, grünes Schild). Keine
> personenbezogenen Daten anhängen. Im Training ausschließlich die fiktiven Übungsdaten verwenden.

## Prompt
```text
Du bist Revisor*in im Controlling und nimmst einen Foliensatz ab, bevor er an [EINFÜGEN: Zielgruppe, z. B. die
Bereichsleitung] geht. Du hast ihn nicht erstellt.

Angehängt: [EINFÜGEN: Präsentation.pptx] (zu prüfen), [EINFÜGEN: Kennzahlen_Okt-2026.xlsx] (einzige Datenquelle,
Prozentspalten sind Prozentwerte: 6,87 = 6,87 %) und der Kommentar-Leitfaden K04. Berichtsmonat: [EINFÜGEN: Oktober 2026].

Bestätige zuerst je Folie, was du gelesen hast (Titel, Text, Tabellen, Notizen) und was nicht (Diagramme, Bilder).

Prüfe dann jede Folie nach diesen fünf Kriterien:
1. Zahlen: Jede Zahl gegen die Quelle (Blatt, Spalte, Zeile). Abgeleitete Werte nachrechnen und Rechnung zeigen.
   Toleranz: [EINFÜGEN: ±0,1 Prozentpunkte; Beträge gerundet auf T€].
2. Titel: Ist der Titel eine Aussage als ganzer Satz mit Zahl und Vergleich – oder nur ein Thema?
3. Einheiten und Notation: Einheit bei jeder Zahl, Vorzeichen, Prozent gegenüber Prozentpunkten, Vergleichsbasis
   (PL/VJ) und Zeitraum genannt, Wertung (günstig/ungünstig) passend zur Kennzahl.
4. Fokus: genau eine Botschaft je Folie, höchstens drei Stichpunkte, Stichpunkte stützen den Titel. Inhalte, die
   in keiner Quelle stehen (Ursachen, Empfehlungen), als „nicht belegbar“ markieren.
5. Sprechernotizen: vorhanden, zwei bis drei Sätze, erklären die Zahl statt sie zu wiederholen, enthalten keine
   Zahlen, die nicht auf der Folie oder in der Quelle stehen.

Regeln:
- Ändere nichts. Liefere Befunde und je Befund einen konkreten Korrekturvorschlag (neuer Wortlaut).
- Kein Lob, keine Stilkritik am Layout. Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
A. Tabelle „Folie | Kriterium | Befund (Zitat) | Wert laut Quelle / Rechnung | Bewertung (ok / korrigieren /
   nicht belegbar / nicht geprüft) | Korrekturvorschlag“.
B. Je Folie: neuer Titel, falls der alte keine Aussage ist.
C. Anzahl Befunde je Kriterium und die drei wichtigsten Korrekturen vor dem Versand.
```

## Nachschärfen

Korrektur in Copilot in PowerPoint – je Folie, Folie vorher auswählen:
```text
Ändere auf dieser Folie nur Folgendes: Titel = „[EINFÜGEN: neuer Titel]“; ersetze „[EINFÜGEN: alter Text]“ durch
„[EINFÜGEN: neuer Text]“. Layout, übrige Texte und Diagramme bleiben unverändert. Ergänze nichts.
```

Sprechernotizen erzeugen oder ersetzen:
```text
Schreib für diese Folie Sprechernotizen in drei Sätzen: (1) die Aussage, (2) woran man sie in der Darstellung
sieht, (3) was daraus folgt oder offen ist. Verwende nur Zahlen, die auf der Folie stehen.
```

Zu volle Folie teilen:
```text
Diese Folie enthält zwei Botschaften: [EINFÜGEN: A] und [EINFÜGEN: B]. Teile sie in zwei Folien mit je einem
Aussage-Titel. Verteile die vorhandenen Stichpunkte, formuliere nichts Neues.
```

Nach den Korrekturen – Abgleich mit der Storyline (neuer Chat, korrigierte Datei anhängen):
```text
Vergleiche die angehängte Präsentation mit dieser Storyline: [EINFÜGEN: Storyline aus M3-09]. Liste jede Zahl und
jeden Titel, der abweicht, mit Folie, Soll und Ist. Wenn alles übereinstimmt, schreib „keine Abweichung“.
```

Kurzfassung für die E-Mail zum Versand:
```text
Fasse den Foliensatz in vier Sätzen für die Begleitmail zusammen: Kernbotschaft, zwei wichtigste Abweichungen mit
Zahl, Handlungsbedarf. Nur Zahlen aus den Folien, Notation nach K04.
```

## Ergebnis prüfen
- [ ] Copilot hat gesagt, was er nicht lesen konnte – diese Teile (meist Diagramme) haben Sie selbst geprüft.
- [ ] Jede Zahl auf den Folien hat eine Zeile in Tabelle A; zwei Folien selbst durchzählen.
- [ ] **Stichprobe in Excel:** je Folie eine Zahl nachsehen (Filter, Statusleisten-Summe).
- [ ] Alle Titel sind Aussagen; Test: Liest man nur die Titel hintereinander, ergibt sich die Geschichte.
- [ ] Quoten-Veränderungen stehen in Prozentpunkten, Kostenabweichungen mit Vorzeichen und Wertung.
- [ ] Nach den Korrekturen: Abgleich mit der Storyline ergibt „keine Abweichung“.
- [ ] Sprechernotizen enthalten keine neuen, ungeprüften Zahlen.

## Stolperfallen
- **Korrektur erzeugt neue Fehler.** „Überarbeite die Präsentation“ schreibt auch richtige Stellen um. Immer je
  Folie und mit genauem Wortlaut ändern, danach erneut gegen die Storyline prüfen.
- **Notizen werden vergessen.** Sprechernotizen landen beim Export als PDF mit Notizenseiten beim Empfänger – sie
  gehören zur Prüfung.
- **Diagrammwerte sind für Copilot oft unsichtbar.** Diagrammdaten über „Daten bearbeiten“ selbst ansehen oder die
  Werte in den Prüf-Chat kopieren.
- **Stilkritik statt Faktencheck.** Ohne klare Kriterien liefert Copilot Layout-Tipps. Die fünf Kriterien vorgeben.
- **Alter Stand geprüft.** Nach Änderungen in PowerPoint die Datei speichern und **neu** anhängen – der Chat kennt
  sonst nur die erste Fassung.

Mehr dazu: [M3-08 Office-Dateien gegeneinander prüfen](M3-08_Office-Dateien-gegeneinander-pruefen.md) · [M2-10 Faktencheck eines Kommentars](../modul2/M2-10_Faktencheck-Kommentar.md)
