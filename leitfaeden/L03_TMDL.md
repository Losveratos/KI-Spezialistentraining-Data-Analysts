# L03 · TMDL mit Copilot

> **Wofür:** Das semantische Modell als Text lesen, prüfen und in einem Schritt für viele Objekte ändern – Copilot schreibt
> die Skripte, die TMDL-Ansicht in Power BI Desktop bringt sie sicher ins Modell. **Für wen:** Data Analysts, die Modelle in
> Desktop pflegen (Import, DirectQuery, Azure SQL, Dataflows, SAP). **Bezug:** vertieft Modul 1 (Ü1.1, Ü1.11, Z1.1). Syntax:
> [K03 TMDL-Kurzreferenz](../prompts/kontext/K03_TMDL-Kurzreferenz.md) (hier nicht wiederholt). Einzelprompts:
> [M1-01](../prompts/modul1/M1-01_Modellueberblick-aus-TMDL.md), [M1-12](../prompts/modul1/M1-12_Beschreibungen-als-TMDL.md),
> [M1-13](../prompts/modul1/M1-13_Modell-KI-faehig-machen.md). Dokumentation aus TMDL: [L04](L04_Dokumentation-aus-TMDL.md).

## Auf einen Blick

1. **TMDL statt Beschreibung.** Geben Sie Copilot das Modell als Text – mit exakten Namen, DAX und Eigenschaften.
2. **Die TMDL-Ansicht ist der Rückweg ins Modell:** skripten, ändern, **Vorschau**, **Anwenden**, prüfen.
3. **Copilot schreibt, Sie wenden an.** Kein Skript ungeprüft, nie das ganze Modell auf einmal.
4. **Vorher sichern:** PBIP-Kopie oder Git-Commit – und das Original-Skript in einer eigenen Registerkarte stehen lassen.
5. **`createOrReplace` ersetzt das ganze Objekt.** Was im zurückgegebenen Skript fehlt, ist nach dem Anwenden weg.
6. **Massenänderungen sind die Stärke:** Beschreibungen, Anzeigeordner, Formatstrings, Ausblenden, `summarizeBy`, Sortierspalten.
7. **Umbenennen im Datenbereich, nicht im Skript.** Berichte binden Felder über Namen.
8. **`lineageTag` nie erfinden lassen:** vorhandene unverändert übernehmen, bei neuen Objekten weglassen.
9. **Einrückung mit Tabs prüfen.** Eine Leerzeile zwischen `///` und Objekt löscht die Beschreibung ohne Fehlermeldung.
10. **Keine Daten, keine Verbindungen in den Prompt:** `partition`- und `expression`-Blöcke weglassen.
11. **PBIP in Git** macht jede Änderung als Diff sichtbar. Lesen Sie den Diff vor jedem Commit.

## Das Wichtigste kompakt

### Warum TMDL der Schlüssel für KI ist

Copilot errät alles, was es nicht sieht – und klingt dabei überzeugend. Im TMDL steht das Modell selbst: Tabellen, Spalten
mit Datentyp, Measures mit DAX, Format und Ordner, Beziehungen. Copilot verwendet damit `Fakt_Leistung[Ist_Kosten]` statt
eines erfundenen `Fakt[Kosten]` und gibt Änderungen in **derselben Sprache** zurück, die die TMDL-Ansicht anwendet. Nicht im
TMDL stehen Datenwerte, die Nutzung in Visuals und die Bedeutung kryptischer Namen (`m_QQ`) – dafür braucht Copilot das
Glossar [K05](../prompts/kontext/K05_Kennzahlen-Glossar.md) oder Ihre Rückfrage.

### TMDL-Ansicht Schritt für Schritt

1. **Öffnen:** linke Leiste › **TMDL-Ansicht** (in Desktop allgemein verfügbar, im Service Vorschau). Der Editor startet leer.
2. **Skripten:** Objekte aus dem **Datenbereich** in den Editor ziehen – mit **Strg** mehrere, oder einen ganzen Abschnitt
   (z. B. alle Measures einer Tabelle); alternativ Rechtsklick › **TMDL skripten**. Desktop erzeugt ein `createOrReplace`-Skript,
   bei Measures und Spalten mit `ref table` für die Tabelle.
