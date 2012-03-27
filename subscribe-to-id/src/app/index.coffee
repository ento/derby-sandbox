{get, view, ready} = app = require('derby').createApp module

## ROUTES ##

# Derby routes can be rendered on the client and the server
get '/', (page, model) ->
  unless roomId = model.get '_session.roomId'
    model.set '_session.roomId', roomId = model.id()
    model.set "rooms.#{roomId}",
      name: 'home'
      id: roomId

  console.log 'current rooms', model.get 'rooms'

#  model.subscribe "rooms.#{roomId}", (err, room) -> # _messages doesn't get updated?

  query = model.query('rooms').where('id').equals(roomId)
  model.fetch query, (err, room) ->
    console.log 'fetch by query', room
#  model.subscribe query, (err, room) -> # no room returned

  model.ref '_room', "rooms.#{roomId}"
  model.subscribe "_room", (err, room) ->
    room.setNull 'messages', ['hello'] if room
    model.fn '_messages', '_room', (room) ->
      return [] unless room
      retval = for message in room.messages
        'o ' + message
      retval

    model.setNull '_newMessage', ''
    page.render 'index'

## CONTROLLER FUNCTIONS ##

ready (model) ->
  app.pushMessage = ->
    roomId = model.get '_room.id'
    message = model.get '_newMessage'
    model.push "_room.messages", message
#    model.push "room.#{roomId}.messages", message # doesn't work
    model.set '_newMessage', ''
