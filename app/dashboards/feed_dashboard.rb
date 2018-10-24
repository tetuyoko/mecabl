require "administrate/base_dashboard"

class FeedDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    crawl_status: Field::HasOne,
    entries: Field::HasMany,
    id: Field::Number,
    title: Field::Text,
    url: Field::String,
    etag: Field::String,
    feed_url: Field::String,
    description: Field::Text,
    modified_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :crawl_status,
    :entries,
    :id,
    :title,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :crawl_status,
    :entries,
    :id,
    :title,
    :url,
    :etag,
    :feed_url,
    :description,
    :modified_at,
    :created_at,
    :updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :crawl_status,
    :entries,
    :title,
    :url,
    :etag,
    :feed_url,
    :description,
    :modified_at,
  ]

  # Overwrite this method to customize how feeds are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(feed)
  #   "Feed ##{feed.id}"
  # end
end
