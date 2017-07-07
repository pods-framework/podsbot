# Description:
#   Pods.io Search allows IRC users to search Pods.io easily
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  .code <search> - Displays the first two search results from Pods.io Code Docs for the searched phrase
#
# Author:
#   pmgarman, sc0ttkclark

searchURL = 'pods.io/docs/code/'
searchBase = 'https://www.googleapis.com/customsearch/v1?cx=018336167779169652526:ob97f-pq5xo&key=AIzaSyB4zssabHUY9wPtWFOnY2BMKT4eMIIdu1M&q=site:' + searchURL

module.exports = (robot) ->
  robot.hear /\.code (.+)$/i, (msg) ->
    phrase = msg.match[1].replace /_/g, '-'
    search = searchBase + encodeURIComponent phrase
    console.log 'Searching Pods.io for: ' + phrase
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