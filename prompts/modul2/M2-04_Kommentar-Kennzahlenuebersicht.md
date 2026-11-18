# M2-04 · Kommentarvorschlag für die Kennzahlenübersicht (Berichtsmonat Oktober 2026)

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | M365 Copilot Chat oder Notebook (mit K04/K05); Variante: Copilot im Power-BI-Bericht* | Ü2.3 | 20 min |

\* Copilot im Bericht (Copilot-Bereich „Zusammenfassen“ bzw. Visual **Narrative/Erzählung** mit Copilot)
braucht einen Workspace auf **bezahlter Fabric-Kapazität oder Power BI Premium (P1+)**, die Freigabe durch
den Fabric-Admin (Mandanteneinstellung) und eine unterstützte Region; Trial-Kapazitäten werden nicht
unterstützt. Für das Narrative-Visual brauchen Sie Bearbeitungsrechte. Er fasst nur zusammen, **was auf der
Berichtsseite sichtbar ist**, nicht das Modell – und er kennt weder Ihren Kommentar-Leitfaden noch Datenfehler.
Der Weg über M365 Copilot Chat unten funktioniert ohne Kapazität.

## Wofür
Die Kennzahlenübersicht braucht jeden Monat drei bis sechs Sätze: Wo stehen wir, was weicht ab, warum,
was ist zu tun. Copilot liefert einen **Entwurf** nach festen Regeln. Die Verantwortung für Aussage und
Zahlen bleibt bei Ihnen.

## Vorbereitung
- Plausibilitätscheck (M2-03) ist erledigt. Bekannte Datenfehler notieren – sie gehören in den Prompt.
- Daten: `KPI_Monat_Region.csv` anhängen (Copilot braucht Vormonate und Vorjahresmonat für Vergleiche)
  oder Export der Tabelle „je Region“ aus der Kennzahlenübersicht, Slicer Monat = 2026-10.
- Kontext: **K04** (Kommentar-Leitfaden) und **K05** (Kennzahlen-Glossar) im Notebook hinterlegen oder anhängen.
- Szenario-Kürzel nach IBCS: **IST** (Actual), **PL** (Plan), **VJ** (Vorjahr), **ΔPL**, **ΔVJ**.

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot (Enterprise Data Protection).
> Keine personenbezogenen Daten. Bei echten Berichten keine Namen von Verantwortlichen in den Kommentar –
> Rollen genügen („Teamleitung Reinigung Ost“).

## Prompt
```text
Du bist Controller*in im Produktionscontrolling eines Dienstleisters und schreibst den Monatskommentar
für die Kennzahlenübersicht. Leser: Bereichsleitung, wenig Zeit, will wissen, wo sie handeln muss.

Kontext:
- Berichtsmonat: Oktober 2026. Vergleich: Plan (PL) und Vorjahresmonat (VJ).
- Daten: angehängte Datei [EINFÜGEN: Dateiname] mit Monatswerten je Region Jan 2025 – Okt 2026.
  Einheit der Prozentspalten: [EINFÜGEN: „Prozentwert, 7,12 = 7,12 %“ (Übungsexporte) oder „Anteil, 0,0712 = 7,12 %“ (eigene DAX-Abfrage)]. Qualitaetsquote entspricht dem Measure m_QQ.
- Bekannte Datenfehler (nicht kommentieren, sondern als Datenhinweis nennen):
  [EINFÜGEN: Funde aus dem Plausibilitätscheck, z. B. „Südwest Sep 2026 Ist_Kosten Fahrzeugreinigung ca. × 10
  (Kommafehler)“, „Nord Mai 2026 Bahnhofsreinigung doppelt geladen“]
- Schwellen: Kostenabweichung ab ±3 % kommentieren, ab +5 % kritisch; Qualitätsquote unter 90 % kritisch;
  Krankenquote über 8 % beobachten. [EINFÜGEN: eigene Schwellen oder „siehe K04“]
- Halte dich an den Kommentar-Leitfaden (K04) und das Kennzahlen-Glossar (K05), sofern angehängt.

Aufgabe: Schreib einen Kommentarvorschlag für Oktober 2026.

Regeln:
1. Aussage zuerst: Der erste Satz ist die wichtigste Botschaft des Monats (wie eine Überschrift, mit Zahl).
2. Jede Zahl stammt aus der Datei oder ist daraus berechnet. Rechne mit dem Analysewerkzeug, nicht im Kopf.
3. Abweichungen immer mit Bezug: „IST 1,23 Mio. € liegt 7,1 % über PL“ – nie eine Prozentzahl ohne Basis.
4. Ursachen nur, wenn sie in den Daten belegt sind (z. B. gleichzeitiger Anstieg von Krankenquote und
   Überstunden). Kennzeichne Vermutungen als „mögliche Ursache – zu prüfen“. Erfinde keine Ereignisse.
5. Nenne auch, was im Plan ist, wenn es eine Aussage ist (stabile Regionen in einem Satz).
6. Handlungsbedarf konkret: was, wer (Rolle), bis wann – oder „kein Handlungsbedarf“.
7. Keine Wertungen wie „erfreulich“, „dramatisch“. Sachlich, deutsch, Zahlenformat 1.234.567 € und 7,1 %.
8. Datenfehler nicht kommentieren, sondern im Datenhinweis nennen, mit betroffenen Kennzahlen (z. B. YTD).
9. Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
**Kernaussage** (1 Satz)
**Abweichungen** (2–4 Stichpunkte, je: Region – Kennzahl – IST vs. PL/VJ – ggf. belegte Ursache)
**Handlungsbedarf** (1–3 Stichpunkte)
**Datenhinweis** (1–2 Sätze)
**Belege** (Tabelle: Aussage | Zahl | Quelle: Spalte, Monat, Region | berechnet ja/nein)
Höchstens 120 Wörter ohne die Beleg-Tabelle.

Beispiel für den Stil (andere Daten, nur zur Orientierung):
„Kosten insgesamt im Plan (IST 4,02 Mio. €, +0,8 % ΔPL); Region Beispiel 4,2 % über Plan bei gleichzeitig
gestiegener Überstundenquote (5,1 % nach 3,0 % im Vormonat). Handlungsbedarf: Teamleitung Beispiel prüft
Einsatzplanung bis Monatsende.“
```

