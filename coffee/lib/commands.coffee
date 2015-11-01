# run the given command
root.runCommand = (str) ->
  # remove start and end character
  withOutSlashAndDot = _.initial(_.drop(str)).join ''
  # split
  splited = withOutSlashAndDot.split ' '
  # extract the command and the arguments
  command = splited[0]
  args = _.drop splited

  # get the function from the array
  f = root.commands[command]

  # if f exits then run it with the given args
  if f
    f.apply root, args

    # clear the search 
    $('#searchBox').val ''
    Session.set 'searchQuery', {
      str: '',
      category: Session.get('searchQuery').category
    }

# the list of possible commands
root.commands = {
  # open the editor
  'editor': ->
    Router.go 'editor'
  # alert the first arg in uppercase
  'shout': (str) ->
    alert str.toUpperCase()
  # go the mail log in
  'mail': ->
    window.location.href = "http://mail.zehnnachdrei.de"
  # go to the logs
  'logs': ->
    Router.go 'logs'
}


# Hallo mein liebster Ben ich liebe dich so unglaublich doll das kannst du fast gar nicht glauben und ich dich erst meine liebste Fenja. Ich liebe dich!
