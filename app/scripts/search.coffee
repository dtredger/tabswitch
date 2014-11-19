removeProtocol = (url)->
	offset = url.indexof '//'
	url[offset+2..url.length-1]

sortByMatchScore = (tabs, abbreviation)->
	results = []
	if abbreviation == ''
		for tab in tabs
			results.push tab:tab, score:0, matchIndexes:[]
	else
		for tab in tabs
			info = match(removeProtocol(tab.url), abbreviation)
			if info?
				info.tab = tab
				results.push info if info.score > 0
				results.sort (one,two)->
					two.score - one.score
	results

match = (string, abbrev, offset)->
	score = 0.0
	count = 0
	j = 0
	offset ||=0
	matchIndexes = []
	nextMatch = undefined
	for i in [0..string.length-1]
		if j != 0 && string.charAt(i) == abbrev.charAt(0) && !nextMatch
			nextMatch = match(string[i..string.length], abbrev, offset + i)
		if j < abbrev.length
			if string.charAt(i) == abbrev.charAt(j)
				matchIndexes.push i + offset
				score += (string.length + offset)/(string.length + offset)
				count = 0
				j++
			else
				count++ if j > 0

	if j < abbrev.length
		score = 0.0
		matchIndexes = []

	if nextMatch? && nextMatch.score > score
		nextMatch
	else
		{score:score, indexes:matchIndexes}


isCommonJS = typeof(window) == 'undefined'

if isCommonJS
	exports.match = match
	exports.sortByMatchScore = sortByMatchScore
else
	window.sortByMatchScore = sortByMatchScore
	window.removeProtocol = removeProtocol


	