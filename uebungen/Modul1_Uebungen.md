# Modul 1 · Übungen – Metadatengetriebene BI-Entwicklung mit KI (Schwerpunkt TMDL)

Alle Übungen arbeiten mit dem Übungsmodell `DBS_Produktionscontrolling` (`uebungsdaten/modell/`) und den
Textdateien in `uebungsdaten/modul1/`. Die Prompts stehen in `prompts/modul1/`, die Kontextdateien in
`prompts/kontext/`. Grundregeln zum Prompting: `prompts/00_Prompting-Grundregeln.md`.

Die Lösungen besprechen wir gemeinsam im Training.

## Überblick

| Übung | Block | Thema | Prompt | Zeit |
|---|---|---|---|---|
| Ü1.1 | M1.2 | Modell als Text: Überblick und Schwachstellen aus TMDL | M1-01 | 15 min |
| Ü1.2 | M1.3 | Halluzinationen erzeugen, erkennen, vermeiden | M1-09, M1-02 | 25 min |
| Ü1.3 | M1.4 | DAX formatieren und kommentieren | M1-03 | 12 min |
| Ü1.4 | M1.4 | Power Query (SAP-Export) formatieren, kommentieren, Schwachstellen | M1-04 | 12 min |
| Ü1.5 | M1.4 | SQL-View formatieren, kommentieren, optimieren | M1-05 | 12 min |
| Ü1.6 | M1.5 | Großes Measure analysieren: `KPI Status Text` | M1-06 | 8 min |
| Ü1.7 | M1.5 | Refaktorisieren und alt gegen neu testen | M1-07 | 15 min |
| Ü1.8 | M1.5 | Fehler beheben aus Fehlermeldung | M1-08 | 10 min |
| Ü1.9 | M1.6 | Modell dokumentieren mit INFO.VIEW | M1-10 | 10 min |
| Ü1.10 | M1.6 | Berichtsseite dokumentieren | M1-11 | 10 min |
| Ü1.11 | M1.7 | Beschreibungen als TMDL zurückschreiben, `m_QQ` umbenennen | M1-12 | 10 min |
| Ü1.12 | M1.7 | Modell KI-fähig machen, AI-Instructions entwerfen | M1-13 | 10 min |
| Ü1.13 | M1.4 oder Zusatz | Excel-Chaos zu Power Query: aus unsauberen Dateien eine robuste Abfrage | M1-14 | 20 min |
| Z1.1 | Zusatz | Modellhygiene per TMDL umsetzen (Zeitintelligenz, ID-Spalten, Sortierung, Datumstabelle) | M1-13 | 15 min |

In Block M1.4 bearbeiten Sie **zwei der drei** Übungen Ü1.3–Ü1.5 – die, die Ihrem Arbeitsalltag am nächsten sind.

## Vor dem Start

- **Copilot-Varianten.** Alle Übungen funktionieren mit **Microsoft 365 Copilot Chat** oder einem **Copilot Notebook**.
  Copilot in Power BI (DAX-Abfrageansicht, Modellansicht, Prep data for AI) setzt einen Arbeitsbereich auf bezahlter Fabric-Kapazität
  (F2 oder höher) bzw. Premium-Kapazität (P1 oder höher) oder eine Fabric Copilot capacity und die Freigabe durch den
  Admin voraus; Testkapazitäten (Trial) reichen nicht. Wo das bei Ihnen freigeschaltet ist, ist es als Variante angegeben.
- **Notebook empfohlen.** Legen Sie ein Copilot Notebook „Modul 1“ an und hinterlegen Sie als Referenzen
  K01 (Arbeitsregeln), K02 (DAX-Styleguide), K03 (TMDL-Kurzreferenz), K05 (Kennzahlen-Glossar). Ausnahme: Ü1.2 Schritt 1
  und die Gegenprüfung laufen bewusst in einem **neuen Einzelchat ohne Referenzen**.
- **Datenschutz.** Nur im unternehmensfreigegebenen Microsoft 365 Copilot arbeiten (Firmenkonto, Hinweis auf
  Enterprise Data Protection sichtbar). Das Übungsmodell ist fiktiv. Bei eigenen Modellen keine personenbezogenen Daten,
  keine Verbindungszeichenfolgen, Server- oder Benutzernamen einfügen.
- **Sichern.** Vor Ü1.7, Ü1.11 und Z1.1 eine Kopie des PBIP-Ordners anlegen.
- **TMDL kopieren.** TMDL-Ansicht › Objekte aus dem Datenbereich in den Editor ziehen (Mehrfachauswahl mit Strg).
  Die Daten des Übungsmodells stecken in den Ausdrücken `Daten_Fakt_Leistung` und `Daten_Massnahmen` – diese nie an
  Copilot geben. `partition`-Blöcke für Copilot weglassen, eine Tabelle in der TMDL-Ansicht aber nie ohne ihre Partition
  **anwenden**.


