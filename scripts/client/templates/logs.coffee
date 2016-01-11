Template.Logs.helpers {
  # telling the template if the user is an admin
  currentUserIsAdmin: ->
    Roles.userIsInRole Meteor.user(), ['admin']
  # get all the logs
  logs: ->
    Logs.find()
}

Template.Logs.events {
  # expanding/collapsing a td on click
  'click tr': ->
    # getting the element that was clicked on
    target = $(event.target)
    # check if it is already extended
    if target.css('overflow') == 'auto' or target.css('white-space') == 'normal'
      # if it is => collapse it
      target.css 'overflow', 'scroll'
      target.css 'white-space', 'nowrap'
    else
      # if it isnt => extend it
      target.css('overflow', 'auto')
      target.css('white-space', 'normal')
}