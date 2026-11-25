# M3-01 · Chat, Notizbuch oder Agent – das richtige Copilot-Werkzeug wählen

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | Microsoft 365 Copilot (App oder `copilot.cloud.microsoft`), Excel, PowerPoint | Ü3.1 | 10 min |

## Wofür
Copilot ist nicht ein Werkzeug, sondern mehrere: Einzelchat, Notizbuch (Copilot Notebook), die vorinstallierten
Agenten Researcher und Analyst sowie Copilot direkt in Excel und PowerPoint. Wer das falsche wählt, bekommt
geschätzte statt gerechnete Zahlen oder kopiert denselben Kontext zum zehnten Mal. Diese Datei hilft bei der Wahl –
und beginnt mit einer Bestandsaufnahme, denn was Sie sehen, hängt von Lizenz und Freigaben Ihres Unternehmens ab.

> Sie brauchen für dieses Modul **keine eigenen Agenten**. Schaltflächen wie „Agent erstellen“ (Create agent)
> ignorieren Sie; alle Übungen funktionieren mit dem, was bereits vorhanden ist.

## Vorbereitung – Bestandsaufnahme „Was sehe ich in meinem Copilot?“ (3 min)
1. Copilot öffnen und mit dem **Unternehmenskonto** anmelden. Prüfen: Kennzeichnung „Arbeit“ (Work) und grünes
   Schild-Symbol (Enterprise Data Protection). Die App heißt inzwischen „Microsoft Copilot“ bzw. „Copilot Chat“.
2. Linke Navigation: Gibt es **Chat**, **Notizbücher** (Notebooks) und **Agents** (Agenten, „Alle Agents“)?
3. Im Eingabefeld das Menü **Tools** öffnen (je nach Version stehen die Einträge auch unter *Agents*):
   Sehen Sie **Researcher** und **Analyst**? Weitere Einträge (z. B. Word-, Excel-, PowerPoint-Agent) notieren.
4. Excel und PowerPoint öffnen: Gibt es die Copilot-Schaltfläche? In Excel zusätzlich: Gibt es
   „Mit Copilot bearbeiten“ (Edit with Copilot, früher „Agent Mode“)?
5. Ergebnis notieren – es bestimmt, welchen Weg Sie in den folgenden Übungen gehen.

> **Datenschutz:** Nur im unternehmensfreigegebenen Copilot arbeiten (Anmeldung mit Unternehmenskonto, grünes Schild).
> Keine personenbezogenen Daten einfügen oder anhängen. Im Training nur die fiktiven Dateien aus
> [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/) verwenden.

## Entscheidungshilfe

| Werkzeug | Nehmen Sie es, wenn … | Stärke | Grenze |
|---|---|---|---|
| **Einzelchat** (Copilot Chat, Datei anhängen) | eine einmalige Frage zu einer Datei oder einem Text ansteht | sofort da, funktioniert immer | Kontext ist nach dem Chat weg; rechnet nicht immer nachvollziehbar |
| **Notizbuch** (Copilot Notebook) | Sie wiederholt mit denselben Regeln und Dateien arbeiten (Monatsbericht) | Referenzen und Anweisungen bleiben erhalten | liest Referenzen als Text – exakte Rechnung besser mit Analyst oder Excel |
| **Researcher** | Sie eine Recherche mit Quellen brauchen (Doku, Methoden, Best Practices) | mehrstufige Suche, Bericht mit Quellenangaben | dauert Minuten; Quellen stichprobenartig öffnen |
| **Analyst** | Zahlen aus Excel/CSV gerechnet werden müssen (Profil, Abgleich, Ranking) | rechnet mit Python und zeigt die Schritte | Ergebnis steht im Chat, nicht in Ihrer Datei |
| **Copilot in Excel** | das Ergebnis **in der Arbeitsmappe** bleiben soll (Formel, Pivot, Diagramm, Prüfspalte) | reproduzierbar, rechnet bei neuen Daten mit | Datei muss in OneDrive/SharePoint liegen; ändert die Mappe |
| **Copilot in PowerPoint** | aus Gliederung oder Datei Folien entstehen oder Folien überarbeitet werden | Layout, Sprechernotizen, Umformulieren | Zahlen auf Folien immer gegen die Quelle prüfen |

Voraussetzungen (Stand November 2026, laut Microsoft Learn): Researcher und Analyst sind Teil der
Microsoft-365-Copilot-Lizenz und stehen im Chat unter *Tools*. Copilot in Excel/PowerPoint hängt von Lizenz und
Mandanteneinstellung ab. Word-, Excel- und PowerPoint-Agent im Chat erzeugen Dateien, benötigen aber die Lizenz
**und** vom Admin freigeschaltete Anthropic-Modelle – nur nutzen, sofern in Ihrem Unternehmen freigeschaltet.
**Rückfallweg für alles:** normaler Copilot Chat mit angehängter Datei.

