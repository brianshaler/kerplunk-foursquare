_ = require 'lodash'
Promise = require 'when'

processCheckin = require './processCheckin'

module.exports = (System) ->
  pc = processCheckin System
  (checkins = []) ->
    promise = Promise()
    items = []
    for checkin in checkins
      do (checkin) ->
        promise = promise.then ->
          pc checkin
        .then (result) ->
          items.push result.item if result?.item
        .catch (err) ->
          console.log 'failed to process an item', checkin
    promise.then -> items
