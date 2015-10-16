require 'faker'

FactoryGirl.define do
  factory :user do
    password = Faker::Internet.password
    id  { rand 1_000..2_000_000 }
    sequence(:name) { |n| Faker::Name.first_name + "#{n}" }
    email { Faker::Internet.email }
    password {  password }
    password_confirmation { password }
    rating { rand 3300..3900 }

    factory :authed_user do
      provider { 'facebook' }
    end

    factory :non_authed_user do
      provider { nil }
    end
  end
end
