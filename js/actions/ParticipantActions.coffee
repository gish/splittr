AppDispatcher = require '../dispatcher/AppDispatcher.coffee'
ParticipantConstants = require '../constants/ParticipantConstants.coffee'

ParticipantActions =
  add: (name) ->
    AppDispatcher.handleViewAction
      type: ParticipantConstants.ADD_PARTICIPANT
      name: name

  addCost: (data) ->
    AppDispatcher.handleViewAction
      type: ParticipantConstants.ADD_COST
      data: data

module.exports = ParticipantActions
