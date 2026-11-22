# L01 · Power Query mit Copilot

> **Wofür:** die Regeln, die in Power Query über Laufzeit, Robustheit und richtige Zahlen entscheiden – und wie
> Copilot dabei hilft. **Für wen:** Data Analysts mit Power BI Desktop/Service, Azure SQL, Dataflows, SAP-Exporten,
> teils DirectQuery. **Bezug:** Modul 1, Ü1.4 und Ü1.8; Einzelprompts [M1-04](../prompts/modul1/M1-04_M-formatieren-kommentieren.md)
> (formatieren, kommentieren) und [M1-08](../prompts/modul1/M1-08_Fehler-beheben.md) (Fehler beheben); Grundregeln:
> [00 · Prompting](../prompts/00_Prompting-Grundregeln.md); im Notebook: [K01 · Arbeitsregeln](../prompts/kontext/K01_Arbeitsregeln-BI-Copilot.md);
> Übungsabfrage: [SAP_Export_Leistung.pq](../uebungsdaten/modul1/SAP_Export_Leistung.pq).

## Auf einen Blick

1. **Rechnen, wo die Daten liegen:** Bei SQL-Quellen faltbare Schritte (Filter, Spaltenauswahl, Gruppieren) zuerst.
2. **DirectQuery und Dual müssen vollständig falten** – ein nicht faltbarer Schritt ist dort ein Fehler, keine Bremse.
3. **Folding nachweisen**, nicht vermuten: „Native Abfrage anzeigen“ und Abfragediagnose – auch bei Copilot-Code.
4. **Jede Typumwandlung aus Text mit Kultur:** SAP-Format 1.234,56 braucht `"de-DE"`.
5. **Pfade, Server, Datenbanken als Parameter**, nie hart kodiert in Schritten.
6. **Spalten per Name, nie per Position** – die benötigten früh auswählen, Personenspalten entfernen.
7. **Schritte sprechend benennen, das Warum kommentieren.** `#"Geänderter Typ3"` ist keine Dokumentation.
8. **Fehler sichtbar lassen:** lieber eine fehlgeschlagene Aktualisierung als still verschwundene Zeilen.
9. **`Table.Buffer` ist kein Turbo:** kostet Speicher und stoppt das Folding.
10. **Gemeinsame Logik in die Quelle (View) oder einen Dataflow**, nicht in kopierte Abfragen.
11. **Datenschutzebenen setzen, nicht ignorieren** – veröffentlichte Modelle halten sich ohnehin nicht an „ignorieren“.
12. **Jede Änderung mit Alt-Neu-Vergleich testen:** Zeilen und Summen, nicht nur „kein Fehler“.

## Das Wichtigste kompakt

### Query Folding: wo gerechnet wird

Folding heißt: Power Query übersetzt die Schritte in **eine** Abfrage an die Quelle (z. B. SQL). Das geht nur bei
Quellen mit Abfrage-Engine (Azure SQL, SQL Server); CSV, Excel und Dateien auf SharePoint falten nie.
**DirectQuery/Dual:** Jeder Schritt muss falten – sonst Schritt entfernen, Logik in die Quelle oder Import.
**Import großer Tabellen:** Folding entscheidet über die Aktualisierungsdauer; der `RangeStart`/`RangeEnd`-Filter der
inkrementellen Aktualisierung muss falten, sonst wird jedes Mal alles gelesen.
**Prüfen in Desktop:** Rechtsklick auf den letzten Schritt › **Native Abfrage anzeigen** (View Native Query) –
ausgegraut bei einer SQL-Quelle heißt in der Regel: ab hier (oder früher) kein Folding. **Extras › Schritt
diagnostizieren** (Tools › Diagnose Step) zeigt die tatsächlich gesendete Abfrage. Power Query Online (Dataflows)
bietet zusätzlich Folding-Indikatoren und den Abfrageplan.

