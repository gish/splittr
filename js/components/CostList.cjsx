React = require 'react'

CostList = React.createClass
  render: ->
    costs = []
    for participant in @props.participants
      name = participant.name
      for cost in participant.costs
        key = "#{name}-#{cost.type}"
        costs.push (
          <tr key={key}>
            <td>{name}</td>
            <td>{cost.type}</td>
            <td>{cost.sum}</td>
          </tr>
        )
    (
      <table>
        <thead>
          <tr>
            <th>Deltagare</th>
            <th>Typ</th>
            <th>Summa</th>
          </tr>
        </thead>
        <tbody>
          {costs}
        </tbody>
      </table>
    )

module.exports = CostList

