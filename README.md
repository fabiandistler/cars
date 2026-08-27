# Maßstab 1:64 — Slice 0

Ein Spielzeugauto in einer leeren Kiste. Kein Upgrade, kein Gate, keine
Werkbank, kein Menü. Das ist Absicht.

Slice 0 beantwortet **eine** Frage, und ihre Antwort entscheidet über das
gesamte Projekt:

> **Machen zehn Minuten ziellos herumfahren Spaß — ohne einen Parameter
> anzufassen?**
>
> Zuckt die Hand zum Inspector statt zur Lenkung: nicht bestanden.

Wenn nein, endet das Projekt nach 35 investierten Stunden statt nach 500.

**Stand: bestanden (2026-08-27).** Damit ist Slice 0 beendet — nach der Regel
in [TUNING.md](TUNING.md) wird danach entschieden, nicht weitergedreht. Der
nächste Bauabschnitt steht in [SLICE1.md](SLICE1.md).

## Loslegen

1. **Godot 4.6** herunterladen, Standard-Build (**nicht** .NET — kein C# nötig).
2. Ordner als Projekt öffnen. Beim ersten Öffnen importiert Godot die Assets.
3. **F5** startet `welt/testkiste.tscn`.

Prüfen ohne Editor:

```
godot --headless --path . --import
```

## Steuerung

| | |
|---|---|
| Gas / Bremse | `W` `S` oder `↑` `↓` |
| Lenken | `A` `D` oder `←` `→` |
| Handbremse | Leertaste |
| Getriebe automatisch/manuell | `T` |
| Gang hoch / runter | `F` / `R` |
| Debug-Overlay | `~`, Seite wechseln mit `<` `>` |

Gamepad ist ebenfalls belegt (Trigger, linker Stick, A/X/Y).

## Was wo liegt

```
auto/spielzeugauto.tscn     Das Auto. HIER sitzen alle Fahrparameter.
auto/rammbock.tscn          Der Rammbock. Einmal definiert, zweimal benutzt.
auto/rammbock_wirkung.gd    Zerfall der Barriere beim Treffer
fremd/kenney_toy_car_kit/   Karosserie, Rad und Bäume (Kenney, CC0)
kamera/kamerarig.tscn       Verfolgerkamera (Pivot → SpringArm3D → Camera3D)
kamera/kamera_rig.gd        das einzige selbst geschriebene Skript im Projekt
welt/kiste.tscn             Boden 400×400, vier Wände, Sonne, Umgebung
welt/barriere.tscn          Das Gate aus Slice 1. Trennwand bei z = -60.
welt/fundstueck.tscn        Der Rammbock zum Aufsammeln, bei (48, 8)
welt/fundstueck.gd          Aufsammeln = Einbauen
welt/hain.tscn              Was hinter der Barriere lockt
welt/testkiste.tscn         HAUPTSZENE — Kiste + Hindernisse + Barriere
welt/testparcours.tscn      Messstrecke. Eingefroren. Nicht ändern.
optik/                      Tiefenschärfe und Umgebung (Spielzeug-Look)
addons/gevp/                Fremder Fahrzeug-Controller (MIT). Nicht anfassen.
```

## Der Fahrzeug-Controller

Die Fahrphysik ist **nicht** selbst geschrieben, und das ist die wichtigste
Einzelentscheidung des Projekts. Sie verwandelt "vier Wochen Federungsphysik
schreiben" in "zwei Wochen an fremden Parametern drehen".

`addons/gevp/` ist [Godot-Easy-Vehicle-Physics](https://github.com/DAShoe1/Godot-Easy-Vehicle-Physics)
(MIT), unverändert übernommen. **Alles darin bleibt unverändert** — auch wenn du
`vehicle.gd` irgendwann durchschaust und der Impuls kommt, es sauberer zu bauen.
Siehe `CLAUDE.md`.

Das Add-on bringt vier fahrbare Demos mit, die dir zeigen, wohin das Fahrgefühl
gedreht werden kann:
`addons/gevp/scenes/demo_arcade.tscn`, `demo_simcade.tscn`,
`demo_monster_truck.tscn`, `demo_drift.tscn`. Basis dieses Projekts ist Arcade.

## Tunen

Alles dazu in **[TUNING.md](TUNING.md)**: Reihenfolge der Parameter, die vier
Noten, das Stop-Kriterium, und vier bekannte Kopplungen (Schwerkraft ↔ Federung,
Schwerkraft ↔ Bremskraft, Reifenradius ↔ Drehmoment, Physik-Tickrate).

Jede Änderung kommt als Zeile in `TUNING.csv`. Die Datei ist leer und wartet.

Alle Fahrhilfen sind **aus** — Traktionskontrolle, ABS, Stabilitäts-,
Gegenlenk-, Lenkschlupf- und Seitengrip-Assistent. Sonst tunt man gegen
versteckte Korrekturen. Sie werden nach dem Grundtuning einzeln zugeschaltet
und bewertet.

## Offene Entscheidungen

| Frage | Stand |
|---|---|
| **Welches Kenney-Auto wird die Spielfigur?** | **Entschieden (2026-08-27): der Truck** (`vehicle-truck`). Der flache Kastenaufbau trägt Rammbock, Rotor und Greifer sichtbar; die Rennwagen im Kit tun das nicht. Der Platzhalter aus Godot-Primitiven ist raus. |
| **Schwerkraftfaktor** | Startwert 2 (`19.62`, Projekteinstellungen → *Physics → 3D → Default Gravity*). Kein belegter Wert, eine Vermutung. Beim Ändern die Kopplungen in `TUNING.md` beachten. |
| **Reifenradius gegen Modellgröße** | Offen, aber unkritisch. Der Truck will Radius 0,58, getunt ist 0,45 — er sieht dadurch leicht untergerädert aus. Ändern heißt über die Kopplung in `TUNING.md` auch `max_torque` ändern, also Fahrverhalten statt Optik. |

## Weiterlesen

| | |
|---|---|
| [CONTEXT.md](CONTEXT.md) | Vokabular des Projekts und die Maßstabsregel |
| [TUNING.md](TUNING.md) | Das Tuning-Protokoll |
| [ASSETS.md](ASSETS.md) | Herkunft und Lizenz jedes fremden Bestandteils |
| [CLAUDE.md](CLAUDE.md) | Was in diesem Slice nicht passiert |
| [SLICE1.md](SLICE1.md) | Der nächste Bauabschnitt: das erste Gate |