```powerquery
let
    Quelle = Sql.Database(pServer, pDatenbank),
    Leistung = Quelle{[Schema = "dbo", Item = "Leistung"]}[Data],
    #"Ab 2025" = Table.SelectRows(Leistung, each [Monat] >= #date(2025, 1, 1)),        // faltet zu WHERE
    #"Benötigte Spalten" = Table.SelectColumns(#"Ab 2025",                                // faltet zu SELECT-Liste
        {"Monat", "RegionID", "LeistungsartID", "Ist_Stunden", "Plan_Stunden", "Plan_Kosten"})
    // nicht faltbare Schritte (Text.Proper, Index …) erst ab hier
in
    #"Benötigte Spalten"
```

| Bricht Folding bei SQL-Quellen typischerweise | Besser |
|---|---|
| `Table.Buffer` | weglassen; nur Folding stoppen: `Table.StopFolding` |
| Index hinzufügen, untere Zeilen behalten (`Table.LastN`) | absteigend sortieren + obere Zeilen (`Table.FirstN`) |
| `Text.Proper`, Spalte teilen, Auffüllen, Transponieren | in die View oder ans Ende der Abfrage |
| Zusammenführen mit anderer Quelle (z. B. Excel-Mapping) | Mapping in die Datenbank oder einen Dataflow |
| eigene Funktionen / komplexe `each`-Logik je Zeile | SQL-Ausdruck in der View; einfache Arithmetik faltet oft |
| `Value.NativeQuery` ohne Option | `[EnableFolding = true]`, damit Folgeschritte falten können |

### Schritte benennen und kommentieren

Schrittnamen beschreiben die Wirkung (`#"Nur Kostenarten 6xxxxx"` statt `#"Gefilterte Zeilen1"`), `//`-Kommentare
das **Warum** (fachliche Regel, Eigenheit der Quelle). Umbenennen per Rechtsklick › **Umbenennen** zieht die Verweise
nach; im Erweiterten Editor passen Sie sie selbst an. Abfragen in Gruppen ordnen: *Parameter*, *Staging*, *Modell*,
*Prüfung*. Formatieren und Kommentieren übernimmt Copilot mit dem Prompt M1-04 (Link oben).

### Datentypen und Kultur (SAP-Exporte)

Ohne Kulturangabe wandelt Power Query mit der Kultur der Datei um (Systemeinstellung bzw. Optionen › **Regionale
Einstellungen**). Mit `"en-US"` wird „12.345,67“ zum Fehler oder falschen Wert; bei „01.10.2026“ können Tag und Monat
**still vertauscht** werden. Die Kultur gehört in den Code – dann ist egal, auf welchem Rechner jemand bearbeitet.

```powerquery
#"Typen deutsch" = Table.TransformColumnTypes(#"Spalten umbenannt",
    {{"Betrag", type number}, {"Menge", type number}, {"Buchungsdatum", type date}}, "de-DE"),  // 3. Argument = Kultur
Wert = Number.FromText("12.345,67", "de-DE"),                                                  // 12345.67
Datum = Date.FromText("15.10.2026", [Format = "dd.MM.yyyy", Culture = "de-DE"])
```

- Die automatische Typerkennung („Geänderter Typ“) wertet nur die ersten 200 Zeilen aus: Typen einmal bewusst
  festlegen; zwei Typschritte hintereinander sind ein Warnsignal.
- Negativwerte prüfen – SAP schreibt das Minus je nach Einstellung hinter die Zahl („1.234,56-“).
- Beträge `type number`/`Currency.Type`, Schlüssel `Int64.Type`, Kostenstellen mit führenden Nullen `type text`.

### Parameter statt fester Pfade und Server

**Start › Parameter verwalten:** `pServer`, `pDatenbank`, `pExportOrdner`, `pBerichtsmonat`. Im Service ändern Sie die Werte in
den Einstellungen des semantischen Modells, ohne neu zu veröffentlichen. `C:\Users\…\Desktop\…` funktioniert nur auf
einem Rechner – im Service scheitert die Aktualisierung spätestens am Gateway. Beispiel:
`Csv.Document(File.Contents(pExportOrdner & "KSB1_" & pBerichtsmonat & ".csv"), [Delimiter = ";", Encoding = 1252])`.

### Spalten per Name, früh ausgewählt, Schema geprüft

