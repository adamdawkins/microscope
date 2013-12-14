Meteor.publish 'posts', (options) ->
  Posts.find {}, options

Meteor.publish 'comments', ->
  Comments.find()

Meteor.publish 'notifications', ->
  Notifications.find userId: @userId
