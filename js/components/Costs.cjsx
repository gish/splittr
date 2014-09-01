React = require 'React'
ParticipantStore = require '../stores/ParticipantStore.coffee'
CostForm = require './CostForm.cjsx'
CostList = require './CostList.cjsx'

getState = ->
  participants: ParticipantStore.getAll()

Costs = React.createClass
  getInitialState: ->
    getState()

  componentDidMount: ->
    ParticipantStore.addChangeListener => @_onChange()

  render: ->
    participants = @state.participants
    (
      <div>
        <h1>Kostnader</h1>
        <CostForm participants={participants} />
        <CostList participants={participants} />
      </div>
    )

  _onChange: ->
    @setState getState()


module.exports = Costs
