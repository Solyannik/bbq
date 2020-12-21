class Subscription < ActiveRecord::Base
  REGEXP_EMAIL = /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/

  belongs_to :event
  belongs_to :user, optional: true

  validates :event, presence: true

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: REGEXP_EMAIL, unless: -> { user.present? }

  validates :user, uniqueness: {scope: :event_id}, if: -> { user.present? }
  validates :user_email, uniqueness: {scope: :event_id}, unless: -> { user.present? }
  validate :check_email
  validate :not_author?

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  def not_author?
    if user.present?
      if event.user == user
        errors.add(:user, :invalid)
      end
    end
  end

  def check_email
    if user_id.blank? && user_email.present? &&  User.where("email LIKE ?", user_email).present?
       errors.add(:email, I18n.t('subscriptions.subscription.has_email'))
    end
  end
end