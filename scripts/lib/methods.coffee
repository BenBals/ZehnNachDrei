# defining the methods
Meteor.methods {
  # update the article with the mongo obj and id of the article
  updateArticle: (id, obj) ->
    # security check
    if Roles.userIsInRole Meteor.user(), ['admin', 'editor']
      # logging the update
      Meteor.call 'logThisShit', 'change article', Articles.findOne(id), obj
      # pushing the update to the database
      Articles.update(id, obj)

      # extract the poll data
      if obj['$set'].pollData
        update = {
          $set: {
            articleId: id,
            data: JSON.parse obj['$set'].pollData
          }
        }

        # update an existing poll if there is one
        if Polls.findOne({articleId: id})
          Polls.update Polls.findOne(articleId: id)._id, update
        # or insert a new one with empty votes
        else
          update['$set'].votes = _.map update['$set'].data.options, ->
            return []
          Polls.insert update.$set

      # remove the poll if wished
      if obj.$unset
        # do the removal if the pollData string is empty
        if obj.$unset.pollData == ''
          # get the old poll
          old = Polls.findOne(articleId: id)
          # if there is one
          if old
            # log it with all the old data
            Meteor.call 'logThisShit', 'remove poll', Polls.findOne(articleId: id), '-'
          # remove the poll from the database
          Polls.remove Polls.findOne(articleId: id)._id
    else
      # if the user is unathorised throw an error
      Meteor.call('notAuthorisedError')

  # creating a new article from a blank preset
  newArticle: ->
    # staff only
    if Roles.userIsInRole Meteor.user(), ['admin', 'editor']
        # insert an empty article
        id = Articles.insert(blankArticle)
        # logging the creation
        Meteor.call 'logThisShit', 'create article', '-', id
        # return the id of the new article (so the user can be redirected to the edit page)
        return id
    else
      # if the user is unathorised throw an error
      Meteor.call('notAuthorisedError')
  # remove the given article
  removeArticle: (id) ->
    # vip
    if Roles.userIsInRole Meteor.user(), ['admin', 'editor']
      # logging the deletion
      Meteor.call 'logThisShit', 'delete article', Articles.findOne(id), '-'
      # remove it from the database
      id = Articles.remove(id)
      return id
    else
      # if the user is unathorised throw an error
      Meteor.call('notAuthorisedError')

  # method for setting users roles
  setRoles: (obj) ->
    # check for admin permissions
    if Roles.userIsInRole this.userId, ['admin']
      # loop over the obj
      for id, settings of obj
        # parse settings into a role readable format
        rs = []
        if settings.admin then rs.push 'admin'
        if settings.editor then rs.push 'editor'
        if settings.spectator then rs.push 'spectator'

        # set the role
        Roles.setUserRoles id, rs
    else
      # if the user is not authorised raise an error
      Meteor.call('notAuthorisedError')

  # convinient error method
  notAuthorisedError : ->
    throw new Meteor.Error("not-authorized");

  # add a new entry to the logs
  logThisShit: (action, before, after) ->
    # push the data to the database
    Logs.insert {
        # the users database
        'email': Meteor.user().emails[0].address
        # and the users data
        'userId': Meteor.userId()
        # the performed action
        'action': action
        # the state before
        'before': JSON.stringify before
        # and after
        'after': JSON.stringify after
        # time of the operation
        'time': Date.now()
      }
}

# fehler meldung, kein internet