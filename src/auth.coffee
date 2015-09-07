userToIdentity = require './util/userToIdentity'

module.exports = (System, getFoursquare) ->
  (req, res, next) ->
    unless req.query.code
      return next new Error 'no oauth code in query string'

    # get and apply accessToken
    System.getSettings()
    .then (settings) ->
      fsq = getFoursquare settings
      fsq.getAccessToken
        code: req.query.code
      .then (accessToken) ->
        settings.accessToken = accessToken
        settings
    # fetch foursquare user account
    .then (settings) ->
      # with accessToken now
      fsq = getFoursquare settings
      fsq.Users.getUser 'self'
      .catch (err) ->
        console.log 'getUser error', err?.stack ? err
        throw err
      .then (data) ->
        throw new Error "Couldn't find myself" unless data?.user
        settings.user = data.user
        # merge foursquare profile information
        # with the `me` Identity
        # by creating a placeholder identity and then `linking`
        me = System.getMe()
        identity = userToIdentity settings.user
        Promise.promise (resolve, reject) ->
          me.link identity, (err) ->
            return reject err if err
            resolve settings
    .then (settings) ->
      # console.log 'auth now has settings:', settings
      {accessToken, user} = settings
      if !accessToken? or !user?
        throw new Error 'Something went wrong'
      System.updateSettings
        $set:
          accessToken: accessToken
          user: user
    .then ->
      res.redirect '/admin/foursquare/connect'
    .catch (err) ->
      console.log 'error during foursquare auth'
      console.log err?.stack ? err
      next err
