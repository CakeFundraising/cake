class Video < ActiveRecord::Base
  belongs_to :recordable, polymorphic: true
  before_save :extract_video_id

  Y_REGEX = /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/
  #V_REGEX = /^(?:https?:\/\/)?(?:www\.)?vimeo\.com\/(.+\/+)?(\d+)/

  validates :url, :recordable_type, :recordable_id, presence: true
  validates :url, format: { with: Y_REGEX, message: "Invalid Youtube link." }, if: :new_record?
  #validates :url, format: { with: V_REGEX, message: "Invalid Vimeo link." }, if: :new_record?

  private

  def extract_video_id
    self.url = self.url.match(Y_REGEX)[5] unless self.url.match(Y_REGEX).nil?
    #self.url = self.url.match(V_REGEX)[2] unless self.url.match(Y_REGEX).nil?
  end
end
