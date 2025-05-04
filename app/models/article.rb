class Article < ApplicationRecord
	validates :title, presence: true #presence: trueで入力を必須にする
	validates :content, presence: true
end
