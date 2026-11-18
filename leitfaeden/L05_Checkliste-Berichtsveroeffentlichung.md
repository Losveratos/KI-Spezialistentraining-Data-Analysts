# L05 · Checkliste Berichtsveröffentlichung

> **Wofür?** Prüfliste für Kennzahlenübersicht, Detailbericht und Maßnahmentracking, bevor ein Bericht seine Nutzer
> erreicht – von der Datenquelle bis zur KI-Bereitschaft. **Wie benutzen?** Vor jeder **Erstveröffentlichung**
> vollständig; bei **Änderungen** nur die betroffenen Abschnitte (neues Measure → 2, 3; neue Seite → 4, 5, 6;
> neue Quelle → 1, 6, 7). Ergebnis in der Abnahme festhalten. **Bezug:** [L01 · Power Query](L01_Power-Query.md),
> [L02 · DAX](L02_DAX.md), [L03 · TMDL](L03_TMDL.md), [L04 · Dokumentation aus TMDL](L04_Dokumentation-aus-TMDL.md).
> Feature-Aussagen geprüft gegen Microsoft Learn am 18.11.2026; vieles ist Preview oder hängt von
> Mandanten-Einstellungen ab – im Zweifel mit Ihrer Fabric-Administration klären.

## So nutzen Sie die Checkliste mit Copilot

Copilot sieht Ihren Bericht nicht. Sie geben ihm, was er prüfen kann – **Copilot prüft, Sie entscheiden**.

| Was Sie Copilot geben | Woher | Für Abschnitt |
|---|---|---|
| Screenshot der Berichtsseite (PNG, Filterbereich aufgeklappt) | Win+Umschalt+S in Desktop | 4, 5 |
| TMDL der Tabellen ohne Partitionen | TMDL-Ansicht (siehe [L03](L03_TMDL.md)) | 2, 7, 9 |
| Ergebnis der Abfragen 5 und 6 | [`INFO_Abfragen.dax`](../uebungsdaten/modul1/INFO_Abfragen.dax), DAX-Abfrageansicht › Kopieren | 2, 9 |
| Abgleichstabelle Bericht gegen Quelle | DAX-Abfrage + Quellsystem, als Excel/CSV | 3 |
| Export der Leistungsanalyse (`.json`) oder kopierte Visual-Abfragen | Optimieren › Leistungsanalyse | 6 |

- Copilot Notebook „Berichtsabnahme“ anlegen mit [K01](../prompts/kontext/K01_Arbeitsregeln-BI-Copilot.md),
  [K02](../prompts/kontext/K02_DAX-Styleguide.md), [K04](../prompts/kontext/K04_Kommentar-Leitfaden-KPI.md),
  [K05](../prompts/kontext/K05_Kennzahlen-Glossar.md) und dieser Checkliste – dann genügt im Prompt „Abschnitt 4 der L05“.
- Punkte mit **(manuell)** kann Copilot nicht prüfen (Gateway, Berechtigungen, Service-Einstellungen).
- Datenschutz: Screenshots und Abgleichstabellen enthalten Zahlen. Nur im unternehmensfreigegebenen Copilot arbeiten,
  keine personenbezogenen Daten ([Grundregeln](../prompts/00_Prompting-Grundregeln.md), Regel 10).
- Copilot in Power BI (Berichtsbereich, Prep data for AI) braucht Fabric-Kapazität ab F2 bzw. Premium ab P1,
  Admin-Freigabe und keine Testkapazität. Die Checkliste funktioniert auch ohne.

## 1 Daten und Aktualisierung

- [ ] Jede Quelle dokumentiert: Azure SQL (Server, Datenbank, View), Dataflow (Arbeitsbereich, Name), SAP-Export
      (Ablageort, Datei, wer exportiert wann). Keine Pfade auf dem eigenen Rechner.
- [ ] **(manuell)** Gateway: Quellen hinter der Firewall (Dateifreigabe mit SAP-Exporten, lokale Datenbanken) sind einem
      Gateway-Cluster zugeordnet; Import- und DirectQuery-Modelle möglichst über getrennte Gateways.
- [ ] **(manuell)** Anmeldeinformationen im Service mit technischem statt persönlichem Konto; Datenschutzebenen im
      Service gesetzt (Desktop veröffentlicht sie nicht mit).
