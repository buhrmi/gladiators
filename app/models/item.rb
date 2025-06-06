class Item < ApplicationRecord
  serialize :stats, HashWithIndifferentAccess
end
