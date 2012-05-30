require 'test_helper'

class PositionMetricPointsControllerTest < ActionController::TestCase
  setup do
    @position_metric_point = position_metric_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:position_metric_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position_metric_point" do
    assert_difference('PositionMetricPoint.count') do
      post :create, position_metric_point: @position_metric_point.attributes
    end

    assert_redirected_to position_metric_point_path(assigns(:position_metric_point))
  end

  test "should show position_metric_point" do
    get :show, id: @position_metric_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @position_metric_point
    assert_response :success
  end

  test "should update position_metric_point" do
    put :update, id: @position_metric_point, position_metric_point: @position_metric_point.attributes
    assert_redirected_to position_metric_point_path(assigns(:position_metric_point))
  end

  test "should destroy position_metric_point" do
    assert_difference('PositionMetricPoint.count', -1) do
      delete :destroy, id: @position_metric_point
    end

    assert_redirected_to position_metric_points_path
  end
end
