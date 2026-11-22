# KI-Spezialistentraining für Data Analysts – Termin 1 (vor Ort)

**Modul 1:** Metadatengetriebene BI-Entwicklung mit KI (Schwerpunkt TMDL)
**Modul 2:** KPI-Analysen mit KI

Begleitmaterial für die Teilnehmenden: Prompt-Sammlung, Kontextdateien, Übungen
und ein Übungsmodell mit fiktiven Daten. Alles ist so gebaut, dass Sie es nach dem Training direkt
auf Ihre eigenen Modelle und Berichte übertragen können.

## Inhalt

| Ordner / Datei | Was steckt drin |
|---|---|
| [Spickzettel.md](Spickzettel.md) | Alles Wichtige auf zwei Seiten: Ablauf, Prompt-Bausteine, Regeln für TMDL, DAX, Power Query, Kommentare – mit Prompt-Finder |
| [prompts/00_Prompting-Grundregeln.md](prompts/00_Prompting-Grundregeln.md) | Die Grundregeln für Analyse-Prompts – zuerst lesen |
| [prompts/kontext/](prompts/kontext/README.md) | Kontextdateien (Arbeitsregeln, DAX-Styleguide, TMDL-Kurzreferenz, Kommentar-Leitfaden, Glossar) zum Hinterlegen in Copilot |
| [prompts/modul1/](prompts/modul1/) | Prompts für TMDL, DAX, M, SQL, Dokumentation, KI-Fähigkeit |
| [prompts/modul2/](prompts/modul2/) | Prompts für Datenprüfung, Kommentare, Korrelationen, Maßnahmentracking |
| [leitfaeden/](leitfaeden/README.md) | Leitfäden zum Nachschlagen: Power Query, DAX, TMDL, Dokumentation aus TMDL, Checkliste Berichtsveröffentlichung |
| [uebungen/](uebungen/) | Übungsaufgaben je Modul (Lösungen besprechen wir im Training) |
| [uebungsdaten/modell/](uebungsdaten/modell/README.md) | Übungsmodell „DBS Produktionscontrolling“ (Power-BI-Projekt) |
| [uebungsdaten/modul1/](uebungsdaten/modul1/) | Code-Beispiele für die Übungen (Power Query, SQL, Fehlerfälle, DAX-Abfragen) |
| [uebungsdaten/modul2/](uebungsdaten/modul2/) | KPI-Exporte (Excel, CSV) für die Analyseübungen |

## So nutzen Sie die Prompt-Dateien

Jede Prompt-Datei ist gleich aufgebaut:

1. **Wofür** – welches Problem der Prompt löst
2. **Vorbereitung** – was Sie einfügen oder anhängen (z. B. TMDL aus der TMDL-Ansicht, eine Kontextdatei)
3. **Prompt** – kopierfertig; ersetzen Sie jedes `[EINFÜGEN: …]`
4. **Nachschärfen** – Folgeprompts, wenn das erste Ergebnis nicht passt
5. **Ergebnis prüfen** – Checkliste gegen Halluzinationen und Fehler
6. **Stolperfallen** – was in der Praxis schiefgeht

Arbeitsweise in drei Schritten:

```
Kontext hinterlegen (Notebook / Anhang)  →  Prompt kopieren + Platzhalter füllen  →  Ergebnis prüfen
```

## Voraussetzungen

- Power BI Desktop (aktuelle Version) mit TMDL-Ansicht und DAX-Abfrageansicht
- Microsoft 365 Copilot (Chat, Notebooks) mit Unternehmenskonto
- Copilot in Excel für Modul 2
- Optional, sofern freigeschaltet: Copilot in Power BI (setzt einen Arbeitsbereich auf bezahlter Fabric-Kapazität ab F2
  oder Premium ab P1 voraus, Testkapazitäten reichen nicht), Analyst- und Researcher-Agent

## Wichtig

- **Datenschutz:** Nur im freigegebenen Unternehmens-Copilot arbeiten. Keine personenbezogenen Daten
  in Prompts einfügen. Die Übungsdaten sind vollständig fiktiv.
- **Prüfen bleibt Ihre Aufgabe:** Copilot liefert Vorschläge. Code wird in Desktop getestet, Zahlen
  werden gegen den Bericht abgeglichen, bevor etwas in einen produktiven Bericht übernommen wird.

## Nach dem Training

Termin 2 (remote) baut auf diesem Material auf: Copilot-Funktionen und Datenvalidierung in Office
(Modul 3) und Ausblick Microsoft Fabric mit automatisierter Dokumentation und Berichtserstellung (Modul 4).

Weiterlesen: Daten-WG Knowledge Kitchen – datenwgknowledgekitchen.com
(u. a. Podcast-Folge „AI on top of BI“, Quarterly Updates zu Power BI & Fabric).
