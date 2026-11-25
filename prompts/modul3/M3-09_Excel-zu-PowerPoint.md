# M3-09 · Von Excel zu PowerPoint – erst Storyline, dann Folien

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 3 | Copilot Chat mit Dateianhang (Storyline), danach Copilot in PowerPoint* oder Gliederung übernehmen | Ü3.6 | 15 min |

\* Copilot in PowerPoint kann beim Erstellen einer Präsentation eine Datei als Grundlage verwenden – laut Microsoft
auch eine Excel-Datei (neben Word, PDF und PowerPoint). Verfügbarkeit hängt von Lizenz und Mandanteneinstellung ab.

## Wofür
Aus einem Kennzahlenexport soll ein kurzer Foliensatz für die Bereichsleitung werden. Wer Copilot direkt „mach
Folien aus dieser Datei“ sagt, bekommt hübsche Folien ohne Aussage und mit ungeprüften Zahlen. Besser in zwei
Schritten: zuerst die **Storyline** mit Aussage-Titeln und belegten Zahlen (prüfbar als Text), dann erst die
Folien. Für Schritt 2 gibt es drei Wege – je nachdem, was bei Ihnen freigeschaltet ist.

## Vorbereitung
- `Kennzahlen_Okt-2026.xlsx` aus [`uebungsdaten/modul3/`](../../uebungsdaten/modul3/) an einen neuen Chat anhängen
  (`tblRegionOkt`, `tblZeitreihe`, `tblMassnahmen`); für Weg A zusätzlich in OneDrive/SharePoint ablegen.
- [K04 Kommentar-Leitfaden](../kontext/K04_Kommentar-Leitfaden-KPI.md) anhängen – er regelt Aussage-Titel und Notation.
- Falls vorhanden: gerechnete Tabelle aus [M3-04](M3-04_Analyst-Datenanalyse-nachvollziehbar.md) bereithalten.

> **Datenschutz:** Nur im unternehmensfreigegebenen Copilot arbeiten (Unternehmenskonto, grünes Schild). Keine
> personenbezogenen Daten anhängen. Im Training ausschließlich die fiktiven Übungsdaten verwenden.

## Prompt

Schritt 1 – Storyline (Copilot Chat oder Analyst, Datei angehängt):
```text
Du bist Controller*in im Produktionscontrolling und bereitest den Monatsbericht [EINFÜGEN: Oktober 2026] für
[EINFÜGEN: Zielgruppe, z. B. die Bereichsleitung] vor. Zeit im Termin: [EINFÜGEN: 10 Minuten].

Kontext: Angehängt ist [EINFÜGEN: Kennzahlen_Okt-2026.xlsx] (Regionen_Okt, Zeitreihe Jan–Okt 2026, Massnahmen).
Prozentspalten sind Prozentwerte (6,87 = 6,87 %). Halte dich an den Kommentar-Leitfaden K04.

Aufgabe: Entwirf die Storyline für [EINFÜGEN: 5] Folien. Erstelle noch keine Folien.

Regeln:
- Jeder Folientitel ist eine Aussage als ganzer Satz mit Zahl und Vergleich – keine Themenüberschrift.
- Eine Botschaft je Folie, höchstens drei Stichpunkte, jeder mit Zahl, Einheit und Vergleichsbasis (PL oder VJ).
- Jede Zahl stammt aus der Datei. Rechne mit dem Analysewerkzeug und nenne zu jeder Zahl Blatt, Spalte und Zeile
  bzw. die Rechnung.
- Quoten-Veränderungen in Prozentpunkten. Mehrkosten sind ungünstig – Wertung ausschreiben.
- Ursachen nur, wenn sie in der Datei belegt sind; sonst „mögliche Ursache (zu prüfen)“.
- Schlag je Folie eine Darstellung vor (Tabelle, Balken, Linie) und nenne die Datenreihe dafür.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
1. Kernbotschaft des Foliensatzes in einem Satz.
2. Tabelle „Folie | Titel (Aussage) | Stichpunkte | Darstellung | Beleg (Blatt, Spalte, Rechnung)“.
3. Sprechernotizen je Folie (zwei bis drei Sätze).
4. „Annahmen und offene Punkte“.
```

Schritt 2 – Folien erzeugen. Wählen Sie den Weg, der bei Ihnen verfügbar ist:

**Weg A – Copilot in PowerPoint mit Datei-Referenz.** Neue Präsentation › Copilot › Präsentation erstellen
(Create a presentation) bzw. „Mit Copilot bearbeiten“ (Edit with Copilot) › Datei referenzieren (Reference file):
```text
Erstelle eine Präsentation mit genau [EINFÜGEN: 5] Folien auf Basis der Datei [EINFÜGEN: Kennzahlen_Okt-2026.xlsx]
und der folgenden Gliederung. Übernimm Titel, Stichpunkte, Zahlen und Sprechernotizen wörtlich. Ergänze keine
Zahlen, Ursachen oder Folien, die nicht in der Gliederung stehen. Schlichtes Layout, keine Stockfotos.
[EINFÜGEN: Storyline-Tabelle und Sprechernotizen aus Schritt 1]
```

