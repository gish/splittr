React = require 'react'

DebtTable = React.createClass
  render: ->
    debts = []
    participants = @props.participants
    totalCosts = participants.reduce (memo, participant) =>
      memo + @_getParticipantCosts participant
    , 0
    debts = participants.map (participant) =>
      name = participant.name
      costs = @_getParticipantCosts participant
      balance = Math.round(costs - totalCosts/participants.length, 2)
      (
        <tr>
          <td>{name}</td>
          <td>{costs}</td>
          <td>{balance}</td>
        </tr>
      )

    (
      <table>
        <thead>
          <tr>
            <th>Deltagare</th>
            <th>Kostnader</th>
            <th>Balans</th>
          </tr>
        </thead>
        <tbody>
          {debts}
        </tbody>
      </table>
    )

  _getParticipantCosts: (participant) ->
    participant.costs.reduce (memo, cost) ->
      memo + cost.sum
    , 0


module.exports = DebtTable
