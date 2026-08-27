# Arbeitsregeln für dieses Repository

Gilt für Menschen und Agenten gleichermaßen. Wer hier arbeitet, liest zuerst
`README.md` und `CONTEXT.md`.

## Wo das Projekt steht

Slice 0. Ein Prototyp, der **eine** Frage beantwortet: Macht ziellos
herumfahren Spaß? Alles, was diese Frage nicht beantwortet, ist außerhalb des
Auftrags — auch wenn es sinnvoll aussieht.

Budget: **5 Stunden pro Woche**, netto etwa vier. Jede Scope-Entscheidung wird
gegen diese Zahl geprüft. Ein Block, der nicht auf dem Plan steht, kostet
Wochen, die es nicht gibt.

## Was hier nicht passiert

Diese Liste ist wichtiger als jeder Plan. Jeder Punkt darauf wird sich
unterwegs sinnvoll anfühlen.

- **`addons/gevp/` wird nicht verändert.** Nicht refaktoriert, nicht
  umbenannt, nicht "nur die Struktur", nicht "nur diese eine Funktion". Fremder
  Code bleibt fremd, bis das Spiel bewiesen hat, dass es existieren will. Das
  ist eine explizite Projektregel, kein Versehen. Wenn du `vehicle.gd`
  durchschaust und der Impuls kommt, es sauberer zu bauen: das ist derselbe
  Impuls, der bei der Arbeit gute Architektur baut, und hier kostet er sechs
  Wochen für null Spielwert.
- Kein Upgrade-System, keine Slots, keine Gewichtsrechnung.
- Keine Energie, keine Ladestellen, kein HUD.
- Keine Werkbank, kein Menü, kein Speichern, keine Optionen.
- Kein Tauch- oder Gleitmodus — auch nicht "nur mal ausprobieren".
- Keine zweite Region, keine Welt, kein Level-Design.
- Keine Gegner, keine Gefahren, kein Schaden.
- Kein Ton außer dem Motorgeräusch-Platzhalter, der beim Tunen hilft.
- Kein Blender, keine eigenen 3D-Modelle.
- Keine Tests, keine CI, keine Architektur-Ebenen, keine Abstraktionen "für
  später". Fabian ist Softwareentwickler und wird den Impuls haben, das hier
  "richtig" zu bauen. Bei 5 h/Woche kostet das sechs Wochen für null Spielwert.
- Keine Steam-Seite, kein Trailer, keine Namensfindung.

## Was `welt/testparcours.tscn` ist

Ein **Messinstrument**, kein Level. Es ist eingefroren. Wer die Strecke ändert,
macht alle bisherigen Zeilen in `TUNING.csv` unvergleichbar und damit wertlos.

## Was Agenten nicht entscheiden

- **Das Fahrgefühl.** Es ist irreduzibel menschlich — ein Agent kann nicht
  fahren und nicht fühlen. Sinnvolle Startwerte liefern, Parameter sichtbar
  exponieren, dann übergeben. Nicht "besser abstimmen".
- **Ob Slice 0 bestanden ist.** Das Abnahmekriterium lautet: Fabian fährt zehn
  Minuten ziellos, ohne einen Parameter anzufassen, und hat Spaß. Nur er kann
  das feststellen.
- **Welches Kenney-Auto die Spielfigur wird.** Fragen, nicht raten.

## Handwerkliche Regeln

- **Lizenzhygiene:** Nichts kommt ins Projekt, das nicht in `ASSETS.md` steht.
  Herkunft, Lizenz, Datum. Nachträglich ist das nicht rekonstruierbar.
- **Gruppen:** `wheel.gd` liest die **erste** Gruppe des getroffenen Colliders
  und schlägt damit Reifenwerte nach. Jeder `StaticBody3D` und `RigidBody3D`,
  den ein Rad berühren kann, trägt als erste Gruppe `Road`, `Dirt` oder `Grass`
  — oder gar keine. Andernfalls läuft der Controller in einen
  Dictionary-Fehler.
- **Kollisionsebenen:** Ebene 1 = Welt, Ebene 2 = Auto. Der `SpringArm3D` der
  Kamera prüft nur Ebene 1, damit er nicht am eigenen Auto hängen bleibt.
- **Kopplungen:** Schwerkraft, Federungs-Ruhelage, Bremskraft, Reifenradius und
  Motordrehmoment hängen zusammen. Wer einen davon ändert, liest vorher den
  Abschnitt "Bekannte Kopplungen" in `TUNING.md`.
- **`Transform3D(...)` in `.tscn` wird zeilenweise gelesen**, nicht
  spaltenweise: die ersten drei Zahlen sind die erste *Zeile* der
  Basismatrix. Die Spalten X/Y/Z stehen also verteilt an den Positionen
  1/4/7, 2/5/8, 3/6/9. Wer das verwechselt, baut die transponierte
  (= gespiegelte) Drehung ein.

## Prüfen ohne Editor

```
godot --headless --path . --import      # Importfehler und Skriptfehler
godot --headless --path . --quit-after 600   # Laufzeitfehler der Hauptszene
```

## Sprache

Deutsch, technisch, knapp. Keine Grundlagenerklärungen — Fabian ist Data
Scientist und AI Engineer, aber Godot und GDScript sind neu für ihn. Diagramme
und Szenenbäume statt Prosa, wo möglich. Widerspruch ist erwünscht: wenn ein
Schritt falsch ist, sag es. Unsicherheit benennen statt raten; vor
produktspezifischen Aussagen (Versionen, APIs) nachschlagen.

Begriffe kommen aus `CONTEXT.md`. Dieselben Wörter, jedes Mal.
