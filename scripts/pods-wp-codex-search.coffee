# Description:
#   WP Codex Search allows IRC users to search the WP codex easily
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  .codex <search> - Displays the first search result from the WP Codex for the searched phrase
#
# Author:
#   pmgarman, sc0ttkclark

codexURL = 'codex.wordpress.org'
searchBase = 'https://www.googleapis.com/customsearch/v1?cx=018336167779169652526:ob97f-pq5xo&key=AIzaSyB4zssabHUY9wPtWFOnY2BMKT4eMIIdu1M&q=site:' + codexURL + '%20'

module.exports = (robot) ->
  robot.hear /\.codex (.+)$/i, (msg) ->
    phrase = msg.match[1]
    search = searchBase + encodeURIComponent phrase
    console.log 'Searching WP Codex for: ' + phrase
    console.log 'Searching with: ' + search
    msg
      .http(search)
      .get() (err, res, body) ->
        try
          response = JSON.parse body

          if response.items is 'null'
            msg.send 'No results found.'
          else
            found = response.items[0].title.replace( new RegExp( '/\s\u00B7\spods\-framework.*/' ), '' )
            msg.send found + ' - ' + response.items[0].link
            if response.items[1].link isnt 'undefined'
              found2 = response.items[1].title.replace( new RegExp( '/\s\u00B7\spods\-framework.*/' ), '' )
              msg.send found2 + ' - ' + response.items[1].link

        catch
          return