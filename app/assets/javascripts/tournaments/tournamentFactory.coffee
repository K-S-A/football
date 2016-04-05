angular.module('mainApp').factory 'Tournament', [
  'railsResourceFactory'
  (railsResourceFactory) ->
    railsResourceFactory(
      url: '/tournaments',
      name: 'tournament')
]
