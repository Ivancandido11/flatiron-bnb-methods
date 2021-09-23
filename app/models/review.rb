class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :validate_existing_and_passed_res

private

  def validate_existing_and_passed_res
    return if created_at.nil?

    unless reservation.checkout <= created_at || reservation.status != "accepted"
      errors.add(:base,
                 "Cant review until checked out")
    end
  end

end
