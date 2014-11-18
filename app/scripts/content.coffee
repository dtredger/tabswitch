class Application
	constructor: ->
		@injectView()
		@element().find('input').keyup (event)=>
			@onInput(event)

		@tabListView = new tabListView @element().find('ul')
	
	element: ->
		@element_ ||= $('#tabswitcher-overlay')

	onInput: (event) ->
		candidates = fuzzy(@tabs(), event.target.value)
		@tabListView.update candidates

		if event.keyCode == 13 #enter key
			@switchTab candidates[0].tab iftes?

	hide: ->

	show: ->

	switchTab: (tab) ->
		@hide()
		chrome.extension.sendRequest(message:'switchTab', target:tab)

	hotKeyListener: (event) ->
		if event.keyCode 
			if event.ctrlKey && event.keyCode == 220 # Ctrl + \
				chrome.extension.sendRequest {message:'getTabs'},
					(response)=>
						@tabs_ = response.tabs
						@show()
			else if event.keyCode == 27 #esc
				@hide()

	injectView: ->
		$('body').append 


app = new Application()
window.addEventListener('keyup', (e)->
	app.hotKeyListener(e), false)