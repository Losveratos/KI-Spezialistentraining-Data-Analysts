# M2-06 · Korrelationen zwischen Kennzahlen finden (Matrix und Zeitversatz)

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | Copilot in Excel mit Python*, Analyst* oder M365 Copilot Chat mit Datei | Ü2.5 | 20 min |

\* **Copilot in Excel mit Python** – über „Mit Copilot bearbeiten“ (Edit with Copilot, bis Anfang 2026 „Agent Mode“;
Python dort seit August 2026) schreibt Python-Code in die Arbeitsmappe und führt ihn aus; die Ergebnisse sind
nachrechenbar. Voraussetzung: Microsoft-365-Copilot-Lizenz und Python in Excel im Mandanten freigegeben; die Datei
sollte in OneDrive/SharePoint liegen. **Analyst** (Agent in Copilot Chat) rechnet ebenfalls mit Python und zeigt die Schritte. Steht beides nicht
zur Verfügung: Variante C unten (Chat liefert die Rechenvorschrift, Excel rechnet mit `KORREL`).

## Wofür
Welche Kennzahlen bewegen sich gemeinsam – gleichzeitig oder mit Zeitversatz? Eine Korrelationsmatrix
liefert Kandidaten für Wirkungsketten. Sie liefert **keine** Ursachen; die Bewertung folgt in **M2-07**.
Wichtig: Copilot darf Korrelationen nicht „schätzen“. Er muss sie rechnen, sonst sind die Zahlen wertlos.

## Statistik in fünf Sätzen
- **Pearson r** misst den linearen Zusammenhang (−1 bis +1). Ein einzelner Ausreißer kann r stark verzerren.
- **Spearman ρ** rechnet mit Rängen, ist robuster gegen Ausreißer und erfasst auch nicht lineare, aber monotone
  Verläufe. Weichen Pearson und Spearman stark voneinander ab, steckt oft ein Ausreißer dahinter.
- **Stichprobengröße:** Je Region gibt es 22 Monatswerte. Bei n = 22 ist erst ab etwa |r| ≥ 0,42 ein Zusammenhang
  statistisch von null unterscheidbar (5 %-Niveau, zweiseitig). Monatsreihen mit Trend oder Saison sind nicht
  unabhängig – dort liegt die Schwelle faktisch höher. Wenige extreme Monate können eine hohe Korrelation allein
  erzeugen. „Signifikant“ heißt nur: kaum durch Zufall erklärbar – nicht stark, nicht ursächlich.
- **Zeitversatz (Lag):** Lag 1 heißt: Wert A im Monat t gegen Wert B im Monat t+1. Ist |r| bei Lag 1 deutlich
  größer als bei Lag 0, ist das ein Hinweis (kein Beweis), dass B zeitlich auf A folgt. Jeder Lag kostet einen
  Datenpunkt (Lag 1: n = 21, Schwelle ≈ 0,43).
- **Gepoolt vs. je Region:** Alle Regionen zusammen (154 Zeilen) erhöhen n, mischen aber Niveauunterschiede
  zwischen Regionen hinein. Immer auch je Region rechnen.

## Vorbereitung
- `DBS_KPI_Export.xlsx` (Blätter `KPI_Monat_Region` und `KPI_Monat_Region_Leistungsart`) in OneDrive öffnen
  bzw. in Copilot Chat anhängen.
- Datenfehler aus M2-03 bereithalten: Kommafehler Südwest/Sep 2026, Dublette Nord/Mai 2026.

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot (Enterprise Data Protection).
> Keine personenbezogenen Daten. Dateien mit echten Daten nur aus freigegebenen Speicherorten verwenden.

## Prompt (Variante A/B: Excel mit Python oder Analyst)
```text
Du bist Data Analyst*in im Produktionscontrolling und arbeitest mit Python (pandas, scipy).

Kontext: Die Arbeitsmappe [EINFÜGEN: Dateiname] enthält die Blätter KPI_Monat_Region (Monat × Region) und
KPI_Monat_Region_Leistungsart (zusätzlich je Leistungsart), Jan 2025 – Okt 2026. Einheit der Prozentspalten: [EINFÜGEN: „Prozentwert, 7,12 = 7,12 %“ (Übungsexporte) oder „Anteil, 0,0712 = 7,12 %“ (eigene DAX-Abfrage)].
Bekannte Datenfehler: [EINFÜGEN: Funde aus M2-03].

Aufgabe:
1. Baue eine Analysetabelle mit einer Zeile je Monat × Region aus dem Blatt KPI_Monat_Region mit den Spalten
   Abw_Kosten_Prozent, Kosten_je_Stunde (Ist_Kosten / Ist_Stunden), Produktivitaet, Qualitaetsquote,
   Krankenquote und Ueberstundenquote. Ergänze Winterdienst_Ist_Kosten: Ist_Kosten der Leistungsart
   Winterdienst aus dem zweiten Blatt, verknüpft über Monat und Region.
2. Rechne zwei Korrelationsmatrizen (Pearson und Spearman) über alle Zeilen gepoolt und gib n an.
3. Rechne dieselben Matrizen je Region (n = 22) und liste je Region die drei stärksten Paare (|r| ≥ 0,5).
4. Zeitversatz: Rechne für die Paare Krankenquote → Qualitaetsquote, Ueberstundenquote → Qualitaetsquote und
   Krankenquote → Abw_Kosten_Prozent die Korrelation bei Lag 0, 1 und 2 Monaten, je Region
   (Lag k: erste Kennzahl im Monat t, zweite im Monat t+k; Verschiebung innerhalb der Region).
5. Wiederhole Schritt 2 einmal ohne die bekannten Datenfehler und zeig, welche Korrelationen sich um mehr als
   0,2 ändern.

Regeln:
- Rechne tatsächlich (Code ausführen), schätze nichts. Zeig den Code.
- Gib bei jeder Korrelation n und den p-Wert an und kennzeichne |r| < 0,42 bei n ≈ 22 als „nicht belastbar“.
- Interpretiere noch keine Ursachen. Nur: Paar, Richtung, Stärke, Lag, Robustheit (Pearson vs. Spearman).
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
A) Heatmap der gepoolten Spearman-Matrix (deutsche Beschriftung).
B) Tabelle „Region | Paar | Lag | Pearson r | Spearman ρ | n | p | belastbar ja/nein“, sortiert nach |ρ|.
C) Tabelle „Paar | r mit Datenfehlern | r ohne Datenfehler | Differenz“.
D) Fünf Stichpunkte: auffälligste Zusammenhänge, nur beschreibend.
```

