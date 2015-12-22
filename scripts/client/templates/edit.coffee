Template.Edit.helpers {
  # making a datestring (JS -> html) out of the timestap
  blub: utils.timestampToDateString
  # return whether a given category is currently the set category
  isSelected: (category) ->
    Template.instance().data.article.category == category
  # see if the current user has the required permissons
  isEditorOrAdmin: ->
    Roles.userIsInRole Meteor.user(), ['admin', 'editor']
}

Template.Edit.events {
  # making the save happen when the button is clicked
  'click .save': ->
    # check for date
    if !$('#publishDate')[0].validity.valid
      $('#publishDate').val utils.timestampToDateString(Date.now())

    # getting all the data from the dom and creating a obj for mongo
    obj = {
      $set: {
        title: $('#title').val(),
        description: $('#description').val(),
        imgSource: $('#imgSource').val(),
        text: $('#text').val(),
        publishDate: utils.timestampToSameDateAtZehnNachDrei Date.parse($('#publishDate').val())
        category: $('#category').val()
        author: $('#author').val()
      }
    }

    # see if there is poll data and set or unset it accordingly
    if $('#pollData').val() != ''
      obj.$set.pollData = $('#pollData').val()
    else
      obj.$unset = {}
      obj.$unset.pollData = ''

    # checking if all fields have content
    if obj.$set.title == "" or obj.$set.description == "" or obj.$set.imgSource == "" or obj.$set.text == ""
      alert "Du musst alle Felder ausfüllen!"
      return

    # if everything is right push the data to the db
    Meteor.call 'updateArticle', this.article._id, obj

    # removing the saved state from local storage
    root.utils.removeFromLocalStorage 'text_' + this.article._id

  # making the remove happen when the button is clicked
  'click .remove': ->
    # making a popup and asking the user if they really want this
    if window.confirm 'Willst du den Artikel wirklich löschen?'
      # if so tell the db to remove the article
      Meteor.call 'removeArticle', this.article._id, (err, res) ->
        # check if the is a error and if there is notify the user
        if err
          console.log err.reason
          alert err.message
        # if everything was successful go to the edit overview
        Router.go('editor')

      # removing the saved state from local storage
      root.utils.removeFromLocalStorage 'text_' + this._id

  # putting every change into localStorge everytime a key is realeaseds
  'keyup #text': (e) ->
    newVal = $(e.target).val()
    oldVal = this.article.text
    # if it changed -> put it into localStorage
    if oldVal != newVal
      # save as text_id
      root.utils.saveLocalStorage 'text_' + this.article._id, newVal
    else
      # remove the one for the current article
      root.utils.removeFromLocalStorage 'text_' + this.article._id

  # asking to recover stuff if there is stuff to recover
  'focus #text': ->
    # only ask once per session
    if !Session.get 'notFirstTyping_' + this.article._id
      # save that it has been focused
      Session.set 'notFirstTyping_' + this.article._id, true
      # get the saved text form localStorage
      savedText = root.utils.loadLocalStorage 'text_' + this.article._id
      # if there is some saved ask to user if they want to recover it
      if savedText
        if window.confirm 'Du hast ungespeicherte Vortschritte vom letzten Mal. Willst du sie laden?'
          # put it into the text field if they say yes
          $('#text').val(savedText)

  # toggle the poll settings on click of the header
  'click #pollDataH': ->
    $('#pollData, .poll-warning').toggle()

}