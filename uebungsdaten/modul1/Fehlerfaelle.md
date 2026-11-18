# Fehlerfälle für Ü1.8 – Fehlerbehebung mit Copilot

Vier Fehler, wie sie im Alltag mit dem Übungsmodell `DBS_Produktionscontrolling` auftreten.
Je Fall: wo der Fehler auftaucht, der Code und die Meldung, wie Power BI Desktop (deutsche Oberfläche)
sie anzeigt. Der genaue Wortlaut kann je nach Desktop-Version leicht abweichen.

Die Lösungen stehen **nicht** hier; wir besprechen sie in Übung Ü1.8.

---

## Fall A – Neues Measure „Kosten je Leistungseinheit“

**Wo:** Berichtsansicht › Neues Measure in Tabelle `Fakt_Leistung`. Die Bearbeitungsleiste zeigt den Fehler
sofort nach dem Bestätigen.

```dax
Kosten je Leistungseinheit =
Fakt_Leistung[Ist_Kosten] / Fakt_Leistung[Leistungseinheiten]
```

**Meldung:**

```text
Ein einzelner Wert für die Spalte "Ist_Kosten" in der Tabelle "Fakt_Leistung" kann nicht ermittelt
werden. Dies kann vorkommen, wenn eine Measureformel auf eine Spalte verweist, die viele Werte enthält,
ohne eine Aggregation wie "min", "max", "count" oder "sum" anzugeben, um ein einzelnes Ergebnis zu erhalten.
```

---

## Fall B – Measure „Ist Kosten 2026“

**Wo:** Neues Measure in `Fakt_Leistung`. Das Measure wird angelegt, das Visual zeigt danach
„Fehler beim Abrufen der Daten für dieses Visual“; unter „Details anzeigen“ steht:

```dax
Ist Kosten 2026 =
CALCULATE ( [Ist Kosten], Kalender[Jahr] = "2026" )
```

**Meldung:**

```text
Bei DAX-Vergleichsvorgängen werden keine Vergleiche von Werten des Typs "Integer" mit Werten des Typs
"Text" unterstützt. Verwenden Sie ggf. die Funktion VALUE oder FORMAT, um einen der Werte zu konvertieren.
```

---

## Fall C – Aktualisierung der SAP-Abfrage schlägt fehl

**Wo:** Start › Aktualisieren. Die Abfrage `SAP_Export_Leistung` (siehe `SAP_Export_Leistung.pq`)
lief im September fehlerfrei. Für Oktober wurde ein neuer Export mit einer geänderten SAP-Layoutvariante
gezogen. Im Aktualisierungsdialog erscheint:

```text
SAP_Export_Leistung
Expression.Error: Die Spalte "Kostenstellenbez." der Tabelle wurde nicht gefunden.
Details:
    Kostenstellenbez.
```

Kopfzeile des neuen Exports (Zeile 4 der CSV-Datei):

```text
Kostenstelle;Bezeichnung Kostenstelle;Kostenart;Kostenartenbez.;Buchungsdatum;Periode;Geschäftsjahr;Wert/KWähr;KWähr;Menge erfasst;ME;Belegnummer;Bezeichnung;Partnerobjekt;Benutzername
```

Betroffener Schritt (aus der Abfrage):

```powerquery
#"Geänderter Typ" = Table.TransformColumnTypes(#"Höher gestufte Header",{{"Kostenstelle", type text}, {"Kostenstellenbez.", type text}, {"Kostenart", Int64.Type}, {"Kostenartenbez.", type text}, {"Buchungsdatum", type text}, {"Periode", Int64.Type}, {"Geschäftsjahr", Int64.Type}, {"Wert/KWähr", type text}, {"KWähr", type text}, {"Menge erfasst", type text}, {"ME", type text}, {"Belegnummer", Int64.Type}, {"Bezeichnung", type text}, {"Partnerobjekt", type text}}),
```

---

## Fall D – Monatsnamen sortieren

**Wo:** Copilot hat vorgeschlagen, für die Sortierung der Monatsnamen eine berechnete Spalte anzulegen.
Die Spalte wird angelegt. Beim Versuch, `Kalender[Monatsname]` über **Spaltentools › Nach Spalte sortieren**
nach `MonatSort` zu sortieren, erscheint:

```dax
MonatSort =
MONTH ( DATEVALUE ( "1. " & Kalender[Monatsname] & " 2026" ) )
```

**Meldung:**

```text
Es wurde eine zirkuläre Abhängigkeit erkannt: Kalender[MonatSort], Kalender[Monatsname], Kalender[MonatSort].
```

---

## Wie Sie die Fälle an Copilot geben

Pro Fall: Prompt **M1-08** verwenden, Code und Meldung vollständig einfügen. Für Fall A, B und D
zusätzlich das TMDL der betroffenen Tabelle (TMDL-Ansicht › Tabelle in den Editor ziehen;
Partition weglassen). Für Fall C die alte und die neue Kopfzeile.
