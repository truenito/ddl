require 'faker'

FactoryGirl.define do
  factory :match do
    id  { 999_999 }
    name { Faker::Name.first_name }
    password {  Faker::Internet.password }
    status { 'waiting' }

    factory :live_match do
      status { 'playing' }
    end

    factory :canceled_match do
      status { 'canceled' }
    end
  end
end
