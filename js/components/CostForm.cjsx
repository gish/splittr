React = require 'react'
ParticipantActions = require '../actions/ParticipantActions.coffee'

getState = ->
  name: ''
  type: ''
  sum: 0


CostForm = React.createClass
  getInitialState: ->
    getState()

  render: ->
    participants = []
    for participant in @props.participants
      name = participant.name
      participants.push (<option key={name}>{name}</option>)
    (
      <form onSubmit={@_onSubmit}>
        <label>
          Deltagare
          <select ref="name" onChange={@_onParticipantChange}>
            {participants}
          </select>
        </label>
        <label>
          Typ
          <input type="text" key="type" value={@state.type} onChange={@_onTypeChange} />
        </label>
        <label>
          Summa
          <input type="num" key="cost" value={@state.sum} onChange={@_onSumChange} />
        </label>
        <input type="submit" />
      </form>
    )

  _onAdd: ->
    @setState getState()

  _onSubmit: (e) ->
    e.preventDefault()
    name = @refs.name.getDOMNode().value
    ParticipantActions.addCost
      name: name
      type: @state.type
      sum: parseInt @state.sum, 10

  _onTypeChange: (e) ->
    @setState type: e.target.value

  _onSumChange: (e) ->
    @setState sum: e.target.value


module.exports = CostForm
