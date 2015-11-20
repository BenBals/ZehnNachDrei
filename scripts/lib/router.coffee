# Configure the router
Router.configure
  layoutTemplate: 'layout',

# the home or index or what ever you want to call it
Router.route '/', ->
  this.render 'Home', {
    data: ->
      return {
        matchingArticles: ->
          root.utils.search Session.get('searchQuery')
        query: ->
          Session.get('searchQuery')
        categories: root.categories
      }
  }

# go to the article with the given id
Router.route '/article/:_id', ->
  this.render 'Article', {
    data: ->
      Articles.findOne({_id: this.params._id})
  }

# open the editor
Router.route 'editor', ->
  this.render 'Editor', {
    data: ->
      {
        articles: Articles.find()
      }
  }

# go to the edit page for the given article
Router.route 'edit/:_id', ->
  this.render 'Edit', {
    data: {
      article: Articles.findOne({_id: this.params._id})
      categories: root.categories
    }
  }


Router.route 'logs', {
  subscriptions: -> Meteor.subscribe 'logs'
  action: -> this.render 'Logs'

}
# mangage users route
Router.route 'manageUsers', ->
  this.render 'ManageUsers'

Router.route 'impressum', ->
  this.render 'Impressum'