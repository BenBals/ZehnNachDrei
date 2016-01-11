# stuff to only do on the server

# publish the articles
Meteor.publish 'articles', ->
  # all articles for admins or editors
  if Roles.userIsInRole this.userId, ['admin', 'editor', 'spectator']
    Articles.find {},
    {
      # sort them newest first (decremental publishing date)
      sort: {
        publishDate: -1
      }
    }
  # public articles for normal users
  else
    # article must have all required fields filled out
    Articles.find {
      # must be published (timestamp of publishing date less then the current one)
      publishDate: {
        $lt: Date.now()
      },
      title: {$ne: ""}
      description: {$ne: ""}
      text: {$ne: ""}
      imgSource: {$ne: ""}
    },
    {
      # sort them newest first (decremental publishing date)
      sort: {
        publishDate: -1
      }
    }

# publish the logs to the admins only
Meteor.publish 'logs', ->
  if Roles.userIsInRole this.userId, ['admin']
    return Logs.find {}, {
      # newest first
      sort: {
        time: -1
      }
    }

# publish all userData to the admins and their own to all others
Meteor.publish 'userData', ->
  if Roles.userIsInRole this.userId, ['admin']
    return Meteor.users.find {}
  else
    return Meteor.users.find {_id: this.userId}

Meteor.publish 'polls', (id) ->
  # trying to remove sensible data
  transform = (doc) ->
    doc.votes = _.map doc.votes, (ele) ->
      return ele.length

  # returning the poll for the article to the user
  cursor = Polls.find({articleId: id}, {transform: transform})
  console.log cursor
  return cursor

# create a example user if no user is present
if Meteor.users.find().count() is 0
    # settings for the new user
    options =
      email: 'redaktion@zehnnachdrei.de'
      password: 'pass' # change IMMEDIATELY
      roles:['admin', 'editor']
    # make the user with the options
    Accounts.createUser options

  # give the new user admin priveleges
  Roles.setUserRoles Meteor.users.findOne()._id, ['admin', 'editor']