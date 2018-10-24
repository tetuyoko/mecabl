require "administrate/base_dashboard"

class CrawlStatusDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    feed: Field::BelongsTo,
    id: Field::Number,
    status: Field::Number,
    error_count: Field::Number,
    error_message: Field::String,
    http_status: Field::String,
    digest: Field::String,
    update_fequency: Field::Number,
    crawled_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :feed,
    :id,
    :status,
    :error_count,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :feed,
    :id,
    :status,
    :error_count,
    :error_message,
    :http_status,
    :digest,
    :update_fequency,
    :crawled_at,
    :created_at,
    :updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :feed,
    :status,
    :error_count,
    :error_message,
    :http_status,
    :digest,
    :update_fequency,
    :crawled_at,
  ]

  # Overwrite this method to customize how crawl statuses are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(crawl_status)
  #   "CrawlStatus ##{crawl_status.id}"
  # end
end
