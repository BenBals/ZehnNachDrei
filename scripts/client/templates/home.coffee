# only show the articles that actully have all the needed data
Template.Home.helpers {
  existingArticles: ->
    Articles.find {
      title: {$ne: ""}
      description: {$ne: ""}
      text: {$ne: ""}
      imgSource: {$ne: ""}
    }
}

Template.Home.events
  'click .backButton': ->
    # go to the last page
    history.back()

  'click .cardLi': ->
    # go to the article
    Router.go('/article/' + this._id)