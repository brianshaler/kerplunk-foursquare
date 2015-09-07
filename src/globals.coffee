module.exports =
  public:
    nav:
      Admin:
        'Social Networks':
          Foursquare:
            'App Settings': '/admin/foursquare/app'
            'Connect Account': '/admin/foursquare/connect'
    editStreamConditionOptions:
      isFoursquareTrue:
        description: 'foursquare checkins only'
        where:
          platform: 'foursquare'
      isFoursquareFalse:
        description: 'no foursquare checkins'
        where:
          platform:
            $ne: 'foursquare'
    activityItem:
      icons:
        foursquare: '/plugins/kerplunk-foursquare/images/icon-36x36.png'
