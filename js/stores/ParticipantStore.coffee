AppDispatcher = require '../dispatcher/AppDispatcher.coffee'
ParticipantConstants = require '../constants/ParticipantConstants.coffee'
EventEmitter = require('events').EventEmitter
merge = require 'react/lib/merge'

CHANGE_EVENT = 'ParticipantStoreChange'

_participants = [
  name: 'John Doe'
  costs: [
    type: 'Middag'
    sum: 100
  ]
,
  name: 'Jane Doe'
  costs: [
    type: 'Dessert'
    sum: 200
  ]
]

add = (name) ->
  participant =
    name: name
    costs: []
  _participants.push participant

addCost = (data) ->
  for participant in _participants
    if participant.name is data.name
      participant.costs.push
        type: data.type
        sum: data.sum


AppDispatcher.register (payload) ->
  action = payload.action
  switch action.type
    when ParticipantConstants.ADD_PARTICIPANT then add action.name
    when ParticipantConstants.ADD_COST then addCost action.data

  ParticipantStore.emitChange()
  true


ParticipantStore = merge EventEmitter::,
  getAll: ->
    _participants

  emitChange: ->
    @emit CHANGE_EVENT

  addChangeListener: (callback) ->
    @on CHANGE_EVENT, callback


module.exports = ParticipantStore
