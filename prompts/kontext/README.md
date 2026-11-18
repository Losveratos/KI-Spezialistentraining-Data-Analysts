# Kontextdateien – einmal hinterlegen, in jedem Prompt nutzen

Kontextdateien enthalten Regeln und Wissen, die Copilot für viele Aufgaben braucht. Statt sie in jeden
Prompt zu kopieren, hinterlegen Sie sie einmal.

| Datei | Inhalt | Nutzen in |
|---|---|---|
| [K01_Arbeitsregeln-BI-Copilot.md](K01_Arbeitsregeln-BI-Copilot.md) | Wie Copilot arbeiten soll: keine erfundenen Namen, Logik nicht ändern, Annahmen ausweisen | allen Modulen |
| [K02_DAX-Styleguide.md](K02_DAX-Styleguide.md) | Formatierung, VAR, DIVIDE, Namen, Kommentare | Modul 1 |
| [K03_TMDL-Kurzreferenz.md](K03_TMDL-Kurzreferenz.md) | TMDL-Syntax und Stolperfallen beim Zurückschreiben | Modul 1 |
| [K04_Kommentar-Leitfaden-KPI.md](K04_Kommentar-Leitfaden-KPI.md) | Wie ein guter Kennzahlenkommentar aussieht | Modul 2 |
| [K05_Kennzahlen-Glossar.md](K05_Kennzahlen-Glossar.md) | Definitionen der Kennzahlen im Übungsmodell | Modul 1 und 2 |

## Drei Wege, sie zu nutzen

**1. Copilot Notebook (empfohlen für wiederkehrende Arbeit)**
In Microsoft 365 Copilot ein Notebook anlegen (z. B. „Power-BI-Entwicklung“), die Kontextdateien als
Referenzen hinzufügen und dann im Notebook-Chat arbeiten. Copilot bezieht die Referenzen in jede
Antwort ein. Je Thema ein Notebook (Entwicklung / Kommentierung) hält die Kontexte sauber getrennt.

**2. Anhängen im Einzelchat**
Datei über die Büroklammer anhängen und im Prompt darauf verweisen („Halte dich an K02“). Wird die
Dateiendung `.md` nicht angenommen, die Datei als `.txt` speichern oder den Inhalt in ein Word-Dokument
kopieren und dieses (aus OneDrive) anhängen.

**3. Einfügen**
Inhalt (ab der Linie `---`) an den Anfang des Chats kopieren mit: „Halte dich in diesem Chat an folgende
Regeln: …“. Funktioniert immer, kostet aber Platz im Chat.

## Eigene Kontextdateien anlegen

Die wirksamsten Kontextdateien für Ihren Alltag:
- **Glossar** Ihrer Kennzahlen (wie K05) – Definition, Einheit, „gut ist“, fachliche Besonderheiten
- **Teamkonventionen** für DAX, M und SQL (wie K02)
- **Kommentarbeispiele** aus echten, freigegebenen Berichten (wie K04) – Copilot imitiert den Stil
- **TMDL** Ihres Modells (Tabellen und Measures) – bei großen Modellen nur die relevanten Tabellen
