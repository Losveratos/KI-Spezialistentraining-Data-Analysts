# M2-09 · Maßnahmentracking: Statuskommentar und Maßnahmenwirkung

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | M365 Copilot Chat oder Notebook mit zwei Dateien; Analyst* oder Copilot in Excel für die Wirkungsrechnung | Ü2.7 (Teil 2) | 15 min |

\* Analyst: vorinstallierter Agent in Microsoft 365 Copilot Chat (Microsoft-365-Copilot-Lizenz), rechnet mit Python.
Ohne Analyst: normaler Copilot Chat mit angehängten Dateien, Zahlen anschließend in Excel nachrechnen.

## Wofür
Das Maßnahmentracking beantwortet zwei Fragen: **Wo stehen die Maßnahmen?** (Status, Termine, Einsparung)
und **Wirken sie?** (Zeigen die Kennzahlen eine Veränderung nach Abschluss?). Die zweite Frage ist die
wertvollere – und die, bei der Copilot am leichtesten zu viel behauptet. Eine Wirkung gilt erst als gestützt,
wenn der Vorher/Nachher-Unterschied bestehen bleibt, nachdem Saison (Vorjahresvergleich) und allgemeine
Entwicklung (Vergleichsgruppe) herausgerechnet sind.

## Vorbereitung
- Konsistenzcheck (M2-08) erledigt; Verstöße und Rückfragen liegen vor.
- Dateien: `Massnahmen.csv` **und** `KPI_Monat_Region_Leistungsart.csv` anhängen.
- Maßnahme für die Wirkungsanalyse wählen (Übung: **M-004** „Tourenoptimierung Fahrzeugreinigung Süd“).
- Optional **K04**, **K05**.

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot (Enterprise Data Protection).
> Keine Namen von Verantwortlichen – nur Rollen.

## Prompt
```text
Du bist Controller*in und schreibst den Statuskommentar für das Maßnahmentracking im Monatsbericht.

Kontext:
- Datei 1: Maßnahmenliste [EINFÜGEN: Massnahmen.csv]. Einsparungen in EUR pro Jahr. Stichtag 31.10.2026.
- Datei 2: Monatswerte je Region und Leistungsart [EINFÜGEN: KPI_Monat_Region_Leistungsart.csv],
  Jan 2025 – Okt 2026. Einheit der Prozentspalten: [EINFÜGEN: „Prozentwert, 7,12 = 7,12 %“ (Übungsexporte) oder „Anteil, 0,0712 = 7,12 %“ (eigene DAX-Abfrage)].
- Ergebnis des Konsistenzchecks: [EINFÜGEN: Verstöße aus M2-08, z. B. M-007, M-012, M-019]
- Halte dich an K04 (Kommentar-Leitfaden), sofern angehängt.

Aufgabe A – Status:
1. Zähle Maßnahmen je Status, Summe Einsparung_Plan und Einsparung_Ist, Zielerreichung (Ist/Plan).
2. Nenne verzögerte und überfällige Maßnahmen mit Region, Leistungsart und Zieltermin.

Aufgabe B – Wirkung der Maßnahme [EINFÜGEN: z. B. M-004]:
1. Lies aus Datei 1 Region, Leistungsart und Abschlussdatum (kein eigenes Feld: bei Status „abgeschlossen“ den
   Zieltermin nehmen, Spalte Kommentar beachten).
2. Vergleiche in Datei 2 für diese Region und Leistungsart die Mittelwerte von Produktivitaet, Ist_Stunden,
   Leistungseinheiten und Ist_Kosten: 4 Monate vor Abschluss vs. alle Monate nach Abschluss bis Okt 2026.
3. Kontrolle Saison: dieselben Kalendermonate im Vorjahr (2025) vergleichen.
4. Kontrolle Vergleichsgruppe: dieselbe Leistungsart in allen anderen Regionen, gleiche Zeiträume.
5. Wirkung = Veränderung in der Maßnahmen-Region minus Veränderung in der Vergleichsgruppe
   (Differenz der Differenzen). Rechne sie für Produktivitaet und Ist_Stunden in % und für Ist_Kosten in €
   pro Monat und hochgerechnet pro Jahr.
6. Vergleiche die hochgerechnete Kostenwirkung mit Einsparung_Plan und Einsparung_Ist der Maßnahme.

Regeln:
- Rechne tatsächlich (Analysewerkzeug), zeig die Rechenschritte. Keine geschätzten Zahlen.
- Wirkung nur „belegt“ nennen, wenn der Vorher/Nachher-Unterschied nach Abzug von Vorjahreseffekt (Saison) und
  Vergleichsgruppe deutlich bestehen bleibt; sonst „Hinweis auf Wirkung“ oder „keine Wirkung erkennbar“.
- Maßnahmen mit Konsistenzverstößen nicht als Erfolg zählen, sondern mit Datenvorbehalt nennen.
- Positive Entwicklungen genauso nüchtern formulieren wie negative.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
1. Tabelle Status (Status | Anzahl | Einsparung_Plan | Einsparung_Ist).
2. Tabelle Wirkung (Kennzahl | vorher | nachher | Δ Maßnahme | Δ Vorjahr gleiche Monate | Δ Vergleichsgruppe | Wirkung).
3. Statuskommentar, max. 90 Wörter: Kernaussage mit Zahl → Wirkung der Maßnahme mit Beleg →
   Verzögerungen/Widersprüche mit Rückfrage an Rolle → Handlungsbedarf.
```

