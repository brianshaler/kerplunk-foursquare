React = require 'react'

{DOM} = React

module.exports = React.createFactory React.createClass
  render: ->
    DOM.section
      className: 'content admin-panel'
    ,
      DOM.h1 null, 'Foursquare Configuration'
      DOM.p null,
        'Copy the details from your Foursquare App, which you can find or create at '
        DOM.a
          href: 'https://foursquare.com/developers/apps'
          target: '_blank'
        , 'https://foursquare.com/developers/apps'
      DOM.p null,
        DOM.form
          method: 'post'
          action: '/admin/foursquare/app'
        ,
          DOM.table null,
            DOM.tr null,
              DOM.td null,
                DOM.strong null, 'Client ID:'
              DOM.td null,
                DOM.input
                  name: 'settings[foursquare][clientId]'
                  defaultValue: @props.settings?.foursquare?.clientId
            DOM.tr null,
              DOM.td null,
                DOM.strong null, 'Client Secret:'
              DOM.td null,
                DOM.input
                  name: 'settings[foursquare][clientSecret]'
                  defaultValue: @props.settings?.foursquare?.clientSecret
            DOM.tr null,
              DOM.td null,
                DOM.strong null, 'Callback URL:'
              DOM.td null,
                DOM.input
                  name: 'settings[foursquare][callbackUrl]'
                  defaultValue: @props.settings?.foursquare?.callbackUrl
            DOM.tr null,
              DOM.td null, ''
              DOM.td null,
                DOM.input
                  type: 'submit'
                  value: 'Save & Next'
