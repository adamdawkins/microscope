Template.postsList.helpers
  postsWithRank: ->
    @posts.rewind()
    @posts.map (post, index, cursor) ->
      post._rank = index
      post

  hasMorePosts: ->
    @posts.rewind()
    Router.current().limit() == @posts.fetch().length


Template.postItem.rendered = ->
  # animate post from previous position to new position
  instance = this
  rank = instance.data._rank
  $this = $(@firstNode)
  postHeight = 80
  newPosition = rank * postHeight
  
  # if element has a currentPosition (i.e. it's not the first ever render)
  if typeof (instance.currentPosition) isnt "undefined"
    previousPosition = instance.currentPosition
    # calculate difference between old position and new position and send element there
    delta = previousPosition - newPosition
    $this.css("top", delta + "px")

  # let it draw in the old position, then ..
  Meteor.defer ->
    instance.currentPosition = newPosition
    # bring element back to its new original position
    $this.css "top", "0px"