`Table.ColumnNames(t){7}` ist nach der nächsten SAP-Layoutvariante eine andere Spalte – ohne Fehlermeldung.
`Csv.Document` mit festem `Columns = 14` schneidet neue Spalten still ab. Deshalb: per Name umbenennen, die benötigten
Spalten direkt nach den Überschriften auswählen (Spalten wie „Benutzername“ fliegen raus – schützt Personendaten,
spart Speicher) und das Schema prüfen, damit eine Layoutänderung eine verständliche Meldung erzeugt:

```powerquery
Pflichtspalten = {"Kostenstelle", "Kostenart", "Buchungsdatum", "Wert/KWähr", "Menge erfasst", "ME"},
Fehlend = List.Difference(Pflichtspalten, Table.ColumnNames(#"Überschriften übernommen")),
#"Schema geprüft" = if List.IsEmpty(Fehlend) then #"Überschriften übernommen"
    else error Error.Record("Schemaabweichung", "SAP-Export: Spalten fehlen", Text.Combine(Fehlend, ", ")),
#"Benötigte Spalten" = Table.SelectColumns(#"Schema geprüft", Pflichtspalten),
#"Spalten umbenannt" = Table.RenameColumns(#"Benötigte Spalten", {{"Wert/KWähr", "Betrag"}, {"Menge erfasst", "Menge"}}),
```

### Staging, Referenzen und Dataflows

Eine **Staging-Abfrage** (z. B. `SAP_KSB1_Roh`, **Laden aktivieren** aus) liest und vereinheitlicht die Quelle; Fakt-
und Prüfabfragen verweisen darauf (Rechtsklick › **Verweis**). **Aber:** Jede verweisende Abfrage wertet sie **erneut**
aus – drei Verweise, bis zu drei Zugriffe auf die Quelle; `Table.Buffer` hilft nicht, der Puffer gilt nur innerhalb
einer Auswertung. Was mehrere Modelle brauchen (Mapping Kostenstelle → Region/Leistungsart, bereinigte SAP-Exporte),
stellen Sie einmal als **Dataflow** bereit: Dataflow Gen2 mit Fabric-/Premium-Kapazität, sonst Dataflow Gen1.

### Fehlerbehandlung: sichtbar statt verschluckt

**Schrittfehler** brechen die Abfrage ab (z. B. `Expression.Error`, Spalte nicht gefunden), **Zellfehler** stehen als
*Error* in einzelnen Zellen („n. v.“ ist keine Zahl). „Fehler entfernen“ und `otherwise null` lassen Zeilen oder Werte
verschwinden – die Summen stimmen dann nicht mehr. Wenn abfangen, dann eng und nachvollziehbar:

```powerquery
// nur diese Spalte; der Originalwert bleibt zum Prüfen erhalten
#"Betrag als Zahl" = Table.AddColumn(#"Spalten umbenannt", "Betrag_Zahl",
    each try Number.FromText([Betrag], "de-DE") otherwise null, type nullable number),
```

Dazu eine **Prüfabfrage** `Table.SelectRowsWithErrors(Fakt, {"Betrag", "Buchungsdatum"})` (wie „Fehler beibehalten“):
auf einer Prüfseite anzeigen oder vor jeder Veröffentlichung zählen. Mit `try … catch (e) => …` werten Sie
`e[Message]` aus, statt pauschal zu ersetzen.

### Performance-Mythen

| Mythos | Tatsächlich |
|---|---|
| „`Table.Buffer` macht schneller.“ | Mal ja, oft nein: liest alles in den Speicher, stoppt Folding. Sinnvoll, wenn eine kleine Tabelle in derselben Abfrage mehrfach gelesen wird (Nachschlagelisten: `List.Buffer`). |
| „Weniger Schritte = schneller.“ | Selten der Engpass. Entscheidend ist, wo Folding bricht und wie viele Zeilen danach lokal laufen. |
| „Vorschau schnell = Aktualisierung schnell.“ | Die Vorschau arbeitet mit einem Ausschnitt. Messen: Abfragediagnose oder volle Aktualisierung. |

### Datenschutzebenen

