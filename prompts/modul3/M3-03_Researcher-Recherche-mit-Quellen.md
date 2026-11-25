# M3-03 · Researcher – Recherche mit Quellenpflicht

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | Researcher* (Copilot Chat › Tools), Rückfallweg: Copilot Chat mit Websuche | Ü3.2 | 10 min + Laufzeit |

\* Researcher ist ein von Microsoft bereitgestellter Agent in Copilot Chat (unter *Tools* bzw. *Agents*), Teil der
Microsoft-365-Copilot-Lizenz. Er recherchiert mehrstufig im Web und – sofern nicht eingeschränkt – in Ihren
Arbeitsdaten und liefert einen Bericht mit Quellenangaben. Ohne Researcher: gleichen Prompt im normalen Chat stellen.

## Wofür
Fachliche Fragen rund um die Datenanalyse – „Wie prüft man …?“, „Was sagt die Microsoft-Dokumentation zu …?“,
„Welche Grenzen hat …?“ – beantwortet der Einzelchat oft aus dem Gedächtnis und ohne Beleg. Researcher sucht,
liest und zitiert. Ihr Beitrag: eine enge Frage, klare Quellenregeln und konkrete Antworten auf seine Rückfragen.
Die Recherche läuft einige Minuten – starten Sie sie und arbeiten Sie parallel an
[M3-04](M3-04_Analyst-Datenanalyse-nachvollziehbar.md) weiter.

## Vorbereitung
- Frage wählen. Vorschläge aus dem Controlling-Alltag:
  - „Welche Excel-Funktionen und Vorgehensweisen empfiehlt Microsoft, um einen Export gegen Stammdaten und
    Prüfregeln zu validieren (Dubletten, Wertebereiche, Pflichtfelder)?“
  - „Welche Voraussetzungen und dokumentierten Grenzen hat Copilot in Excel bei der Analyse von Tabellen?“
  - „Was sagt die Power-BI-Dokumentation zu Zeilengrenzen und Formaten beim Export von Visual-Daten?“
- Entscheiden: Nur Webquellen oder auch interne Dateien und E-Mails? Für das Training: **nur Web**.

> **Datenschutz:** Nur im unternehmensfreigegebenen Copilot arbeiten (Unternehmenskonto, grünes Schild). Researcher
> kann auf Arbeitsdaten zugreifen, für die Sie berechtigt sind – schreiben Sie in den Prompt, ob das gewünscht ist.
> Keine vertraulichen Details oder Personendaten in die Recherchefrage schreiben; sie kann in Websuchen einfließen.

## Prompt
```text
Du recherchierst für ein Team erfahrener Data Analysts im Produktionscontrolling (Power BI, Excel-Exporte, SAP-Daten).

Frage: [EINFÜGEN: genau eine Frage, z. B. Welche Excel-Funktionen und Vorgehensweisen empfiehlt Microsoft, um einen
Export gegen Stammdaten und Prüfregeln zu validieren?]

Rahmen:
- Zweck: [EINFÜGEN: z. B. Vorlage für eine monatliche Prüfroutine vor dem Berichtsversand]
- Umgebung: [EINFÜGEN: z. B. Excel für Microsoft 365, deutsch, Dateien in OneDrive; Power BI Service]
- Nicht gesucht: [EINFÜGEN: z. B. VBA-Makros, Drittanbieter-Add-ins]

Quellenregeln:
- Verwende vorrangig offizielle Microsoft-Quellen (learn.microsoft.com, support.microsoft.com). Andere Quellen
  nur ergänzend und als solche gekennzeichnet.
- Verwende [EINFÜGEN: nur Webquellen / auch meine Arbeitsdaten].
- Jede Sachaussage bekommt eine Quelle mit Titel und Link. Nenne, soweit erkennbar, das Datum der Seite.
- Was du nicht belegen kannst, schreibst du unter „Nicht belegt“ – nicht in den Haupttext.
- Unterscheide „allgemein verfügbar“, „Vorschau“ und „abhängig von Lizenz oder Admin-Einstellung“.

Vorgehen: Stell mir zuerst deine Rückfragen (höchstens fünf). Beginne erst danach mit der Recherche.

Ausgabe:
1. Antwort in fünf Sätzen.
2. Tabelle „Aussage | Quelle (Titel, Link) | Stand/Datum | Status (verfügbar / Vorschau / mandantenabhängig)“.
3. Empfehlung für unser Team als Schrittfolge (höchstens sieben Schritte).
4. „Nicht belegt“ und „Widersprüche zwischen Quellen“ als Listen (oder „keine“).
```

