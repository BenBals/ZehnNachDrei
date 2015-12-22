# code that only runs on the client side

# making the articles avalible form the dev tools console
window.Articles = Articles

# getting the articles (published for everyone and all for admins and editors)
Meteor.subscribe 'articles'

# getting the user data (of all users for admins and their own for others, see the server.coffee file)
Meteor.subscribe 'userData'

# process markdown n shit
root.processToHtml = (raw) ->
  if raw
    raw = marked.parse raw
    raw.split('<script>').join('').split('</script>').join('')
  else raw

# starting the search thing
Session.set 'searchQuery', {
  str: "",
  category: "all"
}

$ ->
  # do smartbanner when everything is rendered
  console.log 'doing smartbanner'
  # wait 200ms to give everything some time
  setTimeout ->
    $.smartbanner()
  ,200