# Modul 3 · Übungen – Microsoft Copilot und Office: Funktionen und Datenvalidierung

Alle Übungen arbeiten mit den Dateien in `uebungsdaten/modul3/` (Beschreibung dort in der
[README](../uebungsdaten/modul3/README.md)). Die Prompts stehen in `prompts/modul3/`, die Kontextdateien in
`prompts/kontext/`. Die Lösungen besprechen wir gemeinsam im Training.

> **Datenschutz (gilt für alle Übungen):** Nur im freigegebenen Unternehmens-Copilot arbeiten (Anmeldung mit
> Unternehmenskonto). Keine personenbezogenen Daten einfügen oder anhängen. Die Übungsdaten sind fiktiv.

> **Kein Zugang zu einer Funktion?** Jede Übung nennt einen Weg mit dem normalen Copilot-Chat und angehängter Datei.
> Eigene Agenten werden nicht benötigt und nicht erstellt.

## Überblick

| Übung | Thema | Prompt | Datei | Zeit |
|---|---|---|---|---|
| Ü3.1 | Chat, Notizbuch oder Agent? Bestandsaufnahme und Notizbuch einrichten | M3-01, M3-02 | Kontextdateien | 12 min |
| Ü3.2 | Agenten im Einsatz: Researcher und Analyst | M3-03, M3-04 | `Kennzahlen_Okt-2026.xlsx` | 12 min |
| Ü3.3 | Excel: strukturierte Analyse | M3-05 | `Kennzahlen_Okt-2026.xlsx` | 12 min |
| Ü3.4 | Excel: Validierung gegen einen Regelkatalog | M3-06, M3-07 | `Leistungsnachweise_Export_Okt-2026.xlsx` | 18 min |
| Ü3.5 | Office-Dateien gegeneinander prüfen | M3-08 | `Monatsbericht_Okt-2026_Entwurf.pptx`, `Kennzahlen_Okt-2026.xlsx` | 12 min |
| Ü3.6 | Von Excel zu PowerPoint | M3-09, M3-10 | `Kennzahlen_Okt-2026.xlsx` | 12 min |
| Zusatz | [Excel mit Copilot – acht Übungsfälle](Modul3_Excel-Faelle.md) (Formeln, Formatieren, SVERWEIS, Kreuztabelle …) | M3-05, M3-07 | `Excel-Copilot_Uebungsfaelle.xlsx` | je 8–12 min |

---

## Ü3.1 · Chat, Notizbuch oder Agent? (12 min)

**Ziel:** Sie wissen, welche Copilot-Funktionen Ihnen zur Verfügung stehen, und richten ein Notizbuch ein, das Sie
für den Rest des Moduls nutzen.

**Schritte**
1. Bestandsaufnahme: Öffnen Sie Microsoft 365 Copilot. Welche Bereiche sehen Sie (Chat, Notizbücher, Agenten)?
   Welche Agenten sind aufgeführt? Notieren Sie die Namen im Chat des Trainings.
2. Entscheidungshilfe aus **M3-01** lesen: Für welche Ihrer wiederkehrenden Aufgaben passt welche Funktion?
   Nennen Sie je ein eigenes Beispiel für Einzelchat, Notizbuch und Agent.
3. Notizbuch „Kennzahlen Oktober 2026“ nach **M3-02** anlegen. Als Referenzen hinzufügen:
   `K04_Kommentar-Leitfaden-KPI.md`, `K05_Kennzahlen-Glossar.md` und `Kennzahlen_Okt-2026.xlsx`.
4. Testfrage im Notizbuch: „Welche Region weicht im Oktober am stärksten vom Plan ab? Nenne Wert und Quelle.“
5. Dieselbe Frage in einem neuen Einzelchat **ohne** Anhang stellen. Was ist der Unterschied?

**Erwartetes Ergebnis:** Eine Liste Ihrer verfügbaren Agenten, ein Notizbuch mit drei Referenzen und eine Antwort
mit Quellenangabe – im Einzelchat ohne Anhang dagegen eine Rückfrage oder eine erfundene Antwort.

**Ohne Notizbücher:** Neuer Einzelchat, die drei Dateien anhängen, dann Schritt 4.

