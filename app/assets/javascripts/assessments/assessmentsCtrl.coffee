'use strict'

angular.module('mainApp').controller 'AssessmentsCtrl', [
  'User'
  'Assessment'
  'Tournament'
  '$state'
  (User, Assessment, Tournament, $state) ->
    vm = this

    vm.participants = User.participants
    vm.tournament = Tournament.current
    vm.sortableOptions =
      handle: '.glyphicon-sort'

    vm.create = ->
      path = '/tournaments/' + $state.params.id + '/assessments'
      params = vm.participants.map (u) ->
        ratedUserId: u.id

      Assessment.$post(path, params).then ->
        $state.go('profile')

    vm

]
