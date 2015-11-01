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
    url = Router.current().originalUrl
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

  # updating the search
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
    console.log 'select this shit'
    console.log e

    category = $(e.target).val()

    Session.set 'searchQuery', {
      str: Session.get('searchQuery').str
      category: category
    }