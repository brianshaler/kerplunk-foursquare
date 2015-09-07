_ = require 'lodash'
React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    #Avatar = @props.getComponent 'kerplunk-stream:avatar'
    photo = @props.settings?.foursquare?.user?.photo
    DOM.section
      className: 'content admin-panel'
    ,
      DOM.p null,
        'We will now authenticate your user account to the app...'
      DOM.p null,
        DOM.a
          href: '/admin/foursquare/oauth'
        , 'Click here to authenticate'
      if @props.settings?.foursquare?.user
        DOM.div null,
          DOM.h4 null, 'Your account has been connected!'
          DOM.img
            src: "#{photo.prefix}500x500#{photo.suffix}"
            style:
              width: '64px'
              height: '64px'
      else
        null
