class Score::ResultList < CacheDependendRecord
  belongs_to :list
  belongs_to :result
end
