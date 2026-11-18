# K04 · Kommentar-Leitfaden für Kennzahlenberichte

> **Wie nutzen?** An alle Kommentar-Prompts aus Modul 2 anhängen oder im Copilot Notebook hinterlegen.
> Er legt fest, wie ein guter Kommentar im Produktionscontrolling aussieht. Ersetzen Sie die
> Beispiele durch Kommentare aus Ihren eigenen Berichten – Copilot imitiert den Stil.

---

## Grundsätze

1. **Aussage zuerst.** Der erste Satz ist die Botschaft, nicht die Beschreibung des Diagramms.
   Gut: „Ost liegt im Oktober 7 % über Plan – getrieben von Überstunden.“
   Schlecht: „Die Tabelle zeigt die Kosten je Region.“
2. **Jede Aussage mit Zahl und Vergleich.** Ist gegen Plan (PL) und/oder Vorjahr (VJ), absolut und relativ.
3. **Wesentliches vor Vollständigem.** Höchstens drei Punkte je Kommentar, sortiert nach Bedeutung.
   Was im Plan liegt, wird in einem Satz zusammengefasst („Alle übrigen Regionen im Plan (±2 %).“).
4. **Beobachtung und Ursache trennen.** Ursachen nur nennen, wenn sie in den Daten oder im mitgegebenen
   Kontext belegt sind. Sonst: „mögliche Ursache: … (zu prüfen)“.
5. **Handlungsbedarf benennen**, wenn es einen gibt: Was ist zu tun, von wem, bis wann – oder „kein Handlungsbedarf“.
6. **Datenqualität zuerst.** Ist ein Wert unplausibel (Ausreißer, Dublette, Lücke), wird er nicht kommentiert,
   sondern als Datenproblem gemeldet.

## Notation

| Kürzel | Bedeutung |
|---|---|
| IST | Istwert der Berichtsperiode |
| PL | Plan |
| VJ | Vorjahr, gleiche Periode |
| Abw | Abweichung IST – PL (absolut, in Einheit der Kennzahl) |
| Abw % | Abweichung in Prozent von PL |
| Pp. | Prozentpunkte (bei Quoten: 9,6 % statt 5,5 % = +4,1 Pp., nicht „+75 %“) |

- Zahlen deutsch formatieren: `1,2 Mio. €`, `48 T€`, `7,3 %`. Eine Nachkommastelle bei Prozenten.
- Vorzeichen immer angeben: `+7,3 %`, `−2,1 Pp.`.
- Positive Abweichung bei Kosten ist **ungünstig**, bei Qualität **günstig** – Wertung im Text klar machen
  („ungünstig“, „günstig“), nicht nur das Vorzeichen.

## Formate je Berichtstyp

**Kennzahlenübersicht** (Management, 3–5 Sätze)
Gesamtaussage → die eine bis zwei wichtigsten Abweichungen mit Zahl → was im Plan ist → Handlungsbedarf.

**Detailbericht** (Fachbereich, 5–8 Sätze oder Stichpunkte)
Entwicklung über die Zeit (seit wann, wie stark) → Zerlegung (welche Leistungsart, welche Kennzahl treibt) →
Zusammenhänge mit anderen Kennzahlen (als Beobachtung) → offene Prüfpunkte.

**Maßnahmentracking** (Steuerung, Stichpunkte)
Status gesamt (x von y im Plan) → verzögerte und kritische Maßnahmen mit Zieltermin →
nachgewiesene Wirkung abgeschlossener Maßnahmen (Vorher/Nachher-Zahl) → Unstimmigkeiten in den Daten.

## Beispielkommentar (Kennzahlenübersicht, fiktiv, nicht aus dem Übungsmodell)

> **März 2026: Kosten insgesamt 0,9 % über Plan – einzige relevante Abweichung im Sicherheitsdienst West.**
> Der Sicherheitsdienst West liegt mit +6,4 % (+31 T€) über Plan; laut Einsatzplanung gehen 24 T€ auf
> Zusatzeinsätze bei zwei Großveranstaltungen zurück, die dem Auftraggeber weiterberechnet werden.
> Qualitätsquote (93,8 %) und Krankenquote (5,1 %) liegen in allen Regionen im Zielkorridor.
> Kein Handlungsbedarf; Weiterberechnung im April prüfen.

## Formulierungen, die vermieden werden

- „signifikant“ (ohne Test), „eindeutig“, „zweifellos“
- „aufgrund von …“ ohne Beleg
- Diagrammbeschreibungen („Die Linie steigt“) statt Aussagen
- Prozentveränderungen bei Quoten ohne Prozentpunkte