- [ ] **(manuell)** Zeitplan passt zum Datenfluss: Modell aktualisiert **nach** Dataflow und SAP-Export, nicht davor.
- [ ] Große Faktentabellen: inkrementelle Aktualisierung geprüft (`RangeStart`/`RangeEnd`, Filter faltet zur Quelle,
      siehe [L01](L01_Power-Query.md)). Danach kein erneutes Publish desselben Modells aus Desktop.
- [ ] **(manuell)** Fehlerfall: Fehlerbenachrichtigung an Besitzer aktiv, zusätzlich Team-Postfach unter „Diese Kontakte
      benachrichtigen“ (nur Konten im eigenen Mandanten). Nach vier Fehlschlägen in Folge deaktiviert der Service den Zeitplan.
- [ ] Ausgefallene Quelle getestet: Was zeigt der Bericht, wenn der SAP-Export fehlt oder leer ist?
- [ ] **Datenstand sichtbar** auf jeder Seite (Measure „Daten bis“ aus dem letzten Buchungsdatum, nicht `NOW()`),
      dazu der Berichtsmonat im Titel oder Untertitel.

```text
Du bist Power-BI-Entwickler*in und prüfst die Datenanbindung eines Berichts vor der Veröffentlichung.
Kontext: Power-Query-Abfragen bzw. Partitionsausdrücke (M) des Modells:
[EINFÜGEN: M-Code, Server- und Pfadangaben durch Platzhalter ersetzt]
Aufgabe: Erstelle eine Tabelle „Abfrage | Quelle | Quelltyp (Cloud / lokal / Datei) | Gateway nötig? (Vermutung) |
Speichermodus | Risiko | Empfehlung“. Prüfe auf lokale Pfade, fest codierte Datumswerte, fehlende Typisierung,
Schritte, die Query Folding brechen, und Filter, die für inkrementelle Aktualisierung taugen.
Regeln: Nur aus dem Code ableiten; Gateway und Zugangsdaten kennzeichnest du als „im Service prüfen“.
Ausgabe: Tabelle, danach höchstens 5 Stichpunkte. Liste am Ende alle Annahmen auf.
```

## 2 Semantisches Modell

- [ ] Sternschema: Fakten (Leistung, Maßnahmen) hängen an Dimensionen (Kalender, Region, Leistungsart); Beziehungen 1:n,
      einfache Filterrichtung, bidirektional nur begründet.
- [ ] Datumstabelle markiert; Zeitintelligenz läuft über `Kalender[Datum]`, nicht über Faktspalten.
- [ ] Schlüssel und technische Spalten (IDs, Sortier- und Hilfsspalten) ausgeblendet und nicht summiert.
- [ ] Textspalten mit eigener Reihenfolge (Monatsname, Status) haben eine Sortierspalte.
- [ ] Formatstrings gesetzt (`#,0 €`, `0.0 %`), Einheiten wie in [K02](../prompts/kontext/K02_DAX-Styleguide.md).
- [ ] Keine impliziten Measures: Visuals verwenden explizite Measures; Faktspalten sind ausgeblendet oder bewusst sichtbar.
- [ ] Jedes sichtbare Measure und jede sichtbare Spalte hat Beschreibung und Anzeigeordner
      (Vorlage: [M1-12](../prompts/modul1/M1-12_Beschreibungen-als-TMDL.md)).
- [ ] Größe: keine ungenutzten Spalten, keine Zeitstempel mit Sekunden ohne Bedarf, „Automatisches Datum/Uhrzeit“ aus.
- [ ] RLS (falls nötig): Rollen definiert, Filter auf Dimensionen, unbekannte Kennungen liefern keine Zeilen.
- [ ] Gegenprobe: Abfrage 5 (ohne Beschreibung) und 6 (Hygiene-Verdacht) aus
      [`INFO_Abfragen.dax`](../uebungsdaten/modul1/INFO_Abfragen.dax) ausgeführt, jede Zeile erledigt oder begründet.