## Ü3.2 · Agenten im Einsatz: Researcher und Analyst (12 min)

**Ziel:** Sie erleben den Unterschied zwischen „recherchieren mit Quellen“ und „rechnen mit nachvollziehbaren Schritten“.

**Schritte**
1. **Researcher** mit Prompt **M3-03**: Lassen Sie recherchieren, wie man Monatsdaten vor einer Kommentierung auf
   Plausibilität prüft (Methoden, typische Prüfregeln). Beantworten Sie die Rückfragen des Agenten knapp.
   Der Agent arbeitet einige Minuten – starten Sie ihn und machen Sie mit Schritt 2 weiter.
2. **Analyst** mit Prompt **M3-04** und `Kennzahlen_Okt-2026.xlsx`: Abweichung je Region zum Plan und zum Vorjahr,
   Rangfolge, auffällige Regionen. Lassen Sie sich die Rechenschritte zeigen.
3. Prüfen Sie zwei Zahlen des Analysten direkt in der Excel-Datei nach.
4. Zurück zum Researcher: Sind die Quellen angegeben? Öffnen Sie eine davon. Passt die Aussage zur Quelle?

**Erwartetes Ergebnis:** Eine Ergebnistabelle des Analysten mit nachvollziehbarer Rechnung und ein Recherchebericht
mit Quellen – plus Ihre Einschätzung, wofür Sie welchen Agenten im Alltag einsetzen würden.

**Ohne diese Agenten:** Beide Prompts funktionieren im Einzelchat mit angehängter Datei. Verlangen Sie dort
ausdrücklich Quellen bzw. die Rechnung und prüfen Sie mehr Zahlen nach.

## Ü3.3 · Excel: strukturierte Analyse (12 min)

**Ziel:** Sie stellen Copilot in Excel präzise Aufgaben und erhalten Ergebnisse, die bei neuen Daten gültig bleiben.

**Schritte**
1. `Kennzahlen_Okt-2026.xlsx` in Excel öffnen (für Copilot in Excel aus OneDrive/SharePoint, AutoSpeichern an).
2. Erst unstrukturiert fragen: „Analysiere die Daten.“ Ergebnis kurz ansehen.
3. Dann strukturiert mit den Bausteinen aus **M3-05** (Tabelle, Spalten, Rechnung, Ausgabeort):
   a) Rangfolge der Regionen nach `Abw_Prozent` aus `tblRegionOkt`
   b) aus `tblZeitreihe` eine Pivot-Tabelle: Ist- und Plan-Kosten je Region und Monat
   c) eine Formelspalte in `tblZeitreihe`: Abweichung zum Plan in Prozent
   d) ein Diagramm: Krankenquote je Monat für die Region mit der höchsten Abweichung
4. Bei c) prüfen: Steht eine **Formel** in der Spalte oder ein fester Wert?

**Erwartetes Ergebnis:** Rangfolge, Pivot-Tabelle, Formelspalte und Diagramm – und der Vergleich, wie viel besser
die strukturierten Prompts funktionieren.

**Ohne Copilot in Excel:** Datei im Copilot-Chat anhängen und nach den Formeln fragen („Gib mir die Excel-Formel
für …, deutsche Funktionsnamen, strukturierte Verweise“), dann selbst einfügen.

## Ü3.4 · Excel: Validierung gegen einen Regelkatalog (18 min)

**Ziel:** Sie prüfen einen Export systematisch gegen feste Regeln – statt „finde Auffälligkeiten“ – und bauen
Prüfspalten, die beim nächsten Export wieder funktionieren.

**Schritte**
1. `Leistungsnachweise_Export_Okt-2026.xlsx` öffnen. Blatt „Prüfregeln“ lesen (R1–R8), Blatt „Stammdaten“ ansehen.
2. Zuerst offen fragen: „Gibt es Auffälligkeiten in tblLeistung?“ Notieren Sie, wie viele Probleme Copilot nennt.
3. Jetzt mit Prompt **M3-06**: Regelkatalog R1–R8 prüfen lassen, Ausgabe als Verstoßliste mit `BelegNr` und Anzahl je Regel.
4. Mit Prompt **M3-07** für mindestens drei Regeln Prüfspalten als **Formeln** erzeugen lassen (z. B. R1, R6, R7).
   Zählen Sie die Treffer je Prüfspalte (Filter oder ZÄHLENWENN).
