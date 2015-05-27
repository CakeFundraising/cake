module CouponBookHelper
  COUPON_BOOK_URL = ENV['COUPON_BOOK_HOST']

  def coupon_book_page(page)
    "#{COUPON_BOOK_URL}/#{page}"
  end
end