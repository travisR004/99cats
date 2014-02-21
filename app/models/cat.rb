# == Schema Information
#
# Table name: cats
#
#  id                   :integer          not null, primary key
#  age                  :integer          not null
#  birth_date           :date             not null
#  color                :string(255)      not null
#  name                 :string(255)      not null
#  sex                  :string(255)      not null
#  created_at           :datetime
#  updated_at           :datetime
#  profile_file_name    :string(255)
#  profile_content_type :string(255)
#  profile_file_size    :integer
#  profile_updated_at   :datetime
#  user_id              :integer
#

class Cat < ActiveRecord::Base
  COLORS = %w(Red Blue Brown Black Tri White Calico Gray)
  # has_attached_file :profile, :style  =>  {:medium => "300x300>"}
  validates :age, presence: true, numericality: true
  validates :sex, inclusion: { in: %w(M F)}, presence: true
  validates :color, inclusion: {in: COLORS},
    presence: true
  # validates_attachment_content_type :profile, :content_type => /\Aimage\/.*\Z/
  validates :birth_date, :name, presence: true

  belongs_to :user

  has_many :cat_rental_requests


end