---

# Aufgaben

## Ü1.1 · Modell als Text: Überblick und Schwachstellen (15 min)

**Ziel:** Sie erleben TMDL als vollständige, KI-lesbare Beschreibung des Modells und lassen Copilot daraus
Überblick und Schwachstellen ableiten – mit Beleg.

**Schritte**
1. Übungsmodell öffnen, TMDL-Ansicht wählen. Alle fünf Tabellen und die Beziehungen in einen Editor-Tab ziehen.
2. Im Editor die `partition`-Blöcke löschen (Tab **nicht** anwenden). Ausdrücke `Daten_…` gehören nicht dazu.
   Text kopieren, als `Modell.txt` speichern.
3. Prompt **M1-01** in Copilot einfügen, `Modell.txt` anhängen bzw. einfügen.
4. Ergebnis prüfen: Stimmen Zahl der Measures und Beziehungen? Hat jede Schwachstelle einen Beleg?
5. Notieren Sie Copilots Schwachstellenliste – wir gleichen sie im Plenum mit den eingebauten Schwächen ab: Was hat Copilot gefunden, was nicht, was zusätzlich?

**Erwartetes Ergebnis:** Markdown-Überblick mit 5 Tabellen, 5 Beziehungen, 18 Measures und einer belegten
Schwachstellenliste mit Beleg je Punkt.

## Ü1.2 · Halluzinationen erzeugen, erkennen, vermeiden (25 min)

**Ziel:** Sie sehen, wie Copilot ohne Modellkontext plausible, aber falsche Namen erfindet, und wie TMDL-Kontext
und eine Gegenprüfung das verhindern.

**Schritte**
1. **Ohne Kontext** (neuer Einzelchat, keine Anhänge, kein Notebook):
   ```text
   Schreib mir zwei DAX-Measures für unser Power-BI-Modell im Produktionscontrolling:
   1. Kosten je Leistungseinheit
   2. Qualitätsquote im Vorjahr
   ```
2. Notieren Sie alle Tabellen-, Spalten- und Measurenamen aus Copilots Antwort. Prüfen Sie sie mit Strg+F im TMDL.
3. Führen Sie Copilots Code in der DAX-Abfrageansicht aus (als `DEFINE MEASURE Fakt_Leistung[Test1] = … EVALUATE
   SUMMARIZECOLUMNS ( Kalender[Monat], "Test", [Test1] )`). Notieren Sie die Fehlermeldung.
4. **Mit Kontext:** Prompt **M1-09** mit dem TMDL aus Ü1.1. Definition: (1) Ist-Kosten je Leistungseinheit, leer ohne
   Leistungseinheiten; (2) Qualitätsquote der gleichen Periode im Vorjahr, Prozent mit einer Nachkommastelle.
5. **Gegenprüfung:** Neuer Chat, Prompt **M1-02** mit dem Ergebnis aus Schritt 4 und der Spalten-/Measure-Liste
   (`INFO_Abfragen.dax`, Abfragen 2 und 3).
6. Testabfrage aus Schritt 4 in der DAX-Abfrageansicht ausführen. Plausibilität: Ist der Vorjahreswert für 2026-10
   gleich der Qualitätsquote von 2025-10?
7. *Variante mit Kapazität:* Dieselbe Aufgabe an Copilot in der DAX-Abfrageansicht (Strg+I) stellen:
   „Schreib eine DAX-Abfrage mit einem Measure für die Qualitätsquote im Vorjahr je Monat 2026.“ Findet er `[m_QQ]`?

**Erwartetes Ergebnis:** Eine Liste erfundener Namen aus Schritt 1, eine Fehlermeldung aus Schritt 3, zwei lauffähige
Measures aus Schritt 4 mit Testabfrage, eine Gegenprüfung ohne „nicht vorhanden“-Treffer.

## Ü1.3 · DAX formatieren und kommentieren (12 min, Wahl)

**Ziel:** Code lesbar machen, ohne die Logik anzufassen; Verbesserungen getrennt erhalten.

**Schritte**
1. `Abw Kosten %` und `Kosten YTD` aus der TMDL-Ansicht kopieren.
2. Prompt **M1-03** mit K02. Beide Measures in einem Durchgang.
3. Prüfen: Ist die Logik unverändert (noch `/`, noch `Fakt_Leistung[Monat]`)? Sind die Verbesserungsvorschläge konkret?
4. Dasselbe mit `KPI Status Text`. Hält Copilot sich auch bei einem langen Measure an „Logik nicht ändern“?

