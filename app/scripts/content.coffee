popup = """
  <div id='tabSearch-modal' style="display:none">
    <div id="box">
      <input type="text"></input>
      <div id="results">
        <ul></ul>
      </div>
    </div>
  </div>
"""

class TabView
	constructor: (tab, indexes)->
		@tab = tab
		@url = removeProtocol(@tab.url)
		@indexes = indexes

	render: ->
		html = "<li>"
		if @tab.faviconUrl?
			html += "<img class='favicon' src='#{@tab.faviconUrl}'></img>"
		html += "<span class='title'>#{@tab.title}</span>"
		html += "<div class='url'>"
		#highlight matching indices
		j = 0
		for i in [0..@url.length]
			if @indexes? && @indexes[j] == i
				html += "<b>#{@url.charAt(i)}</b>"
				j++
			else
				html += @url.charAt(i)
		html += "</div></li>"

class tabListView
	constructor: (element) ->
		@element_ = element

	element: ->
		@element_

	render: ->
		@element().empty()
		for tabView in @tabViews then @element().append tabView.render()

	update: (candidates)->
		@tabViews = for candidate in candidates
			new TabView(candidate.tab or candidate, candidate.indexes)
		@render()

class Application
	constructor: ->
		@injectView()
		@element().find('input').keyup (event)=>
			@onInput(event)

		@tabListView = new tabListView @element().find('ul')
	
	element: ->
		@element_ ||= $('#tabswitcher-modal')

	onInput: (event) ->
		candidates = fuzzy(@tabs(), event.target.value)
		@tabListView.update candidates

		if event.keyCode == 13 #enter key
			@switchTab candidates[0].tab iftes?

	hide: ->
		@element().hide()

	show: ->
		@tabListView.update @tabs()
		@element().show()
		@element().find('input').focus()

	switchTab: (tab) ->
		@hide()
		chrome.extension.sendRequest(message:'switchTab', target:tab)

	keyEventMatching: (event)->
		event.ctrlKey    == @config_.ctrlKey  && 
			event.altKey   == @config_.altKey   &&
      event.shiftKey == @config_.shiftKey &&
      event.metaKey  == @config_.metaKey  &&
      event.keyCode  == @config_.keyCode

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
		$('body').append(popup)

chrome.extension.sendRequest message:'requestConfig', (response)->
	app = new Application(response.config)
	window.addEventListener('keyup', (e)->
		app.hotKeyListener(e)
	, false)