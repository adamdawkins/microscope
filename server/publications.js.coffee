Meteor.publish 'posts', ->
  Posts.find()

Meteor.publish 'comments', ->
  Comments.find()

Meteor.publish 'notifications', ->
  Notifications.find()
