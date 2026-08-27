# Fremde Bestandteile

Lizenzhygiene ab dem ersten Tag. Nachträglich ist die Herkunft nicht
rekonstruierbar, und fehlende Herkunft ist der häufigste Grund, warum
Hobbyprojekte nicht veröffentlicht werden können.

**Regel: Nichts kommt ins Projekt, das hier nicht steht.**

| Bestandteil | Herkunft | Lizenz | Aufgenommen | Wo im Projekt |
|---|---|---|---|---|
| Godot Engine 4.6 | <https://godotengine.org> | MIT | 2026-08-27 | Engine, nicht im Repo |
| Godot-Easy-Vehicle-Physics | <https://github.com/DAShoe1/Godot-Easy-Vehicle-Physics>, Commit `c392257` (2025-08-17) | MIT — © 2024 David Shoemaker, © 2021 Dechode, © 2024 Baron Wittman | 2026-08-27 | `addons/gevp/` — unverändert übernommen, siehe `addons/gevp/LICENSE` |
| Motorgeräusch `4000.wav` | Teil des Add-ons oben | MIT (mit dem Add-on) | 2026-08-27 | `addons/gevp/sounds/` |
| Demo-Automodell im Add-on (`sedanSports`) | Kenney Car Kit, im Add-on eingebettet | CC0 | 2026-08-27 | `addons/gevp/scenes/*_car.tscn` — nur in den Demos, nicht im Spiel |
| Godot-`.gitignore`-Vorlage | <https://github.com/github/gitignore> `Godot.gitignore` | CC0 | 2026-08-27 | `.gitignore` |
| Kenney Toy Car Kit 1.2 | <https://kenney.nl/assets/toy-car-kit>, Ausgabedatum 2025-01-05 | CC0 — Namensnennung nicht erforderlich, siehe `fremd/kenney_toy_car_kit/License.txt` | 2026-08-27 | `fremd/kenney_toy_car_kit/` — übernommen sind nur `vehicle-truck.glb`, `wheel-small.glb` und `Textures/colormap.png`, nicht das ganze Kit |

## Zum Kenney-Kit

Das Kit enthält 100+ Modelle, davon acht Fahrzeuge; der große Rest sind
Streckenteile. Übernommen ist **nur, was gebraucht wird** — ein ganzes Kit ins
Repo zu legen macht die Herkunftsfrage später unübersichtlich, nicht klarer.

- **`vehicle-truck.glb`** ist die Spielfigur. Entschieden am 27.08.2026: der
  flache Kastenaufbau trägt die sichtbaren Anbauteile ab Slice 1 (Rammbock,
  später Rotor und Greifer). Die Rennwagensilhouetten im Kit tragen sie nicht.
- **`wheel-small.glb`** ist das Radmodell, das der Truck selbst benutzt.
- **`Textures/colormap.png`** wird von beiden GLB-Dateien **relativ** referenziert.
  Der Unterordner `Textures/` muss neben den GLB-Dateien liegen, sonst sind die
  Modelle unbemalt.

GLB und nicht FBX: Godot importiert glTF direkt, FBX ist der unangenehmste Weg.

## Noch nicht aufgenommen

Zurzeit nichts.

## Eigene Bestandteile

Alles unter `auto/`, `kamera/`, `welt/`, `optik/` ist selbst gebaut — Szenen,
Kollisionskörper, Materialien, Fahrparameter. Fremde Modelle liegen
ausschließlich unter `fremd/` und `addons/`. Diese Trennung ist der Grund,
warum es den Ordner `fremd/` gibt: sie macht die Lizenzfrage an der
Ordnerstruktur ablesbar.

`auto/spielzeugauto.tscn` ist selbst gebaut und *referenziert* die beiden
Kenney-Modelle; die Platzhalter-Karosserie aus Godot-Primitiven ist seit
Slice 1 Block 0 ersetzt.
