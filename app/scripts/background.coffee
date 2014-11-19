chrome.extension.onRequest.addListener (request, sender, sendResponse)->
	switch request.message
		when 'getTabs'
			chrome.tabs.query {currentWindow:true}, (allTabs)->
				sendResponse({tabs:allTabs})
			break
		when 'switchTab'
			chrome.tabs.update(request.target.id, selected:true)
			sendResponse({})
			break
		when 'requestConfig'
			chrome.storage.sync.get 'config', (items)->
				sendResponse({config:items.config})
			break
		else
			sendResponse({})
			
# TODO - add option for getTabs to find in all windows