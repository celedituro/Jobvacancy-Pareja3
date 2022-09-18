class User
  include ActiveModel::Validations

  attr_accessor :id, :name, :email, :crypted_password, :job_offers, :updated_on, :created_on,
                :subscription

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  validates :name, :crypted_password, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX,
                                              message: 'invalid email' }

  def self.create(name, email, password)
    data = {}
    data[:name] = name
    data[:email] = email
    data[:password] = password
    User.new(data)
  end

  def initialize(data = {})
    @id = data[:id]
    @name = data[:name]
    @email = data[:email]
    @crypted_password = if data[:password].nil?
                          data[:crypted_password]
                        else
                          Crypto.encrypt(data[:password])
                        end
    @job_offers = if data[:job_offers].nil?
                    []
                  else
                    data[:job_offers]
                  end
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
    @subscription = OnDemandSubscription.new
  end

  def has_password?(password)
    Crypto.decrypt(crypted_password) == password
  end

  def subscribe_to(subscription)
    @subscription = subscription
  end
end
