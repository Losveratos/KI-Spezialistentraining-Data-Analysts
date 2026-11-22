# Übungsmodell DBS_Produktionscontrolling

Power-BI-Projekt (PBIP) mit semantischem Modell im TMDL-Format und einem schlichten Bericht mit drei Seiten.
Alle Daten sind **fiktiv** („DBS Training GmbH“) und eignen sich nur für Übungszwecke. Sie enthalten
keine echten Unternehmenszahlen und keine personenbezogenen Daten.

## Öffnen

1. Power BI Desktop (aktuelle Version) starten.
2. Falls Ihre Desktop-Version das noch verlangt: unter *Datei › Optionen und Einstellungen › Optionen ›
   Vorschaufeatures* die Optionen **„Power BI-Projektdateien (.pbip) speichern“** und
   **„TMDL-Ansicht“** aktivieren und Desktop neu starten. In aktuellen Versionen sind beide fest eingebaut (TMDL-Ansicht in
   Desktop seit September 2025, Power BI-Projekte seit September 2026 allgemein verfügbar).
3. `DBS_Produktionscontrolling.pbip` öffnen.
4. Beim ersten Öffnen sind die Tabellen leer. Oben erscheinen zwei gelbe/graue Hinweisleisten: zweimal
   **Jetzt aktualisieren** klicken (erst Beziehungen, dann Daten) – oder **Start › Aktualisieren**. Die Daten
   stecken im Modell selbst (Power Query), es werden keine Dateipfade, Datenbanken oder Gateways benötigt.

**Ablageort mit kurzem Pfad wählen.** Windows erlaubt höchstens 260 Zeichen pro Dateipfad; die Projektdateien
liegen bis zu 110 Zeichen tief im Ordner `modell`. Legen Sie das Trainingsmaterial deshalb an einem kurzen Ort
ab, z. B. `C:\Training\KI-Training\`. Sonst meldet Desktop „The specified path, file name, or both are too long“
(tritt leicht in tief verschachtelten OneDrive- oder Teams-Ordnern auf).

Der Ordner muss vollständig bleiben: `DBS_Produktionscontrolling.pbip`, `DBS_Produktionscontrolling.Report`
und `DBS_Produktionscontrolling.SemanticModel` gehören zusammen.

**Als einzelne Datei weitergeben:** Projekt in Desktop öffnen, aktualisieren und mit *Datei › Speichern unter*
als `.pbix` speichern. Die `.pbix` enthält Modell, Daten und Bericht und öffnet ohne weitere Schritte.

## Inhalt

| Tabelle | Inhalt |
|---|---|
| `Kalender` | Tage 01.01.2025–31.12.2026 mit Jahr, MonatNr, Monat („2026-10“), Monatsname, Quartal |
| `Region` | 7 Regionen: Nord, Ost, Südost, Süd, Südwest, Mitte, West |
| `Leistungsart` | 5 Leistungsarten in den Geschäftsfeldern Reinigung, Sicherheit, Facility |
| `Fakt_Leistung` | Monatswerte je Region und Leistungsart, Januar 2025 bis Oktober 2026: Stunden und Kosten (Ist/Plan), Leistungseinheiten, Qualitätsprüfungen, Krankheits- und Sollarbeitstage, Überstunden |
| `Massnahmen` | ca. 25 Maßnahmen mit Status, Fortschritt, Zieltermin und Einsparung (Plan/Ist) |

Die Measures liegen in der Tabelle `Fakt_Leistung` (u. a. Ist Kosten, Plan Kosten, Abw Kosten %,
Krankenquote, Ueberstundenquote, Produktivitaet, Kosten YTD, Massnahmen offen, KPI Status Text).

Berichtsseiten:

1. **Kennzahlenübersicht**: Karten, Tabelle je Region, Datenschnitt Monat
2. **Detailbericht**: Matrix Region × Monat, Liniendiagramm, Datenschnitte Region und Leistungsart
3. **Maßnahmentracking**: Maßnahmentabelle und zwei Karten

Berichtsmonat ist **Oktober 2026**.