*Privat*, *Organisation*, *Öffentlich* steuern, ob Power Query Daten einer Quelle an eine andere senden darf (z. B. einen
Filterwert aus Excel an Azure SQL); einstellen unter **Datei › Optionen und Einstellungen › Datenquelleneinstellungen ›
Berechtigungen bearbeiten**. Unpassende Ebenen führen zu `Formula.Firewall`-Fehlern oder verhindern Folding. Seit
Desktop Juli 2026 dürfen Abfragen mit Verweisen bei kompatiblen Ebenen auch selbst auf Quellen zugreifen – wie im
Service (Vorschaufeature, standardmäßig aktiv). „Ebenen ignorieren“ beschleunigt nur in Desktop: veröffentlichte
Modelle halten sich nicht daran, und die Ebenen aus Desktop wandern nicht mit – im Service an Verbindung bzw. Gateway setzen.

### Änderungen absichern: Alt-Neu-Vergleich

Alte Fassung als Kopie behalten (Laden aus), dann in einer Prüfabfrage vergleichen:

```powerquery
let
    Kennzahlen = (t as table, fassung as text) as record => [Fassung = fassung, Zeilen = Table.RowCount(t),
        Ist_Kosten = Number.Round(List.Sum(t[Ist_Kosten]), 2), Ist_Stunden = Number.Round(List.Sum(t[Ist_Stunden]), 2),
        Spalten = Text.Combine(Table.ColumnNames(t), ", ")],
    Vergleich = Table.FromRecords({Kennzahlen(SAP_Export_Leistung_alt, "alt"), Kennzahlen(SAP_Export_Leistung, "neu")})
in
    Vergleich
```

## Mit Copilot arbeiten

M365 Copilot (Chat oder Notebook) sieht weder Ihre Daten noch Ihre Abfrage und führt keinen M-Code aus – Aussagen zu
Folding, Typen und Ergebnissen sind **Einschätzungen**, die Sie in Desktop prüfen. Lange Abfragen als `.txt` anhängen;
Pfade, Server und Benutzerkennungen vorher ersetzen.

### 1 · Abfrage aus dem Erweiterten Editor erklären lassen
**Wann:** Sie übernehmen ein Modell oder sollen eine gewachsene Abfrage ändern.
```text
Du bist erfahrene*r Power-Query-Entwickler*in im Produktionscontrolling. Erkläre mir diese Abfrage.
Quelle und Speichermodus: [EINFÜGEN: z. B. Azure SQL dbo.Leistung, Import | SAP-CSV-Export KSB1]
Code aus dem Erweiterten Editor: [EINFÜGEN: M-Code]
Aufgabe: 1. Was liefert die Abfrage (Granularität einer Zeile, Ergebnisspalten mit Typ)? Höchstens drei Sätze.
2. Tabelle: Schrittname | was passiert | vermuteter Zweck – unsichere Zwecke markierst du mit „unklar“.
3. Abhängigkeiten nach außen: Parameter, andere Abfragen, Pfade, Server, Kultur.
Regeln: Ändere keinen Code, erfinde keine Spalten, kennzeichne Folding-Aussagen als Einschätzung.
Ausgabe: Zusammenfassung, Tabelle, Abhängigkeiten, „Annahmen und offene Punkte“.
```
**Ergebnis prüfen:** Ergebnisspalten und Typen gegen die Vorschau des letzten Schritts; „unklar“-Schritte im Editor
anklicken. Abhängigkeiten gegen **Ansicht › Abfrageabhängigkeiten** prüfen.

