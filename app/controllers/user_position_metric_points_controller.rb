class UserPositionMetricPointsController < ApplicationController
  # GET /user_position_metric_points
  # GET /user_position_metric_points.json
  def index
    @user_position_metric_points = UserPositionMetricPoint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_position_metric_points }
    end
  end

  # GET /user_position_metric_points/1
  # GET /user_position_metric_points/1.json
  def show
    @user_position_metric_point = UserPositionMetricPoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_position_metric_point }
    end
  end

  # GET /user_position_metric_points/new
  # GET /user_position_metric_points/new.json
  def new
    @user_position_metric_point = UserPositionMetricPoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_position_metric_point }
    end
  end

  # GET /user_position_metric_points/1/edit
  def edit
    @user_position_metric_point = UserPositionMetricPoint.find(params[:id])
  end

  # POST /user_position_metric_points
  # POST /user_position_metric_points.json
  def create
    @user_position_metric_point = UserPositionMetricPoint.new(params[:user_position_metric_point])

    respond_to do |format|
      if @user_position_metric_point.save
        format.html { redirect_to @user_position_metric_point, notice: 'User position metric point was successfully created.' }
        format.json { render json: @user_position_metric_point, status: :created, location: @user_position_metric_point }
      else
        format.html { render action: "new" }
        format.json { render json: @user_position_metric_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_position_metric_points/1
  # PUT /user_position_metric_points/1.json
  def update
    @user_position_metric_point = UserPositionMetricPoint.find(params[:id])

    respond_to do |format|
      if @user_position_metric_point.update_attributes(params[:user_position_metric_point])
        format.html { redirect_to @user_position_metric_point, notice: 'User position metric point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_position_metric_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_position_metric_points/1
  # DELETE /user_position_metric_points/1.json
  def destroy
    @user_position_metric_point = UserPositionMetricPoint.find(params[:id])
    @user_position_metric_point.destroy

    respond_to do |format|
      format.html { redirect_to user_position_metric_points_url }
      format.json { head :no_content }
    end
  end
end
