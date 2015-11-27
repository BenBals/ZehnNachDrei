# stuff to only do on the server

# publish the articles
Meteor.publish 'articles', ->
  # all articles for admins or editors
  if Roles.userIsInRole this.userId, ['admin', 'editor'] or Meteor.user().emails[0].address is 'steffen.kaestner@cjd.de'
    Articles.find {},
    {
      sort: {
        publishDate: -1
      }
    }
  # public articles for normal users
  else
    Articles.find {
      publishDate: {
        $lt: Date.now()
      },
      title: {$ne: ""}
      description: {$ne: ""}
      text: {$ne: ""}
      imgSource: {$ne: ""}
    },
    {
      sort: {
        publishDate: -1
      }
    }

# publish the logs to the admins only
Meteor.publish 'logs', ->
  if Roles.userIsInRole this.userId, ['admin']
    return Logs.find {}, {
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
  transform = (doc) ->
    doc.votes = _.map doc.votes, (ele) ->
      return ele.length

  cursor = Polls.find({articleId: id}, {transform: transform})
  console.log cursor
  return cursor

# create a example user if no user is present
if Meteor.users.find().count() is 0
    options =
      email: 'benjustusbals@gmail.com'
      password: 'pass' # change IMMEDIATELY
      roles:['admin', 'editor']
    Accounts.createUser(options)

  Roles.setUserRoles Meteor.users.findOne()._id, ['admin', 'editor']