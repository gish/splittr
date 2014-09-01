React = require 'react'
ParticipantStore = require '../stores/ParticipantStore.coffee'
ParticipantForm = require './ParticipantForm.cjsx'
ParticipantList = require './ParticipantList.cjsx'

getState = ->
  participants: ParticipantStore.getAll()

Participants = React.createClass
  getInitialState: ->
    getState()

  componentDidMount: ->
    ParticipantStore.addChangeListener => @_onChange()

  render: ->
    participants = @state.participants
    (
      <div>
        <h1>Deltagare</h1>
        <ParticipantForm />
        <ParticipantList participants={participants} />
      </div>
    )

  _onChange: ->
    @setState getState()


module.exports = Participants
