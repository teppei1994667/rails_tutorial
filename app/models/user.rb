class User < ApplicationRecord
	# emailの一意性のバリデーションのためにメールアドレスを全て小文字に変換
	before_save { self.email = email.downcase }
	# nameのバリデーション
	validates :name, presence: true, length: {maximum: 50}
	# emailのフォーマットを正規表現で定義
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	# emailのバリデーション
	validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, 
										uniqueness: true

	validates :password, presence: true, length: {minimum: 6} 

	has_secure_password
end
