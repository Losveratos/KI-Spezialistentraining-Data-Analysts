# 00 · Prompting für die Datenanalyse – die Grundregeln

Kurzreferenz für den Einstieg in Modul 1 (10 Minuten). Gilt für alle Prompts dieser Sammlung.

## Die sechs Bausteine eines guten Analyse-Prompts

| Baustein | Frage | Beispiel |
|---|---|---|
| **Rolle** | Als wer soll Copilot antworten? | „Du bist erfahrene*r Power-BI-Entwickler*in für Produktionscontrolling.“ |
| **Kontext** | Was muss Copilot wissen, das nur Sie wissen? | Modell als TMDL, Spaltennamen, Berichtsmonat, Zielgruppe |
| **Aufgabe** | Was genau soll passieren – ein Verb? | „Formatiere“, „erkläre“, „finde Fehler“, „schlage vor“ |
| **Regeln** | Was darf nicht passieren? | „Verwende nur Spalten aus dem TMDL. Ändere die Logik nicht.“ |
| **Ausgabeformat** | Wie soll das Ergebnis aussehen? | „Ein Codeblock, danach max. 5 Stichpunkte“ |
| **Rückfrage-Klausel** | Was, wenn etwas fehlt? | „Wenn Informationen fehlen, frag nach statt zu raten.“ |

Merksatz: **Copilot weiß nichts über Ihr Modell, das nicht im Prompt oder in einer angehängten Datei steht.**
Alles andere errät es – und klingt dabei überzeugend.

## Zehn Regeln für Datenanalyse-Aufgaben

1. **Metadaten mitgeben, nicht beschreiben.** TMDL-Ausschnitt aus der TMDL-Ansicht einfügen statt
   „ich habe eine Tabelle mit Kosten“. Echte Namen schlagen jede Beschreibung.
2. **Eine Aufgabe pro Prompt.** Erst formatieren, dann kommentieren, dann optimieren – nicht alles auf einmal.
   Große Aufgaben in Schritte zerlegen und Zwischenergebnisse prüfen.
3. **Logik einfrieren.** Beim Formatieren und Kommentieren immer: „Ändere die Berechnungslogik nicht.“
   Sonst „verbessert“ Copilot nebenbei.
4. **Ausgabeformat vorgeben.** Codeblock, Tabelle, Markdown-Überschriften, Länge. Das spart Nacharbeit
   und macht Ergebnisse vergleichbar.
5. **Annahmen sichtbar machen.** „Liste am Ende alle Annahmen auf, die du treffen musstest.“
   Annahmen sind die Stellen, an denen Halluzinationen entstehen.
6. **Zahlen nie ungeprüft übernehmen.** Copilot rechnet in Texten unzuverlässig. Jede Zahl im
   Kommentar gegen Bericht oder Abfrage prüfen – oder rechnen lassen (Excel/Python) statt schätzen.
7. **Gegenprüfen lassen – in einem neuen Chat.** Ein zweiter Durchgang mit „Prüfe diesen Code/Kommentar
   kritisch gegen …“ findet viel. Im selben Chat verteidigt Copilot eher seine erste Antwort.
8. **Beispiele zeigen (Few-Shot).** Ein gutes Beispiel (ein formatiertes Measure, ein guter Kommentar)
   wirkt stärker als drei Absätze Beschreibung.
9. **Kontext wiederverwenden.** Wiederkehrende Regeln (Styleguide, Glossar, Arbeitsregeln) einmal als
   Datei im Copilot-Notebook hinterlegen statt in jeden Prompt zu kopieren → Ordner `kontext/`.
10. **Datenschutz zuerst.** Nur im freigegebenen Unternehmens-Copilot arbeiten (Anmeldung mit
    Unternehmenskonto, Schild-Symbol „Enterprise Data Protection“). Keine personenbezogenen Daten einfügen.

## Woran Sie Halluzinationen erkennen

- Spalten oder Measures, die es im Modell nicht gibt (`Fakt[Kosten]` statt `Fakt_Leistung[Ist_Kosten]`)
- DAX-Funktionen, die es nicht gibt oder die anders heißen (`DATEDIFFMONTH`, `PERCENTCHANGE`)
- Zahlen im Text, die in keiner Quelle stehen oder „glatt“ wirken
- Ursachen („wegen der Tarifrunde“), die nirgends in den Daten oder im Kontext stehen
- Sehr sichere Formulierungen ohne Beleg („eindeutig“, „zweifellos“)

Gegenmittel: Kontext mitgeben (TMDL), Annahmen auflisten lassen, im neuen Chat gegenprüfen,
Code in der DAX-Abfrageansicht testen, Zahlen gegen den Bericht abgleichen.

## Wo welche Copilot-Variante passt

| Aufgabe | Erste Wahl | Alternative |
|---|---|---|
| Code formatieren, erklären, optimieren | M365 Copilot Chat (Code einfügen) | Copilot in der DAX-Abfrageansicht*, falls verfügbar |
| Wiederkehrende Arbeit mit festen Regeln | **Copilot Notebook** mit Kontextdateien aus `kontext/` | Chat + Kontextdatei jedes Mal anhängen |
| Daten analysieren, Kommentare, Korrelationen | Copilot in Excel oder Analyst-Agent* (rechnet tatsächlich) | Chat mit eingefügter Tabelle (nur für kleine Tabellen) |
| Recherche (Microsoft-Doku, Best Practices) | Researcher-Agent* | Chat mit Websuche |

\* nur, sofern in Ihrem Unternehmen freigeschaltet bzw. der Workspace auf einer Fabric-Kapazität liegt.

## Prompt-Gerüst zum Kopieren

```text
Rolle: Du bist [EINFÜGEN: Rolle, z. B. erfahrene*r Power-BI-Entwickler*in im Produktionscontrolling].

Kontext:
[EINFÜGEN: TMDL-Ausschnitt, Code, Tabelle oder Beschreibung]

Aufgabe: [EINFÜGEN: ein Verb + Gegenstand, z. B. Formatiere das Measure und kommentiere jeden Schritt.]

Regeln:
- Verwende nur Tabellen, Spalten und Measures, die im Kontext stehen.
- [EINFÜGEN: weitere Regel, z. B. Ändere die Berechnungslogik nicht.]
- Wenn Informationen fehlen, frag nach, statt zu raten.

Ausgabe: [EINFÜGEN: Format, z. B. ein DAX-Codeblock, danach höchstens 5 Stichpunkte zu den Änderungen.]
Liste am Ende alle Annahmen auf, die du treffen musstest.
```
