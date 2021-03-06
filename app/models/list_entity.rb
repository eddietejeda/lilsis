require 'active_record'

class ListEntity < ActiveRecord::Base
  self.table_name = "ls_list_entity"

  include SoftDelete

  belongs_to :list, inverse_of: :list_entities
  belongs_to :entity, inverse_of: :list_entities
end