```text
Du bist Power-BI-Architekt*in und machst die Modellabnahme vor der Veröffentlichung.
Kontext:
- TMDL des Modells ohne Partitionen: [EINFÜGEN]
- Ergebnis Abfrage 5 und 6 aus INFO_Abfragen.dax: [EINFÜGEN]
- Prüfliste: Abschnitt 2 der Checkliste L05 und DAX-Styleguide K02 (im Notebook).
Aufgabe: Prüfe das Modell Punkt für Punkt gegen Abschnitt 2. Bewerte jede Zeile aus Abfrage 6 als echten Befund
oder Fehlalarm (die Abfrage sucht nur nach Text, z. B. „/“ auch in Kommentaren).
Regeln: Belege jeden Befund mit dem Objektnamen aus dem TMDL. Ändere nichts, schlage nur vor.
Ausgabe: Tabelle „Prüfpunkt | Status (erfüllt / offen / nicht prüfbar) | Objekt | Befund | Vorschlag | Aufwand S/M/L“.
Wenn Informationen fehlen, frag nach, statt zu raten.
```

## 3 Kennzahlen und Zahlenprüfung

- [ ] Abgleich gegen die Quelle: Hauptkennzahlen je Monat im Bericht = Quellsystem (Azure-SQL-View, SAP-Export,
      Vorsystem), Toleranz vorher festgelegt.
- [ ] Gesamtsummen in Tabellen und Matrizen = Summe der Zeilen – oder dokumentiert, warum nicht (Quoten, Durchschnitte).
- [ ] VJ stimmt mit dem Vorjahresbericht; Plan entspricht der gültigen Planversion.
- [ ] Stichproben: drei bis fünf Einzelwerte (eine Region, ein Monat, eine Leistungsart) von Hand nachgerechnet.
- [ ] Grenzfälle: leerer Monat, Region ohne Plan (Division durch 0 → leer), neue Kostenstelle, Maßnahme ohne Zieltermin,
      Jahreswechsel.
- [ ] Ampeln und Schwellen ergeben in der Verteilung Sinn (Abfrage 9 in
      [`INFO_Abfragen.dax`](../uebungsdaten/modul1/INFO_Abfragen.dax)) und passen zum Glossar.
- [ ] Datenqualität vor Kommentar: Dubletten, Ausreißer, Kommafehler ([M2-03](../prompts/modul2/M2-03_Datenprofil-und-Plausibilitaetscheck.md));
      Maßnahmentracking konsistent ([M2-08](../prompts/modul2/M2-08_Massnahmentracking-Konsistenzcheck.md)).

Abgleichsabfrage für die DAX-Abfrageansicht (Namen aus dem Übungsmodell, Ergebnis als Excel speichern):

```dax
EVALUATE
SUMMARIZECOLUMNS (
    Kalender[Monat],
    "Ist Kosten", [Ist Kosten],
    "Plan Kosten", [Plan Kosten]
)
ORDER BY Kalender[Monat]
```

Plausibilitätsprüfung im **Analyst-Agenten** oder in **Copilot in Excel** – dort wird gerechnet, nicht geschätzt:

```text
Du bist Controller*in und prüfst Zahlen vor der Berichtsfreigabe.
Kontext: Die angehängte Datei enthält je Monat die Werte aus dem Bericht (Spalten „Bericht_…“) und aus der Quelle
(Spalten „Quelle_…“). [EINFÜGEN: Dateiname, Kennzahlen, Einheit, Toleranz z. B. ±0,5 %]
Aufgabe: Berechne je Monat und Kennzahl die Differenz absolut und in Prozent, markiere alles außerhalb der Toleranz.
Prüfe, ob die Jahressumme der Monatswerte der Gesamtsumme entspricht und ob Monate fehlen.
Regeln: Rechne tatsächlich (Python bzw. Excel-Formeln), schätze nicht. Keine Ursachen, die nicht in den Daten stehen.
Ausgabe: Tabelle der Abweichungen, danach höchstens 5 Prüfhinweise. Zeige deinen Rechenweg.
```

## 4 Berichtsgestaltung

- [ ] Jede Seite hat einen **Aussage-Titel** („Kosten Oktober 2026: Ost 7 % über Plan“ statt „Kostenübersicht“);
      Visual-Titel ohne kryptische Feldnamen (`m_QQ`, `Sum of …`).