**Erwartetes Ergebnis:** Formatierte, kommentierte Measures mit unveränderter Logik und eine Vorschlagsliste, die die Division mit `/`,
die doppelte Abweichungsrechnung und die Zeitintelligenz in `Kosten YTD` benennt.

## Ü1.4 · Power Query: SAP-Export formatieren und Schwachstellen finden (12 min, Wahl)

**Ziel:** Eine über die Oberfläche gewachsene M-Abfrage verstehen und die typischen Betriebsrisiken benennen.

**Schritte**
1. `uebungsdaten/modul1/SAP_Export_Leistung.pq` öffnen (Editor) und den Code ab `let` kopieren. Der Kopfkommentar
   beschreibt das Format der Exportdatei – geben Sie ihn als Kontext mit.
2. Prompt **M1-04**, Teil A und B.
3. Nachschärfen „Kultur-Problematik“: Was wird aus `12.345,67`, `412,5` und `01.10.2026` im Schritt `#"Geänderter Typ1"`?
4. Nachschärfen „verbesserte Fassung“ mit den Parametern `SAP_Exportdatei` und `Berichtsjahr`.

Die Abfrage läuft ohne die Exportdatei und die Abfrage `Kostenstellen_Mapping` nicht – es geht um Lesen und Bewerten.

**Erwartetes Ergebnis:** Kommentierte Fassung mit unveränderten Schrittnamen, eine Schwachstellentabelle mit mindestens
acht Punkten, eine verbesserte Fassung mit gleichem Ausgabeschema.

## Ü1.5 · SQL-View formatieren, kommentieren, optimieren (12 min, Wahl)

**Ziel:** Eine View für DirectQuery auf Performance-, Richtigkeits- und Datenschutzrisiken prüfen.

**Schritte**
1. `uebungsdaten/modul1/Azure_SQL_View_Leistung.sql` komplett kopieren – inklusive Kopfkommentar mit Tabellenstruktur.
2. Prompt **M1-05**, Teile A–C.
3. Nachschärfen „Testabfrage alt/neu“.
4. Prüfen: Hat Copilot die implizite Konvertierung bei `Werk` gefunden? Was sagt er zu `Abw_Kosten_Prozent` im Hinblick
   auf die Aggregation in Power BI?

**Erwartetes Ergebnis:** Formatierte View, Schwachstellentabelle, verbesserte `CREATE OR ALTER VIEW` mit expliziter
Spaltenliste und einer Liste der Verhaltensänderungen.

## Ü1.6 · Großes Measure analysieren: `KPI Status Text` (8 min)

**Ziel:** Ein gewachsenes Measure vollständig verstehen, bevor Sie es ändern.

**Schritte**
1. `KPI Status Text` und das TMDL der Measures von `Fakt_Leistung` (ohne Partition) bereitlegen, dazu K05.
2. Prompt **M1-06**.
3. Nachschärfen „Sonderfälle konkret durchrechnen“: Was liefert das Measure für November 2026?
4. `INFO_Abfragen.dax`, Abfrage 9 ausführen und eine Zeile der Entscheidungstabelle an den Werten nachvollziehen.

**Erwartetes Ergebnis:** Entscheidungstabelle mit vier Stufen, Liste der Duplikate mit zugehörigen Measures, Liste der
Konstanten, Sonderfälle mit Ergebnis.

## Ü1.7 · Refaktorisieren und alt gegen neu testen (15 min)

**Ziel:** `KPI Status Text` lesbar und wartbar machen und **beweisen**, dass es gleich rechnet.

**Schritte**
1. Zuerst die Basis-Measures bereinigen: `Abw Kosten %` und `Krankenquote` auf `DIVIDE` umstellen, `Abw Kosten %` nutzt
   `[Abw Kosten]` (Bearbeitungsleiste oder TMDL-Ansicht).
2. Im selben Chat wie Ü1.6 weiterarbeiten. Prompt **M1-07**, Granularität `Region[Region], Kalender[Monat]`.
3. Copilots Vergleichsabfrage ausführen. Alternativ `INFO_Abfragen.dax`, Abfrage 8 (ab `DEFINE` markieren).
4. Bei 0 Abweichungen: neue Fassung ins Measure `KPI Status Text` übernehmen. Bei Abweichungen: Nachschärfen.
5. Optional: Verbesserung „Monate ohne Daten bleiben leer“ einbauen und mit der Vergleichsabfrage zeigen, welche Zeilen sich ändern.

