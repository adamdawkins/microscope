Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    Meteor.subscribe('posts')

Router.map ->
  @route 'postsList', path: '/'
  @route 'postPage',
    path: '/posts/:_id'
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