### 2 · Neue Abfrage aus Spaltenliste und Beispielzeilen schreiben
**Wann:** Ein neuer SAP-Export oder eine neue Tabelle soll ins Modell.
```text
Du bist Power-Query-Entwickler*in. Schreibe eine neue M-Abfrage für Power BI Desktop.
Quelle: [EINFÜGEN: Dateityp, Trennzeichen, Kodierung, Kopfzeilen vor den Überschriften – oder Server/Schema/Tabelle]
Spaltenüberschriften (wörtlich): [EINFÜGEN: Kopfzeile]
3–5 Beispielzeilen (anonymisiert): [EINFÜGEN: Zeilen]
Ergebnis: [EINFÜGEN: z. B. je Monat × RegionID × LeistungsartID: Monat date, RegionID Int64.Type, Ist_Kosten number]
Regeln: Pfade/Server nur über die Parameter [EINFÜGEN: z. B. pExportOrdner]. Spalten nur per Name; nicht benötigte
im ersten möglichen Schritt entfernen. Typumwandlung aus Text mit Kultur "de-DE", wenn die Beispiele deutsches Format
zeigen; Negativwerte beachten. Bei SQL-Quellen faltbare Schritte zuerst. Kein Table.Buffer. Sprechende deutsche
Schrittnamen, über jedem Schritt ein //-Kommentar zum Warum.
Ausgabe: ein ```powerquery-Block, dann „Annahmen und offene Punkte“. Wenn Informationen fehlen, frag nach.
```
**Ergebnis prüfen:** In einer neuen leeren Abfrage testen; Zeilenzahl und Betragssumme gegen die Quelle (z. B. Summe
der SAP-Liste). Sonderfälle: Negativwerte, leere Zellen, führende Nullen, Datumswerte nach dem 12. Tag.

### 3 · Refaktorisieren ohne Logikänderung
**Wann:** Die Abfrage läuft, ist aber nicht wartbar (feste Pfade, Positionszugriffe, doppelte Typschritte).
```text
Du bist Power-Query-Entwickler*in. Refaktoriere die Abfrage, ohne ihr Ergebnis zu ändern.
Code: [EINFÜGEN: M-Code]
Festes Ausgabeschema (Name, Typ, Reihenfolge): [EINFÜGEN: Spaltenliste]
Umsetzen: feste Pfade/Server → Parameter [EINFÜGEN: Namen]; Positionszugriffe → Namen; doppelte Typschritte
zusammenfassen; Spaltenauswahl und Filter so früh wie möglich; sprechende Schrittnamen und //-Kommentare.
Regeln: gleiche Zeilen, gleiche Werte, gleiches Schema. Alles, was das Ergebnis ändern könnte (andere Kultur,
anderer Filter), setzt du NICHT um, sondern listest es getrennt auf.
Ausgabe: ```powerquery-Block, Tabelle „Änderung | Begründung | Risiko“, „Annahmen und offene Punkte“.
```
**Ergebnis prüfen:** Alt-Neu-Vergleich (oben): Zeilen, Summen und Spaltenliste identisch; abhängige Abfragen laden
weiter. Bei SQL-Quellen: „Native Abfrage anzeigen“ – Folding darf nicht schlechter geworden sein.

### 4 · Fehlermeldung diagnostizieren
**Wann:** Die Aktualisierung bricht ab, oft nach neuem Export. Langfassung: [M1-08](../prompts/modul1/M1-08_Fehler-beheben.md).
```text
Power-Query-Fehler bei der Aktualisierung in [EINFÜGEN: Desktop / Service / Dataflow].
Meldung wörtlich mit Details: [EINFÜGEN: Fehlertext]   Schritt laut Editor: [EINFÜGEN: Schrittname]
Code: [EINFÜGEN: M-Code]
Kopfzeile bzw. Schema der Quelle, alt und neu: [EINFÜGEN: Spaltenlisten]   Zuletzt geändert: [EINFÜGEN: oder „unbekannt“]
Aufgabe: 1. Zerlege die Meldung (Fehlergrund vor dem Doppelpunkt, Meldung, Details) und übersetze sie in einen Satz.
2. Wahrscheinlichste Ursache mit Beleg aus Code oder Kopfzeile, bis zu zwei Alternativen. 3. Kleinstmögliche
Korrektur als vollständiger Code. 4. Wie die Abfrage die nächste Layoutänderung klar meldet statt still falsch zu rechnen.
Regeln: Erst Diagnose, dann Lösung. Keine Korrektur, die Fehler per try … otherwise oder „Fehler entfernen“ verschluckt.
```
**Ergebnis prüfen:** Nach der Korrektur kann der nächste Schritt scheitern: bis zum letzten Schritt durchklicken.
Summen gegen Vormonat bzw. Quelle; trat der Fehler im Service auf, dort erneut aktualisieren (Gateway, Pfade).