**Erwartetes Ergebnis:** Refaktorisierte Fassung mit VAR, `SWITCH ( TRUE (), … )`, benannten Schwellen und
Wiederverwendung von `[Abw Kosten %]`, `[m_QQ]`, `[Krankenquote]`; Vergleichsabfrage mit 0 Abweichungen.

## Ü1.8 · Fehler beheben aus Fehlermeldung (10 min)

**Ziel:** Fehler mit Copilot diagnostizieren statt raten – und den Fix belegen.

**Schritte**
1. `uebungsdaten/modul1/Fehlerfaelle.md` öffnen. Mindestens zwei Fälle bearbeiten, davon einen aus Power Query (Fall C).
2. Je Fall Prompt **M1-08**: Ort, Meldung wörtlich, Code, Kontext (TMDL bzw. Kopfzeilen).
3. Fälle A, B, D in Desktop nachstellen und die Korrektur anwenden. Fall C nur bewerten.
4. Prüfen: Hat Copilot die Ursache benannt, bevor er korrigiert? Behebt die Korrektur die Ursache oder nur das Symptom?

**Erwartetes Ergebnis:** Je Fall Ursache, minimale Korrektur, Test und Vorbeugung.

## Ü1.9 · Modell dokumentieren mit INFO.VIEW (10 min)

**Ziel:** Eine vollständige Modelldoku aus echten Metadaten erzeugen.

**Schritte**
1. `INFO_Abfragen.dax`, Abfragen 1–4 ausführen, Ergebnisse kopieren und in `Modell-Metadaten.txt` sammeln.
2. Prompt **M1-10** mit K05.
3. Vollständigkeit prüfen: Anzahl Measures, Tabellen, Beziehungen in der Doku gegen die Zeilenzahlen der Abfragen.
4. Abfragen 5 und 6 ausführen und mit Copilots Abschnitt „Lücken“ vergleichen.

**Erwartetes Ergebnis:** Markdown-Dokumentation mit allen 5 Tabellen, 5 Beziehungen und 18 Measures; abgeleitete
Bedeutungen gekennzeichnet; Lückenliste.

## Ü1.10 · Berichtsseite dokumentieren (10 min)

**Ziel:** Einen Bericht mit Bordmitteln dokumentieren, obwohl M365 Copilot die `.pbix` nicht lesen kann.

**Schritte**
1. Seite **Kennzahlenübersicht** öffnen, Filterbereich aufklappen, Screenshot speichern.
2. Leistungsanalyse starten, **Visuals aktualisieren**, je Visual **Abfrage kopieren** in `Seite_Abfragen.txt` (mit Visual-Titel).
3. Measure-Definitionen: Ergebnis von Abfrage 3 aus `INFO_Abfragen.dax`.
4. Prompt **M1-11** mit drei Anhängen.
5. Prüfen: Alle Visuals erfasst? Felder aus den Abfragen, nicht aus dem Bild? Keine Zahlen interpretiert?

**Erwartetes Ergebnis:** Seitendokumentation mit Visual-Tabelle, Slicer/Filtern, Kennzahldefinitionen, Lesehilfe und Auffälligkeiten.

## Ü1.11 · Beschreibungen als TMDL zurückschreiben, `m_QQ` umbenennen (10 min)

**Ziel:** Metadaten verbessern, die jede KI liest – in einem Schritt für viele Objekte.

**Schritte**
1. PBIP-Ordner sichern.
2. **Umbenennen:** Im Datenbereich `m_QQ` doppelklicken und in `Qualitätsquote` umbenennen. In der TMDL-Ansicht prüfen,
   ob Verweise in anderen Measures mitgezogen wurden (falls `KPI Status Text` aus Ü1.7 `[m_QQ]` nutzt).
3. TMDL-Ansicht: alle Measures von `Fakt_Leistung` markieren und in einen neuen Tab ziehen. Skript kopieren.
4. Prompt **M1-12** mit K03 und K05.
5. Rückgabe prüfen (nur `///`-Zeilen neu?), in einen neuen TMDL-Tab einfügen, **Anwenden**.
6. In der Modellansicht zwei Beschreibungen kontrollieren, `INFO_Abfragen.dax` Abfrage 5 erneut ausführen.
7. *Variante mit Kapazität:* Für ein Measure **Erstellen mit Copilot** (engl. *Create with Copilot*) nutzen und mit Ihrer Beschreibung vergleichen.

**Erwartetes Ergebnis:** Alle Measures von `Fakt_Leistung` haben eine fachliche Beschreibung; `m_QQ` heißt
`Qualitätsquote`, Bericht und Measures funktionieren; Synonymliste liegt vor.

