extends Node3D
## Verfolgerkamera für das Spielzeugauto.
##
## Aufbau (der Rig-Knoten selbst ist der Pivot):
## [codeblock]
## Auto (RigidBody3D)
## └── Kamerarig (Node3D, top_level = true)   ← Position sofort, Gierung gedämpft
##     └── Federarm (SpringArm3D)             ← löst Wandkollision selbst auf
##         └── Kamera (Camera3D)
## [/codeblock]
##
## Zwei Entscheidungen, die hier drinstecken:
## [br]1. Der Pivot richtet sich nach der [b]Blickrichtung der Karosserie[/b] aus,
##    nicht nach der Fahrtrichtung. Deshalb schlägt die Kamera beim Rückwärtsfahren
##    nicht um — der häufigste Grund für "fühlt sich falsch an".
## [br]2. [code]top_level = true[/code] koppelt den Rig von der Auto-Transformation ab,
##    obwohl er im Baum darunter hängt. Ohne das würde sich die ganze Welt bei
##    jedem Lenkeinschlag mitdrehen.

## Das Auto. Wird in der Fahrzeugszene auf den Elternknoten gesetzt.
@export var ziel : Node3D

@export_group("Dämpfung")
## Wie schnell die Kamera der Karosserieausrichtung folgt, in 1/s.
## Klein = träge und ruhig, groß = direkt und nervös.
@export var gierung_daempfung := 4.0

@export_group("Abstand")
## Federarmlänge im Stand.
@export var abstand_still := 7.5
## Federarmlänge bei vollem Tempo.
@export var abstand_tempo := 11.0
## Ab diesem Tempo (Einheiten/s) gilt der volle Abstand.
@export var tempo_voller_abstand := 22.0

@export_group("Ruck")
## Auslenkung eines Stoßes, in Einheiten. Wird von welt/fundstueck.gd ausgelöst
## und ist die einzige Rückmeldung beim Aufsammeln — Ton gibt es in diesem
## Slice nicht (CLAUDE.md).
@export var ruck_staerke := 0.4
## Wie schnell der Ruck abklingt, in 1/s. Groß = kurz und trocken.
@export var ruck_abklingen := 7.0
## Schwingungen pro Sekunde während des Rucks.
@export var ruck_frequenz := 6.0

@export_group("Sichtfeld")
## Sichtfeld im Stand, in Grad.
@export var sichtfeld_still := 62.0
## Sichtfeld bei vollem Tempo, in Grad. Kostet nichts, wirkt viel.
@export var sichtfeld_tempo := 76.0

@onready var federarm : SpringArm3D = $Federarm
@onready var kamera : Camera3D = $Federarm/Kamera

var gierung := 0.0
var ruck := 0.0
var ruck_zeit := 0.0

func _ready() -> void:
	top_level = true
	if ziel:
		gierung = gierung_der_karosserie()
		global_transform = Transform3D(Basis(Vector3.UP, gierung), ziel.global_position)

func _process(delta : float) -> void:
	if ziel == null:
		return

	var ziel_gierung := gierung_der_karosserie()
	## Rahmenratenunabhängige exponentielle Dämpfung.
	gierung = lerp_angle(gierung, ziel_gierung, 1.0 - exp(-gierung_daempfung * delta))
	global_transform = Transform3D(Basis(Vector3.UP, gierung), ziel.global_position + ruck_versatz(delta))

	var tempo := 0.0
	if ziel is RigidBody3D:
		tempo = (ziel as RigidBody3D).linear_velocity.length()
	var anteil := clampf(tempo / maxf(tempo_voller_abstand, 0.001), 0.0, 1.0)
	federarm.spring_length = lerpf(abstand_still, abstand_tempo, anteil)
	kamera.fov = lerpf(sichtfeld_still, sichtfeld_tempo, anteil)

## Kurzer Stoß auf die Kamera. Wird von außen aufgerufen, wenn im Spiel etwas
## passiert, das man spüren soll — in Slice 1 genau einmal, beim Aufsammeln
## des Rammbocks.
func stoss() -> void:
	ruck = ruck_staerke
	ruck_zeit = 0.0

## Abklingende Auf-und-ab-Auslenkung. Liefert Null, sobald nichts mehr ansteht,
## damit die Kamera im Normalfall exakt so ruhig bleibt wie vorher.
func ruck_versatz(delta : float) -> Vector3:
	if ruck <= 0.001:
		return Vector3.ZERO
	ruck = lerpf(ruck, 0.0, 1.0 - exp(-ruck_abklingen * delta))
	ruck_zeit += delta
	return Vector3.UP * sin(ruck_zeit * TAU * ruck_frequenz) * ruck

## Gierwinkel aus der Karosserie-Z-Achse, flach auf die Bodenebene projiziert.
## Bei überschlagenem oder senkrecht stehendem Auto bleibt der letzte Winkel stehen.
func gierung_der_karosserie() -> float:
	var achse := ziel.global_transform.basis.z
	var flach := Vector2(achse.x, achse.z)
	if flach.length() < 0.05:
		return gierung
	flach = flach.normalized()
	return atan2(flach.x, flach.y)
