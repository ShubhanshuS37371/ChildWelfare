vlocity.cardframework.registerModule.controller('AlertController', ['$scope', function($scope) {
        $scope.showAlert = true
        $scope.alertEnabled = function(obj){
            //$scope.showAlert = !localStorage.getItem('dismissed:'+obj.Id);
            //console.log('is alert enabled ',$scope.showAlert);
        };
        // Your code goes here
        $scope.dismissAlert = function(obj){
            $scope.showAlert = false;
            console.log('dismiss alert ',$scope.showAlert);
            localStorage.setItem('dismissed:'+obj.Id,true);
        };
}]);