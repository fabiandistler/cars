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
## Wie die Trümmer wegfliegen, ist dabei kein Optik-, sondern ein Spielproblem —
## siehe die Begründung bei [member schub_vorwaerts].
##
## Passiert genau einmal. Danach ist [code]monitoring[/code] aus, und es gibt
## keinen Zustand, der gespeichert werden müsste.

## Wie weit links und rechts vom Treffer die Klötze mitgehen, in Einheiten.
## 28 löst bei 8 Einheiten Klotzbreite sechs bis sieben Klötze. Direkt an der
## Seitenwand findet der Filter nur nach innen Klötze — dort bleibt das Loch
## kleiner, und genau dieser Fall ist der enge.
@export var wirkbreite := 28.0

## WARUM DER IMPULS SO AUSSIEHT, WIE ER AUSSIEHT
## Ein gelöster Klotz ist 2,4 Einheiten hoch — exakt so hoch wie die Wand, aus
## der er stammt. Er ist also, sobald er im Weg liegt, selbst wieder ein Gate.
## Die erste Fassung schob die Klötze nach vorn: das Auto holte sie bei 40
## Einheiten/s sofort wieder ein und blieb an der eigenen Trümmerwand hängen —
## am Rand der Wand in zwei von vier Anläufen komplett.
##
## Deshalb geht der Schub jetzt hoch und zur Seite statt nach vorn. Die Klötze
## müssen lange genug in der Luft bleiben, dass das Auto durch ist, bevor sie
## landen — und sie sollen nach außen räumen, nicht in die Lücke.

## Schub nach vorn. Bewusst klein: mehr davon legt die Trümmer wieder in den Weg.
@export var schub_vorwaerts := 350.0

## Schub nach oben. Bestimmt die Flugzeit: 750 auf 60 Masseeinheiten sind rund
## 12,5 Einheiten/s, bei Schwerkraft 19,62 also gut 1,2 Sekunden in der Luft.
## In der Zeit fährt das Auto etwa 50 Einheiten — es ist längst durch.
@export var schub_hoch := 750.0

## Schub nach außen, am Rand des Wirkbereichs. In der Mitte null, außen voll:
## so klappt die Wand auf, statt nach vorn umzufallen.
@export var schub_seitlich := 700.0

## Kollisionsebene, auf die ein gelöster Klotz wechselt.
##
## TRÜMMER SIND SCHAUSPIEL, KEIN HINDERNIS — und das ist eine Entscheidung,
## keine Bequemlichkeit. Ein gelöster Klotz ist 2,4 Einheiten hoch, exakt so
## hoch wie die Wand: liegt er im Weg, ist er wieder ein Gate. Gemessen, vier
## Anläufe, mit Ebenenwechsel abgeschaltet:
##
##   Mitte der Wand      -> kam durch
##   dicht an der Seitenwand -> blieb stecken, zweimal von zwei
##
## Am Rand drückt der seitliche Schub die Klötze gegen die Seitenwand, von der
## sie in die eben gerissene Lücke zurückprallen. Mit mehr Höhe oder mehr Schub
## wird das wahrscheinlicher richtig, aber nie sicher — und ein Gate, das in
## einem von vier Anläufen zumacht, ist schlimmer als eines, das immer hält.
##
## Ebene 4 kollidiert weiter mit der Welt (Ebene 1), aber nicht mehr mit dem
## Auto (Ebene 2). Die Klötze fliegen und landen sichtbar wie zuvor, das Auto
## pflügt hindurch. Genau das soll der Moment sein.
##
##   Rückgängig machen: diese Zeile löschen und den Ebenenwechsel unten
##   entfernen. Dann sind die Trümmer wieder fest — und das Gate wieder
##   Glückssache.
@export var truemmer_ebene := 4

## Womit ein gelöster Klotz noch kollidiert: Welt (1) und andere Trümmer (4).
@export var truemmer_maske := 5

func _ready() -> void:
	body_entered.connect(_getroffen)

func _getroffen(koerper : Node3D) -> void:
	var treffer := koerper as RigidBody3D
	if treffer == null or not treffer.freeze:
		return

	var vorwaerts := -global_transform.basis.z
	var rechts := global_transform.basis.x
	for kind in treffer.get_parent().get_children():
		var klotz := kind as RigidBody3D
		if klotz == null or not klotz.freeze:
			continue
		var versatz := klotz.global_position.x - treffer.global_position.x
		if absf(versatz) > wirkbreite:
			continue

		var anteil := absf(versatz) / wirkbreite
		var impuls := vorwaerts * schub_vorwaerts \
			+ Vector3.UP * schub_hoch \
			+ rechts * signf(versatz) * schub_seitlich * anteil

		## Erst auftauen, dann schieben — die Reihenfolge der aufgeschobenen
		## Aufrufe bleibt erhalten. Ein Impuls auf einen eingefrorenen Körper
		## verpufft.
		klotz.set_deferred("freeze", false)
		klotz.set_deferred("collision_layer", truemmer_ebene)
		klotz.set_deferred("collision_mask", truemmer_maske)
		klotz.call_deferred("apply_impulse", impuls)

	set_deferred("monitoring", false)