3. **Original sichern:** Registerkarte umbenennen (`ORIGINAL …`), nicht mehr anfassen; Änderungen in einer zweiten Registerkarte.
4. **Bearbeiten:** selbst (Strg+F mit regulären Ausdrücken, Umschalt+Alt+F formatiert) oder das geprüfte Copilot-Ergebnis
   einfügen. Der Bereich **Probleme** zeigt Syntaxfehler mit Zeile.
5. **Vorschau:** Modell vor und nach dem Skript als Diff (rot = entfernt/geändert, grün = neu), Reihenfolge ggf. anders als im Skript.
6. **Anwenden:** führt das Skript aus. Bei Fehler öffnet **Details anzeigen** den Bereich **Ausgabe**.
7. **Prüfen:** Modellansicht, betroffene Berichtsseiten, Abfragen 5 und 6 aus [`INFO_Abfragen.dax`](../uebungsdaten/modul1/INFO_Abfragen.dax).
8. **Rückgängig:** Verlassen Sie sich nicht auf Strg+Z. Der verlässliche Rückweg ist die Original-Registerkarte: **Anwenden**
   stellt die skriptierten Objekte wieder her (so beschreibt es auch Microsoft). Neu angelegte Objekte löschen Sie im
   Datenbereich. Letzte Rückfallebene: PBIP-Kopie oder Git.

Die TMDL-Ansicht ändert nur Metadaten und aktualisiert keine Daten – nach Änderungen an Power Query oder berechneten Spalten
aktualisieren Sie selbst. Registerkarten werden mitgespeichert, im PBIP als `.tmdl`-Dateien im Ordner `TMDLScripts`.

### PBIP-Projekt und Git

**Datei › Speichern unter › Power BI-Projekt (.pbip)** legt Bericht und Modell als Textdateien ab (PBIP ist seit September
2026 allgemein verfügbar). Das Modell steht in `<Name>.SemanticModel/definition/` (`model.tmdl`, `relationships.tmdl`,
`expressions.tmdl`, je Tabelle eine Datei unter `tables/`). Die `.gitignore` von Desktop schließt `cache.abf` (Daten) und
`localSettings.json` aus. **Aber:** Partitionen mit Servernamen, SQL- oder SAP-Abfragen landen im Repository – im Übungsmodell
sogar die Daten, weil sie in `expressions.tmdl` stecken.

- **Ablage:** kurzer lokaler Pfad (Windows-Grenze 260 Zeichen), nicht direkt in OneDrive- oder SharePoint-Ordner speichern.
- **Git:** Repository z. B. in Azure DevOps, Arbeit in VS Code (Quellcodeverwaltung). Ein Commit je abgeschlossener Änderung
  mit sprechender Nachricht („Beschreibungen Fakt_Leistung ergänzt“).
- **Extern bearbeiten:** vorher in Desktop speichern. Desktop bietet dann **Externe Änderungen anwenden** an (Vorschaufeature
  „Detect and reload external PBIP changes“, ab Desktop August 2026), sonst Projekt neu öffnen.

**Diff lesen.** Die Korrektur einer ID-Spalte im Git-Diff (Ausschnitt, `lineageTag`-Zeilen weggelassen):

```diff
 	column RegionID
 		dataType: int64
+		isHidden
 		formatString: 0
-		summarizeBy: sum
+		summarizeBy: none
 		sourceColumn: RegionID
```

`-` ist der alte, `+` der neue Stand, Zeilen ohne Zeichen sind Kontext. **Rauschen:** geänderte `annotation`-Zeilen,
verschobene Eigenschaften. **Warnsignale:** Blöcke nur mit `-` (Objekt gelöscht), geänderte Namen in `measure`- oder
`column`-Zeilen, unbeabsichtigte Änderungen in `partition`-Blöcken.