### 5 · Prüfen lassen, welche Schritte Folding brechen
**Wann:** Die Aktualisierung aus Azure SQL dauert, oder eine DirectQuery-Tabelle meldet einen Fehler.
```text
Du bist Expert*in für Query Folding in Power Query. Quelle: [EINFÜGEN: Azure SQL Database / SQL Server]
Speichermodus: [EINFÜGEN: Import / DirectQuery / Dual]; Zeilen in der Quelle: [EINFÜGEN: ca.]
Code: [EINFÜGEN: M-Code]
Beobachtung: „Native Abfrage anzeigen“ ist ab Schritt [EINFÜGEN: Schrittname] ausgegraut.
Aufgabe: 1. Tabelle: Schritt | faltet voraussichtlich (ja / nein / unsicher) | Begründung (M-Funktion, SQL-Gegenstück).
2. Erster Schritt, ab dem Folding voraussichtlich bricht – und warum. 3. Umbau mit gleichem Ergebnis: Reihenfolge
ändern, faltbare Alternative oder Verlagerung in eine SQL-View.
Regeln: Alles ist Einschätzung, ich prüfe in Desktop. Erfinde keine M-Funktionen oder Optionen.
Ausgabe: Tabelle, Befund, umgebauter Code als ```powerquery-Block, „Annahmen und offene Punkte“.
```
**Ergebnis prüfen:** „Native Abfrage anzeigen“ am **letzten** Schritt: Das SQL enthält Filter und Spaltenauswahl.
**Extras › Schritt diagnostizieren:** gesendete Abfrage und Dauer; Alt-Neu-Vergleich für das Ergebnis.

### 6 · SQL-View oder M? Logik in die Quelle schieben
**Wann:** große SQL-Tabellen, DirectQuery, dieselbe Logik in mehreren Modellen, oder ein Schritt faltet partout nicht.
SQL-Entwurf danach mit [M1-05](../prompts/modul1/M1-05_SQL-formatieren-kommentieren.md) formatieren.
```text
Entscheide mit mir, wo diese Transformationslogik hingehört: in eine View in Azure SQL oder in Power Query.
Quelltabellen, Datenmenge, Indizes: [EINFÜGEN: z. B. dbo.SAP_Kosten, ca. 40 Mio. Zeilen, Index auf Kostenstelle, Buchungsdatum]
Speichermodus und Aktualisierung: [EINFÜGEN: Import täglich / DirectQuery / inkrementell]
Weitere Nutzer der Logik: [EINFÜGEN: Modelle, Dataflows, Excel]   Rechte / wer Views anlegt: [EINFÜGEN: Rolle/Team]
Aktuelle M-Schritte: [EINFÜGEN: M-Code]
Aufgabe: 1. Bewerte jeden Schritt: View | M | egal – Begründung (Folding, Wiederverwendung, Wartung, Rechte).
2. T-SQL-Entwurf für die View-Kandidaten (explizite Spaltenliste) und die verbleibende M-Abfrage.
3. Was ändert sich für Aktualisierungsdauer, DirectQuery und inkrementelle Aktualisierung?
Regeln: Nur Tabellen und Spalten aus dem Kontext. Filter so formulieren, dass Indizes greifen können.
Ausgabe: Bewertungstabelle, ```sql-Block, ```powerquery-Block, „Annahmen und offene Punkte“.
```
**Ergebnis prüfen:** View-Ergebnis (Zeilen, Summen je Monat) gegen das bisherige M-Ergebnis, bevor Sie umstellen.
Laufzeit der View von der Datenbankseite prüfen lassen; Zuständigkeit und Versionierung der View klären.

### Ausblick: Copilot in Dataflow Gen2 (Fabric)

In Dataflow Gen2 arbeitet Copilot direkt im Power-Query-Editor: Er liest die tatsächliche Abfrage samt Schritten,
erklärt Abfragen oder einzelne Schritte und legt Transformationen aus natürlicher Sprache als normale Schritte an
(neue Oberfläche in der Vorschau). Voraussetzung: Arbeitsbereich auf bezahlter Fabric- oder Premium-Kapazität
(F2+/P1+, keine Testkapazität) und Admin-Freigabe. Erzeugte Schritte prüfen Sie wie jeden anderen Code.
Ohne Kapazität bleibt der Weg über M365 Copilot mit den Prompts oben.

## Häufige Fehler

| Symptom | Ursache | Lösung |
|---|---|---|
| Beträge falsch skaliert, Datum ab dem 13. fehlerhaft (davor still vertauscht) | Kultur `en-US`/Systemkultur auf deutschem Format | Typänderung mit `"de-DE"`, Summe gegen SAP-Liste |
| `Expression.Error: Die Spalte „…“ … wurde nicht gefunden` | neue SAP-Layoutvariante; feste Spaltenliste im Auto-Typschritt | Schemaprüfung, Auswahl per Name, Auto-Typschritt ersetzen |
| `Formula.Firewall: …` | Datenschutzebenen inkompatibel bzw. alte Desktop-Version | Ebenen setzen, Desktop aktualisieren, Staging-Abfrage |
| DirectQuery: Schritt nicht unterstützt / Abfrage zu komplex | nicht faltbarer Schritt | Schritt entfernen, Logik in View oder Import |
| Desktop schnell, Service langsam oder Zeitüberschreitung | Folding bricht früh; Vorschau nur Ausschnitt; „ignorieren“ nur lokal | Native Abfrage und Diagnose prüfen, Schritte umordnen |
| Summen kleiner als in SAP, keine Meldung | „Fehler entfernen“/`otherwise null` verschluckt Werte | Prüfabfrage `Table.SelectRowsWithErrors`, Fehlerzeilen zählen |
| Service: `DataSource.NotFound` | lokaler Pfad `C:\Users\…` | Parameter, SharePoint/Freigabe, Gateway |

## Checkliste vor dem Veröffentlichen

- [ ] Die zwölf Punkte aus „Auf einen Blick“ erfüllt – jede Ausnahme im Code kommentiert (z. B. `Table.Buffer`).
- [ ] Keine festen Pfade, Server, Datenbanken; jede Typumwandlung aus Text mit Kultur, keine doppelten Typschritte.
- [ ] SQL-Quellen: „Native Abfrage anzeigen“ am letzten Schritt geprüft; DirectQuery und `RangeStart`/`RangeEnd` falten.
- [ ] Staging-Abfragen mit „Laden aktivieren“ aus; Abfragen in Gruppen; gemeinsame Logik in View oder Dataflow.
- [ ] Fehlerzeilen geprüft (Anzahl bekannt und erklärt), nichts still verschluckt.
- [ ] Datenschutzebenen im Service an Verbindung/Gateway gesetzt.
- [ ] Alt-Neu-Vergleich gelaufen; Copilot-Code in Desktop getestet, jede Funktion steht in der M-Referenz.

## Weiterführend

- Folding: [Leitfaden Power BI Desktop](https://learn.microsoft.com/power-bi/guidance/power-query-folding) · [Grundlagen](https://learn.microsoft.com/power-query/query-folding-basics) · [Abfragediagnose](https://learn.microsoft.com/power-query/query-diagnostics) · [native Abfragen](https://learn.microsoft.com/power-query/native-query-folding) · [DirectQuery](https://learn.microsoft.com/power-bi/connect-data/desktop-directquery-about)
- Grundlagen: [Best Practices](https://learn.microsoft.com/power-query/best-practices) · [Datentypen und Gebietsschema](https://learn.microsoft.com/power-query/data-types) · [Table.TransformColumnTypes](https://learn.microsoft.com/powerquery-m/table-transformcolumntypes) · [Parameter](https://learn.microsoft.com/power-query/power-query-query-parameters) · [Verweisende Abfragen](https://learn.microsoft.com/power-bi/guidance/power-query-referenced-queries)
- Fehler, Performance, Datenschutz: [Umgang mit Fehlern](https://learn.microsoft.com/power-query/dealing-with-errors) · [try/otherwise/catch](https://learn.microsoft.com/power-query/error-handling) · [Table.Buffer](https://learn.microsoft.com/powerquery-m/table-buffer) · [Datenschutzebenen](https://learn.microsoft.com/power-query/privacy-levels) · [Firewall ab Desktop Juli 2026](https://learn.microsoft.com/power-bi/transform-model/desktop-data-privacy-firewall-partitions)
- Copilot und Referenz: [Copilot in Dataflow Gen2](https://learn.microsoft.com/fabric/data-factory/copilot-fabric-data-factory) · [Copilot für Power BI – Voraussetzungen](https://learn.microsoft.com/power-bi/create-reports/copilot-introduction) · [M-Funktionsreferenz](https://learn.microsoft.com/powerquery-m/)
