# == Schema Information
#
# Table name: trades
#
#  id          :integer          not null, primary key
#  description :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_trades_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Trade < ApplicationRecord
  belongs_to :user
  has_many_attached :images, dependent: :destroy
end
