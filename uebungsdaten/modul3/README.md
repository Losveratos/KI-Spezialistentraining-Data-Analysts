# Übungsdateien Modul 3 – Copilot und Office

Vier Dateien: drei für die Übungen Ü3.1–Ü3.6 und eine Arbeitsmappe mit acht Excel-Fällen. Alle Daten sind **fiktiv** und passen zum Übungsmodell aus Termin 1
(gleiche Regionen, Leistungsarten, Berichtsmonat Oktober 2026).

| Datei | Wofür | Übung |
|---|---|---|
| `Kennzahlen_Okt-2026.xlsx` | bereinigter Kennzahlenexport – Quelle für Analyse, Prüfung und Präsentation | Ü3.1, Ü3.2, Ü3.3, Ü3.5, Ü3.6 |
| `Leistungsnachweise_Export_Okt-2026.xlsx` | Export mit Belegen, der gegen einen Regelkatalog geprüft wird | Ü3.4 |
| `Monatsbericht_Okt-2026_Entwurf.pptx` | Präsentationsentwurf, der gegen die Kennzahlen geprüft wird | Ü3.5 |
| `Excel-Copilot_Uebungsfaelle.xlsx` | acht Übungsfälle für Copilot in Excel, je Blatt mit Aufgaben, Beispiel-Prompts und Kontrollwerten | [Excel-Fälle](../../uebungen/Modul3_Excel-Faelle.md) |

Für Copilot **in** Excel bzw. PowerPoint legen Sie die Dateien in OneDrive oder SharePoint ab (AutoSpeichern an).
Für den Copilot-Chat können Sie sie anhängen.

## Kennzahlen_Okt-2026.xlsx

| Blatt | Tabelle | Inhalt |
|---|---|---|
| Regionen_Okt | `tblRegionOkt` | je Region: Ist_Kosten, Plan_Kosten, Abw_Kosten, Abw_Prozent, Ist_Kosten_VJ (Oktober 2025), Qualitaetsquote, Krankenquote, Ueberstundenquote |
| Zeitreihe | `tblZeitreihe` | Januar bis Oktober 2026 je Region: Ist_Kosten, Plan_Kosten, Qualitaetsquote, Krankenquote |
| Massnahmen | `tblMassnahmen` | 25 Maßnahmen: MassnahmeID, Titel, Region, Leistungsart, Status, Fortschritt, Zieltermin, Einsparung_Plan, Einsparung_Ist |
| Hinweise | – | Erläuterungen |

Prozentwerte stehen als Zahl: `6,87` bedeutet 6,87 %. `Fortschritt` ist ein Anteil (`0,6` = 60 %).
Kennzahlen-Definitionen: [K05 · Kennzahlen-Glossar](../../prompts/kontext/K05_Kennzahlen-Glossar.md).

## Leistungsnachweise_Export_Okt-2026.xlsx

| Blatt | Tabelle | Inhalt |
|---|---|---|
| Leistungsnachweise | `tblLeistung` | Belege Oktober 2026: BelegNr, Datum, Region, Leistungsart, Objekt, Stunden, Stundensatz, Betrag, Erfasst_von, Status |
| Stammdaten | `tblRegion`, `tblLeistungsart` | gültige Regionen; gültige Leistungsarten mit Stundensatz_min und Stundensatz_max |
| Prüfregeln | `tblRegeln` | Regelkatalog R1–R8 |

Der Regelkatalog:

| Regel | Kurzname | Beschreibung |
|---|---|---|
| R1 | BelegNr ist eindeutig | Jede Belegnummer kommt genau einmal vor. |
| R2 | Datum im Berichtsmonat | Datum liegt zwischen 01.10.2026 und 31.10.2026. |
| R3 | Region gültig | Region steht in `tblRegion`. |
| R4 | Leistungsart gültig | Leistungsart steht in `tblLeistungsart`. |
| R5 | Stunden plausibel | Stunden sind größer als 0 und höchstens 12 je Beleg. |
| R6 | Stundensatz in der Spanne | Stundensatz liegt zwischen Stundensatz_min und Stundensatz_max der Leistungsart. |
| R7 | Betrag rechnerisch richtig | Betrag = Stunden × Stundensatz, Toleranz 0,01 €. |
| R8 | Pflichtfelder und Datentyp | Pflichtfelder sind gefüllt; Datum ist ein Datum, Zahlen sind Zahlen. |

Wie viele Verstöße in der Datei stecken, steht hier absichtlich nicht.

## Monatsbericht_Okt-2026_Entwurf.pptx

Fünf Folien: Titel, Kosten je Region, Qualität und Personal, Maßnahmen, Handlungsbedarf. Der Entwurf stammt von
„einem Kollegen“ und soll vor dem Versand gegen `Kennzahlen_Okt-2026.xlsx` geprüft werden.
