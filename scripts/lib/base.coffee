# getting the root so we can make global variables from coffeescript
root = exports ? this
root.root = root

# the collection that stores all the articles
root.Articles = new (Mongo.Collection)('articles')
# the collection that stores all the logs
root.Logs = new (Mongo.Collection)('logs')

# easier way to access lodash
_ = lodash

# preset for empty article
root.blankArticle = {
  text: ""
  title: ""
  imgSource: ""
  description: ""
  publishDate: Date.now()
  category: "Test"
}

# utils
root.utils = {
  # generating 'or lists' for the search
  generateSearchFindObj: (obj) ->
    # extract the string and the category
    str = obj.str
    category = obj.category
    # filter empty elemetns for the split list
    filteredList = _.filter str.split(' '), (el) -> el != ""
    # use generateSerarchRegex to make the orList
    orList = _.map filteredList, (n) ->
      {
        title: root.utils.generateSearchRegex n
      }
    # check all cases for existing or empty or List and existing or no category
    if _.isEmpty orList
      if category and category != "all"
        return {
          category: category
        }
      else
        return {}
    else
      if category and category != "all"
        return {
          $or: orList
          category: category
        }
      else
        return {
          $or: orList
        }
      
  # generate the search RegExp§                                                         
  generateSearchRegex: (str) ->
    new RegExp str, 'i'

  # search the articles for query
  search: (query) ->
    if query == undefined
      return Articles.find()
    Articles.find root.utils.generateSearchFindObj(query)
  # managing localStorage
  loadLocalStorage: (id) ->
    JSON.parse localStorage[id]
  saveLocalStorage: (id, obj) ->
    localStorage[id] = JSON.stringify obj
  removeFromLocalStorage: (id) ->
    localStorage.removeItem id

  # time conversion
  timestampToDateString: (n) ->
    date = new Date(n)
    toTwoDigits = (n) ->
      if n < 10
        '0' + String(n)
      else String(n)

    return date.getUTCFullYear() + "-" + toTwoDigits(date.getMonth() + 1) + "-" + date.getDate()

  # timestamp to german format for the article page
  timestampToGermanDate: (n) ->
    date = new Date(n)
    return date.getDate() + '. ' + utils.germanMonths[date.getMonth()] + ' ' + date.getUTCFullYear()

  # converting a unix timestamp to a js timestamp
  unixTimeToTimestamp: (n) ->
    return n * 1000

  # set the time on a timestamp to 15:10:00
  timestampToSameDateAtZehnNachDrei: (n) ->
    date = new Date(n)
    return date.setHours(15,10,0)

  # names of the months in German
  germanMonths: ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember']

  # render the poll to the #poll div
  renderPoll: (pollDataString) ->
    pollData = JSON.parse pollDataString
    Blaze.renderWithData Template.Poll, pollData, $('#poll')[0]

}

# array of all the categories
root.categories = [
  "Schulintern",
  "Wissenswertes",
  "Erfolge",
  "Partyticker",
  "Lifestyle",
  "Kultur",
  "Umfragen",
  "Orientierungsstufe",
  "Zukunft"
]