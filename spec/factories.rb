FactoryBot.define do
  factory :short_link do
    original_url { Faker::Internet.url(scheme: 'https') }
    slug { Faker::Internet.slug(glue: '-')}
  end
  factory :user do
    email { Faker::Internet.email}
    password { Faker::Internet.password}
  end
end
