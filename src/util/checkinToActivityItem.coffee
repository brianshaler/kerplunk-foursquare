#checkinToActivityItem
PLATFORM = 'foursquare'

module.exports = (checkin) ->
  lat = 0
  lng = 0
  if checkin.venue?.location?.lat && checkin.venue.location.lng
    lat = parseFloat checkin.venue.location.lat
    lng = parseFloat checkin.venue.location.lng

  media = []
  if checkin.photos?.count > 0 and checkin.photos.items?.length > 0
    checkin.photos.items.forEach (photo) ->
      aspect = if photo.width and photo.height
        photo.width / photo.height
      else
        1
      image =
        type: "photo"
        sizes: []
      image.sizes.push
        url: "#{photo.prefix}original#{photo.suffix}"
        width: photo.width ? 1024
        height: photo.height ? 1024
      if aspect != 1
        sizes = [256, 512, 1024]
        for size in sizes
          image.sizes.push
            url: "#{photo.prefix}cap#{size}#{photo.suffix}"
            width: if aspect > 1 then size else size * aspect
            height: if aspect < 1 then size else size / aspect
      image.sizes.push
        url: "#{photo.prefix}500x500#{photo.suffix}"
        width: 500
        height: 500
      image.sizes.push
        url: "#{photo.prefix}300x300#{photo.suffix}"
        width: 300
        height: 300
      image.sizes.push
        url: "#{photo.prefix}100x100#{photo.suffix}"
        width: 100
        height: 100
      if image.sizes.length > 0
        media.push image

  guid: "#{PLATFORM}-#{checkin.id}"
  platform: PLATFORM
  attributes: {}
  message: if checkin.shout?.length > 0
    "#{checkin.shout} @ #{checkin.venue.name}"
  else
    "I'm at #{checkin.venue.name}"
  postedAt: new Date checkin.createdAt * 1000
  media: media if media.length > 0
  location: ([lng, lat] if lng? and lat? and (lng != 0 or lat != 0))
  data: checkin
