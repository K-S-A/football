'use strict'

angular.module('mainApp').directive 'myDeleteRoundTeam', [
  'Round'
  '$window'
  (Round, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        if $window.confirm('Remove team?')
          scope.vm.round.removeTeam(scope.team.id)

]
