extends Area3D
## Das Fundstück — der Rammbock, bevor er am Auto sitzt.
##
## Aufsammeln [i]ist[/i] Einbauen. Kein Slot, kein Inventar, keine Werkbank: bei
## genau einem Teil ist jede Verwaltung Selbstzweck (SLICE1.md).
##
## Berührt das Auto diesen Bereich, passiert dreierlei:
## [br]1. Der Knoten [code]Rammbock[/code] am Auto wird sichtbar.
## [br]2. [code]RammbockKollision[/code] und [code]RammbockWirkung[/code] am
##    Auto werden eingeschaltet — ab hier trägt das Auto die Form, die die
##    Barriere zerlegt, und den Auslöser dafür.
## [br]3. Ein kurzer Kameraruck. Das ist der ganze "Moment". Ton ist in diesem
##    Slice nicht vorgesehen, und eine neue Audiodatei bräuchte eine Zeile in
##    ASSETS.md — siehe CLAUDE.md.
##
## Der Bereich horcht nur auf Ebene 2 (das Auto) und liegt selbst auf keiner
## Ebene: er ist ein Auslöser, kein Hindernis.
##
## Passiert genau einmal — danach ist der Knoten weg. Es gibt keinen Zustand,
## der gespeichert werden müsste.

func _ready() -> void:
	body_entered.connect(_beruehrt)

func _beruehrt(koerper : Node3D) -> void:
	var rammbock := koerper.get_node_or_null("Rammbock") as Node3D
	var kollision := koerper.get_node_or_null("RammbockKollision") as CollisionShape3D
	var wirkung := koerper.get_node_or_null("RammbockWirkung") as Area3D
	if rammbock == null or kollision == null or wirkung == null:
		return

	rammbock.visible = true
	## Kollisionsformen und Bereiche dürfen nicht mitten in der Physikabfrage
	## umgeschaltet werden — Godot verwirft die Änderung sonst mit einer
	## Fehlermeldung.
	kollision.set_deferred("disabled", false)
	wirkung.set_deferred("monitoring", true)

	var rig := koerper.get_node_or_null("Kamerarig")
	if rig != null and rig.has_method("stoss"):
		rig.call("stoss")

	queue_free()
