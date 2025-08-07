# frozen_string_literal: true

class AdminPolicy
  attr_reader :user, :record

  def initialize(user, _record)
    @user = user
  end

  def access?
    user&.admin?
  end
end
