# K05 · Kennzahlen-Glossar – Übungsmodell „DBS Produktionscontrolling“

> **Wie nutzen?** An Analyse- und Kommentar-Prompts anhängen, damit Copilot die Kennzahlen richtig
> deutet. Für Ihre eigenen Berichte legen Sie ein Glossar in derselben Form an – es ist einer der
> wirksamsten Hebel gegen Fehlinterpretationen.
>
> Alle Daten im Übungsmodell sind **fiktiv** (Dienstleister „DBS Training“ mit den Geschäftsfeldern
> Reinigung, Sicherheit, Facility).

---

## Struktur

| Dimension | Ausprägungen |
|---|---|
| Region | Nord, Ost, Südost, Süd, Südwest, Mitte, West |
| Leistungsart (Geschäftsfeld) | Fahrzeugreinigung (Reinigung), Bahnhofsreinigung (Reinigung), Sicherheitsdienst (Sicherheit), Facility Management (Facility), Winterdienst (Facility) |
| Zeit | Monatswerte Januar 2025 – Oktober 2026, Berichtsmonat **Oktober 2026** |
| Maßnahmen | ca. 25 Verbesserungsmaßnahmen mit Status, Fortschritt, Zieltermin und Einsparung |

## Kennzahlen

| Kennzahl (Measure) | Definition | Einheit | Gut ist |
|---|---|---|---|
| Ist Kosten | Summe der gebuchten Kosten der Leistungserbringung | € | – |
| Plan Kosten | Summe der geplanten Kosten | € | – |
| Abw Kosten | Ist Kosten − Plan Kosten | € | niedrig (negativ = unter Plan = günstig) |
| Abw Kosten % | Abw Kosten / Plan Kosten | % | niedrig |
| Ist Stunden / Plan Stunden | geleistete bzw. geplante produktive Stunden | h | – |
| Kosten je Stunde | Ist Kosten / Ist Stunden | €/h | niedrig |
| Produktivitaet | Leistungseinheiten / Ist Stunden (z. B. gereinigte Fahrzeuge, Objekte, Einsatzstunden) | LE/h | hoch |
| Qualitätsquote (im Modell noch `m_QQ`) | bestandene / durchgeführte Qualitätsprüfungen | % | hoch (Ziel ≥ 90 %) |
| Krankenquote | Krankheitstage / Sollarbeitstage | % | niedrig (Schwelle 8 %) |
| Ueberstundenquote | Überstunden / Ist Stunden | % | niedrig |
| Ist Kosten VJ | Ist Kosten der gleichen Periode im Vorjahr | € | – |
| Abw VJ % | (Ist Kosten − Ist Kosten VJ) / Ist Kosten VJ | % | niedrig |
| Kosten YTD | kumulierte Ist Kosten seit Jahresbeginn | € | – |
| Massnahmen offen | Anzahl Maßnahmen mit Status ≠ abgeschlossen | Anzahl | – |
| Einsparung Ist | realisierte Einsparung p. a. aus Maßnahmen | € | hoch |
| Einsparung Zielerreichung | Einsparung Ist / Einsparung Plan | % | ≥ 100 % |
| KPI Status Text | Ampel: „kritisch“ (Kosten > 5 % über Plan **und** Qualität < 90 %), „beobachten“ (eins davon oder Krankenquote > 8 %), „Maßnahme verzögert“, sonst „im Plan“ | Text | „im Plan“ |

## Fachliche Hinweise für die Interpretation

- **Winterdienst** ist saisonal: hohe Stunden und Kosten Dezember–Februar, nahezu null Mai–September.
  Vergleiche beim Winterdienst immer mit dem Vorjahresmonat, nicht mit dem Vormonat.
- **Krankenquote** ist in Januar/Februar regelmäßig höher (Erkältungssaison).
- Steigende Krankenquote führt typischerweise zu mehr **Überstunden** (Vertretung) und mit etwas Verzögerung
  zu sinkender **Qualität** – das ist eine fachliche Hypothese, kein Beweis.
- Quoten (Qualität, Krankheit, Überstunden) werden in **Prozentpunkten** verglichen.
- In den Excel-/CSV-Exporten stehen Quoten und Abweichungen als **Prozentzahl** (9,52 = 9,52 %), `Fortschritt` als Anteil (0,6 = 60 %).
- Maßnahmenstatus: offen → in Umsetzung → abgeschlossen; „verzögert“, wenn der Zieltermin überschritten ist.