### Massenänderungen mit Copilot

| Änderung | Wo im TMDL | Hinweis |
|---|---|---|
| Beschreibungen | `///` direkt über `measure`/`column` | höchstens ca. 200 Zeichen, Wichtigstes zuerst ([M1-12](../prompts/modul1/M1-12_Beschreibungen-als-TMDL.md)) |
| Anzeigeordner | `displayFolder: Kosten\Abweichung` | Ordnerplan vorgeben, sonst erfindet Copilot neue Ordner |
| Formatstrings | `formatString: #,0 €` | Punkt als Dezimaltrenner; Prozent-Measures `0.0 %` |
| IDs ausblenden | `isHidden`, `summarizeBy: none` | z. B. `RegionID`, `LeistungsartID` in `Fakt_Leistung` und `Massnahmen` |
| Sortierspalten | `sortByColumn: MonatNr` an `Kalender[Monatsname]` | Sortierspalte nie aus der sortierten Spalte berechnen |
| Datumstabelle | `dataCategory: Time` an der Tabelle | sicherer in Desktop: **Tabellentools › Als Datumstabelle markieren** – per TMDL müsste die ganze Tabelle samt Partition ins Skript |

So soll Copilots Rückgabe aussehen: neu sind nur Beschreibung, Ordner und Format, alles andere stammt Zeichen für Zeichen aus
dem skriptierten Original (dessen `lineageTag`-Zeilen fehlen hier zur Übersicht – bei Ihnen bleiben sie stehen). Die Division
mit `/` bleibt bewusst stehen: Bei einer Beschreibungsaufgabe ändert Copilot keine Logik.

```tmdl
createOrReplace

	ref table Fakt_Leistung

		/// Abweichung der Ist- von den Plankosten in Prozent der Plankosten. Positiv = über Plan (ungünstig).
		measure 'Abw Kosten %' = ( [Ist Kosten] - [Plan Kosten] ) / [Plan Kosten]
			formatString: 0.0 %
			displayFolder: Kosten\Abweichung

		/// Ist-Kosten je geleisteter Stunde in Euro.
		measure 'Kosten je Stunde' = DIVIDE ( [Ist Kosten], [Ist Stunden] )
			formatString: #,0.00 €
			displayFolder: Kosten\Kennzahlen
```

### Umbenennen mit Vorsicht

Visuals speichern ihre Felder mit Namen. Im Skript umbenannt, entsteht mit `ref table` ein **zusätzliches** Objekt; wird die
ganze Tabelle geskriptet, verschwindet das alte, und Visuals zeigen Fehler – darauf weist auch Microsoft hin.

- **Sicherer Weg:** im Datenbereich umbenennen (Doppelklick). Desktop passt DAX-Verweise und die Visuals des geöffneten Berichts an.
- **Nicht angepasst:** andere Berichte und Excel-Auswertungen auf dem veröffentlichten Modell, gespeicherte DAX-Abfragen
  (Abfrage 8 und 9 in `INFO_Abfragen.dax`), AI-Instructions, Ihre Doku. Copilot hilft beim Auflisten (Aufgabe 4).
- `sourceColumn` bleibt beim Umbenennen gleich – die Verbindung zu Power Query hängt daran, nicht am Spaltennamen.

### Große Modelle in Teilen an Copilot geben

- **Copilot merkt nicht, wenn eine Eingabe abgeschnitten wurde,** und „ergänzt“ fehlende Teile. **Inventar zuerst:** Abfragen 1–4 aus `INFO_Abfragen.dax` – kompakt und vollständig. Dann je Tabelle oder Anzeigeordner das
  TMDL, als `.txt` angehängt oder als Referenz im Copilot Notebook.
- **Weglassen:** `partition`-Blöcke (Server, SQL, SAP-Abfragen, Dataflow-IDs) und `expression`-Blöcke – im Übungsmodell **nie**
  `Daten_Fakt_Leistung` und `Daten_Massnahmen`; für reine Leseaufgaben auch `annotation`-Zeilen.
