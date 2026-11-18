# Modul 2 · Übungen: KPI-Analysen mit KI

Berichtsmonat in allen Übungen: **Oktober 2026**. Datenbasis: Übungsmodell `DBS_Produktionscontrolling`
und die Exporte in `uebungsdaten/modul2/` (`KPI_Monat_Region.csv`, `KPI_Monat_Region_Leistungsart.csv`,
`Massnahmen.csv`, `DBS_KPI_Export.xlsx`). Prompt-Vorlagen: `prompts/modul2/M2-01` bis `M2-11`.
Kontextdateien: **K04** (Kommentar-Leitfaden), **K05** (Kennzahlen-Glossar), Grundregeln in `00_Prompting-Grundregeln.md`.

> **Datenschutz (gilt für alle Übungen):** Nur im unternehmensfreigegebenen Microsoft 365 Copilot arbeiten
> (Anmeldung mit Firmenkonto, Hinweis „Enterprise Data Protection“). Keine personenbezogenen Daten
> einfügen oder anhängen. Die Übungsdaten sind fiktiv. Für echte Berichte gilt: nur freigegebene Exporte,
> Namen durch Rollen ersetzen.

> **Werkzeug-Hinweis:** Analyst (Agent in Copilot Chat) und Copilot in Excel mit Python rechnen tatsächlich
> und zeigen Code – erste Wahl für Profile und Korrelationen. Beide setzen eine Microsoft-365-Copilot-Lizenz
> bzw. Freigaben voraus. Copilot im Power-BI-Bericht und in der DAX-Abfrageansicht braucht zusätzlich einen
> Workspace auf bezahlter Fabric-/Premium-Kapazität. **Jede Übung geht auch mit dem normalen
> M365 Copilot Chat und angehängter Datei** – dann alle Zahlen in Excel nachrechnen.

**Einheiten in den Exporten:** Prozentspalten sind Prozentwerte (`6,87` = 6,87 %). Eine eigene DAX-Abfrage
liefert dagegen Anteile (`0,0687`). Die Lösungen besprechen wir gemeinsam im Training.

## Übersicht

| Übung | Thema | Prompt | Zeit | Block |
|---|---|---|---|---|
| Ü2.1 | Daten bereitstellen (Export, DAX-Abfrage) | M2-01, M2-02 | 10 min | M2.1 |
| Ü2.2 | Datenprofil und Plausibilitätscheck | M2-03 | 15 min | M2.1 |
| Ü2.3 | Kommentar Kennzahlenübersicht | M2-04 | 20 min | M2.2 |
| Ü2.4 | Kommentar Detailbericht | M2-05 | 15 min | M2.2 |
| Ü2.5 | Korrelationen finden | M2-06 | 20 min | M2.3 |
| Ü2.6 | Korrelationen bewerten | M2-07 | 20 min | M2.3 |
| Ü2.7 | Maßnahmentracking: Konsistenz, Status, Wirkung | M2-08, M2-09 | 25 min | M2.4 |
| Ü2.8 | Faktencheck eines Kommentars | M2-10 | 10 min | M2.2 (Ende) oder Puffer |
| Ü2.9 | Optional: Kommentar-Baustein als DAX-Measure | M2-11 | 15 min | Transfer/Nacharbeit |

**Was einen guten Kommentar ausmacht** (Maßstab für Ihre Kommentare):
1. **Aussage zuerst** – der erste Satz ist die Botschaft, mit Zahl.
2. **Zahl mit Bezug** – IST gegen PL und/oder VJ, Betrag und Prozent, Zeitraum genannt.
3. **Prozent vs. Prozentpunkte** – Quoten ändern sich in Pp.
4. **Ursache nur mit Beleg** – gleichzeitige Datenbewegung = „passt zu“; fachlicher Beleg = „wegen“.
5. **Handlungsbedarf** – was, wer (Rolle), bis wann. Oder ausdrücklich „kein Handlungsbedarf“.
6. **Datenhinweis** – bekannte Datenfehler offen nennen, nicht kommentieren.

---

## Ü2.1 · Daten für Copilot bereitstellen (10 min)

**Ziel:** Sie bringen Berichtsdaten auf zwei Wegen zu Copilot und prüfen, ob Copilot sie richtig gelesen hat.

**Schritte**
1. `KPI_Monat_Region.csv` in Copilot Chat anhängen und den Prompt aus **M2-01** verwenden. Einheit der
   Prozentspalten angeben (Prozentwerte).
2. Prüfen: Zeilenzahl, Zeitraum, Regionen, eine Beispielzeile.
3. TMDL der Tabellen `Fakt_Leistung`, `Kalender`, `Region` aus der TMDL-Ansicht kopieren und mit dem Prompt aus
   **M2-02** eine SUMMARIZECOLUMNS-Abfrage schreiben lassen.
