React = require 'react'
Participants = require './components/Participants.cjsx'
Debts = require './components/Debts.cjsx'
Costs = require './components/Costs.cjsx'

React.renderComponent (
    <div>
      <Participants />
      <Costs />
      <Debts />
    </div>
  ),
  document.getElementById 'app'
