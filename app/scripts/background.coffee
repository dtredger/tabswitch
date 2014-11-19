chrome.extension.onRequest.addListener (request, sender, sendResponse)->
	switch request.message
		when 'getTabs'
			chrome.windows.getCurrent (window)->
				chrome.tabs.getAllInWindow window.id, (allTabs)->
					sendResponse(tabs:allTabs)
			break
		when 'switchTab'
			chrome.tabs.update(request.target.id, selected:true)
			sendResponse({})
			break
		else
			sendResponse({})
			