'use strict'

angular.module('mainApp').directive 'myFillTeams', ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        scope.$apply ->
          scope.vm.match.hostTeamId = scope.hostTeam.id
          scope.vm.match.guestTeamId = scope.guestTeam.id

        angular.element(document).find('#add_match_form input:first').focus()
