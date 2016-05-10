'use strict'

angular.module('mainApp').directive 'myParticipate', [
  'Tournament'
  'Auth'
  (Tournament, Auth) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      checkState = (newVal, oldVal) ->
        if !scope.tournament.isOpen() || !Auth.isAuthenticated() || scope.tournament.includeUser(Auth._currentUser)
          element.hide()
        else
          element.show()

      scope.$watchGroup(['tournament.status', (-> Auth._currentUser)], checkState)

      element.on 'click', ->
        Tournament.$post('/tournaments/' + scope.tournament.id + '/join').then (data) ->
          scope.tournament.users.push(Auth._currentUser)
          element.hide()

]
