angular.module('mainApp').factory 'Tournament', [
  'railsResourceFactory'
  (railsResourceFactory) ->
    Tournament = railsResourceFactory(
      url: '/tournaments',
      name: 'tournament')
    Tournament.beforeRequest (data) ->
      if data && data['users']
        data['user_ids'] = data['users'].map (u) ->
          u.id
        delete data['users']

    Tournament
]
