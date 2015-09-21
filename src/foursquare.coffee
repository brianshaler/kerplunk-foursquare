_ = require 'lodash'

globals = require './globals'

# handlers
auth = require './auth'
oauth = require './oauth'
setupApp = require './setupApp'
setupConnect = require './setupConnect'
GetFoursquare = require './util/getFoursquare'

getCheckins = require './api/getCheckins'
getMyCheckins = require './api/getMyCheckins'

module.exports = (System) ->
  getFoursquare = GetFoursquare System
  API =
    getCheckins: getCheckins System, getFoursquare
    getMyCheckins: getMyCheckins System, getFoursquare

  routes:
    admin:
      '/admin/foursquare': 'setupApp'
      '/admin/foursquare/oauth': 'oauth'
      '/admin/foursquare/auth': 'auth'
      '/admin/foursquare/api/history': 'myCheckins'
      '/admin/foursquare/timeline': 'timeline'
      '/admin/foursquare/app': 'setupApp'
      '/admin/foursquare/connect': 'setupConnect'

  handlers:
    oauth: oauth System, getFoursquare
    auth: auth System, getFoursquare
    setupApp: setupApp System
    setupConnect: setupConnect System

    myCheckins: (req, res, next) ->
      API.getMyCheckins req.query
      .then (items) ->
        res.send
          items: items
      .catch (err) ->
        next err
    timeline: (req, res, next) ->
      API.getCheckins()
      .then (items) ->
        res.send
          count: items.length
      .catch (err) ->
        console.log err.stack ? err
        next err

  methods:
    getMyCheckins: API.getMyCheckins
    getCheckins: API.getCheckins
    getUser: ->
      System.getSettings()
      .then (settings) ->
        settings?.user

  globals: _.clone globals, true

  jobs:
    getCheckins:
      frequency: 600 # 120
      task: (finished) ->
        API.getCheckins()
    getMyCheckins:
      frequency: 36000
      task: (finished) ->
        opt =
          order: "asc"
        API.getMyCheckins opt
