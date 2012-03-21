{get, view, ready} = app = require('derby').createApp module

## ROUTES ##

start = +new Date()

get '/', (page, model) ->
  model.setNull 'num_list', [{n: 1}, {n: 2}]
  model.fn '_reactive_list', 'num_list', (num_list) ->
    ({n: item.n * 2} for item in num_list)
  model.fn '_reactive_num', 'num_list', (num_list) ->
    sum = 0
    sum += item.n for item in num_list
    sum

  page.render 'index'


## CONTROLLER FUNCTIONS ##

ready (model) ->
  exports.increment = ->
    newList = ({n: item.n + 1} for item in model.get 'num_list')
    console.log 'incremented num_list', newList
    console.log 'previous _reactive_list', model.get '_reactive_list'
    model.set 'num_list', newList
