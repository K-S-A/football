'use strict'

angular.module('mainApp').directive 'myRemoveParticipant', [
  'Tournament'
  (Tournament) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        index = scope.$index
        userIds = Tournament.current.users.map (obj) ->
          obj.id

        userIds.splice(index, 1)

        Tournament.$patch(
          '/tournaments/' + Tournament.current.id
          userIds: userIds).then (data) ->
            Tournament.current.users = data.users
]
