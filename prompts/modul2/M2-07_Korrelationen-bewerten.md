# M2-07 · Korrelationen bewerten: Kausalität, Drittvariable, Wirkungskette

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | M365 Copilot Chat (gleicher Chat wie M2-06 oder neuer Chat mit Ergebnistabelle) | Ü2.6 | 20 min |

## Wofür
Eine Korrelation ist ein Kandidat, keine Erklärung. Bevor ein Zusammenhang in einen Kommentar darf,
muss er fünf Fragen bestehen. Copilot hilft, Gegenargumente systematisch zu sammeln – er ist hier
**Advocatus Diaboli**, nicht Bestätiger.

## Das Bewertungsraster (fünf Fragen)

| Frage | Prüfung | Typischer Befund |
|---|---|---|
| 1. Ist er **stabil**? | Pearson vs. Spearman, mit/ohne Ausreißer, je Region | Kommafehler erzeugt Scheinzusammenhang |
| 2. Ist er **groß genug für n**? | n ≈ 22 je Region → erst ab \|r\| ≈ 0,42 belastbar; wenige Extremmonate prüfen | 4 auffällige Monate tragen die ganze Korrelation |
| 3. Gibt es eine **Drittvariable**? | Saison, Trend, Regionsgröße, Leistungsmix | Winterdienst-Kosten ↔ Krankenquote: beide winterhoch |
| 4. Stimmt die **zeitliche Reihenfolge**? | Lag-Analyse: Ursache muss vor oder gleichzeitig mit Wirkung auftreten | Qualität fällt 1 Monat nach Krankenstand |
| 5. Gibt es einen **fachlichen Mechanismus**? | Plausible Kette, die der Fachbereich bestätigen kann | Krankheit → Überstunden/Einspringer → Qualität ↓, Kosten ↑ |

Erst wenn 1–5 tragen, darf der Kommentar „passt zu“ sagen. „Verursacht“ braucht zusätzlich einen
fachlichen Beleg (z. B. Rückmeldung der Teamleitung, Einsatzpläne) – den liefert keine Korrelation.

## Vorbereitung
- Ergebnistabelle aus M2-06 (Paar, Region, Lag, r, ρ, n, p) kopieren oder im selben Chat weiterarbeiten.
- Optional die Datei `KPI_Monat_Region_Leistungsart.csv` erneut anhängen, damit Copilot nachrechnen kann.

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot (Enterprise Data Protection).
> Keine personenbezogenen Daten.

## Prompt
```text
Du bist Statistiker*in mit Erfahrung im Produktionscontrolling und prüfst Korrelationen kritisch,
bevor sie in einen Managementkommentar gehen. Deine Rolle: Gegenargumente finden, nicht bestätigen.

Kontext:
- Monatsdaten je Region, Jan 2025 – Okt 2026, also n ≈ 22 je Region (bei Lag 1: 21).
- Bekannte Datenfehler: [EINFÜGEN: Funde aus M2-03]
- Bekannte Saison: Winterdienst hat Stunden/Kosten fast nur Dez–Feb; Krankenquoten sind in Jan/Feb
  in allen Regionen höher.
- Ergebnisse der Korrelationsanalyse: [EINFÜGEN: Tabelle aus M2-06 oder Verweis auf Ergebnis oben]

Aufgabe: Bewerte jede der folgenden Korrelationen mit dem Raster unten.
[EINFÜGEN: z. B.
 a) Winterdienst_Ist_Kosten ↔ Krankenquote (gepoolt)
 b) Krankenquote (Monat t) → Qualitaetsquote (Monat t+1), Region Ost
 c) Ueberstundenquote ↔ Abw_Kosten_Prozent, Region Ost
 d) Kosten_je_Stunde ↔ Abw_Kosten_Prozent, Region Südwest]

Raster je Korrelation:
1. Stabilität: Pearson vs. Spearman, mit und ohne Ausreißer/Datenfehler.
2. Stichprobe: n, p-Wert, Anzahl der Monate, die den Zusammenhang tragen (Einfluss einzelner Punkte).
3. Drittvariablen: Nenne mindestens zwei mögliche (Saison, Trend, Leistungsmix, Regionsgröße, Datenfehler)
   und schlage je einen Test vor (z. B. saisonbereinigt, ohne Wintermonate, je Region, partielle Korrelation).
   Führe die Tests aus, wenn du rechnen kannst.
4. Zeitliche Reihenfolge: Was zeigt die Lag-Analyse?
5. Mechanismus: Welche fachliche Kette wäre plausibel, und welche Information aus dem Fachbereich
   würde sie bestätigen oder widerlegen?

Regeln:
- Trenne strikt: Befund aus den Daten / Vermutung / offene Frage.
- Kein Urteil „kausal“. Höchste Stufe: „belastbarer Hinweis auf eine Wirkungskette – fachlich zu bestätigen“.
- Rechne Tests tatsächlich, wenn ein Analysewerkzeug verfügbar ist; sonst schreib, dass du nicht gerechnet hast.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
Je Korrelation eine Tabelle mit den Zeilen 1–5 (Spalten: Prüfung | Ergebnis | Bewertung grün/gelb/rot)
und einem Urteil in einem Satz:
„Scheinkorrelation“ | „nicht belastbar“ | „Hinweis, fachlich zu prüfen“ | „belastbarer Hinweis auf Wirkungskette“.
Am Ende: Welche Korrelation darf in welcher Formulierung in den Kommentar? (je ein Satzvorschlag)
```

