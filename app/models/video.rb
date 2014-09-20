class Video < ActiveRecord::Base
  belongs_to :recordable, polymorphic: true
  before_save :process_url

  Y_REGEX = /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/
  V_REGEX = /vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|)(\d+)(?:$|\/|\?)/

  validates :url, :recordable_type, :recordable_id, presence: true
  validates :url, format: { with: Regexp.union(Y_REGEX, V_REGEX), message: "Invalid video link." }

  private

  def get_vimeo_info
    uri = URI("http://vimeo.com/api/v2/video/#{self.url}.json")
    request = Net::HTTP.get(uri)
    response = JSON.parse(request).first
  end

  def process_url
    # Youtube
    unless self.url.match(Y_REGEX).nil?
      self.url = self.url.match(Y_REGEX)[5]
      self.thumbnail = "http://img.youtube.com/vi/#{self.url}/1.jpg"
      self.provider = :youtube
    end
    # Vimeo
    unless self.url.match(V_REGEX).nil?
      self.url = self.url.match(V_REGEX)[3]
      self.thumbnail = get_vimeo_info["thumbnail_small"]
      self.provider = :vimeo
    end
  end
end
