class ImportanceMetricPointsController < ApplicationController
  # GET /importance_metric_points
  # GET /importance_metric_points.json
  def index
    @importance_metric_points = ImportanceMetricPoint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @importance_metric_points }
    end
  end

  # GET /importance_metric_points/1
  # GET /importance_metric_points/1.json
  def show
    @importance_metric_point = ImportanceMetricPoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @importance_metric_point }
    end
  end

  # GET /importance_metric_points/new
  # GET /importance_metric_points/new.json
  def new
    @importance_metric_point = ImportanceMetricPoint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @importance_metric_point }
    end
  end

  # GET /importance_metric_points/1/edit
  def edit
    @importance_metric_point = ImportanceMetricPoint.find(params[:id])
  end

  # POST /importance_metric_points
  # POST /importance_metric_points.json
  def create
    @importance_metric_point = ImportanceMetricPoint.new(params[:importance_metric_point])

    respond_to do |format|
      if @importance_metric_point.save
        format.html { redirect_to @importance_metric_point, notice: 'Importance metric point was successfully created.' }
        format.json { render json: @importance_metric_point, status: :created, location: @importance_metric_point }
      else
        format.html { render action: "new" }
        format.json { render json: @importance_metric_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /importance_metric_points/1
  # PUT /importance_metric_points/1.json
  def update
    @importance_metric_point = ImportanceMetricPoint.find(params[:id])

    respond_to do |format|
      if @importance_metric_point.update_attributes(params[:importance_metric_point])
        format.html { redirect_to @importance_metric_point, notice: 'Importance metric point was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @importance_metric_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /importance_metric_points/1
  # DELETE /importance_metric_points/1.json
  def destroy
    @importance_metric_point = ImportanceMetricPoint.find(params[:id])
    @importance_metric_point.destroy

    respond_to do |format|
      format.html { redirect_to importance_metric_points_url }
      format.json { head :no_content }
    end
  end
end
