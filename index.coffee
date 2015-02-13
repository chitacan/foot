app = angular.module 'footApp', []

app.config ($httpProvider) ->
  delete $httpProvider.defaults.headers.common['X-Requested-With'];

app.controller 'audioCtrl', ($scope, program, _) ->
  program.sync().then (res) ->
    console.log res
    list     = res.list.data.results.collection1.message
    resource = res.info.data.results.resources

    $scope.programs = _.map list, (v, k) -> _.extend v, resource[k]
  .catch (e) ->
    console.error e

  $scope.onClickList = (program) -> 
    if program.status == 4
      this.player.load program.url
      this.player.play()

  audiojs.events.ready () ->
    p = audiojs.createAll()
    $scope.player= p[0]
    p[0].element.addEventListener 'pause',   () -> console.log 'paused'
    p[0].element.addEventListener 'play',    () -> console.log 'play'
    p[0].element.addEventListener 'error',   () -> console.log 'error'
    p[0].element.addEventListener 'suspend', () -> console.log 'suspend'

app.service 'program', ($http, $q) ->
  this.list = () ->
    req =
      method : 'GET'
      url    : 'https://www.kimonolabs.com/api/3kplvmje'
      params :
        apikey    : 'YmPUBuAN7hpEa3LbfEsA5zAgdEs0qcuW'
        kimmodify : '1'
    $http req

  this.info = () ->
    req =
      method : 'GET'
      url    : 'https://www.kimonolabs.com/api/ciqlk7me'
      params :
        apikey    : 'YmPUBuAN7hpEa3LbfEsA5zAgdEs0qcuW'
    $http req

  this.sync = () ->
    $q.all { list : this.list(), info : this.info() }

  this

app.factory '_', () -> window._
app.filter 'trusted', ($sce) -> (url) -> $sce.trustAsResourceUrl url
