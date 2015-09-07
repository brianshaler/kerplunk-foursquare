module.exports = (System) ->
  (req, res, next) ->
    System.getSettings()
    .done (settings) ->
      if req?.body?.settings?.foursquare
        # Process form
        $set = {}
        updated = false
        for k, v of req.body.settings.foursquare
          $set[k] = v
          updated = true
        if updated
          System.updateSettings
            $set: $set
          .then ->
            # Done with this step. Continue!
            res.redirect "/admin/foursquare/connect"
          return
      # Show the page for this step
      res.render 'app',
        settings:
          foursquare: settings
        title: 'Foursquare App Settings'
    , (err) ->
      next err
