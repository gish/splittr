React = require 'react'

ParticipantList = React.createClass
  render: ->
    participants = []
    for participant in @props.participants
      participants.push (<li key={participant.name}>{participant.name}</li>)
    (
      <ul>
        {participants}
      </ul>
    )

module.exports = ParticipantList
