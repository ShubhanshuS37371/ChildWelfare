vlocity.cardframework.registerModule.controller('npDetailValuesController', ['$scope', '$filter', function($scope,$filter) {
        // Your code goes here
        $scope.getTotalAmount = function(fieldData, obj)
        {
            var sum = 0;
            angular.forEach(fieldData,function(value){
                var objVal = $filter('getter')(obj, value);
                if(angular.isNumber(objVal))
                    sum += parseInt(objVal)
            });
            return sum;
        }
    
}]);