FactoryBot.define do
  factory :user, aliases: [:owner] do
    provider { "github" }
    sequence :uid do |n|
      "12345#{n}"
    end
    name { "First Last" }
    email { "first@last.com" }
    nickname { "nick" }
    github { "https://github.com/nick" }

    factory :admin do
      role { 1 }
    end
  end

  factory :project do
    group_members { "Sharon Jones" }
    sequence :name do |n|
      "Witty Name #{n}"
    end
    description { "A great project!" }
    project_type { "BE Mod 3" }
    final_confirmation { true }
    demo_night
    owner
  end

  factory :demo_night do
    sequence :name do |n|
      "DemoName #{n}"
    end
    status { 0 }
    final_date { '2017/01/23' }

    factory :demo_night_with_projects do
      after(:create) do |demo_night, evaluator|
        create_list(:project, 2, demo_night: demo_night)
      end
    end
  end

end
