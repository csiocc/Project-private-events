class TestInvite < ApplicationRecord
  enum :answer, { pending: 0, accepted: 1, declined: 2 }
end