- [ ] Einheiten und Skalierung sichtbar (€, T€, %, Pp.); gleiche Kennzahl auf allen Seiten gleich formatiert.
- [ ] Wertachsen von Balken und Säulen beginnen bei 0; vergleichbare Diagramme haben dieselbe Skala.
- [ ] Farben und Notation einheitlich: IST/PL/VJ immer gleich, Abweichungen klar günstig/ungünstig (Kosten über Plan =
      ungünstig), Notation wie in [K04](../prompts/kontext/K04_Kommentar-Leitfaden-KPI.md).
- [ ] Filter und Slicer sichtbar oder im Filterbereich erklärt; ausgeblendete Filter dokumentiert; Startauswahl
      (z. B. aktueller Monat) bewusst gespeichert.
- [ ] Interaktionen geprüft (Format › Interaktionen bearbeiten): Kreuzfilterung nur, wo sie Sinn ergibt.
- [ ] Drillthrough von der Übersicht in den Detailbericht funktioniert, mit Zurück-Schaltfläche und übergebenen Filtern.
- [ ] Tooltips ergänzen nur (Definition, Vorjahr) – keine Pflichtinformation nur im Tooltip.
- [ ] Lesezeichen und Navigationsschaltflächen getestet, keine Lesezeichen mit veralteten Filtern.
- [ ] Mobile Ansicht: Hochformat-Layout für Seiten, die unterwegs gelesen werden (wirkt nur in den Mobile-Apps).

```text
Du bist Reviewer*in für Power-BI-Berichte im Produktionscontrolling.
Kontext: Anhang = Screenshot der Seite [EINFÜGEN: Seitenname] des Berichts [EINFÜGEN: Kennzahlenübersicht /
Detailbericht / Maßnahmentracking], Zielgruppe [EINFÜGEN]. Prüfliste: Abschnitte 4 und 5 der L05, Notation laut K04.
Aufgabe: Prüfe die Seite gegen jeden Punkt aus Abschnitt 4 und gegen die sichtbaren Punkte aus Abschnitt 5
(Kontrast, Farbe als einziges Merkmal, Lesbarkeit). Schlage für jeden Visual-Titel einen Aussage-Titel vor.
Regeln: Beurteile nur, was im Bild erkennbar ist; Interaktionen, Tooltips, Lesezeichen und Alt-Text kennzeichnest du
als „nicht aus dem Bild prüfbar“. Zahlen im Bild nicht interpretieren.
Ausgabe: Tabelle „Prüfpunkt | Visual | Befund | Vorschlag | Priorität (hoch/mittel/niedrig)“, höchstens 15 Zeilen.
```

## 5 Barrierefreiheit

- [ ] Kontrast von Text (Titel, Achsen, Datenbeschriftungen) zum Hintergrund mindestens 4,5 : 1.
- [ ] Farbe nie als einziges Merkmal: Ampeln zusätzlich mit Symbol oder Text, Abweichungen mit Vorzeichen.
- [ ] Keine schwer unterscheidbaren Paare (Rot/Grün, Grün/Braun, Blau/Lila) im selben Diagramm.
- [ ] Alt-Text für jedes inhaltliche Visual (Format › Allgemein › Alternativtext, max. 250 Zeichen), bei wechselnden
      Zahlen dynamisch per Measure.
- [ ] Tab-Reihenfolge gesetzt (Ansicht › Auswahl › Aktivierreihenfolge); dekorative Formen und Bilder daraus entfernt.
- [ ] Sortierung jedes Visuals bewusst gesetzt – die barrierefreie Datentabelle (Alt+Umschalt+F11) übernimmt sie.
- [ ] Bericht einmal nur mit der Tastatur bedient, inklusive Schaltflächen und Lesezeichen.

```text
Du schreibst Alternativtexte für Power-BI-Visuals.
Kontext: Anhang = Screenshot der Seite; Visuals mit Titel und Zweck: [EINFÜGEN]
Aufgabe: Formuliere je Visual einen Alt-Text: was gezeigt wird (Kennzahl, Gliederung, Vergleich) und welche Frage es
beantwortet. Kennzeichne dekorative Visuals, die aus der Tab-Reihenfolge sollen.
Regeln: Höchstens 250 Zeichen, keine konkreten Zahlen (die Daten ändern sich), Fachbegriffe ausschreiben („Plan“
statt „PL“). Visualtyp und Titel nicht wiederholen – der Screenreader liest sie schon vor.
Ausgabe: Tabelle „Visual | Alt-Text | Zeichenzahl“.
```

