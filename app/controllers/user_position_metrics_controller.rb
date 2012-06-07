class UserPositionMetricsController < ApplicationController
  # GET /user_position_metrics
  # GET /user_position_metrics.json
  def index
    @user_position_metrics = UserPositionMetric.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_position_metrics }
    end
  end

  # GET /user_position_metrics/1
  # GET /user_position_metrics/1.json
  def show
    @user_position_metric = UserPositionMetric.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_position_metric }
    end
  end

  # GET /user_position_metrics/new
  # GET /user_position_metrics/new.json
  def new
    @user_position_metric = UserPositionMetric.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_position_metric }
    end
  end

  # GET /user_position_metrics/1/edit
  def edit
    @user_position_metric = UserPositionMetric.find(params[:id])
  end

  # POST /user_position_metrics
  # POST /user_position_metrics.json
  def create
    @user_position_metric = UserPositionMetric.new(params[:user_position_metric])

    respond_to do |format|
      if @user_position_metric.save
        format.html { redirect_to @user_position_metric, notice: 'User position metric was successfully created.' }
        format.json { render json: @user_position_metric, status: :created, location: @user_position_metric }
      else
        format.html { render action: "new" }
        format.json { render json: @user_position_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_position_metrics/1
  # PUT /user_position_metrics/1.json
  def update
    @user_position_metric = UserPositionMetric.find(params[:id])

    respond_to do |format|
      if @user_position_metric.update_attributes(params[:user_position_metric])
        format.html { redirect_to @user_position_metric, notice: 'User position metric was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_position_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_position_metrics/1
  # DELETE /user_position_metrics/1.json
  def destroy
    @user_position_metric = UserPositionMetric.find(params[:id])
    @user_position_metric.destroy

    respond_to do |format|
      format.html { redirect_to user_position_metrics_url }
      format.json { head :no_content }
    end
  end
end
