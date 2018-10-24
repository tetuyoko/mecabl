class CategoryRecord < ActiveRecord::Base
  self.abstract_class = true
  enum category: { 
    notbl: 1,
    bl: 2,
  }
end
