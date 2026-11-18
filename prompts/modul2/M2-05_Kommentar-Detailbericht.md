# M2-05 · Kommentar für den Detailbericht (Zeitreihe und Drilldown Region)

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | M365 Copilot Chat mit Dateianhang, Analyst* oder Copilot in Excel | Ü2.4 | 15 min |

\* Analyst: vorinstallierter Agent in Microsoft 365 Copilot Chat, Teil der Microsoft-365-Copilot-Lizenz, rechnet
mit Python. Ohne Analyst: normaler Copilot Chat mit angehängter Datei.

## Wofür
Der Detailbericht zeigt Entwicklungen über die Zeit und je Region. Der Kommentar beantwortet: Seit wann
weicht etwas ab, wie stark, wo genau (Region, Leistungsart) – und was hängt zeitlich zusammen? Gute
Detailkommentare zeigen eine **Wirkungskette mit Zeitbezug**, schlechte zählen Monatswerte auf.

## Vorbereitung
- `KPI_Monat_Region_Leistungsart.csv` anhängen (für den Drilldown) oder Export der Matrix Region × Monat
  aus dem Detailbericht.
- Bekannte Datenfehler aus M2-03 bereithalten.
- Region festlegen, die Sie im Drilldown kommentieren (Übung: **Ost**; zum Vergleich **Mitte** und **Süd**).
- Optional **K04**, **K05**.

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot (Enterprise Data Protection).
> Keine personenbezogenen Daten.

## Prompt
```text
Du bist Controller*in im Produktionscontrolling und kommentierst den Detailbericht.

Kontext:
- Daten: angehängte Datei [EINFÜGEN: Dateiname], Monatswerte je Region und Leistungsart, Jan 2025 – Okt 2026.
  Einheit der Prozentspalten: [EINFÜGEN: „Prozentwert, 7,12 = 7,12 %“ (Übungsexporte) oder „Anteil, 0,0712 = 7,12 %“ (eigene DAX-Abfrage)]. Qualitaetsquote = Measure m_QQ (bestandene / durchgeführte Prüfungen).
- Fokusregion: [EINFÜGEN: z. B. Ost]. Vergleichsregion ohne Auffälligkeit: [EINFÜGEN: z. B. Mitte].
- Bekannte Datenfehler, die du ausklammerst: [EINFÜGEN: Funde aus M2-03]
- Halte dich an K04 und K05, sofern angehängt.

Aufgabe:
1. Zeitreihe Fokusregion: Bestimme für Abw_Kosten_Prozent, Krankenquote, Ueberstundenquote und
   Qualitaetsquote je den Monat, ab dem der Wert dauerhaft vom eigenen Niveau Jan 2025 – Jun 2026 abweicht
   (Kriterium: mehr als 2 Standardabweichungen über bzw. unter dem Mittel dieses Zeitraums). Gib
   Ausgangsniveau, aktuellen Wert (Okt 2026) und Veränderung an.
2. Zeitliche Reihenfolge: Welche Kennzahl bewegt sich zuerst, welche folgt mit wie vielen Monaten Abstand?
3. Drilldown: Welche Leistungsarten der Fokusregion tragen die Kostenabweichung im Okt 2026 (Beitrag in €
   und Anteil an der Gesamtabweichung der Region)?
4. Vergleich: Zeigt die Vergleichsregion im selben Zeitraum ein ähnliches Muster? (Abgrenzung regional vs. allgemein)
5. Schreib danach den Kommentar.

Regeln:
- Rechne mit dem Analysewerkzeug und nenne die Rechenregel. Keine geschätzten Zahlen.
- Zeitliche Abfolge ist ein Hinweis, kein Beweis für eine Ursache. Formuliere Wirkungsketten als
  „passt zu“ / „zeitlich folgend“, nicht als „verursacht“, solange kein fachlicher Beleg vorliegt.
- Prozentpunkte (Pp.) für Veränderungen von Quoten, Prozent (%) für Veränderungen von Beträgen.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
A) Tabelle „Kennzahl | Niveau Jan 25–Jun 26 | Okt 2026 | Veränderung | auffällig ab Monat“
B) Tabelle „Leistungsart | Abweichung IST–PL Okt 2026 in € | Anteil an Regionsabweichung“
C) Kommentar, max. 100 Wörter: Kernaussage mit Zahl → Verlauf mit Zeitbezug → Schwerpunkt im Drilldown →
   Abgrenzung zur Vergleichsregion → Handlungsbedarf bzw. offene Frage an den Fachbereich.
```

