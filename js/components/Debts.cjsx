React = require 'react'
ParticipantStore = require '../stores/ParticipantStore.coffee'
DebtTable = require './DebtTable.cjsx'

getState = ->
  participants: ParticipantStore.getAll()

Debts = React.createClass
  getInitialState: ->
    getState()

  componentDidMount: ->
    ParticipantStore.addChangeListener () => @_onChange()

  render: ->
    participants = @state.participants
    (
      <div>
        <h1>Skulder</h1>
        <DebtTable participants={participants} />
      </div>
    )

  _onChange: ->
    @setState getState()

module.exports = Debts
