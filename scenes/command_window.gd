extends Control


func _input(event: InputEvent) -> void:
	# 禁用输入测试
	if Input.is_action_just_pressed("ui_cancel"):
		$LineEdit.unedit()
		$LineEdit.release_focus()
		return
	# 命令窗口显示
	if Input.is_action_just_pressed("CommandWindow"):
		self.visible = !self.visible
		$LineEdit.grab_focus.call_deferred()
		if self.visible:
			#$LineEdit.
			$LineEdit.editable = true
			get_tree().paused = true
		else:
			$LineEdit.editable = false
			get_tree().paused = false
	return
