require 'test_helper'

class PositionMetricsControllerTest < ActionController::TestCase
  setup do
    @position_metric = position_metrics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:position_metrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create position_metric" do
    assert_difference('PositionMetric.count') do
      post :create, position_metric: @position_metric.attributes
    end

    assert_redirected_to position_metric_path(assigns(:position_metric))
  end

  test "should show position_metric" do
    get :show, id: @position_metric
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @position_metric
    assert_response :success
  end

  test "should update position_metric" do
    put :update, id: @position_metric, position_metric: @position_metric.attributes
    assert_redirected_to position_metric_path(assigns(:position_metric))
  end

  test "should destroy position_metric" do
    assert_difference('PositionMetric.count', -1) do
      delete :destroy, id: @position_metric
    end

    assert_redirected_to position_metrics_path
  end
end
