require "open-uri"

class CouponPdf < Pdf
  def initialize(coupon)
    @document = Prawn::Document.new(page_layout: :landscape, page_size: "A4")
    @coupon = coupon
    header
    coupon_box
  end

  private

  def coupon_box
    initial_y_position = 15

    bounding_box([0, initial_y_position], :width => 915, :height => 315) do

      define_grid(columns: 3, rows: 1, gutter: 15)

      grid(0,0).bounding_box  do
        image avatar, width: 300, height: 200, position: :left
      end

      grid(0,1).bounding_box  do
        text @coupon.title, size: 30, style: :bold
        text "Expires: #{@coupon.expires_at}"
        text @coupon.description
      end

      grid(0,2).bounding_box  do
        image qrcode, width: 150, height: 150, position: :right
        text 'Promo Code', size: 20, style: :bold
        text @coupon.promo_code, size: 18
      end

      grid.show_all

      horizontal_rule

      text 'Terms & Conditions', size: 20
      text @coupon.terms_conditions.html_safe, size: 10
    end
  end

  def avatar
    return open(@coupon.picture.avatar_path) if @coupon.picture.avatar_path != '/assets/placeholder_avatar.png'
    "#{Rails.root}/app/assets/images/placeholder_avatar.png"
  end

  def qrcode
    return open(@coupon.picture.qrcode_path) if @coupon.picture.qrcode_path != '/assets/placeholder.png'
    "#{Rails.root}/app/assets/images/placeholder.png"
  end
end