## Nachschärfen

Wenn der Kommentar zu lang oder zu allgemein ist:
```text
Kürze auf höchstens 60 Wörter. Behalte nur die Kernaussage, die zwei größten Abweichungen mit Zahl und
den Handlungsbedarf. Streiche alles, was keine Zahl oder keine Handlung enthält.
```

Wenn eine Ursache ohne Beleg auftaucht:
```text
Für die Ursache „[EINFÜGEN: Zitat]“ finde ich keinen Beleg in den Daten. Zeig mir die Spalten und Werte,
auf die du dich stützt. Wenn es keine gibt, formuliere sie als offene Frage an den Fachbereich.
```

Wenn Sie den Titel nach IBCS als Botschaft brauchen:
```text
Formuliere drei Varianten einer Seitenüberschrift als Botschaft (max. 10 Wörter, mit Zahl), z. B.
„Ost treibt Kostenüberschreitung: +7 % ΔPL im Oktober“. Nur Aussagen, die in deinem Kommentar belegt sind.
```

Wenn Sie zusätzlich den Jahresblick brauchen (Achtung Datenfehler):
```text
Ergänze einen Satz zu den Kosten Jan–Okt 2026 (YTD) gegenüber Plan, einmal wie geliefert und einmal ohne die
bekannten Datenfehler. Nenne beide Werte und welcher Wert im Bericht steht.
```

## Ergebnis prüfen
- [ ] Erster Satz enthält die Hauptbotschaft mit Zahl – erwartet: Region **Ost** über Plan bei hoher Kranken-
      und Überstundenquote und gesunkener Qualitätsquote (Übungsdaten).
- [ ] Jede Zahl aus der Beleg-Tabelle in der Datei bzw. im Bericht nachgeschlagen (mindestens drei Stichproben).
- [ ] Der Kommafehler (Südwest, Sep) wird **nicht** als Kostenentwicklung kommentiert, aber im Datenhinweis
      genannt, falls YTD- oder Quartalswerte verwendet werden.
- [ ] Ursachen sind belegt (gleichzeitige Datenbewegung) oder als Vermutung gekennzeichnet.
- [ ] Stabile Region (**Mitte**) taucht höchstens als ein Satz auf – „keine Auffälligkeit“ ist auch eine Aussage.
- [ ] Prozentangaben unterscheiden Prozent und Prozentpunkte (Krankenquote Ost VJ 5,7 % → 9,5 % = **+3,8 Pp.**, nicht +3,8 %).

## Stolperfallen
- **Prozent vs. Prozentpunkte.** Bei Quoten verwechselt Copilot das häufig. Im Prompt ausdrücklich verlangen.
- **Copilot im Bericht rechnet auf der sichtbaren Seite.** Ist der Slicer auf „2026-10“, sieht das Narrative-
  Visual keine Vormonate – Zeitvergleiche erfindet es dann oder lässt sie weg. Es aktualisiert sich nicht
  automatisch bei Filterwechsel (Aktualisieren-Schaltfläche).
- **„KPI Status Text“ ist kein Kommentar.** Das Measure liefert nur ein Etikett (kritisch/beobachten/…), mit
  festen Schwellen im Code. Copilot übernimmt es gern als Begründung – es ist aber selbst nur eine Regel.
- **Glatte Zahlen misstrauen.** „Rund 10 %“ oder „etwa 1 Mio. €“ ohne Beleg sind oft geschätzt. Nachfragen.
