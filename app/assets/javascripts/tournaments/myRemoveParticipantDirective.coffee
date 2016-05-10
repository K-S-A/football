'use strict'

angular.module('mainApp').directive 'myRemoveParticipant', [
  'Tournament'
  (Tournament) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        Tournament.removeParticipant(scope.participant.id).then ->
            Tournament.current.users.splice(scope.$index, 1)

]
