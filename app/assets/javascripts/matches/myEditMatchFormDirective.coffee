'use strict'

angular.module('mainApp').directive 'myEditMatchForm', ->
    restrict: 'E'
    templateUrl: 'matches/editMatchForm.html'
    link: (scope, element, attrs, ctrl, transcludeFn) ->
      toggleForms = ->
        angular.element(document).find('#add_match_form, #edit_match_form').toggle()

      element.find('[type="cancel"]').on 'click', (e) ->
        e.preventDefault()
        toggleForms()

      element.find('#edit_match_form').on 'submit', ->
        scope.vm.update().then (data) ->
          scope.vm.matches[scope.vm.editedMatch.$index] = data
          toggleForms()
