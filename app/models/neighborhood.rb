class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def self.highest_ratio_res_to_listings
    ratio = all.map { |n| n.listings.map.sum { |l| l.reservations.count } / n.listings.count.to_f }.reject!(&:nan?)
    all.find { |n| (n.listings.map.sum { |l| l.reservations.count } / n.listings.count.to_f) == ratio.max }
  end

  def self.most_res
    res = all.map { |n| n.listings.map.sum { |l| l.reservations.count } }.max
    all.find { |n| n.listings.map.sum { |l| l.reservations.count } == res }
  end

  def neighborhood_openings(checkin, checkout)
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
