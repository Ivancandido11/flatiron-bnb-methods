class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods

  def self.highest_ratio_res_to_listings
    ratio = all.map { |c| c.listings.map.sum { |l| l.reservations.count } / c.listings.count.to_f }.max
    all.find { |c| (c.listings.map.sum { |l| l.reservations.count } / c.listings.count.to_f) == ratio }
  end

  def self.most_res
    res = all.map { |c| c.listings.map.sum { |l| l.reservations.count } }.max
    all.find { |c| c.listings.map.sum { |l| l.reservations.count } == res }
  end

  def city_openings(checkin, checkout)
    openings = []
    listings.each do |listing|
      openings << listing if listing.reservations.size.zero?
      listing.reservations.each do |r|
        if (r.checkin <= Time.parse(checkout)) && (r.checkout >= Time.parse(checkin))
          openings.delete(listing)
          break
        else
          openings << listing
        end
      end
    end
    openings
  end
end