## Prompt (Variante C: nur Copilot Chat, Excel rechnet)
```text
Du bist Excel-Expert*in. Ich habe in Excel (deutsche Version) eine Tabelle mit den Spalten Monat, Region,
Krankenquote, Ueberstundenquote, Qualitaetsquote, Abw_Kosten_Prozent, sortiert nach Region und Monat.
[EINFÜGEN: Kopfzeile und zwei Beispielzeilen]

Aufgabe: Erklär mir Schritt für Schritt, wie ich in Excel für eine Region
1. die Pearson-Korrelation zweier Spalten mit KORREL berechne,
2. die Spearman-Korrelation über RANG.MITTELW-Hilfsspalten und KORREL berechne,
3. eine Lag-1-Korrelation berechne (Bereich der zweiten Kennzahl um eine Zeile versetzt),
4. die Mindestkorrelation für n Werte (5 %, zweiseitig) über T.INV.2S berechne.
Gib die Formeln mit deutschen Funktionsnamen und Semikolon als Trennzeichen an, mit Beispielbezügen.
Rechne selbst keine Ergebnisse aus. Wenn Informationen fehlen, frag nach statt zu raten.
```
Formel für die Schwelle (zur Kontrolle): `=T.INV.2S(0,05;n-2)/WURZEL(T.INV.2S(0,05;n-2)^2+n-2)` → bei n = 22 ≈ 0,42.

## Nachschärfen

Wenn Copilot nur gepoolt rechnet:
```text
Die gepoolte Korrelation mischt Unterschiede zwischen Regionen hinein. Rechne zusätzlich je Region und
zusätzlich mit nach Region zentrierten Werten (Wert minus Regionsmittel). Vergleiche die drei Ergebnisse.
```

Wenn eine sehr hohe Korrelation auffällt (z. B. Winterdienst-Kosten ↔ Krankenquote):
```text
Prüfe den Zusammenhang Winterdienst_Ist_Kosten ↔ Krankenquote auf Saison: Rechne die Korrelation
(a) nur mit den Monaten März–November, (b) mit saisonbereinigten Werten (Abweichung vom Mittel desselben
Kalendermonats über alle Regionen). Was bleibt übrig?
```

Wenn Pearson und Spearman weit auseinanderliegen:
```text
Zeig mir für das Paar [EINFÜGEN: Paar, Region] ein Streudiagramm und die drei Punkte mit dem größten Einfluss
auf Pearson r (r mit und ohne den jeweiligen Punkt).
```

## Ergebnis prüfen
- [ ] Code ist sichtbar und läuft; n stimmt (gepoolt 154, je Region 22, bei Lag 1 je Region 21).
- [ ] Eine Korrelation in Excel nachgerechnet (`KORREL`) – Abweichung höchstens in der dritten Nachkommastelle.
- [ ] **Ost**: Krankenquote → Qualitätsquote ist bei **Lag 1** stärker (negativ) als bei Lag 0 (Übungsdaten).
- [ ] **Winterdienst-Kosten ↔ Krankenquote** ist je Region stark positiv (r ≈ 0,85–0,88, außer Ost). Ohne
      Wintermonate bleibt |r| < 0,3, saisonbereinigt gepoolt ≈ 0 und je Region ohne einheitliches Vorzeichen
      (Scheinkorrelation).
- [ ] **Abw_Kosten_Prozent ↔ Kosten_je_Stunde gepoolt**: Pearson fast 1, Spearman nahe 0 – ein einziger Punkt
      (Südwest, Sep 2026, Kommafehler) erzeugt die „Korrelation“. Ohne ihn bricht Pearson ein.
- [ ] Ohne den Kommafehler werden gepoolt echte Zusammenhänge sichtbar, die er vorher überdeckt hat
      (Abw_Kosten_Prozent ↔ Überstunden- und Krankenquote, getragen von Ost).
- [ ] Copilot hat keine Ursachen formuliert – das kommt erst in M2-07.

## Stolperfallen
- **Geschätzte statt gerechnete Werte.** Ohne Codeausführung erfindet Copilot plausible r-Werte. Fehlt der Code,
  Ergebnis verwerfen.
- **Matrix ohne n und p.** 7 Kennzahlen = 21 Paare, × 7 Regionen = 147 Tests – bei 5 % Irrtum sind im Mittel
  rund 7 „signifikante“ Paare reiner Zufall. Nur Paare mit fachlichem Sinn und Wiederholung über Regionen ernst nehmen.
- **Anteile statt Prozent** (0,07 statt 7) ändern r nicht, solange eine Spalte einheitlich skaliert ist – wohl
  aber jede Interpretation von Steigungen.
- **Lag in die falsche Richtung.** `shift(1)` verschiebt nach unten: Prüfen Sie an zwei Zeilen, ob wirklich
  Krankenquote Juli neben Qualitätsquote August steht.
