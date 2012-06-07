require 'test_helper'

class UserPositionMetricPointsControllerTest < ActionController::TestCase
  setup do
    @user_position_metric_point = user_position_metric_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_position_metric_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_position_metric_point" do
    assert_difference('UserPositionMetricPoint.count') do
      post :create, user_position_metric_point: @user_position_metric_point.attributes
    end

    assert_redirected_to user_position_metric_point_path(assigns(:user_position_metric_point))
  end

  test "should show user_position_metric_point" do
    get :show, id: @user_position_metric_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_position_metric_point
    assert_response :success
  end

  test "should update user_position_metric_point" do
    put :update, id: @user_position_metric_point, user_position_metric_point: @user_position_metric_point.attributes
    assert_redirected_to user_position_metric_point_path(assigns(:user_position_metric_point))
  end

  test "should destroy user_position_metric_point" do
    assert_difference('UserPositionMetricPoint.count', -1) do
      delete :destroy, id: @user_position_metric_point
    end

    assert_redirected_to user_position_metric_points_path
  end
end
