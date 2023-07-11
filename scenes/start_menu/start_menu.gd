extends Control


signal start
signal quit

signal changed_locale(locale: String)


var EN_LOCALE = "en_US"
var RU_LOCALE = "ru_RU"

var locale = EN_LOCALE


func _on_start_button_pressed():
	start.emit()


func _on_quit_button_pressed():
	quit.emit()


func _on_en_button_pressed():
	if locale != EN_LOCALE:
		$Center/MarginContainer3/TabContainer.get_children().all(
			func(btn: Button):
				btn.disabled = false
				return true
		)
		$Center/MarginContainer3/TabContainer/EnButton.disabled = true
		locale = EN_LOCALE
		changed_locale.emit(EN_LOCALE)


func _on_ru_button_pressed():
	if locale != RU_LOCALE:
		$Center/MarginContainer3/TabContainer.get_children().all(
			func(btn: Button):
				btn.disabled = false
				return true
		)
		$Center/MarginContainer3/TabContainer/RuButton.disabled = true
		locale = RU_LOCALE
		changed_locale.emit(RU_LOCALE)
