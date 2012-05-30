require 'test_helper'

class ImportanceMetricPointsControllerTest < ActionController::TestCase
  setup do
    @importance_metric_point = importance_metric_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:importance_metric_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create importance_metric_point" do
    assert_difference('ImportanceMetricPoint.count') do
      post :create, importance_metric_point: @importance_metric_point.attributes
    end

    assert_redirected_to importance_metric_point_path(assigns(:importance_metric_point))
  end

  test "should show importance_metric_point" do
    get :show, id: @importance_metric_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @importance_metric_point
    assert_response :success
  end

  test "should update importance_metric_point" do
    put :update, id: @importance_metric_point, importance_metric_point: @importance_metric_point.attributes
    assert_redirected_to importance_metric_point_path(assigns(:importance_metric_point))
  end

  test "should destroy importance_metric_point" do
    assert_difference('ImportanceMetricPoint.count', -1) do
      delete :destroy, id: @importance_metric_point
    end

    assert_redirected_to importance_metric_points_path
  end
end