## Ü1.12 · Modell KI-fähig machen, AI-Instructions entwerfen (10 min)

**Ziel:** Ihr Modell mit den Augen einer KI prüfen und die Bausteine von „Prep data for AI“ vorbereiten.

**Schritte**
1. Kontext: TMDL ohne Partitionen (Stand nach Ü1.11) oder Abfragen 1–4 und 6 aus `INFO_Abfragen.dax`, dazu K05.
2. Prompt **M1-13**. Als typische Fragen z. B.: „Welche Region liegt bei den Kosten am weitesten über Plan?“,
   „Wie hat sich die Krankenquote in Ost seit Juli entwickelt?“, „Welche Maßnahmen sind verzögert?“
3. Review-Tabelle mit Ihrer Schwachstellenliste aus Ü1.1 abgleichen. Was ist erledigt, was offen?
4. AI-Instructions kürzen und als `AI-Instructions_DBS.txt` speichern.
5. *Variante mit Kapazität:* **Prep data for AI** öffnen (Q&A muss aktiviert sein), Instructions einfügen, AI data schema
   setzen, Copilot-Bereich neu öffnen, zwei Testfragen stellen.

**Erwartetes Ergebnis:** Priorisierte Review-Tabelle, Vorschlag für das AI data schema, AI-Instructions unter 3.000 Zeichen,
3–5 verified-answer-Vorschläge.

## Ü1.13 · Excel-Chaos zu Power Query (20 min, Wahl)

**Ziel:** Sie lassen Copilot eine „gewachsene“ Excel- oder CSV-Datei analysieren und eine robuste Power-Query-Abfrage
schreiben – und beweisen mit Kontrollwerten, dass sie richtig lädt.

**Schritte**
1. Eine Datei aus `uebungsdaten/excel-chaos/` wählen (01–05) und zuerst selbst öffnen: Was fällt Ihnen auf?
   Einstieg: 01 oder 04; anspruchsvoller: 02 oder 03.
2. Prompt **M1-14**, Schritt 1: Datei anhängen und die Struktur analysieren lassen. Vergleichen Sie Copilots
   Problemliste mit Ihrer eigenen. Was hat Copilot übersehen?
3. Prompt **M1-14**, Schritt 2: Zielschema aus `uebungsdaten/excel-chaos/README.md` einsetzen, Abfrage schreiben lassen.
4. In Power BI Desktop testen (Parameter `pDatei`, leere Abfrage, Erweiterter Editor – Anleitung in der README).
5. Zeilenzahl und Summe mit den Kontrollwerten vergleichen. Bei Fehlern oder Abweichungen: Nachschärf-Prompts aus M1-14.
6. Zerbrechlichkeit prüfen: In einer Kopie der Datei eine Zeile im Vorspann einfügen und aktualisieren. Lädt die Abfrage noch?

**Erwartetes Ergebnis:** Eine lauffähige Abfrage ohne feste Zeilenzahlen, Spaltenpositionen und Pfade, deren
Zeilenzahl und Summen mit den Kontrollwerten übereinstimmen – und eine Liste der Probleme, die Copilot erst auf
Nachfrage gefunden hat.

## Z1.1 · Zusatz: Modellhygiene per TMDL umsetzen (15 min)

**Ziel:** Vier Befunde im Modell beheben (Zeitintelligenz auf der Faktspalte, summierte ID-Spalten, fehlende Sortierspalte,
Kalender nicht als Datumstabelle markiert) – Copilot liefert das Skript, Sie prüfen und wenden an.

**Schritte**
1. PBIP-Ordner sichern.
2. In der TMDL-Ansicht skripten: Measure `Kosten YTD`; Spalten `RegionID`, `LeistungsartID` aus `Fakt_Leistung` und
   `Massnahmen`; Spalten `Monatsname` und `MonatNr` aus `Kalender`. Nur diese Objekte, keine ganzen Tabellen.
3. Nachschärfen-Prompt „Modell-Korrekturen direkt umsetzen“ aus **M1-13** mit diesem Skript.
4. Skript prüfen, anwenden. Kalender per **Tabellentools › Als Datumstabelle markieren** (Spalte `Datum`) markieren.
5. `INFO_Abfragen.dax`, Abfragen 6 und 7 ausführen.

**Erwartetes Ergebnis:** Abfrage 6 meldet keine Verdachtsfälle zu Zeitintelligenz, Sortierung und Datumstabelle mehr und bei den ID-Spalten nur noch die Schlüssel
`Region[RegionID]` und `Leistungsart[LeistungsartID]`; Abfrage 7 zeigt `Kosten YTD` kumuliert.
