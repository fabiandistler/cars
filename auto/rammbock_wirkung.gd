extends Area3D
## Der Zerfall der Barriere — Slice 1, Block 4.
##
## Der ehrliche Weg (die Barriere ist ein schwerer Stapel, den nur der Rammbock
## verschiebt) funktioniert nicht: mit genug Anlauf schiebt ein 1500er Auto
## irgendwann alles. Deshalb ist die Wand binär — eingefrorene [RigidBody3D],
## die sich mit keiner Geduld bewegen lassen — und dieser Bereich hebt genau
## einmal die Sperre auf.
##
## Ein Klotz der Barriere ist daran erkennbar, dass er ein eingefrorener
## [RigidBody3D] ist. Die Würfel und Klötze der Testkiste sind ungefroren, Boden,
## Wände und Rampe sind [StaticBody3D] — es braucht also keine eigene Gruppe.
##
## Getroffen wird nicht nur der eine Klotz, sondern sein Nachbarschaftsstreifen:
## ein einzelner 8 Einheiten breiter Klotz gäbe kein Loch, durch das man fährt.
##
## Passiert genau einmal. Danach ist [code]monitoring[/code] aus, und es gibt
## keinen Zustand, der gespeichert werden müsste.

## Wie weit links und rechts vom Treffer die Klötze mitgehen, in Einheiten.
## 20 löst bei 8 Einheiten Klotzbreite fünf bis sechs Klötze — rund 44 Einheiten
## Loch bei 2,4 Einheiten Autobreite.
@export var wirkbreite := 20.0

## Schub auf die gelösten Klötze. Ohne ihn fallen sie nur in sich zusammen,
## statt wegzufliegen.
@export var schub := 900.0

func _ready() -> void:
	body_entered.connect(_getroffen)

func _getroffen(koerper : Node3D) -> void:
	var treffer := koerper as RigidBody3D
	if treffer == null or not treffer.freeze:
		return

	var richtung := -global_transform.basis.z
	for kind in treffer.get_parent().get_children():
		var klotz := kind as RigidBody3D
		if klotz == null or not klotz.freeze:
			continue
		if absf(klotz.global_position.x - treffer.global_position.x) > wirkbreite:
			continue
		## Erst auftauen, dann schieben — die Reihenfolge der aufgeschobenen
		## Aufrufe bleibt erhalten. Ein Impuls auf einen eingefrorenen Körper
		## verpufft.
		klotz.set_deferred("freeze", false)
		klotz.call_deferred("apply_impulse", richtung * schub + Vector3.UP * schub * 0.3)

	set_deferred("monitoring", false)
