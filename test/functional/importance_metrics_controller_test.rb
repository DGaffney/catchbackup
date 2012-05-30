require 'test_helper'

class ImportanceMetricsControllerTest < ActionController::TestCase
  setup do
    @importance_metric = importance_metrics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:importance_metrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create importance_metric" do
    assert_difference('ImportanceMetric.count') do
      post :create, importance_metric: @importance_metric.attributes
    end

    assert_redirected_to importance_metric_path(assigns(:importance_metric))
  end

  test "should show importance_metric" do
    get :show, id: @importance_metric
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @importance_metric
    assert_response :success
  end

  test "should update importance_metric" do
    put :update, id: @importance_metric, importance_metric: @importance_metric.attributes
    assert_redirected_to importance_metric_path(assigns(:importance_metric))
  end

  test "should destroy importance_metric" do
    assert_difference('ImportanceMetric.count', -1) do
      delete :destroy, id: @importance_metric
    end

    assert_redirected_to importance_metrics_path
  end
end
