class CrawlStatusesController < ApplicationController
  before_action :set_crawl_status, only: [:show, :update, :destroy]

  def index
    @crawl_statuses = CrawlStatus.all

    render json: @crawl_statuses
  end

  def show
    render json: @crawl_status
  end

  def create
    @crawl_status = CrawlStatus.new(crawl_status_params)

    if @crawl_status.save
      render json: @crawl_status, status: :created, location: @crawl_status
    else
      render json: @crawl_status.errors, status: :unprocessable_entity
    end
  end

  def update
    @crawl_status = CrawlStatus.find(params[:id])

    if @crawl_status.update(crawl_status_params)
      head :no_content
    else
      render json: @crawl_status.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @crawl_status.destroy

    head :no_content
  end

  private

  def set_crawl_status
    @crawl_status = CrawlStatus.find(params[:id])
  end

  def crawl_status_params
    params.require(:crawl_status).permit(:feed_id, :status, :error_count, :error_message, :http_status, :digest, :update_fequency, :crawled_at)
  end
end