Rückfragen beantworten – kurz und vollständig, sonst rät Researcher:
```text
Zu deinen Rückfragen:
1. [EINFÜGEN: Antwort, z. B. Excel für Microsoft 365 Desktop und Web, deutsche Oberfläche]
2. [EINFÜGEN: Antwort, z. B. Datenmenge etwa 500 bis 50.000 Zeilen je Export]
3. [EINFÜGEN: Antwort, z. B. Nur Funktionen ohne Zusatzlizenz; Copilot-Funktionen getrennt ausweisen]
Alles Weitere entscheidest du selbst und führst die Entscheidung unter „Annahmen“ auf. Starte jetzt.
```

## Nachschärfen

Wenn der Bericht zu allgemein ist:
```text
Kürze den Bericht auf die Punkte, die für [EINFÜGEN: Prüfung eines Leistungsnachweis-Exports mit Stammdaten und
Regelkatalog] relevant sind. Ergänze je Punkt ein konkretes Beispiel mit deutscher Excel-Funktion.
```

Wenn Quellen fehlen oder zweifelhaft sind:
```text
Liste alle Aussagen, deren Quelle keine Microsoft-Seite ist. Suche für jede eine Microsoft-Quelle; findest du
keine, verschiebe die Aussage nach „Nicht belegt“.
```

Wenn Aktualität wichtig ist:
```text
Welche deiner Quellen sind älter als zwölf Monate? Prüfe für diese Aussagen, ob es eine neuere Microsoft-Seite
oder einen Eintrag in den Release Notes gibt, und nenne Änderungen.
```

Rückfallweg ohne Researcher – im normalen Copilot Chat denselben Prompt verwenden und ergänzen:
```text
Nutze die Websuche. Zitiere nur Seiten, die du in dieser Unterhaltung tatsächlich aufgerufen hast.
```

## Ergebnis prüfen
- [ ] Researcher hat Rückfragen gestellt und Ihre Antworten erkennbar berücksichtigt.
- [ ] Jede Zeile der Quellentabelle hat einen Link. **Stichprobe: drei Links öffnen** – steht die Aussage dort
      wirklich, und passt sie zu Ihrer Version?
- [ ] Vorschau-Funktionen und lizenzabhängige Funktionen sind als solche markiert.
- [ ] „Nicht belegt“ ist vorhanden und ehrlich gefüllt (oder ausdrücklich „keine“).
- [ ] Die Empfehlung enthält keine Funktionen, die es in Ihrer Excel-Version nicht gibt – eine Funktion in Excel
      eintippen und prüfen.

## Stolperfallen
- **Quelle vorhanden ≠ Aussage belegt.** Researcher verlinkt manchmal eine passende Seite, die den Satz so nicht
  enthält. Ohne Stichprobe ist die Quellenliste nur Dekoration.
- **Zu breite Frage.** „Alles über Datenqualität in Excel“ liefert einen Aufsatz. Eine Frage, ein Zweck, eine Umgebung.
- **Englische Namen.** Dokumentation und Bericht nennen oft englische Funktions- und Menünamen (XLOOKUP, Data
  Validation). Lassen Sie die deutschen Entsprechungen ergänzen (XVERWEIS, Datenüberprüfung).
- **Kontingent und Laufzeit.** Recherchen dauern mehrere Minuten und können mengenmäßig begrenzt sein. Nicht für
  Fragen verwenden, die ein normaler Chat in Sekunden beantwortet.
- **Arbeitsdaten im Bericht.** Mit Zugriff auf Arbeitsdaten können interne Inhalte im Bericht landen – vor dem
  Weitergeben lesen.

Mehr dazu: [M3-01 Werkzeugwahl](M3-01_Chat-Notizbuch-oder-Agent.md) · [M1-02 Halluzinationen gegenprüfen](../modul1/M1-02_Halluzinationen-gegenpruefen.md)
