class FeedsController < ApplicationController
  extend TrailingSlash
  before_action :set_feed, only: [:show, :update, :destroy]

  def index
    @feeds = Feed.all
    render json: @feeds
  end

  def show
    render json: @feed
  end

  def create
    target_url = FeedsController.trailing_slash(params[:url].to_s)
    if Feed.exists?(url: target_url) ||  Feed.exists?(feed_url: target_url)
      render json: {error_message: "Url is already exists: #{target_url}"}
      return
    end

    if @feed = Feed.create_from_url(target_url)
      render json: @feed, status: :created, location: @feed
    else
      render json: @feed.errors, status: :unprocessable_entity
    end
  end

  def update
    @feed = Feed.find(params[:id])

    if @feed.update(feed_params)
      head :no_content
    else
      render json: @feed.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @feed.destroy

    head :no_content
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:title, :url, :etag, :feed_url, :description, :modified_at)
  end
end