## 6 Performance

- [ ] Leistungsanalyse je Seite aufgezeichnet (Aufzeichnung starten › Visuals aktualisieren), auch nach typischen
      Slicer-Klicks; Ergebnis als `.json` exportiert.
- [ ] Langsame Visuals nach Ursache getrennt: **DAX-Abfrage** (Measure optimieren, [L02](L02_DAX.md)), **Direkte Abfrage**
      (Quelle, Index, Folding), **Visualanzeige** (zu viele Datenpunkte, Bilder).
- [ ] Visuals je Seite begrenzt (Teamrichtwert festlegen, z. B. 8–12 datenbezogene Visuals – Erfahrungswert, keine
      Microsoft-Grenze); mehrere Karten durch ein Visual mit mehreren Kennzahlen ersetzt.
- [ ] DirectQuery: Abfragereduktion aktiv (Übernehmen-Schaltfläche für Slicer, Kreuzhervorhebung nur wo nötig), Antwortzeit
      je Visual möglichst unter 5 Sekunden, Gesamtsummen nur, wo gebraucht. Mit RLS: Quelllast mit der Datenbank-Administration abgestimmt.
- [ ] Test im Service mit realistischer Datenmenge – nicht nur in Desktop mit Teildaten.

```text
Du bist Performance-Analyst*in für Power BI.
Kontext: Export der Leistungsanalyse (JSON) bzw. Tabelle „Visual | DAX-Abfrage ms | Direkte Abfrage ms |
Visualanzeige ms | Sonstiges ms“ der Seite [EINFÜGEN], Speichermodus [EINFÜGEN: Import / DirectQuery / gemischt].
Aufgabe: Nenne die fünf langsamsten Visuals, ordne jedem die Hauptursache zu und schlage je eine Maßnahme vor.
Regeln: Trenne strikt zwischen DAX, Quelle und Darstellung. Keine Maßnahme ohne Bezug auf einen Messwert.
Ausgabe: Tabelle „Visual | Gesamt ms | Hauptursache | Maßnahme | erwarteter Effekt (hoch/mittel/gering)“.
```

## 7 Sicherheit und Governance

- [ ] **(manuell)** Arbeitsbereiche für Entwicklung, Test, Produktion getrennt; Administrator/Mitglied/Mitwirkender nur
      fürs Entwicklerteam, Konsumenten über App oder Rolle Betrachter.
- [ ] **(manuell)** RLS gilt nur für Betrachter – ab Mitwirkender sieht man alles. Rollen im Service mit Gruppen besetzt.
- [ ] **(manuell)** RLS getestet: Desktop „Anzeigen als“, Service „Als Rolle testen“, je Rolle eine erwartete und eine
      unerwartete Kennung. Copilot-Antworten deckt „Als Rolle testen“ nicht ab.
- [ ] **(manuell)** Vertraulichkeitsbezeichnung (Purview) auf Bericht und Modell, sofern in Ihrem Mandanten aktiviert.
      Sie wandert beim Export nach Excel, PDF und PowerPoint mit – **nicht** bei CSV.
- [ ] **(manuell)** Export-Einstellung bewusst gewählt: zusammengefasste und zugrunde liegende Daten, nur zusammengefasste
      oder keine (Optionen › Aktuelle Datei › Berichtseinstellungen; Admin-Einstellungen haben Vorrang).
- [ ] **(manuell)** Freigabe über die **App** mit Zielgruppen statt Einzel-Links; Build-Berechtigung aufs Modell nur für
      Personen, die selbst Berichte bauen oder in Excel analysieren.
- [ ] **(manuell)** Nach Abnahme höhergestuft (Promoted); Zertifizierung nach dem Verfahren Ihrer Organisation beantragt,
      sofern eingerichtet.

```text
Du hilfst beim Test der Zeilensicherheit (RLS) eines Power-BI-Modells.
Kontext: Rollendefinitionen aus dem TMDL (role …, tablePermission …): [EINFÜGEN]
Fachliche Zuordnung: [EINFÜGEN: z. B. Regionalleitung sieht nur ihre Region, Bereichsleitung alles]
Aufgabe: Erstelle eine Testmatrix „Rolle | Testkennung (Platzhalter, keine echten Namen) | erwartete Regionen |
Prüf-Visual | erwartete Summe (leer zum Ausfüllen) | Testfall unerwarteter Wert“. Prüfe die DAX-Filter auf Lücken:
Was sieht jemand, der in keiner Zuordnung steht?
Ausgabe: Tabelle, danach Befunde zu den Filterausdrücken. Wenn Informationen fehlen, frag nach.
```

