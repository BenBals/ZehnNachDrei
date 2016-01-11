# Configure the router
Router.configure
  # base template is named layout
  layoutTemplate: 'layout',

# the home or index or what ever you want to call it
Router.route '/', ->
  # render Home template (from Home.html)
  this.render 'Home', {
    # give it data
    data: ->
      return {
        # all articles that match the search and category (all non-empty ones for no seach/all categories)
        matchingArticles: ->
          root.utils.search Session.get('searchQuery')
        # give it the query (for the bar and stuff)
        query: ->
          Session.get('searchQuery')
        # give it a list of all categories for the dropdown
        categories: root.categories
      }
  }

# go to the article with the given id
Router.route '/article/:_id', ->
  this.render 'Article', {
    data: ->
      # give it the data for the article (text, publishing date etc.)
      Articles.findOne({_id: this.params._id})
  }

# open the editor
Router.route 'editor', ->
  this.render 'Editor', {
    data: ->
      # give it the data for the article (text, publishing date etc.)
      {
        articles: Articles.find()
      }
  }

# go to the edit page for the given article
Router.route 'edit/:_id', ->
  this.render 'Edit', {
    data: {
      # give it the data for the article (text, publishing date etc.)
      article: Articles.findOne({_id: this.params._id})
      # and all the categories (for the dropdown)
      categories: root.categories
    }
  }


Router.route 'logs', {
  # subscribe to the logs (diffent method than before)
  subscriptions: -> Meteor.subscribe 'logs'
  # RENDER ALL THE LOGS
  action: -> this.render 'Logs'

}
# mangage users route
Router.route 'manageUsers', ->
  this.render 'ManageUsers'

# impressum route
Router.route 'impressum', ->
  this.render 'Impressum'