## Nachschärfen

Wenn Copilot eine Korrelation vorschnell als Ursache verkauft:
```text
Formuliere die Aussage zu [EINFÜGEN: Paar] so um, dass sie nur beschreibt, was die Daten zeigen.
Nenne danach die zwei wichtigsten alternativen Erklärungen und was man prüfen müsste, um sie auszuschließen.
```

Wenn die Saisonbereinigung fehlt (Scheinkorrelation):
```text
Rechne die Korrelation Winterdienst_Ist_Kosten ↔ Krankenquote als partielle Korrelation unter Kontrolle einer
Variablen „Wintermonat“ (1 für Dez–Feb, sonst 0) und zusätzlich mit Abweichungen vom Mittel desselben
Kalendermonats. Erklär das Ergebnis in zwei Sätzen für Nicht-Statistiker.
```

Wenn die Wirkungskette in Ost geprüft werden soll:
```text
Zeig für Region Ost Jun–Okt 2026 Krankenquote, Ueberstundenquote, Qualitaetsquote und Abw_Kosten_Prozent
nebeneinander. Rechne die Lag-1-Korrelation Krankenquote → Qualitaetsquote einmal mit allen Monaten und einmal
ohne Jul–Okt 2026. Was sagt der Unterschied über die Belastbarkeit?
```

Wenn Sie eine Gegenprüfung im neuen Chat wollen:
```text
Hier ist eine Bewertung von Korrelationen aus einem anderen Chat: [EINFÜGEN: Ergebnis]. Prüfe sie kritisch:
Wo wird Korrelation als Ursache dargestellt, wo fehlt eine Drittvariable, wo ist n zu klein? Nur Mängel auflisten.
```

## Ergebnis prüfen
- [ ] **Winterdienst ↔ Krankenquote** ist als **Scheinkorrelation** (gemeinsame Ursache Saison) eingestuft;
      saisonbereinigt bleibt wenig übrig.
- [ ] **Krankenquote → Qualitätsquote in Ost** ist als **Hinweis auf eine Wirkungskette** eingestuft, mit dem
      Vorbehalt: getragen von wenigen Monaten (Jul–Okt 2026), fachlich zu bestätigen.
- [ ] **Südwest** (Kosten je Stunde ↔ Abweichung): als Datenfehler-Artefakt erkannt, nicht als Zusammenhang.
- [ ] Kein Satzvorschlag enthält „verursacht“, „führt zu“, „wegen“ ohne fachlichen Beleg.
- [ ] Gerechnete Tests sind mit Code oder Rechenweg belegt; nicht gerechnete als solche markiert.

## Stolperfallen
- **Hohe Korrelation ≠ belastbar.** Bei Monatsreihen erzeugen Saison und Trend leicht |r| > 0,7, ohne dass ein
  Zusammenhang besteht. Immer saisonbereinigt oder gegen Vorjahresmonat prüfen.
- **„Signifikant“ wird überinterpretiert.** Ein p-Wert sagt nichts über die Ursache und bei vielen Tests wenig
  über Zufall. Wiederholung in mehreren Regionen ist das stärkere Argument.
- **Copilot bestätigt gern.** Wer fragt „Ist das ein Zusammenhang?“, bekommt meist „Ja“. Fragen Sie nach
  Gegenargumenten oder lassen Sie im neuen Chat prüfen.
- **Wirkungskette rückwärts.** Sinkende Qualität könnte auch Nacharbeit und damit Überstunden auslösen.
  Die Lag-Richtung hilft, die Richtung zu prüfen – beweisen kann sie sie nicht.
