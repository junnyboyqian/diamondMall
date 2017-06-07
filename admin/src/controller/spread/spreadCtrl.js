var module = angular.module('spreadCtrl', ['spreadService', 'filter'])

module.controller('articleCateListCtrl', function ($scope, spreadData) {

    spreadData.getArticleCateList(0,20);
    $scope.articleCateList = spreadData.articleCateList;
    console.log('articleCateListCtrl', $scope.articleCateList)
});
module.controller('addArticleCateCtrl', function ($scope, spreadData) {

    $scope.formData = {};
    $scope.formData.type = '1';

    $scope.submitForm = function () {
        console.log('submitData',$scope.formData)
        spreadData.addArticleCate($scope.formData)
    }

});
module.controller('articleListCtrl', function ($scope, spreadData) {
    $scope.articleList = spreadData.getArticleList(0,20);
    console.log($scope.articleList)

});
