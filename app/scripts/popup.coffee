defaultKey = 
	keyCode: 84 #t
	ctrlKey: false
	altKey: false
	metaKey: false
	shifKey: true


$ ->
	chrome.storage.sync.get 'config', (items)->
		if items.config?
			$('input#settings-hotkey-input').val(humanizeHotkey(items.config))
		else
			chrome.storage.sync.set config: defaultKey, ->
				$('input#settings-hotkey-input').val(humanizeHotkey(defaultKey))

	$('input#settings-hotkey-input').keydown (evt)->
		unless evt.keyCode == 27 #esc
			chrome.storage.sync.set config:getConfig(evt), -> null
		else
			window.close()
			return
		$('input#settings-hotkey-input').val(humanizeHotkey(evt))
		false

humanizeHotkey = (event)->
	"#{getModifier(event)}+#{String.fromCharCode(event.keyCode)}"

getConfig = (event)->
	keyCode: event.keyCode
	ctrlKey: event.ctrlKey
	altKey: event.altKey
	metaKey: event.metaKey
	shifKey: event.shifKey

getModifier = (event)->
  modifier = ""
  if event.ctrlKey
    modifier += 'Ctrl '
  if event.altKey
    modifier += 'Alt '
  if event.metaKey
    modifier += 'Cmd '
  if event.shiftKey
    modifier += 'Shift '
  modifier