- **Zum Zurückschreiben** nur skriptierte Measures und Spalten geben (mit `lineageTag`); eine Tabelle nie ohne ihre Partition anwenden.
- **Jeden Teil kennzeichnen:** „Teil 2 von 4: Tabelle Massnahmen. Beziehungen siehe Teil 1. Nicht enthalten: Partitionen.“

### Sicherheitsregeln

- Vor jeder Änderung PBIP-Ordner kopieren oder committen (PBIX: „Speichern unter“ mit Datum).
- Kleine Schritte: ein Thema, eine Tabelle, ein Skript – anwenden, prüfen, weiter.
- Copilot-Skript vor dem Einfügen mit dem Original vergleichen (VS Code: zwei Dateien vergleichen), dann **Vorschau**.
- Nach dem Einfügen prüfen, ob Tabs ankommen – Leerzeichen aus dem Chat sind der häufigste Fehler.

## Mit Copilot arbeiten

Copilot Notebook „Modellpflege“ mit [K01](../prompts/kontext/K01_Arbeitsregeln-BI-Copilot.md), K03, K05 als Referenzen. **Mit Kapazität**
(F2+/P1+, Admin-Freigabe, keine Testkapazität) erzeugt Copilot in Power BI einzelne Beschreibungen (**Mit Copilot erstellen**).

### Aufgabe 1 · Beschreibungen, Anzeigeordner und Formatstrings für viele Measures

**Wann:** Measures ohne Beschreibung, ungeordnet im Datenbereich oder mit uneinheitlichen Formaten.

```text
Du bist Power-BI-Modellierer. Halte dich an K03 (TMDL) und K05 (Glossar).
Kontext: Skript aus der TMDL-Ansicht (createOrReplace mit ref table): [EINFÜGEN: z. B. alle Measures von Fakt_Leistung]
Ordnerplan: [EINFÜGEN: z. B. Kosten\Ist, Kosten\Abweichung, Kosten\Kennzahlen, Personal, Qualität, Maßnahmen, Zeitvergleich]
Aufgabe: Ergänze je Measure eine Beschreibung (///, höchstens 200 Zeichen: Bedeutung, Einheit, "gut ist"), einen
displayFolder aus dem Ordnerplan und vereinheitliche formatString (Euro: #,0 €, Prozent: 0.0 %).
Regeln:
- Alles andere bleibt Zeichen für Zeichen gleich: Namen, DAX, lineageTag, Einrückung mit Tabs.
- Keine neuen Objekte, keine Umbenennungen, keine Logikänderung.
- Bedeutung weder aus Glossar noch aus DAX eindeutig: Beschreibung "TODO: fachlich klären".
Ausgabe: 1. vollständiges Skript in einem ```tmdl-Block. 2. Tabelle Measure | Ordner | Format alt → neu.
3. Annahmen und offene Punkte. Wenn Informationen fehlen, frag nach.
```

**Ergebnis prüfen**
- [ ] Vergleich mit dem Original: neu sind nur `///`-, `displayFolder`- und `formatString`-Zeilen.
- [ ] `m_QQ` ist als Qualitätsquote beschrieben (Glossar), nicht aus dem Namen geraten.
- [ ] Nach **Anwenden** listet Abfrage 5 aus `INFO_Abfragen.dax` keine Measures von `Fakt_Leistung` mehr.

### Aufgabe 2 · Modellhygiene: IDs ausblenden, Aggregation, Sortierspalte

**Wann:** Sichtbare ID-Spalten werden summiert, Monatsnamen sortieren alphabetisch (Befunde F6, F7 aus Ü1.1).

