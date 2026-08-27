# Slice 1 — Das erste Gate

Slice 0 ist beendet. Der Prüfstein ist bestanden: zehn Minuten ziellos in der
Kiste, ohne einen Parameter anzufassen, und es hat Spaß gemacht. Damit ist die
Frage beantwortet, die über das Projekt entschieden hat.

**`TUNING.csv` ist leer.** Falls du beim Fahren doch etwas verstellt hast:
die Zeilen jetzt nachtragen, solange du dich erinnerst. Sonst stehen im
`.tscn` Werte, deren Herkunft in zwei Wochen niemand mehr rekonstruiert.
Falls nicht: Die Startwerte haben ohne eine einzige Runde getragen. Das ist
das bestmögliche Ergebnis — und der stärkste Grund, jetzt **nicht** doch noch
zu tunen. Das Stop-Kriterium in `TUNING.md` gilt.

---

## Die Abnahmefrage

Slice 0 fragte nach dem Fahrgefühl. Slice 1 fragt nach der **Schleife**:

> **Fabian fährt gegen eine Grenze, scheitert, findet ohne Text ein Teil, baut
> es ein und kommt durch — und das Durchkommen fühlt sich verdient an.**
>
> Muss man ihm sagen, was zu tun ist: nicht bestanden.

Vier Teilfragen, von denen jede ein Nein erzeugen kann:

| | Frage |
|---|---|
| **Lesbar** | Verstehe ich beim ersten Anfahren, *dass* hier etwas fehlt — ohne zu wissen, *was*? |
| **Findbar** | Stolpere ich über das Teil, ohne dass es mir angezeigt wird? |
| **Sichtbar** | Sehe ich am Auto, dass sich etwas verändert hat? |
| **Verdient** | Ist das Durchkommen ein Moment — oder ein Häkchen? |

Die vierte ist die einzige, die zählt. Die ersten drei sind Diagnose, wenn die
vierte nein ist. (Dieselbe Struktur wie die vier Noten in `TUNING.md`.)

---

## Welches Gate zuerst

Sechs Traversal-Teile stehen in `CONTEXT.md`. Die Wahl ist keine Geschmacks-,
sondern eine Budgetfrage:

| Teil | Was es aufhebt | Baukosten | Risiko |
|---|---|---|---|
| **Rammbock** | Eine Barriere, die im Weg liegt | **niedrig** — Kollisionsform, Masse, Sichtbarkeit | gering |
| Magnetgreifer | Etwas muss weggezogen werden | mittel — Joint, Zielobjekte | mittel |
| Magnetreifen | Senkrechte Metallfläche | **hoch** — Schwerkraftvektor umbiegen, Kamera-Up mitdrehen | hoch |
| Dichtung + Ballast | Wasser | hoch — Auftrieb, Dämpfung, Wasservolumen | hoch |
| Rotor | Abgrund | hoch — zweiter Modus, Zeitbudget | hoch |
| Druckkörper + Licht | Tiefes Wasser | hoch — setzt Tauchen voraus | — |

**Vorschlag: Rammbock.**

Der Einwand liegt auf der Hand: Der Rammbock ist das langweiligste der sechs
Teile. Die Magnetreifen sind das Bild, das man im Kopf hat, wenn man an dieses
Spiel denkt.

Trotzdem Rammbock — weil Slice 1 nicht das Teil prüft, sondern die
**Grammatik**: Grenze sehen → scheitern → finden → einbauen → durchkommen.
Diese Grammatik ist bei allen sechs Teilen dieselbe. Sie am billigsten Teil zu
prüfen kostet drei Wochen; sie an den Magnetreifen zu prüfen kostet acht, und
wenn die Schleife nicht trägt, hat man fünf Wochen Physik für nichts gebaut.
Trägt die Grammatik, ist der Austausch des Teils später billig — die Schleife
bleibt, nur das Schloss wechselt.

---

## Wo es spielt: in der Kiste, nicht in einer Region

Keine Region, kein Garagenboden, kein Level-Design. `welt/testkiste.tscn`
bekommt eine Trennwand. Das beantwortet die Abnahmefrage genauso gut und
kostet keine zwei Wochen Weltbau.

```
welt/testkiste.tscn   400 × 400
┌───────────────────────────────────────┐
│                                       │
│   ▓▓▓▓▓▓▓▓▓▓▓  Barriere  ▓▓▓▓▓▓▓▓▓▓   │  ← niedrig genug zum Drübersehen,
│                                       │    zu hoch zum Drüberfahren
│              [dahinter:               │
│               sichtbar etwas, das     │
│               Neugier erzeugt]        │
├───────────────────────────────────────┤
│                                       │
│   Startbereich                        │
│                       ▪ Rammbock      │  ← abseits, sichtbar, ohne Marker
│                                       │
└───────────────────────────────────────┘
```

