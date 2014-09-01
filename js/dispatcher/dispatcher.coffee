#
# * Copyright (c) 2014, Facebook, Inc.
# * All rights reserved.
# *
# * This source code is licensed under the BSD-style license found in the
# * LICENSE file in the root directory of this source tree. An additional grant
# * of patent rights can be found in the PATENTS file in the same directory.
# *
# * @providesModule Dispatcher
# * @typechecks
#

###*
Dispatcher is used to broadcast payloads to registered callbacks. This is
different from generic pub-sub systems in two ways:

1) Callbacks are not subscribed to particular events. Every payload is
dispatched to every registered callback.
2) Callbacks can be deferred in whole or part until other callbacks have
been executed.

For example, consider this hypothetical flight destination form, which
selects a default city when a country is selected:

var flightDispatcher = new Dispatcher();

// Keeps track of which country is selected
var CountryStore = {country: null};

// Keeps track of which city is selected
var CityStore = {city: null};

// Keeps track of the base flight price of the selected city
var FlightPriceStore = {price: null}

When a user changes the selected city, we dispatch the payload:

flightDispatcher.dispatch({
actionType: 'city-update',
selectedCity: 'paris'
});

This payload is digested by `CityStore`:

flightDispatcher.register(function(payload)) {
if (payload.actionType === 'city-update') {
CityStore.city = payload.selectedCity;
}
});

When the user selects a country, we dispatch the payload:

flightDispatcher.dispatch({
actionType: 'country-update',
selectedCountry: 'australia'
});

This payload is digested by both stores:

CountryStore.dispatchToken = flightDispatcher.register(function(payload) {
if (payload.actionType === 'country-update') {
CountryStore.country = payload.selectedCountry;
}
});

When the callback to update `CountryStore` is registered, we save a reference
to the returned token. Using this token with `waitFor()`, we can guarantee
that `CountryStore` is updated before the callback that updates `CityStore`
needs to query its data.

CityStore.dispatchToken = flightDispatcher.register(function(payload) {
if (payload.actionType === 'country-update') {
// `CountryStore.country` may not be updated.
flightDispatcher.waitFor([CountryStore.dispatchToken]);
// `CountryStore.country` is now guaranteed to be updated.

// Select the default city for the new country
CityStore.city = getDefaultCityForCountry(CountryStore.country);
}
});

The usage of `waitFor()` can be chained, for example:

FlightPriceStore.dispatchToken =
flightDispatcher.register(function(payload)) {
switch (payload.actionType) {
case 'country-update':
flightDispatcher.waitFor([CityStore.dispatchToken]);
FlightPriceStore.price =
getFlightPriceStore(CountryStore.country, CityStore.city);
break;

case 'city-update':
FlightPriceStore.price =
FlightPriceStore(CountryStore.country, CityStore.city);
break;
}
});

The `country-update` payload will be guaranteed to invoke the stores'
registered callbacks in order: `CountryStore`, `CityStore`, then
`FlightPriceStore`.
###
Dispatcher = ->
  "use strict"
  @$Dispatcher_callbacks = {}
  @$Dispatcher_isPending = {}
  @$Dispatcher_isHandled = {}
  @$Dispatcher_isDispatching = false
  @$Dispatcher_pendingPayload = null
  return
invariant = require("./invariant.coffee")
_lastID = 1
_prefix = "ID_"

###*
Registers a callback to be invoked with every dispatched payload. Returns
a token that can be used with `waitFor()`.

@param {function} callback
@return {string}
###
Dispatcher::register = (callback) ->
  "use strict"
  id = _prefix + _lastID++
  @$Dispatcher_callbacks[id] = callback
  id


###*
Removes a callback based on its token.

@param {string} id
###
Dispatcher::unregister = (id) ->
  "use strict"
  invariant @$Dispatcher_callbacks[id], "Dispatcher.unregister(...): `%s` does not map to a registered callback.", id
  delete @$Dispatcher_callbacks[id]

  return


###*
Waits for the callbacks specified to be invoked before continuing execution
of the current callback. This method should only be used by a callback in
response to a dispatched payload.

@param {array<string>} ids
###
Dispatcher::waitFor = (ids) ->
  "use strict"
  invariant @$Dispatcher_isDispatching, "Dispatcher.waitFor(...): Must be invoked while dispatching."
  ii = 0

  while ii < ids.length
    id = ids[ii]
    if @$Dispatcher_isPending[id]
      invariant @$Dispatcher_isHandled[id], "Dispatcher.waitFor(...): Circular dependency detected while " + "waiting for `%s`.", id
      continue
    invariant @$Dispatcher_callbacks[id], "Dispatcher.waitFor(...): `%s` does not map to a registered callback.", id
    @$Dispatcher_invokeCallback id
    ii++
  return


###*
Dispatches a payload to all registered callbacks.

@param {object} payload
###
Dispatcher::dispatch = (payload) ->
  "use strict"
  invariant not @$Dispatcher_isDispatching, "Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch."
  @$Dispatcher_startDispatching payload
  try
    for id of @$Dispatcher_callbacks
      continue  if @$Dispatcher_isPending[id]
      @$Dispatcher_invokeCallback id
  finally
    @$Dispatcher_stopDispatching()
  return


###*
Is this Dispatcher currently dispatching.

@return {boolean}
###
Dispatcher::isDispatching = ->
  "use strict"
  @$Dispatcher_isDispatching


###*
Call the calback stored with the given id. Also do some internal
bookkeeping.

@param {string} id
@internal
###
Dispatcher::$Dispatcher_invokeCallback = (id) ->
  "use strict"
  @$Dispatcher_isPending[id] = true
  @$Dispatcher_callbacks[id] @$Dispatcher_pendingPayload
  @$Dispatcher_isHandled[id] = true
  return


###*
Set up bookkeeping needed when dispatching.

@param {object} payload
@internal
###
Dispatcher::$Dispatcher_startDispatching = (payload) ->
  "use strict"
  for id of @$Dispatcher_callbacks
    @$Dispatcher_isPending[id] = false
    @$Dispatcher_isHandled[id] = false
  @$Dispatcher_pendingPayload = payload
  @$Dispatcher_isDispatching = true
  return


###*
Clear bookkeeping used for dispatching.

@internal
###
Dispatcher::$Dispatcher_stopDispatching = ->
  "use strict"
  @$Dispatcher_pendingPayload = null
  @$Dispatcher_isDispatching = false
  return

module.exports = Dispatcher

