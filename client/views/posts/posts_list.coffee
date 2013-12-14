Template.postsList.helpers
  hasMorePosts: ->
    @posts.rewind()
    Router.current().limit() == @posts.fetch().length
