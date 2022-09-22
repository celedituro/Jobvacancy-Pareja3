class UserRepository < BaseRepository
  self.table_name = :users
  self.model_class = 'User'

  def find_by_email(email)
    row = dataset.first(email: email)
    load_object(row) unless row.nil?
  end

  def users
    users = load_collection dataset
    users.each do |user|
      p user.subscription
    end
    users
  end

  protected

  def changeset(user)
    {
      name: user.name,
      crypted_password: user.crypted_password,
      email: user.email,
      subscription: user.subscription.name
    }
  end
end
