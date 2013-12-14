Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  waitOn: ->
    [Meteor.subscribe("notifications")]

PostsListController = RouteController.extend(
  template: "postsList"
  increment: 5
  limit: ->
    parseInt(@params.postsLimit) or @increment

  findOptions: ->
    sort: @sort
    limit: @limit()

  waitOn: ->
    Meteor.subscribe "posts", @findOptions()

  data: ->
    posts: Posts.find({}, @findOptions())
    nextPath: @nextPath()
)
NewPostsListController = PostsListController.extend(
  sort:
    submitted: -1
    _id: -1

  nextPath: ->
    Router.routes.newPosts.path postsLimit: @limit() + @increment
)
BestPostsListController = PostsListController.extend(
  sort:
    votes: -1
    submitted: -1
    _id: -1

  nextPath: ->
    Router.routes.bestPosts.path postsLimit: @limit() + @increment
)
Router.map ->
  @route "home",
    path: "/"
    controller: NewPostsListController

  @route "newPosts",
    path: "/new/:postsLimit?"
    controller: NewPostsListController

  @route "bestPosts",
    path: "/best/:postsLimit?"
    controller: BestPostsListController

  @route "postPage",
    path: "/posts/:_id"
    waitOn: ->
      [Meteor.subscribe("singlePost", @params._id), Meteor.subscribe("comments", @params._id)]

    data: ->
      Posts.findOne @params._id

  @route "postEdit",
    path: "/posts/:_id/edit"
    waitOn: ->
      Meteor.subscribe "singlePost", @params._id

    data: ->
      Posts.findOne @params._id

  @route "postSubmit",
    path: "/submit"
    disableProgress: true


requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render "accessDenied"
    @stop()

Router.before requireLogin,
  only: "postSubmit"

Router.before ->
  clearErrors()