Die Kiste bleibt sonst unverändert. **`welt/testparcours.tscn` wird nicht
angefasst** — er ist eingefroren, auch wenn in Slice 1 nicht mehr gemessen wird.

---

## Wie das Gate technisch dicht wird

Der ehrliche Weg — die Barriere ist ein Stapel `RigidBody3D` mit hoher Masse,
den nur der Rammbock verschiebt — ist der Weg, der nicht funktioniert. Mit
genug Anlauf schiebt ein 1500er Auto irgendwann alles. Ein Gate, das mit Geduld
knackbar ist, ist kein Gate, sondern eine Ermutigung zum Exploit.

Stattdessen: **binär, mit physikalischer Fassade.**

```
Barriere = StaticBody3D (Gruppe "Road", Kollisionsebene 1)
        │
        ├── ohne Rammbock:  bleibt statisch. Auto prallt ab. Immer.
        │
        └── Rammbock trifft (Area3D am Rammbock, kein Trigger am Auto):
                 └── Klötze werden zu RigidBody3D und fliegen realistisch weg
```

Das ist dicht, in zwei Stunden gebaut, und sieht im Moment des Durchbruchs
aus wie echte Physik. Der Zerfall passiert genau einmal — kein Zustand, der
gespeichert werden müsste.

**Zwei Fallen aus `CLAUDE.md`, die hier scharf sind:**

- Jeder `StaticBody3D` und `RigidBody3D`, den ein Rad berühren kann, trägt als
  **erste** Gruppe `Road`, `Dirt` oder `Grass`. Das gilt für die Klötze vor
  *und* nach dem Zerfall. Fehlt sie, läuft `wheel.gd` in einen
  Dictionary-Fehler.
- Barriere und Klötze auf **Kollisionsebene 1** (Welt), nicht 2. Sonst hängt
  der `SpringArm3D` der Kamera daran fest.

---

## Einbau: Aufsammeln *ist* Einbauen

Keine Werkbank, kein Slot-System, kein Inventar. Bei genau einem Teil ist jede
Verwaltung Selbstzweck.

```
Area3D am Rammbock-Fundstück
        └── Auto berührt
                ├── Fundstück verschwindet
                ├── Rammbock-MeshInstance am Auto wird sichtbar
                ├── zusätzliche CollisionShape3D vorn wird aktiv
                └── kurzer Ton / Kameraruck  (das ist der ganze "Moment")
```

Das Gewicht des Rammbocks (`CONTEXT.md`: Gewicht ist die einzige Währung) wird
in Slice 1 **nicht** verrechnet. Eine Währung mit einem Posten ist keine
Währung. Kommt in Slice 2 mit der Leine.

---

## Blöcke und Budget

Bei 5 h/Woche, netto vier:

| # | Block | h | Ergebnis | Stand |
|---|---|---|---|---|
| 0 | **Karosserie entscheiden** und Kenney Toy Car Kit einbauen (glTF/GLB), `ASSETS.md`-Zeile | 3 | Platzhalter raus | **blockiert** — Entscheidung offen |
| 1 | Barriere: Geometrie, Höhe, Sichtlinie darüber, statisch | 3 | Auto prallt ab, jedes Mal | **fertig** — `welt/barriere.tscn` |
| 2 | Rammbock am Auto: Mesh, Kollisionsform, Position | 3 | sichtbar montiert | offen |
| 3 | Fundstück + Aufnahme (Area3D, Sichtbarkeit umschalten) | 2 | Schleife geschlossen | offen |
| 4 | Zerfall der Barriere beim Treffer | 2 | Durchbruch sieht gut aus | offen |
| 5 | Lesbarkeit: Platzierung, Licht, was hinter der Barriere lockt | 3 | ohne Erklärung verständlich | offen |
| 6 | Zehn Minuten fahren, entscheiden | 1 | bestanden / nicht bestanden | offen |
| | **Summe** | **17** | **≈ 4–5 Wochen** | |

### Was Block 1 festgelegt hat

Die Wand steht bei `z = -60`, ist **2,4 Einheiten hoch** und besteht aus 51
eingefrorenen `RigidBody3D` à 8 Einheiten Breite. Drei Zahlen, die im Plan
nicht standen und die jetzt Abhängigkeiten sind:

