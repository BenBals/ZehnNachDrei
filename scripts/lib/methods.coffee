# defining the methods
Meteor.methods {
  # update the article with the mongo obj and id form the user
  updateArticle: (id, obj) ->
    # security check
    if Roles.userIsInRole Meteor.user(), ['admin', 'editor']
      # logging the update
      Meteor.call 'logThisShit', 'change article', Articles.findOne(id), obj
      Articles.update(id, obj)

      console.log obj

      if obj['$set'].pollData
        update = {
          $set: {
            articleId: id,
            data: JSON.parse obj['$set'].pollData
          }
        }

        if Polls.findOne({articleId: id})
          Polls.update Polls.findOne(articleId: id)._id, update
        else
          update['$set'].votes = _.map update['$set'].data.options, ->
            return []
          Polls.insert update.$set

      if obj.$unset
        if obj.$unset.pollData == ''
          console.log 'remove poll'
          old = Polls.findOne(articleId: id)
          if old
            Meteor.call 'logThisShit', 'remove poll', Polls.findOne(articleId: id), '-'
          Polls.remove Polls.findOne(articleId: id)._id
    else
      Meteor.call('notAuthorisedError')
  # creating a new article from a blank preset
  newArticle: ->
    # staff only
    if Roles.userIsInRole Meteor.user(), ['admin', 'editor']
        id = Articles.insert(blankArticle)
        # logging the creation
        Meteor.call 'logThisShit', 'create article', '-', id
        return id
    else
      Meteor.call('notAuthorisedError')
  # remove the given article
  removeArticle: (id) ->
    # vip
    if Roles.userIsInRole Meteor.user(), ['admin', 'editor']
      # logging the deletion
      Meteor.call 'logThisShit', 'delete article', Articles.findOne(id), '-'
      id = Articles.remove(id)
      return id
    else
      Meteor.call('notAuthorisedError')

  # method for setting users roles
  setRoles: (obj) ->
    # check for admin permissions
    if Roles.userIsInRole this.userId, ['admin']
      # loop over the obj
      for id, settings of obj
        # parse settings into a role readable format
        rs = []
        if settings.admin then rs.push('admin')
        if settings.editor then rs.push('editor')

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
    Logs.insert {
        'email': Meteor.user().emails[0].address
        'userId': Meteor.userId()
        'action': action
        'before': JSON.stringify before
        'after': JSON.stringify after
        'time': Date.now()
      }
}

# fehler meldung, kein internet