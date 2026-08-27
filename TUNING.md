# Tuning-Protokoll

Das ist der eigentliche Slice: 12 der 35 Stunden. Alles davor war Aufbau.

**Die Regel, die du aus dem Beruf kennst und im Hobby brechen willst:
ein Parameter pro Durchgang, immer derselbe Parcours, alles protokolliert.**

## Ablauf

1. `welt/testparcours.tscn` öffnen und starten (F6). Nicht die Testkiste — die
   ist zum Fahren, nicht zum Messen.
2. Eine Runde: Slalom → 90-Grad-Ecke → Sprungrampe → Vollbremszone.
3. Genau **einen** Parameter ändern.
4. Zeile in `TUNING.csv` schreiben: Datum, Parameter, alt, neu, vier Noten, Notiz.
5. Zurück zu 2.

Alle Fahrzeugparameter sitzen am Wurzelknoten von `auto/spielzeugauto.tscn`.
Der Controller liefert zu jedem einen Tooltip im Inspector.

## Reihenfolge — keine Präferenz, eine Abhängigkeit

```
1. Masse & Schwerpunkthöhe
        ↓
2. Federung (Steifigkeit · Dämpfung)
        ↓
3. Reifengrip
        ↓
4. Lenkwinkel & Lenkgeschwindigkeit
        ↓
5. Motorleistung
```

Federungswerte gelten nur für eine bestimmte Masse, Grip-Werte nur für eine
bestimmte Federung. Wer am Ende die Masse ändert, hat drei Schritte umsonst
getunt. Zurückspringen entwertet alles dazwischen.

| Schritt | Felder |
|---|---|
| 1 Masse & Schwerpunkt | `vehicle_mass`, `center_of_gravity_height_offset`, `front_weight_distribution`, `inertia_multiplier` |
| 2 Federung | `front_spring_length`, `rear_spring_length`, `front_resting_ratio`, `rear_resting_ratio`, `front_damping_ratio`, `rear_damping_ratio`, `front_arb_ratio`, `rear_arb_ratio` |
| 3 Reifengrip | `coefficient_of_friction`, `tire_stiffnesses`, `contact_patch`, `front_tire_radius`, `front_tire_width` (und `rear_*`) |
| 4 Lenkung | `max_steering_angle`, `steering_speed`, `countersteer_speed`, `steering_speed_decay`, `steering_exponent` |
| 5 Motor | `max_torque`, `torque_curve`, `gear_ratios`, `final_drive`, `max_rpm` |

## Die vier Noten (1–5)

| Achse | Frage beim Fahren | Typischer Fehler |
|---|---|---|
| **Reaktion** | Passiert etwas im selben Moment, in dem ich drücke? | Zu viel Dämpfung, zu träge Lenkung |
| **Kontrolle** | Kann ich einen Fehler wieder einfangen? | Grip zu niedrig, Ausbruch nicht rettbar |
| **Gewicht** | Spüre ich Masse, oder schwebt es? | Federweg zu kurz, Schwerpunkt zu tief |
| **Spaß** | Will ich das noch einmal machen? | Technisch korrekt und trotzdem langweilig |

Die vierte Achse ist die einzige, die zählt, und die einzige, die man nicht
rechnerisch erreicht. Die ersten drei sind Diagnose, wenn die vierte niedrig ist.

## Stop-Kriterium — steht hier, bevor du drinsteckst

Fahrgefühl-Tuning hat kein natürliches Ende. Es ist die häufigste Art, wie
Hobbyprojekte in Bewegung sterben: man ist immer noch beschäftigt, kommt aber
seit Monaten nicht voran.

> **Nach 12 Stunden Tuning oder nach drei aufeinanderfolgenden Änderungen ohne
> Verbesserung in der Spaß-Note ist Slice 0 beendet — unabhängig davon, ob das
> Ergebnis gefällt. Danach wird entschieden, nicht weitergedreht.**

---

## Fahrhilfen

Alle aus. Sonst tunt man gegen versteckte Korrekturen. **Erst nach dem
Grundtuning einzeln zuschalten und jeweils bewerten.**

| Fahrhilfe | Feld | Jetzt (aus) | Anschalten mit |
|---|---|---|---|
| Traktionskontrolle | `traction_control_max_slip` | `-1.0` | `8.0` |
| ABS vorn | `front_abs_spin_difference_threshold` | `100000.0` | `12.0` |
| ABS hinten | `rear_abs_spin_difference_threshold` | `100000.0` | `12.0` |
| Stabilitätsassistent | `enable_stability` | `false` | `true` |
| Gegenlenkassistent | `countersteer_assist` | `0.0` | `0.9` |
| Lenkschlupf-Assistent | `steering_slip_assist` | `100000.0` | `0.15` |
| Seitengrip-Assistent | `lateral_grip_assist` | alle `0.0` | `Road: 0.05` |

**Achtung bei `enable_stability`:** Der Schalter steuert zwei Dinge gleichzeitig
— die Gierkorrektur am Boden *und* die Aufricht-Korrektur in der Luft. Wer ihn
anschaltet, ändert Kurvenverhalten und Sprungverhalten in einem Zug und kann die
beiden nicht getrennt bewerten. (Gemessen: das Auto landet auch ohne die Hilfe
aufrecht — die Aufricht-Korrektur ist kein Muss.)

---

## Bekannte Kopplungen

Vier Stellen, an denen das Ändern eines Wertes einen zweiten mitzieht. Wer eine
davon übersieht, tunt danach Unsinn.

