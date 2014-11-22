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
    font "#{Rails.root}/app/assets/fonts/museosans-300-webfont.ttf"

    bounding_box([15, 450], width: 700, height: 220) do
      stroke_color 'CCCCCC'
      stroke_bounds

      define_grid(columns: 3, rows: 1, gutter: 0)

      grid(0,0).bounding_box do
        image avatar, width: 200, height: 133, position: 15, vposition: 15
      end

      grid(0,1).bounding_box  do
        move_down 15

        text @coupon.title, size: 30
        
        move_down 10
        
        text "Expires: #{@coupon.expires_at}"

        move_down 10

        text @coupon.description
      end

      grid(0,2).bounding_box  do
        image qrcode, width: 75, height: 75, position: 145, vposition: 15

        move_down 30

        text 'Promo Code', size: 18, align: :right
        text @coupon.promo_code, size: 16, align: :right
      end

      #grid.show_all
    end
    
    move_down 30

    text 'Terms & Conditions', size: 14
    text @coupon.terms_conditions.html_safe, size: 9
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