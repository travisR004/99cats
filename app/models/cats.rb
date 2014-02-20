class Cat < ActiveRecord::Base

  validates :age, presence: true, numericality: true
  validates :sex, inclusion: { in: %w(M F)}, presence: true
  validates :color, inclusion: {in: %w(Red Blue Brown Black Tri White Calico Gray)},
    presence: true
  valiidates :birth_date, :name, presence: true

end