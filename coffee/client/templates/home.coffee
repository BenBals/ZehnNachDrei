# only show the articles that actully have all the needed data
Template.Home.helpers {
  existingArticles: ->
    Articles.find {
      title: {$ne: ""}
      description: {$ne: ""}
      text: {$ne: ""}
      imgSource: {$ne: ""}
    }

  isSelected: (category) ->
    if Session.get('searchQuery')
      category == Session.get('searchQuery').category
    else
      false
}

Template.Home.events
  'click .searchButton': ->
    $('.search').toggle()

  'keyup #searchBox': (e) ->

    # get the query string
    query = $(e.target).val()

    # update the query on the session
    Session.set 'searchQuery', {
      str: query,
      category: Session.get('searchQuery').category
    }

  'click .backButton': ->
    # go to the last page
    history.back()

  'change #category': (e) ->
    console.log 'select this shit'
    console.log e

    category = $(e.target).val()

    Session.set 'searchQuery', {
      str: Session.get('searchQuery').str
      category: category
    }