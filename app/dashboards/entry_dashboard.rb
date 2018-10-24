require "administrate/base_dashboard"

class EntryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    feed: Field::BelongsTo,
    train_histories: Field::HasMany,
    id: Field::Number,
    title: Field::Text,
    url: Field::String,
    author: Field::String,
    content: Field::Text,
    digest: Field::String,
    guid: Field::String,
    published_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    version: Field::Number,
    tag_list: Field::Text,
    category: Field::String.with_options(searchable: false),
    thumb_url: Field::String,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :feed,
    :train_histories,
    :id,
    :title,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :feed,
    :train_histories,
    :id,
    :title,
    :url,
    :author,
    :content,
    :digest,
    :guid,
    :published_at,
    :created_at,
    :updated_at,
    :version,
    :tag_list,
    :category,
    :thumb_url,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :feed,
    :train_histories,
    :title,
    :url,
    :author,
    :content,
    :digest,
    :guid,
    :published_at,
    :version,
    :tag_list,
    :category,
    :thumb_url,
  ]

  # Overwrite this method to customize how entries are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(entry)
  #   "Entry ##{entry.id}"
  # end
end
