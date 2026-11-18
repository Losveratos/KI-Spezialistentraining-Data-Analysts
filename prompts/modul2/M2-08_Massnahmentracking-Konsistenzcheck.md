# M2-08 · Maßnahmentracking: Konsistenzcheck

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | M365 Copilot Chat mit Dateianhang oder Copilot in Excel | Ü2.7 (Teil 1) | 10 min |

## Wofür
Maßnahmenlisten werden von vielen gepflegt und widersprechen sich schnell: „abgeschlossen“ mit 60 %
Fortschritt, Zieltermin überschritten, aber „in Umsetzung“, Einsparung doppelt so hoch wie geplant.
Wer darauf einen Statuskommentar baut, berichtet Widersprüche weiter. Copilot prüft die Liste gegen
**explizite Regeln** – die Regeln geben Sie vor, nicht Copilot.

## Vorbereitung
- `Massnahmen.csv` anhängen oder Export der Tabelle von der Berichtsseite **Maßnahmentracking**.
- Stichtag festlegen: Ende Berichtsmonat = **31.10.2026**.
- Optional **K05** (Glossar: Status-Werte, Einheiten – Einsparungen in EUR pro Jahr).

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot (Enterprise Data Protection).
> Maßnahmenlisten enthalten in der Praxis oft Namen von Verantwortlichen – vor dem Hochladen durch Rollen
> ersetzen oder die Spalte entfernen. Im Training enthält `Verantwortlich` nur Rollen.

## Prompt
```text
Du bist Controller*in und prüfst die Maßnahmenliste vor dem Monatsbericht auf Widersprüche.

Kontext:
- Datei: [EINFÜGEN: Massnahmen.csv] mit MassnahmeID, Titel, Region, Leistungsart, Verantwortlich (Rolle),
  Start, Zieltermin, Status (offen | in Umsetzung | verzögert | abgeschlossen), Fortschritt (0–1),
  Einsparung_Plan und Einsparung_Ist (EUR pro Jahr), Kommentar.
- Stichtag: 31.10.2026.

Aufgabe: Prüfe jede Maßnahme gegen diese Regeln und liste alle Verstöße:
R1  Status „abgeschlossen“, aber Fortschritt < 1.
R2  Fortschritt = 1, aber Status nicht „abgeschlossen“.
R3  Zieltermin vor dem Stichtag, Status weder „abgeschlossen“ noch „verzögert“ (überfällig, falsch gemeldet).
R4  Status „verzögert“ ohne Kommentar.
R5  Einsparung_Ist > 2 × Einsparung_Plan (unplausibel hoch – Einheit, Erfassung oder Planwert prüfen).
R6  Einsparung_Ist > 0 bei Status „offen“.
R7  Start nach Zieltermin oder Start nach Stichtag mit Status ungleich „offen“.
R8  Pflichtfelder leer (Status, Zieltermin, Einsparung_Plan).
[EINFÜGEN: weitere Regeln Ihres Bereichs]

Regeln für dich:
- Prüfe nur die genannten Regeln. Wenn dir weitere Auffälligkeiten begegnen, liste sie getrennt als „Hinweis“.
- Rechne mit dem Analysewerkzeug, wenn verfügbar. Datumsangaben im Format [EINFÜGEN: z. B. TT.MM.JJJJ] lesen.
- Bewerte nicht, wer schuld ist. Formuliere Rückfragen neutral an die verantwortliche Rolle.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
1. Tabelle „MassnahmeID | Titel | Regel | Feldwerte | Rückfrage an (Rolle)“ – eine Zeile je Verstoß.
2. Zusammenfassung: Anzahl Maßnahmen, Anzahl mit Verstoß, Verstöße je Regel.
3. Je Verstoß ein Satz als Rückfrage, z. B. „M-0xx: Status abgeschlossen bei Fortschritt 60 % – bitte Status
   oder Fortschritt korrigieren.“
```

## Nachschärfen

Wenn Copilot Verstöße „repariert“ statt meldet:
```text
Ändere keine Werte. Ich brauche nur die Liste der Verstöße mit den Originalwerten.
```

Wenn Sie die Auswirkung auf die Berichtskennzahlen sehen wollen:
```text
Berechne „Massnahmen offen“ (Status ungleich abgeschlossen) und „Einsparung Zielerreichung“
(Summe Einsparung_Ist / Summe Einsparung_Plan) einmal wie geliefert und einmal unter der Annahme, dass die
Verstöße aus R1, R3 und R5 korrigiert werden (R1 → Status in Umsetzung; R3 → Status verzögert; R5 → aus der
Summe herausnehmen). Zeig beide Werte nebeneinander.
```

Wenn Sie die Prüfung dauerhaft im Bericht haben wollen:
```text
Schreib ein DAX-Measure „Massnahmen Widersprueche“ für die Tabelle Massnahmen, das die Anzahl der Maßnahmen
mit Verstoß gegen R1, R3 oder R5 zählt. Stichtag als Variable. Nutze nur die Spalten aus der Tabelle oben.
```

## Ergebnis prüfen
- [ ] **M-007**: Status abgeschlossen, Fortschritt 0,6 → R1 gefunden.
- [ ] **M-012**: Zieltermin 30.06.2026, Status in Umsetzung → R3 gefunden.
- [ ] **M-019**: Einsparung_Ist > 2 × Einsparung_Plan → R5 gefunden.
- [ ] Keine erfundenen Verstöße: zwei weitere gemeldete Zeilen in der CSV nachsehen.
- [ ] Datumsvergleich korrekt (Copilot liest 06/07 gern amerikanisch – Stichprobe prüfen).

## Stolperfallen
- **Der Monats-Slicer filtert die Maßnahmen nicht.** Im Modell gibt es keine Beziehung Massnahmen → Kalender.
  „Massnahmen offen“ zeigt immer den aktuellen Gesamtstand, egal welcher Monat gewählt ist. Für Stichtags-
  aussagen Status-Historie oder Datumslogik nötig.
- **Einsparung p. a. vs. Monatskosten.** Einsparungen sind Jahreswerte, Kosten im Bericht Monatswerte.
  Vor jedem Vergleich auf dieselbe Periode umrechnen.
- **Regeln verstecken sich im Prompt.** Wer Copilot „Finde Widersprüche“ ohne Regeln fragt, bekommt jedes
  Mal eine andere Liste. Explizite Regeln machen die Prüfung wiederholbar – im Notebook ablegen.
