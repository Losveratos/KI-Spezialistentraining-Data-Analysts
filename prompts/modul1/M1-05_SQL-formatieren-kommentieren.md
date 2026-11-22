# M1-05 · SQL formatieren, kommentieren und Schwachstellen finden

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | M365 Copilot Chat oder Notebook (Test in SSMS oder VS Code mit MSSQL-Erweiterung) | Ü1.5 | 12 min |

## Wofür
Views und Abfragen, die Power-BI-Berichte speisen – besonders per DirectQuery –, bestimmen Ladezeit und
Richtigkeit. Copilot formatiert und kommentiert die View und benennt Muster, die bei großen Tabellen teuer
oder riskant sind (nicht sargable Filter, implizite Konvertierung, `NOLOCK`, korrelierte Unterabfragen).

## Vorbereitung
- View-Definition kopieren (SSMS: Rechtsklick › Skript für Sicht als › CREATE). Übung: `uebungsdaten/modul1/Azure_SQL_View_Leistung.sql`.
- **Tabellenstruktur mitgeben** (Spalten mit Datentypen, vorhandene Indizes) – ohne sie kann Copilot implizite
  Konvertierungen und Index-Nutzung nur raten. In der Übungsdatei steht sie als Kommentar im Kopf.
- Optional: wie die View genutzt wird (Import oder DirectQuery, typische Filter im Bericht).
- Datenschutz: keine Servernamen, Benutzernamen oder Beispieldaten mit Personenbezug einfügen; unternehmensfreigegebenen Copilot nutzen.

## Prompt
```text
Du bist T-SQL-Entwickler für Azure SQL Database und optimierst Views, die Power-BI-Berichte speisen.

Kontext:
- Nutzung der View: [EINFÜGEN: z. B. DirectQuery aus Power BI, Bericht filtert nach Monat und Region]
- Tabellenstruktur und Indizes: [EINFÜGEN: Spalten mit Datentypen, Indizes, Zeilenzahlen]
- View-Definition:
[EINFÜGEN: SQL-Code]

Aufgabe in drei Teilen:
Teil A – Formatieren und kommentieren, Logik unverändert: Schlüsselwörter groß, ein Element je Zeile in SELECT,
Tabellenaliase sprechend, Kommentar (--) über jedem logischen Block mit Zweck.
Teil B – Schwachstellen, je Punkt: Stelle im Code, Problem, Auswirkung (Performance, Richtigkeit, Datenschutz,
Wartbarkeit), Schweregrad. Prüfe ausdrücklich: SELECT *, NOLOCK, Funktionen auf Spalten in WHERE/JOIN
(Sargability), implizite Konvertierung durch unterschiedliche Datentypen, wiederholte korrelierte Unterabfragen,
ORDER BY in einer View, hart kodierte Jahre.
Teil C – Verbesserte Fassung als CREATE OR ALTER VIEW mit identischen Ausgabespalten und Datentypen.

Regeln:
- Nur Spalten und Tabellen aus Code und Tabellenstruktur verwenden.
- Jede Aussage zur Performance mit Begründung (welcher Index kann wie genutzt werden).
- Liste in Teil C jede Stelle, an der sich das Ergebnis gegenüber dem Original ändern kann.

Ausgabe: Teil A und C als ```sql-Blöcke, Teil B als Tabelle, danach „Annahmen und offene Punkte“.
Wenn Informationen fehlen, frag nach statt zu raten.
```

## Nachschärfen
Wenn Sie die neue Fassung absichern wollen:
```text
Schreib eine Testabfrage, die alte und neue View (alte als dbo.vw_Leistung_PowerBI_alt) je Monat und Kostenstelle
vergleicht und nur Zeilen mit Abweichungen bei Ist_Kosten, Abw_Kosten oder Zeilenanzahl ausgibt (EXCEPT oder FULL OUTER JOIN).
```
Wenn Copilot `NOLOCK` nur als „schlechte Praxis“ abtut:
```text
Erkläre konkret, welche falschen Ergebnisse NOLOCK in einem Bericht verursachen kann (fehlende oder doppelte Zeilen,
nicht festgeschriebene Daten) und welche Alternative es in Azure SQL Database gibt (READ_COMMITTED_SNAPSHOT).
```
Wenn Sie die View für DirectQuery bewerten wollen:
```text
Power BI legt bei DirectQuery eigene SELECT-Abfragen mit WHERE und GROUP BY um diese View. Welche Teile der View
verhindern, dass solche Filter effizient bis auf die Basistabellen durchgereicht werden?
```

## Ergebnis prüfen
- [ ] Teil A: identische Ergebnisse (gleiche Zeilenzahl, gleiche Summe `Ist_Kosten`) in einer Testdatenbank – nicht in Produktion anlegen.
- [ ] Teil C: Vergleichsabfrage ohne Abweichungen, oder jede Abweichung ist erklärt (z. B. Fehler im Original).
- [ ] Ausführungsplan alt/neu vergleichen (geschätzter Plan in SSMS): Index Seek statt Scan, keine Warnung zu `CONVERT_IMPLICIT`.
- [ ] Keine erfundenen Spalten (z. B. `Region_Name`, `Kosten`), Datentypen passen zur Tabellenstruktur.
- [ ] `SELECT *` ist durch eine explizite Spaltenliste ersetzt – ohne Spalten mit Personenbezug, die der Bericht nicht braucht.

## Stolperfallen
- Ohne Tabellenstruktur „findet“ Copilot implizite Konvertierungen, die es nicht gibt, oder übersieht die echten.
- `TOP 100 PERCENT … ORDER BY` in einer View garantiert keine Sortierung; sortiert wird in der Abfrage bzw. im Bericht.
- Optimierungsvorschläge wie neue Indizes sind Hypothesen – mit Ausführungsplan und DBA abstimmen.
- Bei DirectQuery zählt nicht nur die View: Power BI erzeugt die eigentlichen Abfragen. Testen Sie mit den Filtern des Berichts.
