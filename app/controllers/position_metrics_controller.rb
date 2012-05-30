class PositionMetricsController < ApplicationController
  # GET /position_metrics
  # GET /position_metrics.json
  def index
    @position_metrics = PositionMetric.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @position_metrics }
    end
  end

  # GET /position_metrics/1
  # GET /position_metrics/1.json
  def show
    @position_metric = PositionMetric.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @position_metric }
    end
  end

  # GET /position_metrics/new
  # GET /position_metrics/new.json
  def new
    @position_metric = PositionMetric.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @position_metric }
    end
  end

  # GET /position_metrics/1/edit
  def edit
    @position_metric = PositionMetric.find(params[:id])
  end

  # POST /position_metrics
  # POST /position_metrics.json
  def create
    @position_metric = PositionMetric.new(params[:position_metric])

    respond_to do |format|
      if @position_metric.save
        format.html { redirect_to @position_metric, notice: 'Position metric was successfully created.' }
        format.json { render json: @position_metric, status: :created, location: @position_metric }
      else
        format.html { render action: "new" }
        format.json { render json: @position_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /position_metrics/1
  # PUT /position_metrics/1.json
  def update
    @position_metric = PositionMetric.find(params[:id])

    respond_to do |format|
      if @position_metric.update_attributes(params[:position_metric])
        format.html { redirect_to @position_metric, notice: 'Position metric was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @position_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /position_metrics/1
  # DELETE /position_metrics/1.json
  def destroy
    @position_metric = PositionMetric.find(params[:id])
    @position_metric.destroy

    respond_to do |format|
      format.html { redirect_to position_metrics_url }
      format.json { head :no_content }
    end
  end
end