### 1. Schwerkraft ↔ Ruhelage der Federung

Der Controller berechnet die Federrate aus Masse, Federweg und Ruhelage — mit
**fest verdrahteten 9,8 m/s²** (`vehicle.gd`, `front_weight_per_wheel := ... * 4.9`).
Bei erhöhter Schwerkraft sackt das Auto entsprechend tiefer ein, im Extremfall
bis auf die Anschläge.

> **Faustregel: `resting_ratio = 0,5 / Schwerkraftfaktor`.**

Aktuell: Schwerkraft `19.62` (Faktor 2, in den Projekteinstellungen unter
*Physics → 3D → Default Gravity*), also `front_resting_ratio = rear_resting_ratio = 0.25`.
Damit steht das Auto auf halbem Federweg — gemessen und bestätigt.

Der Schwerkraftfaktor selbst ist eine **offene Frage**, kein belegter Wert. Der
Startwert 2 kommt aus der Überlegung, dass ein Vier-Einheiten-Auto bei normaler
Erdbeschleunigung wie ein echtes Auto fällt — für ein Spielzeug zu träge.
Behandle ihn wie jeden anderen Tuning-Parameter.

### 2. Schwerkraft ↔ Bremskraft

`calculate_brake_force()` rechnet ebenfalls mit fest verdrahteten 9,8 m/s².
Bei doppelter Schwerkraft haben die Reifen doppelte Radlast, die Bremse aber
nicht mehr Kraft. Deshalb `brake_force_multiplier = 2.0`. Ändert sich der
Schwerkraftfaktor, ändert sich dieser Wert mit.

### 3. Reifenradius ↔ Motordrehmoment

`max_torque = 450` statt der 300 des Arcade-Presets, weil der Reifenradius 0,45
statt 0,3 beträgt (Spielzeugproportionen). Dasselbe Drehmoment setzt sich bei
größerem Rad in weniger Vortrieb um. Faktor: `450 = 300 × 0,45 / 0,3`.

### 4. Physik-Tickrate

`120` in den Projekteinstellungen. Der Controller verlangt mindestens diesen
Wert. **Ändern verändert das Fahrverhalten** — und macht damit jede bisherige
Zeile in `TUNING.csv` unvergleichbar.

---

## Startwerte und was sie tun

Gemessen mit Godot 4.6 (headless) am 27.08.2026. Das sind Messwerte, **keine
Aussage darüber, ob es sich gut anfühlt** — das kann nur Fabian feststellen.

| Größe | Wert |
|---|---|
| Auto | 4,0 Einheiten lang, 2,0 breit, Radstand 2,2, Spurweite 1,6 |
| Masse | 1500 (`vehicle_mass`) |
| Reifen | Radius 0,45 · Breite 320 |
| Federweg | vorn 0,25 · hinten 0,30 · Ruhelage jeweils halb |
| Ruhezustand | alle vier Räder Bodenkontakt, halber Federweg |
| Beschleunigung | 0 → ~90 km/h in etwa 6 s, Vollgas, Automatik |
| Vollbremsung | aus 86 km/h in 23 Einheiten ≈ 6 Autolängen |
| Sprungrampe (10°) | bei 82 km/h Scheitel ~4,6 Einheiten, Landung aufrecht |

## Kamera

`kamera/kamerarig.tscn`, Skript `kamera/kamera_rig.gd`. Die Kamera entscheidet
stärker über das Fahrgefühl als jeder Federungsparameter — was man nicht sehen
kann, kann man nicht fahren.

| Feld | Wert | Wirkung |
|---|---|---|
| `gierung_daempfung` | `4.0` | klein = träge und ruhig, groß = direkt und nervös |
| `abstand_still` / `abstand_tempo` | `7.5` / `11.0` | Federarmlänge im Stand / bei Tempo |
| `tempo_voller_abstand` | `22.0` | ab hier gilt der volle Abstand |
| `sichtfeld_still` / `sichtfeld_tempo` | `62` / `76` | kostet nichts, wirkt viel |
| Federarm `transform` | Neigung 10° nach unten, 1,0 über dem Auto | Kamerahöhe — **tiefer als man denkt**. Bodennähe verkauft den Maßstab, Vogelperspektive zerstört ihn. |

Der Pivot richtet sich nach der **Blickrichtung der Karosserie** aus, nicht nach
der Fahrtrichtung. Deshalb schlägt die Kamera beim Rückwärtsfahren nicht um.

## Optik

| Datei | Was |
|---|---|
| `optik/miniatur_kamera.tres` | Tiefenschärfe (Tilt-Shift). Nah 4,5 / **fern 140,0 mit Übergang 90**, Stärke 0,10. Im Inspector unter *DOF Blur*. **Korrigiert am 27.08.2026:** fern stand auf 20 bei Übergang 10 — die Kamera hängt aber selbst schon 7,5–11 hinter dem Auto, scharf war also nur ein Ring von etwa 10 Einheiten vor der Stoßstange. Das verdeckte auch die Barriere aus Slice 1, die 120 Einheiten vor dem Start steht. Unter ~120 ist sie wieder unsichtbar. |
| `optik/miniatur_umgebung.tres` | Sättigung 1,25, Kontrast 1,08, ACES-Tonemapping, SSAO. Bewusst **keine** Bewegungsunschärfe — die lässt alles groß wirken. Bewusst kein Glow. |
| `welt/kiste.tscn` → `Sonne` | Harte, kontrastreiche Schatten (`shadow_blur = 0.5`). |
