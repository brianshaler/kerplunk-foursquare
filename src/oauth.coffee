module.exports = (System, getFoursquare) ->
  (req, res, next) ->
    System.getSettings()
    .then (settings) ->
      fsq = getFoursquare settings
      res.writeHead 303,
        location: fsq.getAuthClientRedirectUrl()
      res.end()
    .catch (err) ->
      next err
