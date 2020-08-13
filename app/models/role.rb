class Role < ApplicationRecord
  # Роль должна присутсвовать и должна быть уникальной
  validates :name, presence:  true
  validates_uniqueness_of :name


  # Модель прописывает роли для User
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true


  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

end
