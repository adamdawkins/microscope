Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    [Meteor.subscribe('notifications')]

Router.map ->
  @route 'postsList',
    path: '/:postsLimit?'
    waitOn: ->
      postsLimit = parseInt(@params.postsLimit) or 5
      Meteor.subscribe 'posts',
        sort:
          submitted: -1
        limit: postsLimit
    data: ->
      limit = parseInt(@params.postsLimit) or 5
      posts: Posts.find({},
        sort:
          submitted: -1

        limit: limit
      )

  @route 'postPage',
    path: '/posts/:_id'
    waitOn: ->
      Meteor.subscribe 'comments', @params._id
    data: ->
      Posts.findOne @params._id

  @route 'postEdit',
    path: 'posts/:_id/edit',
    data: ->
      Posts.findOne @params._id

  @route 'postSubmit', path: '/submit'

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render 'accessDenied'
      @stop()
    

Router.before requireLogin, only: 'postSubmit'
Router.before ->
  clearErrors()
