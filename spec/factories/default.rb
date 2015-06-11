FactoryGirl.define do
  sequence(:first_name) { |n| "Alfred#{n}" }
  sequence(:last_name) { |n| "Meier#{n}" }
  sequence(:name) { |n| "Team#{n}" }

  factory :team do
    name "Mecklenburg-Vorpommern"
    gender :male

    trait(:male) { gender :male }
    trait(:female) { gender :female }
    trait(:generated) do
      name { generate(:name) }
    end
  end

  factory :person do
    first_name "Alfred"
    last_name "Meier"
    gender :male

    trait(:generated) do
      first_name { generate(:first_name) }
      last_name { generate(:last_name) }
    end

    trait(:male) { gender :male }
    trait(:female) { gender :female }
    trait(:with_team) do
      team { Team.first || build(:team) }
    end
  end

  factory :climbing_hook_ladder, class: "Disciplines::ClimbingHookLadder" do
  end
  factory :obstacle_course, class: "Disciplines::ObstacleCourse" do
  end
  factory :fire_relay, class: "Disciplines::FireRelay" do
  end
  factory :fire_attack, class: "Disciplines::FireAttack" do
  end

  factory :assessment do
    discipline { Disciplines::ClimbingHookLadder.first || create(:climbing_hook_ladder) }
    name ""
    gender :male
    trait :obstacle_course do
      discipline { create :obstacle_course }
    end
    trait :fire_attack do
      discipline { create :fire_attack }
    end
    trait :fire_relay do
      discipline { create :fire_relay }
    end
  end

  factory :assessment_request do
    entity { build(:team, :generated) }
    assessment_type :group_competitor
  end

  factory :score_list, class: "Score::List" do
    assessment { Assessment.first || build(:assessment) }
    name "Lauf 1"
    generator { "Score::ListGenerators::Simple" }
  end  

  factory :score_list_entry, class: "Score::ListEntry" do
    association :list, factory: :score_list 
    track 1
    run 1
    entity { Person.first || build(:person, :with_team) }    
    trait :result_valid do
      result_type "valid"
    end
    trait :result_invalid do
      result_type "invalid"
    end
    trait :generate_person do
      entity { build :person, :with_team, first_name: generate(:first_name), last_name: generate(:last_name) }    
    end
  end

  factory :score_stopwatch_time, class: "Score::StopwatchTime" do
    association :list_entry, factory: :score_list_entry
    time 1799
    factory :score_electronic_time, class: "Score::ElectronicTime" do
    end
    factory :score_handheld_time, class: "Score::HandheldTime" do
    end
  end

  factory :score_result_row, class: "Score::ResultRow" do
    initialize_with do
      new(build(:person), build(:score_result))
    end
    after(:build) do |result_row|
      result_row.add_list(build(:score_list_entry))
    end
  end

  factory :score_result, class: "Score::Result" do
    assessment { Assessment.first || build(:assessment) }
    name ""
  end

  factory :team_relay do
    team { Team.first || build(:team) }
  end

  factory :user do
    password "a"
    password_confirmation "a"
  end
end