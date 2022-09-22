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
    @crypted_password = init_password(data)
    @job_offers = init_job_offers(data[:job_offers])
    @updated_on = data[:updated_on]
    @created_on = data[:created_on]
    @subscription = init_subscription(data[:subscription])
  end

  def init_job_offers(job_offers)
    return [] if job_offers.nil?

    job_offers
  end

  def init_subscription(subscription)
    return OnDemandSubscription.new if subscription.nil?

    SubscriptionRepository.new.create_by_subscription(subscription)
  end

  def init_password(data)
    if data[:password].nil?
      data[:crypted_password]
    else
      Crypto.encrypt(data[:password])
    end
  end

  def has_password?(password)
    Crypto.decrypt(crypted_password) == password
  end
end
