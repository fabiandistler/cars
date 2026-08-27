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

## Noch nicht aufgenommen

| Bestandteil | Herkunft | Lizenz | Stand |
|---|---|---|---|
| Kenney Toy Car Kit | <https://kenney.nl/assets/toy-car-kit> | CC0, Namensnennung nicht erforderlich | **Noch nicht heruntergeladen.** Das Paket liefert FBX, OBJ und glTF. glTF/GLB nehmen — Godot importiert es direkt; FBX ist der unangenehmste Weg. Welches Auto die Spielfigur wird, ist offen (siehe README). |

## Eigene Bestandteile

Alles unter `auto/`, `kamera/`, `welt/`, `optik/` ist selbst gebaut. Die
Platzhalter-Karosserie besteht aus Godot-Primitiven (Box, Zylinder) — kein
fremdes Modell, keine Lizenzfrage.
