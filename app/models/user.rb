class User < ApplicationRecord

	attr_accessor :remenber_token

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

	# 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

	# ランダムなトークンを返す
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	 # 永続セッションのためにユーザーをデータベースに記憶する
	def remenber
		self.remenber_token = User.new_token
		update_attribute(:remenber_digest, User.digest(remenber_token))
	end

	# 渡されたトークンがダイジェストと一致したらtrueを返す
	def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
