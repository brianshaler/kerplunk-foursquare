#userToIdentity
PLATFORM = 'foursquare'

module.exports = (user) ->
  names = []
  names.push user.firstName if user.firstName?
  names.push user.lastName if user.lastName?
  displayName = names.join ' '

  userName = displayName

  userPhoto = user.photo
  if userPhoto and userPhoto.prefix and userPhoto.suffix
    userPhoto = "#{userPhoto.prefix}500x500#{userPhoto.suffix}"

  user.nickName = displayName
  user.fullName = displayName
  user.profileUrl = "https://foursquare.com/user/#{user.id}"
  user.platformId = String user.id

  guid: ["#{PLATFORM}-#{user.id}"]
  platform: [PLATFORM]
  # platformId: user.id
  firstName: user.firstName
  lastName: user.lastName
  nickName: user.nickName
  photo: if userPhoto then [{url: userPhoto}] else []
  data:
    foursquare: user
