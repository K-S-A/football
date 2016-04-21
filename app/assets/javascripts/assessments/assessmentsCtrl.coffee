'use strict'

angular.module('mainApp').controller 'AssessmentsCtrl', [
  'User'
  'Assessment'
  '$state'
  (User, Assessment, $state) ->
    vm = this

    vm.participants = User.participants

    vm.create = ->
      path = '/tournaments/' + $state.params.id + '/assessments'
      params = vm.participants.map (u) ->
        ratedUserId: u.id

      Assessment.$post(path, params).then ->
        $state.go('profile')

    vm

]
