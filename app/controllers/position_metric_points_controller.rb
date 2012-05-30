class PositionMetricPointsController < ApplicationController
  # GET /position_metric_points
  # GET /position_metric_points.json
  def index
    @position_metric_points = PositionMetricPoint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @position_metric_points }
    end
  end

  # GET /position_metric_points/1
  # GET /position_metric_points/1.json
  def show
    @position_metric_point = PositionMetricPoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @position_metric_point }
    end
  end

  # GET /position_metric_points/new
  # GET /position_metric_points/new.json
  def new
    @position_metric_point = PositionMetricPoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @position_metric_point }
    end
  end

  # GET /position_metric_points/1/edit
  def edit
    @position_metric_point = PositionMetricPoint.find(params[:id])
  end

  # POST /position_metric_points
  # POST /position_metric_points.json
  def create
    @position_metric_point = PositionMetricPoint.new(params[:position_metric_point])

    respond_to do |format|
      if @position_metric_point.save
        format.html { redirect_to @position_metric_point, notice: 'Position metric point was successfully created.' }
        format.json { render json: @position_metric_point, status: :created, location: @position_metric_point }
      else
        format.html { render action: "new" }
        format.json { render json: @position_metric_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /position_metric_points/1
  # PUT /position_metric_points/1.json
  def update
    @position_metric_point = PositionMetricPoint.find(params[:id])

    respond_to do |format|
      if @position_metric_point.update_attributes(params[:position_metric_point])
        format.html { redirect_to @position_metric_point, notice: 'Position metric point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @position_metric_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /position_metric_points/1
  # DELETE /position_metric_points/1.json
  def destroy
    @position_metric_point = PositionMetricPoint.find(params[:id])
    @position_metric_point.destroy

    respond_to do |format|
      format.html { redirect_to position_metric_points_url }
      format.json { head :no_content }
    end
  end
end
