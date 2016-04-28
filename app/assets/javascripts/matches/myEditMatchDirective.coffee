'use strict'

angular.module('mainApp').directive 'myEditMatch', [
  'Match'
  'Round'
  (Match, Round) ->
    restrict: 'A'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      element.on 'click', ->
        match = angular.copy(scope.match)
        match.$index = scope.$index

        scope.$apply ->
          scope.vm.editedMatch = match

        angular.element(document).find('#add_match_form').hide()
        angular.element(document).find('#edit_match_form').removeClass('hidden').show()
        angular.element(document).find('#edit_match_form input:first').focus()

]
