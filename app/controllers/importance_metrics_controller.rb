class ImportanceMetricsController < ApplicationController
  # GET /importance_metrics
  # GET /importance_metrics.json
  def index
    @importance_metrics = ImportanceMetric.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @importance_metrics }
    end
  end

  # GET /importance_metrics/1
  # GET /importance_metrics/1.json
  def show
    @importance_metric = ImportanceMetric.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @importance_metric }
    end
  end

  # GET /importance_metrics/new
  # GET /importance_metrics/new.json
  def new
    @importance_metric = ImportanceMetric.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @importance_metric }
    end
  end

  # GET /importance_metrics/1/edit
  def edit
    @importance_metric = ImportanceMetric.find(params[:id])
  end

  # POST /importance_metrics
  # POST /importance_metrics.json
  def create
    @importance_metric = ImportanceMetric.new(params[:importance_metric])

    respond_to do |format|
      if @importance_metric.save
        format.html { redirect_to @importance_metric, notice: 'Importance metric was successfully created.' }
        format.json { render json: @importance_metric, status: :created, location: @importance_metric }
      else
        format.html { render action: "new" }
        format.json { render json: @importance_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /importance_metrics/1
  # PUT /importance_metrics/1.json
  def update
    @importance_metric = ImportanceMetric.find(params[:id])

    respond_to do |format|
      if @importance_metric.update_attributes(params[:importance_metric])
        format.html { redirect_to @importance_metric, notice: 'Importance metric was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @importance_metric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /importance_metrics/1
  # DELETE /importance_metrics/1.json
  def destroy
    @importance_metric = ImportanceMetric.find(params[:id])
    @importance_metric.destroy

    respond_to do |format|
      format.html { redirect_to importance_metrics_url }
      format.json { head :no_content }
    end
  end
end
