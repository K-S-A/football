'use strict'

angular.module('mainApp').directive 'myFinishVoting', [
  'Tournament'
  'Auth'
  '$window'
  (Tournament, Auth, $window) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      scope.$watch 'tournament.status', (newVal, _oldVal) ->
        if newVal == 'completed'
          element.show()
        else
          element.hide()

      element.on 'click', ->
        if $window.confirm('Close voting?')
          tournament = angular.copy(scope.tournament)
          tournament.status = 'closed'
          tournament.update().then (data) ->
            scope.tournament = data

            element.hide()

]
