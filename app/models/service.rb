class Service < ApplicationRecord
  has_paper_trail

  belongs_to :user, optional: true

  has_many :points
  has_many :documents

  has_many :service_comments, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :url, presence: true
  validates :url, uniqueness: true

  attr_accessor :service_rating

  before_validation :strip_input_fields

  def self.search_by_name(query)
    Service.where("name ILIKE ?", "%#{query}%")
  end

  def service_rating
    if File.file?("service_ratings.csv")
      csv = CSV.read("service_ratings.csv")
      service_row = csv.find { |row| (row[0] === self.id.to_s) }
      if service_row.nil? || service_row[1].nil?
        "N/A"
      else
        service_row[1]
      end
    else
      "N/A"
    end
  rescue CSV::MalformedCSVError
    "N/A"
  end

  def calculate_service_rating
    perform_calculation
  end

  def points_ordered_status_class
    service_points_hash = (points.group_by { |point| point.status }).sort_by { |key| key }.reverse.to_h

    service_points_hash.each_value do |points|
      sort_service_points(points)
    end
  end

  def pending_points
    !self.points.nil? ? self.points.where(status: "pending") : []
  end

  def sort_service_points(points)
    classifications = ['good', 'neutral', 'bad', 'blocker']

    points.sort! do |a, b|
      a_class = a.case&.classification
      b_class = b.case&.classification

      if !classifications.include?(a.case&.classification) || !classifications.include?(b.case&.classification)
        0
      elsif a_class == b_class
        0
      elsif a_class == 'good'
        -1
      elsif b_class == 'good'
        1
      elsif a_class == 'neutral'
        -1
      elsif b_class == 'neutral'
        1
      elsif a_class == 'bad'
        -1
      elsif b_class == 'bad'
        1
      end
    end
  end

  private

  def strip_input_fields
    self.attributes.each do |key, value|
      self[key] = value.strip if value.respond_to?("strip")
    end
  end

  def perform_calculation
    classification_counts = service_point_classifications_count(self.points)
    calculate_balance(classification_counts)
  end

  def service_point_classifications_count(points)
    approved_points = points.select { |p| p.status == 'approved' && !p.case.nil? }
    total_ratings = approved_points.map { |p| p.case.classification }
    counts = Hash.new 0
    total_ratings.each { |rating| counts[rating] += 1 }
    counts
  end

  def calculate_balance(counts)
    num_bad = counts['bad']
    num_blocker = counts['blocker']
    num_good = counts['good']

    balance = num_good - num_bad - 3 * num_blocker
    balance

    if (num_blocker + num_bad + num_good == 0)
      return "N/A"
    elsif (balance < -10)
      return "E"
    elsif (num_blocker > 0)
      return "D"
    elsif (balance < -4)
      return "C"
    elsif (num_bad > 0)
      return "B"
    else
      return "A"
    end
  end
end