**Weg B – Copilot Chat erzeugt die Datei** (nur sofern in Ihrem Unternehmen freigeschaltet: PowerPoint-Agent
unter *Tools*; benötigt Microsoft-365-Copilot-Lizenz und vom Admin aktivierte Anthropic-Modelle):
```text
Erstelle aus der Storyline oben eine PowerPoint-Datei mit [EINFÜGEN: 5] Folien. Titel, Stichpunkte, Zahlen und
Sprechernotizen wörtlich übernehmen, nichts ergänzen. Diagramme nur aus den genannten Datenreihen.
```

**Weg C – funktioniert immer: Gliederung übernehmen.**
```text
Gib die Storyline als reine Gliederung aus: je Folie eine Zeile mit dem Titel, darunter eingerückt die
Stichpunkte, danach „Notizen:“ mit den Sprechernotizen. Kein Markdown, keine Tabelle.
```
Gliederung in PowerPoint einfügen (Ansicht › Gliederungsansicht) oder in Word mit Überschrift 1/2 formatieren und
über **Neue Folie › Folien aus Gliederung** laden. Diagramme in Excel bauen und einfügen.

## Nachschärfen

Wenn Titel nur Themen nennen („Kosten je Region“):
```text
Formuliere jeden Titel als Aussage nach K04: Was ist die Botschaft, mit welcher Zahl, gegen welche Basis?
Beispielform: „[Region] liegt im Oktober x % über Plan – [Treiber].“ Verwende nur Zahlen aus der Beleg-Spalte.
```

Wenn die Storyline zu voll ist:
```text
Kürze auf die drei wichtigsten Abweichungen. Alles, was innerhalb von [EINFÜGEN: ±2 %] zum Plan liegt, fasst du
in einem Satz zusammen. Maßnahmen nur, wenn Status oder Zieltermin kritisch sind.
```

Für ein Diagramm mit echten Daten:
```text
Welche Zellen aus Kennzahlen_Okt-2026.xlsx brauche ich für das Diagramm auf Folie [EINFÜGEN: Nr]? Nenne Tabelle,
Spalten, Filter und Diagrammtyp, damit ich es in Excel erstelle und in PowerPoint einfüge.
```

## Ergebnis prüfen
- [ ] Die Storyline wurde **vor** dem Erzeugen der Folien geprüft: drei Zahlen in Excel nachgesehen.
- [ ] Jeder Titel ist ein Satz mit Zahl und Vergleich; eine Botschaft je Folie.
- [ ] Die Folien enthalten nur Zahlen aus der Storyline (Folie für Folie abhaken) – keine neuen.
- [ ] Anzahl Folien wie bestellt; Sprechernotizen vorhanden.
- [ ] Diagramme zeigen die genannten Datenreihen; Achse und Einheit stimmen.
- [ ] Vollständige Prüfung der fertigen Datei mit [M3-10](M3-10_PowerPoint-pruefen-und-nachschaerfen.md).

## Stolperfallen
- **Direkt aus der Excel-Datei erzeugte Folien** enthalten oft erfundene Einordnungen und gerundete oder
  vertauschte Werte. Die Storyline als Zwischenschritt macht Zahlen prüfbar, bevor Layout sie versteckt.
- **Copilot „verschönert“.** Zusatzfolien (Agenda, Fazit, „Nächste Schritte“) und Stockfotos kommen ungefragt –
  Folienzahl und „nichts ergänzen“ vorgeben.
- **Diagramme ohne Datenbezug.** Von Copilot gezeichnete Diagramme sind nicht mit Ihrer Excel-Datei verknüpft.
  Für den Monatsbericht Diagramme in Excel erstellen und einfügen.
- **Dateiformat und Ablageort.** Weg A setzt meist voraus, dass die Excel-Datei in OneDrive/SharePoint liegt.
- **Freigabe prüfen.** Weg B nutzt Modelle eines Unterauftragsverarbeiters und ist nicht in jedem Unternehmen
  erlaubt – nur verwenden, wenn ausdrücklich freigegeben.

Mehr dazu: [M2-04 Kommentar Kennzahlenübersicht](../modul2/M2-04_Kommentar-Kennzahlenuebersicht.md) · [M3-08 Office-Dateien gegeneinander prüfen](M3-08_Office-Dateien-gegeneinander-pruefen.md)
