'use strict'

angular.module('mainApp').factory 'Tournament', [
  'railsResourceFactory'
  'railsSerializer'
  (railsResourceFactory, railsSerializer) ->
    Tournament = railsResourceFactory(
      url: '/tournaments'
      name: 'tournament'
      serializer: railsSerializer ->
        @only 'id', 'name', 'status', 'sportsKind', 'teamSize', 'users', 'userIds'
        @resource 'teams', 'Team')

    Tournament.perPage = 20
    Tournament.loading = false

    Tournament.beforeRequest (data) ->
      if data && data['users']
        data['user_ids'] = data['users'].map (u) ->
          u.id
        delete data['users']
        data

    Tournament.getUnrated = (user_id) ->
      Tournament.query(userId: user_id, status: 'completed').then (data) ->
        Tournament.unrated = data

    Tournament.prototype.toTitle = ->
      '"' + @name + '" (' + @teamSize + 'x' + @teamSize + ' ' + @sportsKind + ')'

    Tournament.prototype.isOpen = ->
      ['not started', 'in progress'].indexOf(@status) > -1

    Tournament.prototype.includeUser = (user) ->
      @users.some (u) ->
        u.id is user.id

    Tournament.removeParticipant = (user_id) ->
      path = '/tournaments/' + Tournament.current.id + '/users/' + user_id

      Tournament.$delete(path)

    Tournament.nextPage = ->
      Tournament.loading = true
      page_num = Math.floor(Tournament.all.length / Tournament.perPage) + 1

      Tournament.query(page: page_num).then (data) ->
        indexes = Tournament.all.map (t) ->
          t.id

        data.forEach (t) ->
          Tournament.all.push(t) unless indexes.includes(t.id)

    Tournament
]