## Nachschärfen

Wenn Copilot die Monate nur aufzählt:
```text
Fasse den Verlauf in einem Satz mit Anfangs- und Endpunkt zusammen („von 5,6 % im Juni auf 9,5 % im
Oktober“). Keine Aufzählung einzelner Monate.
```

Wenn die zeitliche Reihenfolge unklar bleibt:
```text
Erstelle eine Tabelle Monat Jun–Okt 2026 mit Krankenquote, Ueberstundenquote und Qualitaetsquote der
Fokusregion nebeneinander und markiere je Spalte den ersten Monat außerhalb des Normalbereichs.
```

Wenn Sie eine positive Entwicklung kommentieren wollen (z. B. Region Süd):
```text
Wiederhole Schritt 1–3 für Region Süd, Leistungsart Fahrzeugreinigung, mit Produktivitaet und Ist_Stunden.
Vergleiche Jan–Apr 2026 mit Mai–Okt 2026 (Mittelwerte) und mit denselben Monaten 2025. Schreib einen Kommentar,
der die Verbesserung mit Zahl belegt, ohne eine Ursache zu nennen, die nicht in den Daten steht.
```

Wenn Sie eine Grafik als Beleg brauchen:
```text
Erstelle ein Liniendiagramm Jan 2025 – Okt 2026 für die Fokusregion mit Krankenquote und Qualitaetsquote
(zweite Achse) und markiere den Beginn der Auffälligkeit. Beschrifte die Achsen auf Deutsch.
```

## Ergebnis prüfen
- [ ] Für **Ost**: Krankenquote und Überstundenquote steigen ab **Juli 2026** gemeinsam; Qualitätsquote fällt
      **einen Monat später** (ab August). Ist das in Copilots Tabelle A so abgebildet?
- [ ] Werte in Tabelle A gegen die Linie im Detailbericht prüfen (Slicer Region = Ost).
- [ ] Drilldown-Summe der Leistungsarten = Gesamtabweichung der Region (Copilot rechnet Anteile gern auf über 100 %).
- [ ] **Mitte** zeigt kein vergleichbares Muster → Kommentar sagt „regional, nicht allgemein“.
- [ ] Wirkungskette ist als Hinweis formuliert („zeitlich folgend“), nicht als bewiesene Ursache.
- [ ] Kein Satz über Südwest/Sep als „Kostensprung“ (Kommafehler).

## Stolperfallen
- **Niveau falsch gewählt.** Wer Okt 2026 mit dem Gesamtmittel inkl. Jul–Okt vergleicht, unterschätzt den
  Anstieg. Referenzzeitraum vor der Auffälligkeit wählen.
- **Saison übersehen.** Krankenquoten sind in Jan/Feb in allen Regionen höher. Ein Anstieg im Januar ist kein
  regionales Problem – Vergleich mit dem Vorjahresmonat oder anderen Regionen klärt das.
- **Anteile an einer Abweichung** können über 100 % liegen, wenn einzelne Leistungsarten unter Plan liegen.
  Das ist richtig, muss aber erklärt werden.
- **Matrix-Export mit Zwischensummen.** „Daten mit aktuellem Layout“ kann Zwischensummen enthalten, die Copilot
  doppelt zählt. Flache Exporte oder die Übungs-CSV verwenden.
