Promise = require 'when'

checkinToActivityItem = require './checkinToActivityItem'
userToIdentity = require './userToIdentity'

module.exports = (System) ->
  ActivityItem = System.getModel 'ActivityItem'
  Identity = System.getModel 'Identity'

  createActivityItem = (data) ->
    Promise.promise (resolve, reject) ->
      ActivityItem.getOrCreate data, (err, item, identity) ->
        return reject err if err
        resolve
          item: item
          identity: identity

  (checkin) ->
    if checkin.type != 'checkin' or !checkin.venue?.name?
      # ignore non-checkins..
      return Promise.resolve()

    data =
      identity: userToIdentity checkin.user
      item: checkinToActivityItem checkin

    createActivityItem data
    .then (result) ->
      {item, identity} = result

      identity.attributes = {} unless identity.attributes?
      identity.attributes.isFriend = true
      identity.updatedAt = new Date()

      photoFound = false
      userPhoto = data.identity.photo?[0]?.url
      identity.photo.forEach (photo) ->
        if photo?.url == userPhoto
          photoFound = true
      if !photoFound and userPhoto?.length > 0
        identity.photo.push url: userPhoto
      identity.markModified 'attributes'

      Promise identity.save()
      .then ->
        item: item
        identity: identity
    # .then (result) ->
    #   addCharacteristics result.item, result.identity, checkin
    .then ({item, identity}) ->
      item.attributes = {} unless item.attributes?
      item.attributes.isFriend = identity.attributes.isFriend
      item.markModified 'attributes'

      System.do 'activityItem.save', item
      .then ->
        item: item
        identity: identity