5. Vergleichen Sie: Anzahl aus Schritt 2, aus Schritt 3 und aus Ihren Prüfspalten. Wo weichen sie ab – und warum?

**Erwartetes Ergebnis:** Eine Verstoßliste je Regel mit Belegnummern, mindestens drei Prüfspalten mit Formeln und
eine Erklärung für die Unterschiede zwischen Copilots Zählung und Ihrer eigenen.

**Ohne Copilot in Excel:** Datei im Copilot-Chat anhängen (M3-06), die Formeln für die Prüfspalten im Chat
erzeugen lassen (M3-07) und selbst einfügen.

## Ü3.5 · Office-Dateien gegeneinander prüfen (12 min)

**Ziel:** Sie lassen einen Präsentationsentwurf Aussage für Aussage gegen die Datenquelle prüfen.

**Schritte**
1. `Monatsbericht_Okt-2026_Entwurf.pptx` kurz selbst durchsehen: Fällt Ihnen etwas auf?
2. Neuer Chat. Beide Dateien anhängen (`…Entwurf.pptx` und `Kennzahlen_Okt-2026.xlsx`), Prompt **M3-08**.
3. Ergebnis prüfen: Hat Copilot **jede** Folie gelesen – auch Titel, Tabelle und Fußzeile? Fragen Sie nach.
4. Drei Bewertungen selbst in der Excel-Datei nachsehen: eine „belegt“, eine „abweichend“, eine „nicht belegbar“.
5. Folgeprompt: korrigierte Fassung der betroffenen Folientexte erzeugen lassen.

**Erwartetes Ergebnis:** Eine Prüftabelle (Behauptung, Folie, Quelle, Bewertung) und korrigierte Folientexte.
Im Entwurf stecken mehr Abweichungen, als man beim Durchlesen sieht – wie viele finden Sie gemeinsam mit Copilot?

**Ohne Dateianhang für PowerPoint:** Folientexte kopieren (Gliederungsansicht) und zusammen mit der Excel-Datei
bzw. deren Tabelle in den Chat einfügen.

## Ü3.6 · Von Excel zu PowerPoint (12 min)

**Ziel:** Aus einem Excel-Export wird ein kurzer Foliensatz mit klaren Aussagen – und Sie prüfen ihn wie in Ü3.5.

**Schritte**
1. Prompt **M3-09**, Schritt 1: aus `Kennzahlen_Okt-2026.xlsx` eine Storyline mit vier bis fünf Aussage-Titeln entwickeln
   lassen (noch keine Folien). Halten Sie sich an den Kommentar-Leitfaden K04.
2. Storyline korrigieren: Stimmt die Hauptbotschaft? Ist jede Aussage mit einer Zahl belegt?
3. Prompt **M3-09**, Schritt 2: Folien erzeugen lassen – auf dem Weg, der bei Ihnen verfügbar ist (Weg A, B oder C im Prompt).
4. Prompt **M3-10**: die erzeugten Folien prüfen (Zahlen gegen die Quelle, Titel als Aussage, Einheiten).
5. Eine Folie gezielt nachschärfen (z. B. Titel kürzen, Tabelle statt Fließtext, Sprechernotizen ergänzen).

**Erwartetes Ergebnis:** Ein Foliensatz mit vier bis fünf Folien, deren Titel Aussagen sind, und ein Prüfprotokoll
ohne offene Abweichungen.

---

## Transfer in den eigenen Alltag

1. Welche Ihrer regelmäßigen Excel-Exporte hat feste Prüfregeln? Schreiben Sie drei davon als Regelkatalog auf
   (Regel, Kurzname, Beschreibung) – das ist die Vorlage für M3-06 und M3-07.
2. Welcher Bericht oder Foliensatz entsteht bei Ihnen monatlich aus einem Export? Legen Sie dafür ein Notizbuch mit
   Glossar, Kommentar-Leitfaden und dem jeweils aktuellen Export an.
3. Prüfen Sie den nächsten Bericht vor dem Versand mit M3-08 gegen seine Quelle.
