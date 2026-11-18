// Übungsdatei Modul 1 – Power-Query-Abfrage "SAP_Export_Leistung" (fiktiv, DBS Training)
// Liest einen CSV-Export der SAP-CO-Einzelposten (Kostenstellen Ist, Transaktion KSB1)
// und verdichtet ihn auf Monat × Region × Leistungsart.
//
// Aufbau der Exportdatei (Semikolon, Windows-1252, deutsches Zahlen- und Datumsformat):
//   Zeile 1–3: SAP-Kopfzeilen ("Kostenstellen: Ist-Einzelposten", Selektionsdatum, Leerzeile)
//   Zeile 4:   Spaltenüberschriften
//   Kostenstelle;Kostenstellenbez.;Kostenart;Kostenartenbez.;Buchungsdatum;Periode;Geschäftsjahr;
//   Wert/KWähr;KWähr;Menge erfasst;ME;Belegnummer;Bezeichnung;Partnerobjekt
//   Beispielzeile:
//   4101100;Fahrzeugreinigung Ost;620000;Löhne gewerblich;15.10.2026;10;2026;12.345,67;EUR;412,5;STD;100045871;Lohn Okt;
//
// Die Abfrage "funktioniert" – sie ist aber so gebaut, wie sie in der Praxis oft entsteht.
// Aufgabe in Ü1.4: von Copilot formatieren, kommentieren und Schwachstellen benennen lassen.

let
    Quelle = Csv.Document(File.Contents("C:\Users\a123456\Desktop\SAP_Exporte\KSB1_Okt2026_final_NEU.csv"),[Delimiter=";", Columns=14, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Entfernte oberste Zeilen" = Table.Skip(Quelle,3),
    #"Höher gestufte Header" = Table.PromoteHeaders(#"Entfernte oberste Zeilen", [PromoteAllScalars=true]),
    #"Geänderter Typ" = Table.TransformColumnTypes(#"Höher gestufte Header",{{"Kostenstelle", type text}, {"Kostenstellenbez.", type text}, {"Kostenart", Int64.Type}, {"Kostenartenbez.", type text}, {"Buchungsdatum", type text}, {"Periode", Int64.Type}, {"Geschäftsjahr", Int64.Type}, {"Wert/KWähr", type text}, {"KWähr", type text}, {"Menge erfasst", type text}, {"ME", type text}, {"Belegnummer", Int64.Type}, {"Bezeichnung", type text}, {"Partnerobjekt", type text}}),
    #"Gepufferte Tabelle" = Table.Buffer(#"Geänderter Typ"),
    #"Umbenannte Spalten" = Table.RenameColumns(#"Gepufferte Tabelle",{{Table.ColumnNames(#"Gepufferte Tabelle"){7}, "Betrag"}, {Table.ColumnNames(#"Gepufferte Tabelle"){9}, "Menge"}}),
    #"Geänderter Typ1" = Table.TransformColumnTypes(#"Umbenannte Spalten",{{"Betrag", type number}, {"Menge", type number}, {"Buchungsdatum", type date}}, "en-US"),
    #"Geänderter Typ2" = Table.TransformColumnTypes(#"Geänderter Typ1",{{"Betrag", type number}, {"Kostenstelle", type text}, {"Kostenart", Int64.Type}}),
    #"Hinzugefügte benutzerdefinierte Spalte" = Table.AddColumn(#"Geänderter Typ2", "Monat", each #date(Date.Year([Buchungsdatum]), Date.Month([Buchungsdatum]), 1)),
    #"Zusammengeführte Abfragen" = Table.NestedJoin(#"Hinzugefügte benutzerdefinierte Spalte", {"Kostenstelle"}, Kostenstellen_Mapping, {"Kostenstelle"}, "Kostenstellen_Mapping", JoinKind.LeftOuter),
    #"Erweiterte Kostenstellen_Mapping" = Table.ExpandTableColumn(#"Zusammengeführte Abfragen", "Kostenstellen_Mapping", {"RegionID", "LeistungsartID"}, {"RegionID", "LeistungsartID"}),
    #"Gepufferte Tabelle1" = Table.Buffer(#"Erweiterte Kostenstellen_Mapping"),
    #"Gefilterte Zeilen" = Table.SelectRows(#"Gepufferte Tabelle1", each [Geschäftsjahr] = 2026 and [Kostenart] >= 600000 and [Kostenart] < 700000 and [RegionID] <> null),
    #"Hinzugefügte Stunden" = Table.AddColumn(#"Gefilterte Zeilen", "Stunden", each if Record.Field(_, Table.ColumnNames(#"Gefilterte Zeilen"){10}) = "STD" then [Menge] else 0),
    #"Gruppierte Zeilen" = Table.Group(#"Hinzugefügte Stunden", {"Monat", "RegionID", "LeistungsartID"}, {{"Ist_Kosten", each List.Sum([Betrag]), type number}, {"Ist_Stunden", each List.Sum([Stunden]), type number}}),
    #"Geänderter Typ3" = Table.TransformColumnTypes(#"Gruppierte Zeilen",{{"Monat", type date}, {"RegionID", Int64.Type}, {"LeistungsartID", Int64.Type}})
in
    #"Geänderter Typ3"
