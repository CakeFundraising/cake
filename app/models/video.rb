class Video < ActiveRecord::Base
  belongs_to :recordable, polymorphic: true
  before_save :extract_youtube_id

  REGEX = /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/

  validates :url, :recordable_type, :recordable_id, presence: true
  validates :url, format: { with: REGEX, message: "Invalid youtube link." }

  private

  def extract_youtube_id
    self.url = self.url.match(REGEX)[5] unless self.url.match(REGEX).nil?
  end
end
