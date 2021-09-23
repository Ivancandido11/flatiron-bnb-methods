class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, class_name: "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :validate_guest_and_host
  validate :validate_available_dates, on: :create
  validate :validate_checkin_before_checkout, on: :create

  def duration
    checkout - checkin
  end

  def total_price
    duration * listing.price
  end

private

  def validate_guest_and_host
    errors.add(:guest_id, "Cannot make reservation to your own listing") if guest == listing.host
  end

  def validate_available_dates
    return if checkin.nil? || checkout.nil?

    openings = listing.neighborhood.neighborhood_openings(checkin.to_s, checkout.to_s)
    errors.add(:base, "Dates not available") unless openings.include?(listing)
  end

  def validate_checkin_before_checkout
    return if checkin.nil? || checkout.nil?

    errors.add(:checkin, "Check in must be before checkout") unless checkin < checkout
  end
end
