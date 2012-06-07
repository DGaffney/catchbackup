require 'test_helper'

class UserPositionMetricsControllerTest < ActionController::TestCase
  setup do
    @user_position_metric = user_position_metrics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_position_metrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_position_metric" do
    assert_difference('UserPositionMetric.count') do
      post :create, user_position_metric: @user_position_metric.attributes
    end

    assert_redirected_to user_position_metric_path(assigns(:user_position_metric))
  end

  test "should show user_position_metric" do
    get :show, id: @user_position_metric
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_position_metric
    assert_response :success
  end

  test "should update user_position_metric" do
    put :update, id: @user_position_metric, user_position_metric: @user_position_metric.attributes
    assert_redirected_to user_position_metric_path(assigns(:user_position_metric))
  end

  test "should destroy user_position_metric" do
    assert_difference('UserPositionMetric.count', -1) do
      delete :destroy, id: @user_position_metric
    end

    assert_redirected_to user_position_metrics_path
  end
end
