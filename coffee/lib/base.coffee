# getting the root so we can make global variables from coffeescript
root = exports ? this
root.root = root

# the collection that stores all the articles
root.Articles = new (Mongo.Collection)('articles')

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

root.parseUnixTimeToString = (n) ->
  date = new Date(n+3600)
  toTwoDigits = (n) ->
    if n < 10
      '0' + String(n)
    else String(n)
  return date.getUTCFullYear() + "-" + toTwoDigits(date.getUTCMonth() + 1) + "-" + date.getUTCDate()

# utils
root.utils = {
  # generating 'or lists' for the search
  generateSearchFindObj: (obj) ->
    str = obj.str
    category = obj.category
    filteredList = _.filter str.split(' '), (el) -> el != ""
    orList = _.map filteredList, (n) ->
      {
        title: root.utils.generateSearchRegex n
      }

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
}

root.categories = [
  "Test",
  "Test2"
]