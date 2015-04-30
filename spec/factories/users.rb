FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "cerito#{n}" }
    sequence(:email) { |n| "cerito#{n}@ddl.com" }
    password 'changeme'
    password_confirmation 'changeme'

    # factory :user_with_image do
    #   avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'guaremate.png')) }
  end
end
