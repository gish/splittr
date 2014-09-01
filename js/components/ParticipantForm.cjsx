React = require 'react'
ParticipantActions = require '../actions/ParticipantActions.coffee'
ParticipantStore = require '../stores/ParticipantStore.coffee'

ParticipantForm = React.createClass
  getInitialState: ->
    name: ''

  componentDidMount: ->
    ParticipantStore.addChangeListener => @_onAdd()

  render: ->
    (
      <form
        onSubmit={@_onSubmit}
      >
        <label>
          Deltagare
          <input
            ref="name"
            type="text"
            placeholder="John Doe"
            value={@state.value}
            onChange={@_onChange}
          />
        </label>
        <input type="submit" />
      </form>
    )


  _onSubmit: (e) ->
    e.preventDefault()
    ParticipantActions.add @state.name

  _onChange: (e) ->
    @setState
      name: e.target.value

  _onAdd: ->
    @setState
      name: ''


module.exports = ParticipantForm
