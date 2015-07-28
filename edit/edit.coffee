angular.module('app').controller('EditCtrl',['$scope','$http','$routeParams', ($scope,$http,$routeParams) ->
  $scope.active = {subject:''}
  if /cli/i.test $routeParams.tech
      $scope.url = 'clis'
  else if /python/i.test $routeParams.tech
    $scope.url = 'pythons'
  $scope.getExercises = () ->
    if localStorage[$scope.url]!= undefined
      $scope.subjects = JSON.parse(localStorage[$scope.url])
    else 
      $scope.resetExercises()
  $('#single_clippy').clippy({text: localStorage[$routeParams.tech]})

  $scope.setCur = (x,m) ->
    $scope.editX = x
    $scope.editX.module = m.name
    $scope.editX.subject = $scope.active.subject.name
    $scope.curX = JSON.parse(JSON.stringify($scope.editX))
    $scope.curX.subject = _.findWhere($scope.subjects,{name:$scope.editX.subject})
  $scope.val = (it) ->
    try
      new RegExp('^'+it.check+'$').test(it.sample)
    catch e
  $scope.save = (state) ->
    $scope.state = state

  $scope.update = ->
    saveX = JSON.parse JSON.stringify $scope.curX
    delete saveX.subject
    delete saveX.module
    if !(curSubj = _.findWhere($scope.subjects,{name:$scope.curX.subject.name}))
      $scope.subjects.push {name:$scope.curX.subject.name,modules:[]}
    if !(curMod = _.findWhere(curSubj.modules,{name:$scope.curX.module}))
      curSubj.modules.push(curMod = {exercises:[],name:$scope.curX.module})
    if $scope.state == 'create'
      curMod.exercises.push(saveX)
      alert('created')
    else
      if $scope.editX.module != $scope.curX.module
        $scope.remove $scope.editX
        $scope.state = 'create'
        $scope.update()
        $scope.state = 'edit'
        return
      $scope.editX.sample    = $scope.curX.sample
      $scope.editX.challenge = $scope.curX.challenge
      $scope.editX.check     = $scope.curX.check
      $scope.editX.output    = $scope.curX.output
    $scope.updateLocalStorage()

  $scope.remove = (exercise,module) ->
    module.exercises.splice(module.exercises.indexOf(exercise),1)
    $scope.updateLocalStorage()
  
  $scope.updateLocalStorage = () ->
    $scope.subjects.forEach((curSubj) ->
      curSubj.modules.forEach((curMod, idx) ->
        if curMod.exercises.length == 0
          curSubj.modules.splice(idx,1)
      )
    )
    localStorage[$scope.url] = angular.toJson  $scope.subjects
    $('#single_clippy').clippy({text: localStorage[$scope.url]})
  
  $scope.resetExercises = () ->
    $http.get("/#{$scope.url}.json")
      .success (data)->
        $scope.subjects = data
        $scope.updateLocalStorage()
        
  $scope.focus = 'exercises'
  $scope.toggleFocus = ->
    if $scope.focus == 'modules'
      $scope.focus = 'exercises'
    else $scope.focus = 'modules'
  
  # drag and drop handlers
  $scope.dragModuleFn = (module,dragSub) -> 
    $scope.dragModule = module
    $scope.dragModuleSubject = dragSub
  $scope.dropModuleFn = (module,dropSub) ->
    dragSub = $scope.dragModuleSubject
    dragSub.splice(dragSub.indexOf($scope.dragModule),1)
    dropSub.splice(dropSub.indexOf(module),0,$scope.dragModule)
  $scope.addSubject = (subjectName) ->
    $scope.subjects.push {name:subjectName,modules: []}
  $scope.addModuleToSubject = (dropSub) ->
    dragSub = $scope.dragModuleSubject
    dragSub.splice(dragSub.indexOf($scope.dragModule),1)
    dropSub.push $scope.dragModule
])