4. Abfrage in der DAX-Abfrageansicht ausführen. Wert Ost/2026-10 mit der Kennzahlenübersicht vergleichen.

**Erwartetes Ergebnis**
- Copilot meldet 154 Zeilen (22 Monate × 7 Regionen), 12 Spalten, Jan 2025 – Okt 2026, 7 Regionen.
- Die DAX-Abfrage läuft und liefert 154 Zeilen; Ost, 2026-10: Ist Kosten **1.076.539,91 €**, Abw Kosten % **0,0687**.

## Ü2.2 · Datenprofil und Plausibilitätscheck (15 min)

**Ziel:** Vor jeder Kommentierung finden Sie Datenfehler in den Exporten und bestimmen, welche Berichtskennzahlen
sie verfälschen.

**Schritte**
1. `KPI_Monat_Region_Leistungsart.csv` anhängen, Prompt **M2-03** verwenden.
2. Funde mit Excel-Filter prüfen (Region, Leistungsart, Monat).
3. Mit dem Folgeprompt „Auswirkung auf den Bericht“ die betroffenen Kennzahlen wie geliefert und bereinigt rechnen lassen.
4. Optional: Dubletten-Abfrage in der DAX-Abfrageansicht (Folgeprompt in M2-02/M2-03).

**Erwartetes Ergebnis**
Eine Fundliste mit mindestens zwei „wahrscheinlichen Datenfehlern“ und dem Winterdienst-Sommer als „erwartet“.

## Ü2.3 · Kommentarvorschlag Kennzahlenübersicht, Oktober 2026 (20 min)

**Ziel:** Sie lassen einen Monatskommentar nach Leitfaden entwerfen, prüfen ihn und verbessern ihn.

**Schritte**
1. `KPI_Monat_Region.csv` anhängen, K04/K05 hinterlegen (Notebook) oder anhängen.
2. Prompt **M2-04** verwenden; die Funde aus Ü2.2 als „bekannte Datenfehler“ eintragen.
3. Kommentar gegen die Checkliste „Ergebnis prüfen“ in M2-04 prüfen; mindestens drei Zahlen im Bericht nachsehen
   (Kennzahlenübersicht, Slicer Monat = 2026-10).
4. Mit einem Folgeprompt kürzen oder schärfen.
5. Vergleich im Plenum.

**Erwartetes Ergebnis**
Ein Kommentar ≤ 120 Wörter, erster Satz mit Hauptbotschaft (Ost), Belegtabelle, Datenhinweis.

## Ü2.4 · Kommentar Detailbericht: Zeitreihe und Drilldown Ost (15 min)

**Ziel:** Sie kommentieren eine Entwicklung mit Zeitbezug und Drilldown und grenzen sie gegen eine stabile Region ab.

**Schritte**
1. `KPI_Monat_Region_Leistungsart.csv` anhängen (für die Zeitreihe zusätzlich `KPI_Monat_Region.csv`).
2. Prompt **M2-05** mit Fokusregion Ost, Vergleichsregion Mitte.
3. Tabellen A und B gegen den Detailbericht prüfen (Slicer Region = Ost, Liniendiagramm Krankenquote/m_QQ).
4. Optional: Folgeprompt „positive Entwicklung“ für Süd/Fahrzeugreinigung.

**Erwartetes Ergebnis**
Tabelle mit Beginn der Auffälligkeit je Kennzahl, Drilldown-Tabelle, Kommentar ≤ 100 Wörter.

## Ü2.5 · Korrelationen finden: Matrix und Zeitversatz (20 min)

**Ziel:** Sie lassen Korrelationen **rechnen** (nicht schätzen), mit Pearson, Spearman und Lag, je Region und gepoolt.

**Schritte**
1. `DBS_KPI_Export.xlsx` in Excel (OneDrive) mit Copilot/Python öffnen oder im Analyst bzw. Copilot Chat anhängen.
2. Prompt **M2-06** (Variante A/B). Ohne Python: Variante C und `KORREL` in Excel für zwei Paare.
3. Prüfen: n, Code sichtbar, eine Korrelation in Excel nachgerechnet.
4. Folgeprompts „Saison“ und „Pearson vs. Spearman“ ausprobieren.

**Erwartetes Ergebnis**
Heatmap, Ergebnistabelle mit n und p, Vergleich mit/ohne Datenfehler. Noch keine Ursachen.

## Ü2.6 · Korrelationen bewerten (20 min)

**Ziel:** Sie bewerten drei Korrelationen mit dem Fünf-Fragen-Raster und formulieren kommentarfähige Sätze.

