require "administrate/base_dashboard"

class TrainMasterDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    train_histories: Field::HasMany,
    id: Field::Number,
    mean: Field::Number,
    content_json: Field::Text,
    trained_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :train_histories,
    :id,
    :mean,
    :content_json,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :train_histories,
    :id,
    :mean,
    :content_json,
    :trained_at,
    :created_at,
    :updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :train_histories,
    :mean,
    :content_json,
    :trained_at,
  ]

  # Overwrite this method to customize how train masters are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(train_master)
  #   "TrainMaster ##{train_master.id}"
  # end
end
