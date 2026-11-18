# K03 · TMDL-Kurzreferenz

> **Wie nutzen?** An Prompts anhängen, in denen Copilot TMDL lesen oder schreiben soll
> (Beschreibungen ergänzen, Measures anlegen, Modell dokumentieren). Copilot kennt TMDL,
> verwechselt aber gern Details – diese Seite hält es auf Spur.

---

## Was ist TMDL?

**Tabular Model Definition Language**: das Power-BI-Datenmodell als lesbarer Text. Jede Tabelle, Spalte,
jedes Measure, jede Beziehung steht dort mit Namen, Ausdruck und Eigenschaften.

Für KI ist das der Schlüssel: Statt das Modell zu beschreiben, geben Sie Copilot **das Modell selbst** –
mit exakten Namen, Datentypen, Beziehungen und DAX-Ausdrücken. Halluzinierte Spaltennamen werden
dadurch selten, und Copilot kann Änderungen direkt als TMDL zurückgeben.

**Wo finde ich es?**
- Power BI Desktop → **TMDL-Ansicht** (linke Leiste): Objekte aus dem Datenbereich auf die Arbeitsfläche
  ziehen → Skript entsteht → kopieren. Geänderte Skripte dort mit **Anwenden** zurückschreiben.
- PBIP-Projekt: Ordner `<Name>.SemanticModel/definition/` mit `model.tmdl`, `relationships.tmdl`,
  `tables/<Tabelle>.tmdl`.

## Syntax in fünf Regeln

1. **Einrückung trägt die Struktur** (Tabs). Kindobjekte sind eine Ebene tiefer eingerückt als ihr Elternobjekt.
2. Objekt = Schlüsselwort + Name: `table Fakt_Leistung`, `measure 'Ist Kosten' = …`, `column Monat`.
3. Namen mit Leer- oder Sonderzeichen in einfache Anführungszeichen: `'Abw Kosten %'`.
4. Eigenschaften als `name: wert` eine Ebene unter dem Objekt; Ausdrücke nach `=`, mehrzeilig eingerückt.
5. Beschreibungen stehen als `///`-Kommentar **direkt** über dem Objekt – ohne Leerzeile dazwischen.

## Beispiel

```tmdl
table Fakt_Leistung

	/// Abweichung der Ist- von den Plankosten in Prozent der Plankosten.
	measure 'Abw Kosten %' = DIVIDE ( [Abw Kosten], [Plan Kosten] )
		formatString: 0.0 %
		displayFolder: Kosten\Abweichung

	/// Monat der Leistungserbringung (Monatserster). Verknüpft mit Kalender[Datum].
	column Monat
		dataType: dateTime
		formatString: MM.yyyy
		summarizeBy: none
		sourceColumn: Monat

	column RegionID
		dataType: int64
		isHidden
		summarizeBy: none
		sourceColumn: RegionID
```

Beziehung (in `relationships.tmdl` bzw. als eigenes Objekt):

```tmdl
relationship Fakt_Leistung_Region
	fromColumn: Fakt_Leistung.RegionID
	toColumn: Region.RegionID
```

## Häufige Eigenschaften

| Eigenschaft | Wofür | Hinweis |
|---|---|---|
| `formatString` | Zahlenformat | im TMDL mit Punkt als Dezimaltrenner (`0.0 %`), Anzeige folgt der Kultur |
| `displayFolder` | Anzeigeordner | Unterordner mit Backslash: `Kosten\Abweichung` |
| `isHidden` | im Bericht ausblenden | z. B. für ID-Spalten |
| `summarizeBy` | Standard-Aggregation | IDs, Jahre, Nummern: `none` |
| `sortByColumn` | Sortierspalte | Name mit Leerzeichen in Anführungszeichen: `sortByColumn: 'Monat Nr'` |
| `dataCategory` | Kategorie | Kalender als Datumstabelle: an der Tabelle `dataCategory: Time`, an der Datumsspalte `isKey` (einfacher: in Desktop „Als Datumstabelle markieren“) |
| `lineageTag` | interne ID | **nicht** von Copilot erfinden lassen – bei neuen Objekten weglassen, Desktop vergibt sie |

## Stolperfallen beim Schreiben mit Copilot

- **Einrückung** geht beim Kopieren aus dem Chat gern verloren (Leerzeichen statt Tabs). Die TMDL-Ansicht
  meldet dann einen Fehler beim Anwenden – Einrückung prüfen.
- **Leerzeile** zwischen `///` und Objekt → Beschreibung geht verloren.
- Copilot erfindet `lineageTag`-GUIDs oder Eigenschaften, die es nicht gibt. Regel im Prompt:
  „Keine lineageTags, nur Eigenschaften aus der Kurzreferenz.“
- Eine Sortierspalte darf nicht aus der Spalte berechnet werden, die sie sortiert (Ringabhängigkeit).
- Immer erst einen **kleinen Ausschnitt** zurückschreiben und anwenden, nicht das ganze Modell.
- Vor dem Anwenden größerer Änderungen: Datei sichern (PBIX/PBIP-Kopie).
