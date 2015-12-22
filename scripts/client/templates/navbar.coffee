Template.NavBar.helpers {
  # return wheter a category is currently selected
  isSelected: (category) ->
    if Session.get('searchQuery')
      category == Session.get('searchQuery').category
    else
      false
  # all the categories
  categories: root.categories
  # get the query from Session
  query: ->
    Session.get('searchQuery')
  # check against the current position 
  currentPathIs: (path) ->
    # get the current url from the Router
    url = Router.current().originalUrl

    # perform some crazy stuff the make it work locally, on the web and in the app (localhost, zehnnachdrei.de or meteor.local)
    splited = url.split('/')
    if splited.length > 3
      return splited[3] == path # 4th element
    else
      return splited[1] == path # 2nd element

}

Template.NavBar.events
  # open the search box
  'click .searchButton': ->
    $('.search').toggle()

  # updating the search every time a button is pressed
  'keyup #searchBox': (e) ->
    # get the query string
    query = $(e.target).val()

    # if dot then run command
    if e.which == 190
      root.runCommand query

    # update the query on the session
    Session.set 'searchQuery', {
      str: query,
      category: Session.get('searchQuery').category
    }

  'click .backButton': ->
    # go to the last page
    history.back()

  # updating the query when a new category is selected
  'change #category': (e) ->
    category = $(e.target).val()

    Session.set 'searchQuery', {
      str: Session.get('searchQuery').str
      category: category
    }