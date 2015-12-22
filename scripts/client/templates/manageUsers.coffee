Template.ManageUsers.helpers {
  # telling the template if the user is an admin
  currentUserIsAdmin: ->
    Roles.userIsInRole Meteor.user(), ['admin']
  # get all the users and pass them to the template
  users: ->
    Meteor.users.find()
  # get an id form the template and tell it if the user is an editor
  isEditor: (id) ->
    Roles.userIsInRole id, ['editor']
  # get an id form the template and tell it if the user is a spectator
  isSpectator: (id) ->
    Roles.userIsInRole id, ['spectator']
  # get an id form the template and tell it if the user is an admin
  isAdmin: (id) ->
    Roles.userIsInRole id, ['admin']
}

Template.ManageUsers.events {
  # doing the save on the button click
  'click .save': ->
    # empty obj to start with
    obj = {}
    ###
    exampleObj = {
      userId: {
        isAdmin: true,
        isEditor: true,
        isSpectator: false
      }
    }
    ###

    # looping over all trs
    $('.userTr').each ->
      # getting the id and the values of the checkboxes
      id = $(this).data('id')
      isAdmin = $(this).find('.isAdmin')[0].checked
      isEditor = $(this).find('.isEditor')[0].checked
      isSpectator = $(this).find('.isSpectator')[0].checked
      # if a user is an admin they are automaticlly an editor too
      if isAdmin then isEditor = true

      # generating the obj for processing on the server
      obj[id] = {
        admin: isAdmin
        editor: isEditor
        spectator: isSpectator
      }
    # give all the data to the server to perform the changes
    Meteor.call "setRoles",obj
}