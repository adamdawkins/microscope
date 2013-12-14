Router.configure 
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: -> 
    return Meteor.subscribe('posts')

Router.map ->
  @route 'postsList', path: '/'
  @route 'postPage', 
    path: '/posts/:_id'
    data: ->
      return Posts.findOne this.params._id
  @route 'postSubmit', path: '/submit'

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render 'accessDenied'
      @stop()
    

Router.before requireLogin, only: 'postSubmit'