## 8 Veröffentlichen und Betrieb

- [ ] Weg in die Produktion festgelegt: Bereitstellungspipeline (Entwicklung → Test → Produktion, Fabric-Kapazität nötig)
      oder Git-Integration mit PBIP. Einschränkungen prüfen – laut Microsoft Learn unterstützen Bereitstellungspipelines
      Berichte im PBIR-Format derzeit nicht.
- [ ] **(manuell)** Nach dem Bereitstellen Modell im Ziel aktualisiert (Daten werden nicht kopiert); Zeitplan,
      Anmeldeinformationen, RLS-Mitglieder und Höherstufung im Ziel gesetzt (werden nicht übertragen).
- [ ] **(manuell)** App aktualisiert („App aktualisieren“) – Publish und Bereitstellung ändern die App nicht. Wird ein
      Bericht aus der App entfernt, verlieren Nutzer ihre persönlichen Lesezeichen.
- [ ] **(manuell)** Abonnements und Datenwarnungen für Kernkennzahlen eingerichtet bzw. angeboten.
- [ ] Dokumentation aktuell: Modell ([L04](L04_Dokumentation-aus-TMDL.md), [M1-10](../prompts/modul1/M1-10_Modell-dokumentieren.md)),
      Seiten ([M1-11](../prompts/modul1/M1-11_Bericht-dokumentieren.md)), Kennzahlendefinitionen im Glossar.
- [ ] Fachliche und technische Ansprechstelle in Bericht oder App-Beschreibung (Funktion oder Postfach).
- [ ] Änderungsprotokoll gepflegt (Datum, Version, Änderung, Auswirkung auf Zahlen) und Nutzern mitgeteilt –
      Power BI informiert interne Nutzer bei App-Updates nicht selbst.

```text
Du schreibst eine Änderungsnotiz für Nutzer eines Power-BI-Berichts im Produktionscontrolling.
Kontext: Bericht [EINFÜGEN], Zielgruppe [EINFÜGEN], Änderungen laut Protokoll: [EINFÜGEN: Stichpunkte]
Aufgabe: Formuliere eine Nachricht (Teams oder E-Mail) mit Betreff, zwei Sätzen „Was ist neu“, Auswirkungen auf Zahlen
(ändern sich Vormonate? warum?), was Nutzer tun müssen (z. B. Lesezeichen neu anlegen), Ansprechstelle (Funktion).
Regeln: Sachlich, höchstens 120 Wörter, nur Änderungen aus dem Protokoll, Zahlen nur, wenn sie im Kontext stehen.
Ausgabe: Betreff und Text, danach eine Ein-Satz-Version für die App-Beschreibung.
```

## 9 Bereit für Copilot und KI

Ausführlich in [M1-13 · Modell KI-fähig machen](../prompts/modul1/M1-13_Modell-KI-faehig-machen.md) – hier die Abnahmepunkte.

- [ ] Grundlagen aus Abschnitt 2 erledigt (Namen, Beschreibungen, Ausblenden, Datumstabelle) – ohne sie hilft der Rest wenig.
- [ ] Beschreibungen tragen das Wichtigste vorn: **Copilot nutzt nur die ersten 200 Zeichen** – fachliche Bedeutung,
      Einheit, wichtige Ausschlüsse zuerst.
- [ ] **(manuell)** Voraussetzungen für **Prep data for AI**: Q&A für das Modell aktiviert, Arbeitsbereich auf F2+/P1+
      (keine Testkapazität), Copilot vom Fabric-Admin freigegeben; in Desktop ggf. als Vorschaufeature einschalten.
- [ ] **AI data schema**: nur Tabellen, Spalten und Measures, die Nutzerfragen beantworten sollen.
- [ ] **AI instructions**: Fachbegriffe, Synonyme, „hoch ist gut/schlecht“ je Kennzahl; im Copilot-Bereich in Desktop mit
      Testfragen geprüft (Bereich schließen und neu öffnen, damit Änderungen greifen).
