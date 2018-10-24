require 'classifier'

class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :update, :destroy, :train]

  def index
    @entries = Entry.all
    render json: @entries
  end

  def show
    render json: @entry
  end

  def new_image
    if @entry = Entry.find_by(url: params[:url])
      h = {thumb_url: @entry.image_url}
      render json: h, status: :ok
    else
      render json: :not_found, status: :not_found
    end
  end

  def create
    @entry = Entry.new(entry_params)

    if @entry.save
      render json: @entry, status: :created, location: @entry
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  def train
    if TrainHistory.create(entry_id: @entry.id, category:  CategoryRecord.categories[params[:category]])
      render json: :ok, status: :ok
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  def update
    if @entry.update(entry_params)
      head :no_content
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy

    head :no_content
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:feed_id, :title, :url, :author, :content, :category, :digest, :guid, :published_at, :version, :tag_list)
  end

end
