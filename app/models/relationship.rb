require 'active_record'

class Relationship < ActiveRecord::Base
  include SingularTable
  include SoftDelete

  has_many :links, inverse_of: :relationship, dependent: :destroy
  belongs_to :entity, foreign_key: "entity1_id"
  belongs_to :related, class_name: "Entity", foreign_key: "entity2_id"

  def self.all_categories
    [
      "",
      "Position",
      "Education",
      "Membership",
      "Family",
      "Donation",
      "Transaction",
      "Lobbying",
      "Social",
      "Professional",
      "Ownership"  
    ]
  end

  def self.all_categories_with_fields
    [
      "Position",
      "Education",
      "Membership",
      "Donation",
      "Transaction",
      "Ownership"
    ]
  end

  def link
    links.find { |link| link.entity1_id = entity1_id }
  end
  
  def reverse_link
    links.find { |link| linl.entity2_id = entity1_id }
  end

  def category_name
    self.class.all_categories[category_id]
  end
  
  def all_attributes
    hash = attributes.merge!(category_attributes).reject { |k,v| v.nil? }
    hash.delete("notes")
    hash
  end

  def category_attributes
    return {} unless self.class.all_categories_with_fields.include? category_name

    category = Kernel.const_get(category_name)
                     .where(relationship_id: id)
                     .first
    return {} if category.nil?

    hash = category.attributes
    hash.delete("id")
    hash.delete("relationship_id")
    hash
  end
end