FactoryBot.define do
  factory :certificates_template, class: Certificates::Template do
    name  'Hindernisbahn'
    image do
      Rack::Test::UploadedFile.new(Rails.root.join('app', 'assets', 'images', 'disciplines',
                                                   'climbing_hook_ladder.png'))
    end
    font { Rack::Test::UploadedFile.new(Rails.root.join('app', 'assets', 'fonts', 'Arial.ttf')) }

    trait :with_text_fields do
      after(:build) do |template|
        template.text_fields.push Certificates::TextField.new(left: 10, top: 10, width: 100, height: 20, size: 10,
                                                              key: :team_name, align: :center)
      end
    end
  end
end
