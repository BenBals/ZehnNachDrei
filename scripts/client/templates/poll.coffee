Template.Poll.helpers {
  # make JSON.stringify avalible to template
  stringify: JSON.stringify
}

Template.Poll.events {
  # submit button event
  'click .submit-poll': (e) ->
    console.log 'thank you for submitting the poll'
    console.log this
}