```text
Du bist Power-BI-Modellierer. Halte dich an K03.
Kontext: Skript aus der TMDL-Ansicht mit diesen Spalten: [EINFÜGEN: z. B. RegionID und LeistungsartID aus Fakt_Leistung
und Massnahmen, Monatsname und MonatNr aus Kalender]
Aufgabe:
1. Fremdschlüssel in Fakt_Leistung und Massnahmen: isHidden ergänzen, summarizeBy: none.
2. Kalender[Monatsname]: sortByColumn: MonatNr; MonatNr ausblenden.
3. Begründe jede Änderung in einem Satz.
Regeln: Nur diese Eigenschaften ändern, alle übrigen Zeilen und lineageTags unverändert. Schlüssel der Dimensionstabellen
(Region[RegionID], Leistungsart[LeistungsartID]) nur summarizeBy: none, nicht ausblenden.
Ausgabe: Skript in einem ```tmdl-Block, danach Tabelle Objekt | Eigenschaft | alt | neu.
```

**Ergebnis prüfen**
- [ ] Keine Spalte, die in einer Beziehung steht, wurde umbenannt oder entfernt.
- [ ] Im Bericht sortieren Monatsnamen Januar bis Dezember.
- [ ] Abfrage 6 aus `INFO_Abfragen.dax` meldet bei F6 nur noch die Dimensionsschlüssel, bei F7 nichts mehr.

### Aufgabe 3 · Diff erklären lassen – vor dem Anwenden oder vor dem Commit

**Wann:** Ein fremdes Skript soll angewendet werden, oder Sie wollen vor dem Commit wissen, was sich wirklich geändert hat.

```text
Du bist Reviewer für Power-BI-Modelle. Unten steht ein Diff von TMDL-Dateien (Git-Diff oder Vorschau der TMDL-Ansicht).
Kontext: [EINFÜGEN: Diff-Text; Partitionen und Ausdrücke mit Verbindungsangaben vorher entfernt]
Beabsichtigt war: [EINFÜGEN: z. B. nur Beschreibungen und Anzeigeordner der Measures von Fakt_Leistung]
Aufgabe: Ordne jede Änderung einer Kategorie zu: beabsichtigt / Rauschen (annotation, Reihenfolge) / unbeabsichtigt
(Logik, Namen, gelöschte Objekte, Partitionen, Beziehungen). Belege "unbeabsichtigt" mit der Diff-Zeile.
Ausgabe: Tabelle Objekt | Änderung | Kategorie | Beleg-Zeile; darunter "Empfehlung: anwenden / nicht anwenden".
```

**Ergebnis prüfen**
- [ ] Jede Beleg-Zeile kommt im Diff wirklich vor.
- [ ] Gelöschte Objekte vollständig – Gegenprobe: Diff-Zeilen mit `-` am Anfang und `measure`, `column` oder `relationship`.

### Aufgabe 4 · Umbenennung vorbereiten (Auswirkungsanalyse)

**Wann:** Ein Name soll fachlich sprechend werden, z. B. `m_QQ` → `Qualitätsquote` (Ü1.11).

```text
Du bist Power-BI-Architekt und planst eine Umbenennung in einem produktiven Modell.
Kontext: Umbenennung [EINFÜGEN: z. B. Measure m_QQ → Qualitätsquote]; Measures als TMDL ohne Partitionen [EINFÜGEN];
Nutzung des Modells [EINFÜGEN: Berichte, Excel-Dateien, gespeicherte DAX-Abfragen, AI-Instructions, Doku].
Aufgabe: Liste alle Stellen, die den alten Namen enthalten oder enthalten könnten: DAX-Verweise im Modell (mit Measure-Name),
abhängige Artefakte außerhalb des Modells, Texte. Schreibe danach einen Ablaufplan: sichern, im Datenbereich umbenennen,
prüfen, nachziehen.
Regeln: Kein TMDL-Skript für die Umbenennung. Trenne "im TMDL belegt" von "zu prüfen".
Ausgabe: Tabelle Fundstelle | Typ | belegt/zu prüfen | Aktion; danach Ablaufplan in höchstens 8 Schritten.
```

**Ergebnis prüfen**
- [ ] DAX-Verweise stimmen mit einer Suche (Strg+F) im skriptierten Modell überein, z. B. `[m_QQ]` in `KPI Status Text`.
- [ ] Nach dem Umbenennen in Desktop: jede Berichtsseite geöffnet, kein Visual mit Fehlermeldung.

## Häufige Fehler

| Symptom | Ursache | Lösung |
|---|---|---|
| **Anwenden** meldet Einrückungs- oder Parserfehler | Leerzeichen statt Tabs nach dem Kopieren aus dem Chat | Führende Leerzeichen per Suchen/Ersetzen durch Tabs ersetzen; „Einrückung mit Tabs“ im Prompt |
| Beschreibung fehlt nach dem Anwenden, ohne Fehler | Leerzeile zwischen `///` und Objekt | Leerzeile löschen, erneut anwenden |
| `formatString` oder `displayFolder` plötzlich weg | Copilot hat Eigenschaften weggelassen; `createOrReplace` ersetzt das ganze Objekt | Original-Registerkarte anwenden, Skript vergleichen, neu beginnen |
| Visuals: „Feld kann nicht gefunden werden“ | Umbenennung im Skript | Original-Registerkarte anwenden, im Datenbereich umbenennen |
| Tabelle nach dem Anwenden leer, Aktualisierung scheitert | Tabelle ohne `partition`-Block angewendet | Partition aus dem Original ergänzen bzw. Original anwenden |
| Copilot verwendet Namen, die es nicht gibt | Nur Teil des Modells oder Beschreibung statt TMDL im Prompt | Relevantes TMDL mitgeben; „Verwende nur Namen aus dem Kontext“ |
| Neue `lineageTag`-GUIDs im Skript | Copilot hat sie erfunden | Bei neuen Objekten löschen, bei bestehenden das Original übernehmen |
| Änderungen aus VS Code erscheinen nicht in Desktop | Desktop hält das Modell im Speicher | **Externe Änderungen anwenden** bzw. Projekt neu öffnen; vorher in Desktop speichern |
| Git-Diff zeigt Hunderte geänderte Zeilen | Zeilenenden (CRLF) oder Daten in `expressions.tmdl` | `core.autocrlf` setzen; Ausdrücke mit Daten getrennt betrachten |

