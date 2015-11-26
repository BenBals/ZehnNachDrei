Template.Poll.helpers {
  stringify: JSON.stringify
}

Template.Poll.events {
  'click .submit-poll': (e) ->
    console.log 'thank you for submitting the poll'
    console.log this
}