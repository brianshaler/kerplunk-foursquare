processCheckins = require '../util/processCheckins'

module.exports = (System, getFoursquare) ->
  processor = processCheckins System
  getCheckins = ->
    System.getSettings()
    .then (settings) ->
      api = getFoursquare settings
      params =
        limit: 100
      if settings.timelineAfterTimestamp?
        params.afterTimestamp = settings.timelineAfterTimestamp
      api.Checkins.getRecentCheckins params
      .then (result) ->
        return [] unless result?.recent?.length > 0
        checkins = result.recent
        System.updateSettings
          $set:
            timelineAfterTimestamp: checkins[0].createdAt
        .then -> checkins
    .then processor
