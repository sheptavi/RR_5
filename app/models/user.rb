class User < ApplicationRecord
  # Связи
  has_many :values, dependent: :destroy
  has_many :images, through: :values
  
  # Хеширование пароля (gem 'bcrypt')
  has_secure_password
  
  # Перед сохранением — приводим email к нижнему регистру
  before_save { self.email = email.downcase }
  
  # Перед созданием — создаём remember_token
  before_create :create_remember_token
  
  # Валидация имени
  validates :name, presence: true, length: { maximum: 50 }
  
  # Валидация email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  
  # Валидация пароля (минимум 6 символов)
  validates :password, length: { minimum: 6 }, allow_nil: true
  
  # Генерация случайного токена
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  # Шифрование токена
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
  
  # Создание зашифрованного remember_token
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
