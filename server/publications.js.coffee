Meteor.publish 'posts', (options) ->
  Posts.find {}, options

Meteor.publish 'singlePost', (id) ->
  id and Posts.find(id)

Meteor.publish 'comments', ->
  Comments.find()

Meteor.publish 'notifications', ->
  Notifications.find userId: @userId
