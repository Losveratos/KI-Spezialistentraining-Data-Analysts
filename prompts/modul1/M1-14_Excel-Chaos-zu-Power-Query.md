# M1-14 · Excel-Chaos zu Power Query

| Modul | Werkzeug | Übung | Dauer |
|---|---|---|---|
| 1 | Microsoft 365 Copilot Chat oder Notebook (Datei anhängen) | Ü1.13 | 20 min |

## Wofür
Eine „gewachsene“ Excel- oder CSV-Datei – Vorspann, Summenzeilen, verbundene Zellen, Zahlen als Text,
Kreuztabelle, ein Blatt je Monat – soll als saubere Tabelle ins Modell. Copilot analysiert die Struktur und
schreibt die Power-Query-Abfrage (M). Sie testen sie und prüfen das Ergebnis gegen Kontrollwerte.

## Vorbereitung
- Datei an Copilot anhängen (Chat: **+** › Datei). Nimmt Ihr Copilot die Datei nicht an: die ersten 30–40 Zeilen
  **einschließlich Vorspann und Kopfzeile** sowie die letzten 5 Zeilen als Text einfügen und Blattnamen nennen.
- Zielschema festlegen: Welche Spalten, welche Datentypen, eine Zeile wofür? Für die Übungsdateien steht es in
  [`uebungsdaten/excel-chaos/README.md`](../../uebungsdaten/excel-chaos/README.md).
- Empfohlen: Kontextdatei [K01](../kontext/K01_Arbeitsregeln-BI-Copilot.md) im Notebook hinterlegen.
- **Datenschutz:** nur im freigegebenen Unternehmens-Copilot arbeiten; echte Dateien vorher auf personenbezogene
  Daten prüfen. Die Übungsdateien sind fiktiv.

> Copilot kann die Abfrage nicht ausführen. Ob sie läuft und richtig rechnet, zeigt erst Power BI Desktop oder Excel.

## Prompt

Schritt 1 – erst verstehen, noch kein Code:

```text
Rolle: Du bist erfahrene*r Power-Query-Entwickler*in.

Kontext: Die angehängte Datei [EINFÜGEN: Dateiname] ist ein gewachsener Export bzw. eine manuell gepflegte Liste.
Sie soll per Power Query in Power BI Desktop geladen werden.

Aufgabe: Analysiere die Struktur. Schreibe noch KEINEN Code.

Ausgabe:
1. Aufbau: Blätter, Zeile der Kopfzeile, Spalten, was eine Datenzeile ist.
2. Problemliste als Tabelle: Problem | Fundstelle (Blatt, Zeile/Spalte, Beispielwert) | Folge beim Laden |
   Lösungsansatz in Power Query.
   Prüfe ausdrücklich: Vorspann und Fußzeilen, Leer- und Summenzeilen, verbundene oder nur einmal gefüllte Zellen,
   Zahlen und Datumswerte als Text (Tausenderpunkt, Dezimalkomma, Minus hinten, Einheiten im Wert),
   uneinheitliche Schreibweisen, Dubletten, Kreuztabellen, Informationen, die nur im Blattnamen oder Titel stehen.
3. Rückfragen, die ich fachlich entscheiden muss (z. B. Was bedeutet „–“? Was passiert mit Summenzeilen?).

Regeln: Nenne nur, was du in der Datei siehst, mit Fundstelle. Wenn du einen Teil der Datei nicht lesen konntest,
sag das ausdrücklich.
```

Schritt 2 – die Abfrage schreiben lassen:

