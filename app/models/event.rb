class Event
  include Mongoid::Document
  store_in collection: "events"

  field :event_id, type: String
  field :name, type: String
  field :description, type: String
  field :time, type: DateTime
  field :location, type: String
  field :total_capacity, type: Integer
  field :category, type: String
  field :host_id, type: String
  field :is_active, type: Boolean

  validates :event_id, presence: true
  validates :name, presence: true, allow_blank: false, length: { in: 1..30 }
  validates :description, presence: true, allow_blank: false, length: { in: 1..500 }
  validates :time, presence: true
  validates :location, presence: true, allow_blank: false, length: { in: 1..30 }
  validates :total_capacity, presence: true, allow_nil: false, numericality: { only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 50 }
  validates :category, presence: true, allow_blank: false, inclusion: { in: %w(SPORTS GAMES MUSIC ART EDUCATION), message: "%{value} is not a valid category" }
  validates :host_id, presence: true

  def as_json(options = { })
    h = super(options)
    @votes = Vote.where(event_id: self.event_id)
    h[:_interest_rating] = get_interest_rating
    @tickets = Ticket.where(event_id: self.event_id)
    h[:_current_capacity] = @tickets.count
    @reviews = Review.where(event_id: self.event_id)
    h[:_review_matched_desc] = get_matched_desc
    h[:_review_host_prep] = get_host_prep
    h[:_review_would_ret] = get_would_ret
    h[:_my_vote] = ""
    h[:_my_review] = ""
    h[:_my_ticket] = ""
    h
  end

  def get_interest_rating
    rating = 0
    @votes.each do |v|
      rating = rating + v.value
    end
    rating
  end

  def get_matched_desc
    rating = 0
    @reviews.each do |v|
      rating = rating + v.matched_desc
    end
    rating
  end

  def get_host_prep
    rating = 0
    @reviews.each do |v|
      rating = rating + v.host_prep
    end
    rating
  end

  def get_would_ret
    rating = 0
    @reviews.each do |v|
      if v.would_ret
        rating = rating + 1
      end
    end
    rating
  end
end
