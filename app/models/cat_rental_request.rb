# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string(255)      default("PENDING"), not null
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base
  before_validation(on: :create) do
    self.status ||= "PENDING"
  end
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, inclusion: {in: %w(PENDING APPROVED DENIED) }
  validate :no_cat_rental_overlap

  belongs_to :cat, dependent: :destroy
  def approve!
    ActiveRecord::Base.transaction do
      overlaps = overlapping_pending_requests
      overlaps.each do |overlap|
        overlap.deny!
      end
      self.status = "APPROVED"
      self.save!
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == 'PENDING'
  end

  def overlapping_pending_requests
    overlapping_requests.select{ |request| request.status == "PENDING" }
  end

  def overlapping_requests
    cat_id = self.cat.id
    s1 = self.start_date
    e1 = self.end_date

    CatRentalRequest.all.where(<<-SQL, cat_id, s1, e1, e1, s1)
    cat_id = ?
    AND
    ((start_date > ?
    AND
    end_date < ?)
    OR
    (start_date < ?
    AND
    end_date > ?))
    SQL
  end

  def overlapping_approved_requests
    overlapping_requests.select{ |request| request.status == "APPROVED" }
  end

  def no_cat_rental_overlap
    if overlapping_approved_requests.length > 0
      errors[:base] << "Cat is already booked for that time!!"
    end
  end

end
