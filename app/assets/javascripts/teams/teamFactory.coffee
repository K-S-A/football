'use strict'

angular.module('mainApp').factory 'Team', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    railsResourceFactory(
      url: '/teams'
      name: 'team'
      serializer: railsSerializer ->
        @only 'id', 'name', 'team_size')
]
