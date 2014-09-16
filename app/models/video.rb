class Video < ActiveRecord::Base
  belongs_to :recordable, polymorphic: true
  before_save :process_url

  Y_REGEX = /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/
  V_REGEX = /vimeo\.com\/([0-9]{1,10})/

  validates :url, :recordable_type, :recordable_id, presence: true
  validates :url, format: { with: Y_REGEX, message: "Invalid Youtube link." }, if: :new_record?
  validates :url, format: { with: V_REGEX, message: "Invalid Vimeo link." }, if: :new_record?

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
      self.url = self.url.match(V_REGEX)[1]
      self.thumbnail = get_vimeo_info["thumbnail_small"]
      self.provider = :vimeo
    end
  end
end