```text
Schreibe jetzt die Power-Query-Abfrage (M) für diese Datei.

Zielschema – eine Zeile je [EINFÜGEN: z. B. Buchung / Region, Leistungsart und Monat]:
[EINFÜGEN: Spaltenname | Datentyp | Bedeutung, je Zeile eine Spalte]

Entscheidungen zu deinen Rückfragen: [EINFÜGEN: z. B. „–“ bedeutet keine Planung, Zeile weglassen; Summenzeilen entfernen]

Regeln:
- Der Dateipfad kommt aus dem Parameter pDatei (Text). Keine Pfade im Code.
- Kopfzeile SUCHEN (Zeile, die „[EINFÜGEN: eindeutiger Spaltenname]“ enthält), nicht „erste n Zeilen entfernen“.
- Spalten immer per Name ansprechen, nie per Position.
- Jede Umwandlung von Text in Zahl oder Datum mit Kultur "de-DE".
- Zeilen, die keine Daten sind, über eine fachliche Bedingung entfernen (z. B. „Kostenart ist leer“), nicht über Zeilennummern.
- Schreibweisen über eine Zuordnungstabelle vereinheitlichen. Unbekannte Werte sollen einen Fehler auslösen,
  nicht still verschwinden.
- Die Abfrage muss weiter funktionieren, wenn Zeilen, Monate oder Blätter dazukommen.
- Schritte sprechend benennen, das Warum kommentieren.
- Verwende nur Funktionen der Power-Query-M-Referenz. Wenn du bei einer Funktion unsicher bist, sag es.

Ausgabe: ein vollständiger ```powerquery-Block (let … in), danach
(a) Annahmen, (b) drei Kontrollwerte, die ich nach dem Laden prüfen soll (Zeilenzahl, Summe, Anzahl je Kategorie).
```

## Nachschärfen

Wenn Desktop einen Fehler meldet:

```text
Die Abfrage scheitert im Schritt [EINFÜGEN: Schrittname] mit dieser Meldung:
[EINFÜGEN: Fehlermeldung]
Der Schritt davor liefert diese Spalten und Beispielzeilen:
[EINFÜGEN: Spaltennamen und 3 Zeilen aus der Vorschau]
Nenne die Ursache, korrigiere nur diesen Schritt und gib die vollständige Abfrage erneut aus.
```

Wenn Zeilenzahl oder Summe nicht zum Kontrollwert passen:

```text
Erwartet: [EINFÜGEN: z. B. 321 Zeilen, Summe 23.732.247,98]. Geladen: [EINFÜGEN: Ist-Werte].
Nenne die drei wahrscheinlichsten Ursachen (z. B. Summenzeilen mitgeladen, negative Beträge nicht erkannt,
Dublette) und je eine Prüfabfrage oder einen Filter, mit dem ich sie in Power Query nachweise.
```

Wenn die Abfrage zu sehr auf diese eine Datei zugeschnitten ist:

```text
Prüfe deine Abfrage auf Zerbrechlichkeit: Was passiert, wenn (1) eine Zeile im Vorspann dazukommt,
(2) eine Spalte ergänzt oder verschoben wird, (3) ein neuer Monat bzw. ein neues Blatt dazukommt,
(4) eine neue Schreibweise auftaucht? Liste je Fall den betroffenen Schritt und härte ihn.
```

Für die Dokumentation:

```text
Beschreibe die Abfrage für die Modelldokumentation: Quelle, Schritte in einem Satz je Schritt, getroffene
fachliche Entscheidungen, bekannte Grenzen. Höchstens 12 Zeilen.
```

## Ergebnis prüfen
- [ ] Abfrage in Power BI Desktop getestet: **Daten transformieren** › Neue Quelle › **Leere Abfrage** ›
      **Erweiterter Editor**; Parameter `pDatei` vorher angelegt (Parameter verwalten › Neuer Parameter, Typ Text).
- [ ] Zeilenzahl und Summe stimmen mit den Kontrollwerten überein.
- [ ] Keine Fehlerzeilen: Spaltenqualität einblenden (Ansicht › Spaltenqualität), jede Spalte 100 % gültig.
- [ ] Datentypen stimmen: Schlüssel mit führenden Nullen sind Text, Beträge Dezimalzahl, Datum ist Datum.
- [ ] Stichprobe: drei Werte aus der Originaldatei im Ergebnis wiederfinden – darunter ein negativer oder auffälliger.
- [ ] Im Code stehen keine festen Zeilenzahlen (`Table.Skip ( …, 5 )`), keine Spaltenpositionen (`Column7`)
      und kein Pfad.

## Stolperfallen
- **Copilot sieht nicht alles.** Verbundene Zellen, ausgeblendete Spalten und Formate gehen beim Lesen verloren;
  bei großen Dateien liest Copilot nur einen Teil. Lassen Sie sich in Schritt 1 sagen, was gelesen wurde.
- **Englische Kultur als Standard.** Ohne Vorgabe wandelt Copilot gern ohne Kultur um – aus „1.335“ wird dann 1,335.
- **Feste Zeilenzahlen.** „Erste 5 Zeilen entfernen“ funktioniert genau so lange, bis jemand eine Zeile einfügt.
- **Füllen vor dem Filtern.** Wer erst nach unten auffüllt und dann Summenzeilen entfernt, schiebt „Summe …“ in die
  nächste Gruppe.
- **Stille Verluste.** `try … otherwise null` über ganze Spalten versteckt Fehler. Besser: Fehler zulassen und beheben.

Mehr dazu: [L01 · Power Query](../../leitfaeden/L01_Power-Query.md) · [M1-04 M formatieren und kommentieren](M1-04_M-formatieren-kommentieren.md) ·
[M1-08 Fehler beheben](M1-08_Fehler-beheben.md)
