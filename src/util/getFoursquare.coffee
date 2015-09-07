_ = require 'lodash'
foursquareApi = require 'node-foursquare'
Promisify = require('when/node').lift

module.exports = (System) ->
  fsqKey = null
  fsqCache = null

  (settings) ->
    promiseWithToken = (fn) ->
      # fn([args...], token, callback)
      ->
        args = []
        for arg in arguments
          args.push arg
        args.push settings.accessToken
        Promisify(fn).apply null, args

    key = [
      settings.clientId
      settings.clientSecret
      settings.callbackUrl
      settings.accessToken
    ].join ','
    return fsqCache if fsqKey == key
    fsqKey = key
    opt =
      secrets:
        clientId: settings.clientId ? ''
        clientSecret: settings.clientSecret ? ''
        redirectUrl: settings.callbackUrl ? ''
      foursquare:
        version: '20150101'
    api = foursquareApi opt

    fsqCache =
      api: api
      Checkins:
        getRecentCheckins: promiseWithToken api.Checkins.getRecentCheckins
      Users:
        getCheckins: promiseWithToken api.Users.getCheckins
        getUser: promiseWithToken api.Users.getUser
      getAccessToken: Promisify api.getAccessToken
      getAuthClientRedirectUrl: api.getAuthClientRedirectUrl