## Prompt
Je Werkzeug ein Startprompt zum Ausprobieren mit [`Kennzahlen_Okt-2026.xlsx`](../../uebungsdaten/modul3/).

Einzelchat (Datei anhängen):
```text
Du bist Controller*in im Produktionscontrolling. Angehängt ist [EINFÜGEN: Kennzahlen_Okt-2026.xlsx].
Bestätige nur, was du erhalten hast: Blätter, Tabellen, Spalten, Zeilenzahl je Blatt. Analysiere noch nichts.
Wenn du einen Teil nicht lesen konntest, sag das ausdrücklich.
```

Notizbuch (nach dem Einrichten, siehe [M3-02](M3-02_Notizbuch-fuer-Datenanalyse-einrichten.md)):
```text
Welche Referenzen liegen in diesem Notizbuch und welche Regeln gelten laut K01 und K04 für deine Antworten?
Antworte als Liste mit Dateiname und je einem Satz Inhalt.
```

Researcher (Tools › Researcher):
```text
Recherchiere: [EINFÜGEN: Frage, z. B. Welche Excel-Funktionen eignen sich für Stammdatenabgleiche in Exporten?]
Nur offizielle Microsoft-Quellen (Learn, Support). Jede Aussage mit Link. Stell mir zuerst deine Rückfragen.
```

Analyst (Tools › Analyst, Datei anhängen):
```text
Rechne für das Blatt Regionen_Okt nach, ob Abw_Kosten = Ist_Kosten − Plan_Kosten in jeder Zeile stimmt.
Zeig den Code bzw. die Rechenschritte und das Ergebnis als Tabelle. Prozentwerte: 6,87 bedeutet 6,87 %.
```

Copilot in Excel (Datei aus OneDrive geöffnet):
```text
Verwende die Tabelle tblRegionOkt. Erstelle auf einem neuen Blatt „Analyse“ eine Formel, die Ist_Kosten über alle
Regionen summiert. Schreib eine Formel in die Zelle, keinen festen Wert. Ändere tblRegionOkt nicht.
```

Copilot in PowerPoint (leere Präsentation):
```text
Erstelle eine Folie mit dem Titel „[EINFÜGEN: Aussage als ganzer Satz]“ und drei Stichpunkten aus diesem Text:
[EINFÜGEN: Text]. Keine Zahlen ergänzen, die nicht im Text stehen.
```

## Nachschärfen

Wenn unklar ist, welches Werkzeug passt:
```text
Ich möchte [EINFÜGEN: Aufgabe]. Zur Verfügung stehen: Copilot Chat mit Dateianhang, Notizbuch, Researcher,
Analyst, Copilot in Excel, Copilot in PowerPoint. Welches Werkzeug empfiehlst du und warum? Nenne auch, was
bei diesem Werkzeug schiefgehen kann und wie ich das Ergebnis prüfe.
```

Wenn ein Agent fehlt: denselben Prompt im normalen Chat stellen und ergänzen:
```text
Rechne mit dem Analysewerkzeug (Python), wenn es verfügbar ist, und sag mir, ob du gerechnet oder geschätzt hast.
```

## Ergebnis prüfen
- [ ] Bestandsaufnahme notiert: Notizbücher, Researcher, Analyst, Copilot in Excel, Copilot in PowerPoint – ja/nein.
- [ ] Grünes Schild bzw. Kennzeichnung „Arbeit“ gesehen – sonst nicht weiterarbeiten.
- [ ] Für jedes fehlende Werkzeug ist der Rückfallweg klar (Chat mit Dateianhang).
- [ ] Der Einzelchat hat Blätter und Tabellen der Datei richtig aufgezählt (gegen die geöffnete Datei prüfen).
- [ ] Analyst bzw. Chat sagt, ob gerechnet oder geschätzt wurde.

## Stolperfallen
- **Gleicher Prompt, anderes Werkzeug, andere Qualität.** Der Einzelchat schätzt Summen manchmal aus dem Text der
  Datei; Analyst und Excel rechnen. Bei Zahlen immer ein rechnendes Werkzeug wählen.
- **Oberfläche ändert sich.** Namen und Menüs wandern (Agent Mode → Edit with Copilot, Tools ↔ Agents). Suchen Sie
  nach der Funktion, nicht nach der exakten Beschriftung.
- **„Agent“ heißt nicht „selbst gebaut“.** Researcher und Analyst sind von Microsoft bereitgestellt. Eigene Agenten
  sind nicht Teil dieses Trainings.
- **Nicht alles, was sichtbar ist, ist freigegeben.** Einträge können erscheinen und trotzdem gesperrt oder
  verbrauchsabhängig abgerechnet sein (z. B. Cowork). Im Zweifel beim internen Copilot-Ansprechpartner nachfragen.

Mehr dazu: [00 · Prompting-Grundregeln](../00_Prompting-Grundregeln.md) · [Kontextdateien](../kontext/README.md)