## Nachschärfen

Wenn Copilot die Wirkung nur als Vorher/Nachher rechnet:
```text
Vorher/Nachher allein reicht nicht – Saison und allgemeine Entwicklung können den Effekt erklären. Ergänze
die Vergleichsgruppe (dieselbe Leistungsart in den anderen Regionen) und rechne die Differenz der Differenzen.
```

Wenn die Kostenwirkung nicht zur geplanten Einsparung passt:
```text
Die hochgerechnete Kostenwirkung ist [EINFÜGEN: Wert], Einsparung_Ist laut Liste [EINFÜGEN: Wert].
Nenne drei mögliche Gründe für die Differenz (z. B. Zeitraum, Tarifsteigerung, Hochrechnungsbasis) und
formuliere eine Rückfrage an die verantwortliche Rolle.
```

Wenn Sie die Wirkung als Grafik für den Bericht brauchen:
```text
Erstelle ein Liniendiagramm Produktivitaet Jan 2025 – Okt 2026 für [EINFÜGEN: Region/Leistungsart] und
den Durchschnitt der Vergleichsgruppe, mit senkrechter Linie beim Abschlussdatum der Maßnahme.
Titel als Botschaft mit Zahl.
```

## Ergebnis prüfen
- [ ] **M-004**: Produktivität Süd/Fahrzeugreinigung ab Mai 2026 rund **+8 %**, Ist_Stunden rund **−7 %** bei
      etwa gleichen Leistungseinheiten (Übungsdaten). Vergleichsgruppe ohne vergleichbaren Sprung.
- [ ] Vorjahresvergleich zeigt keinen saisonalen Mai-Effekt in derselben Größe.
- [ ] Hochrechnung pro Jahr nachvollziehbar (Monatswirkung × 12) und gegen Einsparung_Ist/Plan gestellt.
- [ ] **M-007, M-012, M-019** erscheinen mit Datenvorbehalt, nicht als Erfolg bzw. als „im Plan“.
- [ ] Statuskommentar enthält keine Personennamen und keine Ursache, die nicht in Liste oder Daten steht.

## Stolperfallen
- **Wirkung ohne Vergleichsgruppe** ist eine Behauptung. Gerade bei Reinigung schwanken Stunden saisonal.
- **Kosten steigen trotz Einsparung.** Plankosten wachsen mit Tarif (+3 % p. a.). Eine Einsparung zeigt sich
  daher eher in der Abweichung zum Plan oder in Stunden/Produktivität als im absoluten Kostenbetrag.
- **Zielerreichung über 100 % durch Datenfehler.** M-019 treibt „Einsparung Zielerreichung“ nach oben. Vor dem
  Kommentar mit und ohne M-019 rechnen.
- **Kurzer Nachher-Zeitraum.** Sechs Monate nach Abschluss sind ein Hinweis, kein Dauerbeleg – das gehört in den Kommentar.
