_ = require 'lodash'
processCheckins = require '../util/processCheckins'

module.exports = (System, getFoursquare) ->
  processor = processCheckins System
  (opt = {}) ->
    newest = -1
    oldest = -1
    System.getSettings()
    .then (settings) ->
      api = getFoursquare settings
      unless settings.user.id
        throw new Error 'who am i?'
      params =
        limit: parseInt opt.limit ? 100
        offset: parseInt opt.offset ? 0

      if opt.order == 'desc'
        oldest = settings.myOldest if settings.myOldest > 0
      else
        newest = settings.myNewest if settings.myNewest > 0
      if !opt.offset?
        params.beforeTimestamp = oldest unless oldest == -1
        params.afterTimestamp = newest unless newest == -1
      api.Users.getCheckins 'self', params
      .then (result) ->
        return [] unless result?.checkins?.items?.length > 0
        fsqMe = _.clone settings.user, true
        removes = [
          'photos'
          'scores'
          'todos'
          'requests'
          'following'
          'checkins'
          'mayorships'
          'badges'
          'lists'
          'tips'
          'friends'
        ]
        for prop in removes
          delete fsqMe[prop] if fsqMe[prop]?

        checkins = _.map result.checkins.items, (checkin) ->
          newest = checkin.createdAt if newest == -1 or checkin.createdAt > newest
          oldest = checkin.createdAt if oldest == -1 or checkin.createdAt < oldest
          checkin.user = fsqMe
          checkin

        $set = {}
        if oldest < settings.myOldest or !settings.myOldest or settings.myOldest == -1
          $set.myOldest = oldest
        else if newest > settings.myNewest or !settings.myNewest
          $set.myNewest = newest
        else
          # no need to update settings
          return checkins
        System.updateSettings
          $set: $set
        .then -> checkins
    .then processor