## Checkliste

- [ ] PBIP-Kopie oder Commit vor der Änderung, Original-Skript in eigener Registerkarte
- [ ] Prompt ohne `partition`-/`expression`-Blöcke und Verbindungsangaben; „Logik, Namen, lineageTags unverändert“ als Regel
- [ ] Copilot-Skript mit Original verglichen: nur beabsichtigte Zeilen neu
- [ ] Einrückung mit Tabs, keine Leerzeile zwischen `///` und Objekt
- [ ] **Vorschau** geprüft, dann **Anwenden**; Bereich **Probleme** leer
- [ ] Betroffene Berichtsseiten geöffnet, Abfragen 5 und 6 aus `INFO_Abfragen.dax` erneut ausgeführt
- [ ] Umbenennungen nur im Datenbereich, abhängige Berichte und Abfragen nachgezogen
- [ ] Git-Diff gelesen, Commit mit sprechender Nachricht

## Weiterführend

Microsoft Learn, geprüft am 18.11.2026:

- TMDL-Ansicht: https://learn.microsoft.com/power-bi/transform-model/desktop-tmdl-view
- TMDL-Sprache (Einrückung, Beschreibungen, Namen): https://learn.microsoft.com/analysis-services/tmdl/tmdl-overview
- TMDL-Skripte (`createOrReplace`): https://learn.microsoft.com/analysis-services/tmdl/tmdl-scripts
- Power BI-Projekte (PBIP): https://learn.microsoft.com/power-bi/developer/projects/projects-overview
- Ordner des semantischen Modells im PBIP: https://learn.microsoft.com/power-bi/developer/projects/projects-dataset
- PBIP-Dateien außerhalb von Desktop bearbeiten: https://learn.microsoft.com/power-bi/developer/projects/projects-external-editing
- Datumstabellen festlegen: https://learn.microsoft.com/power-bi/transform-model/desktop-date-tables
- Fabric-Git-Integration: https://learn.microsoft.com/fabric/cicd/git-integration/intro-to-git-integration
