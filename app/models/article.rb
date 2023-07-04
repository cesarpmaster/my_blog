class Article < ApplicationRecord
    has_rich_text :content
    has_one_attached :cover
    validates :title, :content, :cover, presence: true
end