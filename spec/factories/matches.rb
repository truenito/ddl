FactoryGirl.define do
  factory :matches do
    sequence(:name) { |n| "Partida de prueba-#{n}" }
    password 'password123'

    # factory :user_with_image do
    #   avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'guaremate.png')) }
  end
end
