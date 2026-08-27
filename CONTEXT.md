# Vokabular

Damit spätere Sitzungen dieselben Wörter benutzen wie das Konzept. Diese Begriffe
sind die Sprache des Projekts — in Commit-Nachrichten, Dateinamen, Knotennamen
und Gesprächen.

> **Wichtig für Slice 0:** Von allem hier unten existiert im Code **nichts**
> außer *Maßstab*, *Einheit*, *Kiste* und *Parcours*. Die übrigen Begriffe
> beschreiben das Zielbild, nicht den Stand. Wer sie in Slice 0 implementiert,
> arbeitet am falschen Problem.

## Weltmodell

| Begriff | Bedeutung |
|---|---|
| **Auto** | Genau eines, immer dasselbe. Es sammelt Teile, Kratzer und Geschichte an. Es gibt keine Fahrzeugauswahl — die würde die Bindung zerstören. |
| **Region** | Ein zusammenhängender Weltabschnitt: Garagenboden, Dachrinne, Gully, Schuppen, Kanalsystem, Garten, Werkbank. Jede Region liefert die Teile für die nächste. |
| **Gate** | Eine sichtbare Grenze, die genau ein Teil aufhebt. Die Pfütze, an der man zehnmal umgedreht ist, wird zum Eingang. Ein Gate muss ohne Tutorial lesbar sein. |
| **Werkbank** | Der Ort, an dem umgebaut wird. Sichtbarer Einbau — das Teil verändert das Modell. |
| **Ladestelle** | Wo die Leine wieder aufgefüllt wird. Wird gefunden, nicht abgearbeitet: eine Knopfzelle, ein Ladegerät, eine Solar-Gartenlampe. |
| **Gefahr** | Was anderswo ein Gegner wäre. Rasensprenger, Saugroboter auf fester Route, Wespe im Kreisflug. Physik statt Verhalten, keine KI. |

## Fortschritt

| Begriff | Bedeutung |
|---|---|
| **Teil** | Der Oberbegriff für alles Anbaubare. Zerfällt strikt in zwei Achsen: |
| **Traversal-Teil** | Binär, permanent, weltöffnend. Schaltet frei, *wo* man hinkommt. Ungefähr sechs Stück: Magnetreifen, Dichtung + Ballast, Rotor, Rammbock, Druckkörper + Licht, Magnetgreifer. Jedes ist ein Schlüssel für ein sichtbares Schloss. |
| **Tuning-Teil** | Kontinuierlich, tauschbar, mit Zielkonflikt. Verändert, *wie* sich das Auto anfühlt. |
| **Slot** | Vier Stück. Man besitzt alle gefundenen Teile dauerhaft, kann aber nur vier gleichzeitig tragen. Die Frage lautet nie "habe ich es", sondern "welche vier nehme ich mit". |
| **Gewicht** | Die einzige Währung. Jedes Traversal-Teil kostet Gewicht. Gewicht verschlechtert Beschleunigung, Auftrieb und Reichweite und verbessert Unterwasser-Stabilität und Rammwirkung. Eine Währung, drei Preise. |
| **Leine** | Die Energiemechanik. **Kein Timer.** Grundfahren ist kostenlos; nur Fähigkeiten kosten. Energie ist damit eine Reichweite, kein Zeitdruck. Drei Pflichtregeln: nie stranden (bei null nur langsam weiter), Preis vor der Auslösung sichtbar, Aufladen ist Beute. |
| **Modus** | Fahren, Tauchen, Gleiten. **Keine drei Systeme** — ein Controller, drei Modifikatoren. Tauchen ist Fahren mit Auftrieb und Dämpfung; Gleiten ist Fahren mit begrenztem Auftrieb und Zeitbudget. Gleicher Rigidbody, gleiche Kamera, gleiche zwei Eingabeachsen. |

## Produktion

| Begriff | Bedeutung |
|---|---|
| **Slice** | Ein abgeschlossener Bauabschnitt mit eigener Abnahmefrage. Slice 0 = Prüfstein (Fahrgefühl), Slice 1 = erstes Gate, Slice 2 = Leine. |
| **Prüfstein** | Die Abnahmefrage von Slice 0: *Zehn Minuten ziellos in der leeren Kiste herumfahren macht Spaß.* Wenn nicht, endet das Projekt — nach 35 Stunden statt nach 500. |
| **Kiste** | Die leere Testumgebung. `welt/testkiste.tscn`. Hier wird gefahren, nicht gemessen. |
| **Parcours** | Die eingefrorene Messstrecke. `welt/testparcours.tscn`. Slalom, 90-Grad-Ecke, Sprungrampe, Vollbremszone. Wird nie geändert, sonst sind alle bisherigen Messungen wertlos. |

## Maßstab

**Setzung: Das Auto ist 4 Godot-Einheiten lang.** Die Welt wird mit Faktor ~57
gegenüber der Realität gebaut.

Der naheliegende Gedanke — das Auto sieben Zentimeter groß machen und die
Umgebung in Realgröße — lässt das Projekt technisch entgleisen: bei sehr
kleinen Körpern sind Kollisionstoleranz, Federweg und Solver-Schritt größer als
das Fahrzeug. Es zittert, fällt durch dünne Böden und verhält sich bei jeder
Kollision unvorhersehbar. Man dreht dann wochenlang an Federungsparametern,
obwohl das Problem der Maßstab ist.

Die Miniatur entsteht **nicht** durch echte Kleinheit, sondern optisch: durch
Tiefenschärfe, Kameranähe und Materialien. Die Physik merkt davon nichts.

| Realmaß | Godot-Einheiten |
|---|---|
| 1 cm | 0,57 |
| 5 cm | 2,9 |
| 7 cm (Spielzeugauto 1:64) | **4** |
| 10 cm | 5,7 |
| 25 cm | 14,3 |
| 50 cm | 28,5 |
| 90 cm (Werkbankhöhe) | 51 |
| 1 m | 57 |
| 7 m (Boden der Testkiste) | 400 |

Umrechnung: `Einheiten = Realzentimeter × 0,57`.
