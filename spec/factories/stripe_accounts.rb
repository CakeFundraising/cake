# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_account do
    uid { SecureRandom.hex(8) }
    stripe_publishable_key "pk_test_QWtA6xTPiblpPPy3P2fWDpMv"
    token "sk_test_sLTrHz6H1XgFXD1XPBE3VDkR"
  end
end
