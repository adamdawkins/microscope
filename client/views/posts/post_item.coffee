Template.postItem.helpers
  ownPost: ->
    @userId is Meteor.userId()

  domain: ->
    a = document.createElement("a")
    a.href = @url
    a.hostname

  upvotedClass: ->
    userId = Meteor.userId()
    if userId and not _.include(@upvoters, userId)
      "btn-primary upvotable"
    else
      "disabled"

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
    $this.css "top", delta + "px"
  
  # let it draw in the old position, then..
  Meteor.defer ->
    instance.currentPosition = newPosition
    
    # bring element back to its new original position
    $this.css "top", "0px"


Template.postItem.events "click .upvotable": (e) ->
  e.preventDefault()
  Meteor.call "upvote", @_id