- **Die Höhe hängt an der Kamera.** Gemessen: Auto ruht bei `y = 0.07`,
  Dachkante ~1,84, Kamera-Auge 2,37 im Stand und 2,98 bei Tempo. 2,4 liegt
  über dem Dach und über dem Stand-Auge, aber unter dem Tempo-Auge — im
  Anfahren sieht man darüber, davor stehend nicht. Wer `abstand_tempo`, die
  Federarm-Neigung oder die Autohöhe ändert, ändert die Wand mit.
- **Die Dichtheit hängt an der Geometrie, nicht an der Höhe.** Das einzige
  Sprunggerät der Kiste ist die Rampe bei `z = -95` — sie liegt *hinter* der
  Wand und ist ein `StaticBody3D`, lässt sich also nicht davorschieben. Wer
  die Wand nach Norden verschiebt (`z < -95`), macht die Rampe zur Abkürzung
  und das Gate wertlos.
- **Block 4 ist vorbereitet.** Die Klötze sind keine `StaticBody3D`, sondern
  `RigidBody3D` mit `freeze = true`. Godot kann die Klasse eines Knotens zur
  Laufzeit nicht wechseln — der Zerfall ist deshalb `freeze = false` auf den
  getroffenen Klötzen statt eines Neubaus.

Block 0 steht bewusst zuerst. Der Rammbock ist das erste sichtbare Anbauteil —
er ist damit die Probe darauf, ob die gewählte Karosserie Anbauten überhaupt
trägt. Ein flaches Dach trägt sie, eine Sportwagensilhouette nicht. Die
Entscheidung nach Block 2 zu treffen heißt, Block 2 zweimal zu bauen.

---

## Was in Slice 1 weiterhin nicht passiert

Aus der Liste in `CLAUDE.md` fallen genau **zwei** Punkte weg: *ein* Teil und
*ein* Gate. Alles andere gilt unverändert weiter:

- `addons/gevp/` wird nicht verändert. Der Rammbock hängt **außen** am Auto —
  keine Zeile im fremden Controller.
- Kein Slot-System, keine Gewichtsrechnung, kein zweites Teil "weil es gerade
  so gut läuft".
- Keine Energie, keine Ladestellen, kein HUD.
- Keine Werkbank, kein Menü, kein Speichern.
- Kein Tauch- oder Gleitmodus.
- Keine zweite Region, keine Gegner, keine Gefahren.
- Keine Tests, keine CI, keine Abstraktionen "für später".
- `welt/testparcours.tscn` bleibt eingefroren.

Und ein neuer Punkt, der sich in Slice 1 gut anfühlen wird: **kein zweites
Gate.** Eines beantwortet die Frage. Zwei beantworten dieselbe Frage doppelt.

---

## Was Fabian entscheidet, nicht ein Agent

| Frage | Stand |
|---|---|
| **Welches Kenney-Auto wird die Spielfigur?** | Offen. Blockiert Block 0. Flaches Dach trägt Rotor, Rammbock und Greifer sichtbar; eine Sportwagensilhouette nicht. |
| **Ist der Rammbock das richtige erste Teil?** | Vorschlag oben, mit Begründung. Wenn du die Magnetreifen willst: sag es, dann rechne ich den Plan darauf um — er wird etwa doppelt so lang. |
| **Ob Slice 1 bestanden ist** | Nur du. "Verdient" ist keine messbare Größe. |
| **Ob nach Slice 1 Schluss ist** | Auch ein Ja auf die Abnahmefrage ist kein Zwang weiterzumachen. |

---

## Risiken

| Risiko | Gegenmittel |
|---|---|
| Die Barriere ist da, aber niemand versteht, dass sie ein Schloss ist | Block 5 ist dafür da und ist bewusst so groß wie Block 1. Sichtlinie über die Barriere ist das wichtigste Einzelmittel. |
| Der Durchbruch ist technisch korrekt und fühlt sich nach nichts an | Genau das prüft die Abnahmefrage. Es ist ein zulässiges Nein. |
| Der Rammbock ändert das Fahrgefühl (Masse vorn, Schwerpunkt) | Beim ersten Bau die Masse des Rammbocks auf 0 setzen. Erst wenn die Schleife trägt, Gewicht draufgeben — dann ist es ein Tuning-Thema, kein Schleifen-Thema. |
| Scope-Drift: "wenn schon eine Barriere, dann auch gleich eine Region" | Die Liste oben. Sie ist der Grund, warum sie geschrieben steht. |