- [ ] **Verified answers** für die drei bis fünf häufigsten Fragen an passenden Visuals hinterlegt.
- [ ] Nach Bereitstellung über Git oder Pipeline: Modell im Service aktualisiert, damit Schema und Instructions greifen.
- [ ] **(manuell)** Modell im Service als **Approved for Copilot** markiert (gilt fürs Modell, nicht für Bericht oder App).
      Wirkt v. a. auf den eigenständigen Copilot, den Microsoft bis Ende Januar 2027 einstellt; die Admin-Einschränkung
      „nur freigegebene Elemente“ gilt laut Doku auch im neuen Microsoft Copilot in Power BI und Fabric (Preview).

```text
Du kürzt Beschreibungen in einem Power-BI-Modell für Copilot.
Kontext: Liste „Objekt | aktuelle Beschreibung“ (Abfrage 2/3 aus INFO_Abfragen.dax oder TMDL): [EINFÜGEN]; Glossar K05.
Aufgabe: Prüfe jede Beschreibung: Stehen fachliche Bedeutung, Einheit und wichtigste Einschränkung in den ersten
200 Zeichen? Schreib eine neue Fassung, wo nicht.
Regeln: Höchstens 200 Zeichen, Deutsch, Measure-Namen in eckigen Klammern. Keine Annahmen über Logik, die nicht in
Beschreibung oder Glossar steht – sonst „bitte fachlich ergänzen“.
Ausgabe: Tabelle „Objekt | alt (Zeichen) | neu | Zeichen“.
```

---

## Abnahme

| Abschnitt | Geprüft von (Funktion) | Am | Ergebnis (freigegeben / mit Auflagen / offen) | Offene Punkte |
|---|---|---|---|---|
| 1 Daten und Aktualisierung | | | | |
| 2 Semantisches Modell | | | | |
| 3 Kennzahlen und Zahlenprüfung | | | | |
| 4 Berichtsgestaltung | | | | |
| 5 Barrierefreiheit | | | | |
| 6 Performance | | | | |
| 7 Sicherheit und Governance | | | | |
| 8 Veröffentlichen und Betrieb | | | | |
| 9 Bereit für Copilot und KI | | | | |
| **Gesamtfreigabe** | | | | |

Vier-Augen-Prinzip: Abschnitt 3 nicht von derselben Person prüfen lassen, die die Measures geschrieben hat.

## Weiterführend (Microsoft Learn, geprüft am 18.11.2026)

- Datenaktualisierung, Fehlerbenachrichtigung: https://learn.microsoft.com/power-bi/connect-data/refresh-data
- Inkrementelle Aktualisierung: https://learn.microsoft.com/power-bi/connect-data/incremental-refresh-overview
- Modell für Copilot optimieren (200 Zeichen): https://learn.microsoft.com/power-bi/create-reports/copilot-evaluate-data
- Barrierefreie Berichte (mit Checkliste): https://learn.microsoft.com/power-bi/create-reports/desktop-accessibility-creating-reports
- Leistungsanalyse: https://learn.microsoft.com/power-bi/create-reports/performance-analyzer
- DirectQuery-Leitfaden: https://learn.microsoft.com/power-bi/guidance/directquery-model-guidance
- Zeilensicherheit testen: https://learn.microsoft.com/fabric/security/service-admin-row-level-security
- Vertraulichkeitsbezeichnungen: https://learn.microsoft.com/fabric/enterprise/powerbi/service-security-sensitivity-label-overview
- Daten exportieren, Berichtseinstellung: https://learn.microsoft.com/power-bi/visuals/power-bi-visualization-export-data
- App veröffentlichen und aktualisieren: https://learn.microsoft.com/power-bi/collaborate-share/service-create-distribute-apps
- Höherstufen und Zertifizieren: https://learn.microsoft.com/power-bi/collaborate-share/service-endorsement-overview
- Bereitstellungspipelines (Ablauf, Einschränkungen): https://learn.microsoft.com/fabric/cicd/deployment-pipelines/understand-the-deployment-process
- Prep data for AI, Approved for Copilot: https://learn.microsoft.com/power-bi/create-reports/copilot-prepare-data-ai
- Neuerungen November 2026 (Einstellung eigenständiger Copilot): https://learn.microsoft.com/power-bi/fundamentals/whats-new
