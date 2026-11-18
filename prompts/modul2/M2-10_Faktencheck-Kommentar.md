# M2-10 · Faktencheck eines Kommentars (jede Zahl gegen die Daten)

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 2 | **Neuer** M365 Copilot Chat mit Dateianhang; Gegenprobe in Power BI (DAX-Abfrageansicht) | Ü2.8 | 10 min |

## Wofür
Bevor ein Kommentar in den Bericht geht, wird jede Zahl und jede Aussage belegt. Copilot prüft einen
Kommentar zuverlässiger, wenn er ihn **nicht selbst geschrieben** hat – deshalb ein neuer Chat. Der Prüf-Chat
zerlegt den Text in einzelne Behauptungen, sucht je Behauptung den Beleg und markiert, was fehlt.
Die letzte Instanz bleibt der Bericht bzw. eine DAX-Abfrage.

## Vorbereitung
- Den zu prüfenden Kommentar (aus M2-04, M2-05 oder M2-09, oder einen eigenen) kopieren.
- Dieselbe Datei anhängen, auf der der Kommentar beruht (z. B. `KPI_Monat_Region.csv`).
- Datenfehler-Liste aus M2-03 bereithalten.

> **Datenschutz:** Nur im unternehmensfreigegebenen Microsoft 365 Copilot (Enterprise Data Protection).
> Keine personenbezogenen Daten.

## Prompt
```text
Du bist Revisor*in im Controlling und prüfst einen Monatskommentar, bevor er an die Bereichsleitung geht.
Du hast den Kommentar nicht geschrieben und bist nicht an ihn gebunden.

Kontext:
- Datenbasis: angehängte Datei [EINFÜGEN: Dateiname]. Einheit der Prozentspalten: [EINFÜGEN: „Prozentwert, 7,12 = 7,12 %“ (Übungsexporte) oder „Anteil, 0,0712 = 7,12 %“ (eigene DAX-Abfrage)].
- Berichtsmonat: [EINFÜGEN: Oktober 2026]
- Bekannte Datenfehler: [EINFÜGEN: Funde aus M2-03]

Kommentar:
"""
[EINFÜGEN: Kommentartext]
"""

Aufgabe:
1. Zerlege den Kommentar in einzelne prüfbare Behauptungen (jede Zahl, jeder Vergleich, jede Richtung,
   jede Ursache, jede Handlungsempfehlung ist eine eigene Behauptung).
2. Prüfe jede Behauptung gegen die Datei. Rechne nach (Analysewerkzeug), statt zu schätzen.
3. Prüfe Begriffe: Prozent vs. Prozentpunkte, Vergleichsbasis (PL oder VJ) genannt, Zeitraum genannt,
   Rundung korrekt (Toleranz ±0,1 Prozentpunkte bzw. ±0,5 % bei Beträgen).
4. Prüfe, ob eine Aussage auf einem bekannten Datenfehler beruht.
5. Prüfe, ob eine Ursache als Tatsache formuliert ist, obwohl die Daten nur einen zeitlichen Zusammenhang zeigen.

Regeln:
- Bewertung je Behauptung: „belegt“, „falsch“ (mit richtigem Wert), „nicht prüfbar mit diesen Daten“,
  „Ursache ohne Beleg“, „beruht auf Datenfehler“.
- Ändere den Kommentar erst in Schritt 6, wenn ich darum bitte.
- Wenn Informationen fehlen, frag nach statt zu raten.

Ausgabe:
Tabelle „Nr | Behauptung (Zitat) | Prüfung (Spalte, Monat, Region, Rechnung) | Wert laut Daten | Bewertung“.
Danach: Anzahl Behauptungen je Bewertung und die drei wichtigsten Korrekturen.
```

## Nachschärfen

Nach der Prüfung – korrigierte Fassung erzeugen:
```text
Schritt 6: Schreib den Kommentar neu. Übernimm nur belegte Aussagen, korrigiere falsche Werte, formuliere
Ursachen ohne Beleg als offene Frage und ergänze einen Datenhinweis, wo nötig. Gleiche Struktur, gleiche Länge.
Markiere jede geänderte Stelle mit [geändert].
```

Wenn eine Zahl „nicht prüfbar“ ist:
```text
Welche Spalte oder welche zusätzliche Datei bräuchtest du, um Behauptung [EINFÜGEN: Nr] zu prüfen?
Formuliere die DAX-Abfrage, mit der ich den Wert im Modell nachsehen kann.
```

Gegenprobe im Modell (DAX-Abfrageansicht), z. B. für Region und Monat:
```text
Schreib eine DAX-Abfrage für die DAX-Abfrageansicht, die für Kalender[Monat] = "[EINFÜGEN: 2026-10]" und
Region[Region] = "[EINFÜGEN: Ost]" die Measures Ist Kosten, Plan Kosten, Abw Kosten %, Ist Kosten VJ,
Abw VJ %, m_QQ, Krankenquote und Ueberstundenquote als eine Zeile ausgibt. Nur Namen aus diesem TMDL verwenden:
[EINFÜGEN: TMDL-Ausschnitt Fakt_Leistung, Kalender, Region]
```

## Ergebnis prüfen
- [ ] Jede Zahl im Kommentar hat eine Zeile in der Prüftabelle – fehlt eine, Prüfung nachfordern.
- [ ] Mindestens zwei Werte selbst im Bericht oder per DAX-Abfrage nachgesehen (nicht nur Copilot glauben).
- [ ] Prozentpunkte bei Quoten-Veränderungen korrekt (z. B. Krankenquote +4 Pp., nicht +4 %).
- [ ] Ursachen ohne Beleg sind markiert und in der Neufassung als Frage formuliert.
- [ ] Neufassung ist nicht länger als das Original und enthält keine neuen, ungeprüften Zahlen.

## Stolperfallen
- **Prüfen im selben Chat** führt oft zu „Alle Angaben sind korrekt“. Immer neuer Chat.
- **Rundungsdiskussionen.** Legen Sie die Toleranz fest, sonst markiert Copilot 7,1 % vs. 7,08 % als Fehler – oder
  übersieht 7,1 % vs. 6,1 %.
- **Datei ≠ Bericht.** Der Export kann einen anderen Stand haben als der Bericht (Aktualisierung, Filter).
  Bei Abweichungen gilt das Modell; Exportzeitpunkt notieren.
- **Neufassung schmuggelt neue Zahlen ein.** Neufassungen genauso prüfen wie das Original.
