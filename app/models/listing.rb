class Listing < ActiveRecord::Base
  before_destroy :make_user

  belongs_to :neighborhood
  belongs_to :host, class_name: "User"
  has_many :reservations
  has_many :reviews, through: :reservations
  has_many :guests, class_name: "User", through: :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  before_create :make_host

  def average_review_rating
    reviews.average(:rating).to_f
  end

private

  def make_host
    host.update(host: true)
  end

  def make_user
    host.update(host: false) if host.listings.size == 1
  end
end