**Schritte**
1. Ergebnis aus Ü2.5 in den Prompt **M2-07** übernehmen, Korrelationen a) Winterdienst-Ist-Kosten ↔ Krankenquote
   (gepoolt Monat × Region), b) Krankenquote → Qualitätsquote Ost (Lag 1), c) Kosten je Stunde ↔ Abw Kosten % (Südwest)
   eintragen.
2. Copilot rechnen lassen (Saisontest, Ost ohne Jul–Okt).
3. In einem **neuen Chat** die Bewertung gegenprüfen lassen (Folgeprompt).
4. Pro Korrelation einen Kommentarsatz festlegen.

**Erwartetes Ergebnis**
Je Korrelation ein Raster mit Ampel und Urteil, dazu drei Satzvorschläge ohne Kausalbehauptung.

## Ü2.7 · Maßnahmentracking: Konsistenzcheck, Status und Wirkung (25 min)

**Ziel:** Sie finden Widersprüche in der Maßnahmenliste, bewerten die Wirkung einer Maßnahme mit Vorher/Nachher,
Vorjahr und Vergleichsgruppe und schreiben den Statuskommentar.

**Schritte**
1. Teil 1 (10 min): `Massnahmen.csv` anhängen, Prompt **M2-08** mit Stichtag 31.10.2026, Datumsformat TT.MM.JJJJ.
2. Funde in der CSV nachsehen.
3. Teil 2 (15 min): zusätzlich `KPI_Monat_Region_Leistungsart.csv` anhängen, Prompt **M2-09** mit Maßnahme M-004.
4. Wirkungstabelle in Excel stichprobenartig nachrechnen (Süd/Fahrzeugreinigung, Ist_Stunden Mai–Okt 2026).

**Erwartetes Ergebnis**
Verstoßliste mit Rückfragen, Status- und Wirkungstabelle, Statuskommentar ≤ 90 Wörter.

## Ü2.8 · Faktencheck eines Kommentars (10 min)

**Ziel:** Sie lassen einen fremden Kommentar Behauptung für Behauptung gegen die Daten prüfen.

**Schritte**
1. **Neuen** Copilot Chat öffnen, `KPI_Monat_Region.csv` und `Massnahmen.csv` anhängen.
2. Prompt **M2-10** verwenden und den folgenden Prüftext einsetzen.
3. Zwei Werte selbst im Bericht nachsehen.
4. Folgeprompt „Schritt 6“: korrigierte Fassung erzeugen und ebenfalls prüfen.

**Prüftext** (enthält absichtlich Fehler):
> Die Kosten im Oktober 2026 liegen mit 7,5 Mio. € 0,7 % über Plan. Region Ost überschreitet den Plan um 10,0 %;
> Ursache ist die Grippewelle in der Region. Die Krankenquote in Ost stieg gegenüber dem Vorjahr um 3,8 %. Südwest
> verzeichnete im September einen Kostenanstieg von 263 %. Die Qualitätsquote in Ost liegt mit 87,0 % unter dem
> Zielwert von 90 %. Die Tourenoptimierung Süd hat ihre geplante Einsparung um 50 % übertroffen.

**Erwartetes Ergebnis**
Prüftabelle mit sieben Behauptungen und Bewertung, drei wichtigste Korrekturen, korrigierte Fassung.

## Ü2.9 · Optional: Kommentar-Baustein als DAX-Measure (15 min)

**Ziel:** Sie lassen ein Text-Measure entwerfen, das Faktensätze dynamisch aus den Daten erzeugt.

**Schritte**
1. In einer Kopie des Übungsmodells: TMDL der Measures aus `Fakt_Leistung` sowie `Kalender` und `Region` kopieren.
2. Prompt **M2-11** mit K02 (DAX-Styleguide).
3. Measure anlegen, Testabfrage in der DAX-Abfrageansicht ausführen.
4. Measure in die Tabelle der Kennzahlenübersicht ziehen und den Slicer auf 2026-09 stellen.

**Erwartetes Ergebnis**
Je Region ein deutsch formatierter Satz; Ost mit Qualitätssatz; Mitte „im Plan“.

## Transfer in den eigenen Bericht (Abschluss)

Nehmen Sie einen eigenen Monatsbericht und notieren Sie:
1. Welcher Exportweg (Visual-Export, DAX-Abfrage) liefert die Kennzahlen für Ihren Kommentar?
2. Welche drei Plausibilitätsregeln gehören bei Ihnen vor jede Kommentierung (Dubletten, Kommafehler, Lücken …)?
3. Welche Schwellen und Begriffe gehören in Ihren Kommentar-Leitfaden (Vorlage K04) und Ihr Glossar (Vorlage K05)?
4. Welche Kennzahlenpaare würden Sie auf Zeitversatz prüfen – und welche Drittvariable (Saison, Mix) müssen Sie ausschließen?
