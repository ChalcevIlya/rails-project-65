# frozen_string_literal: true

class BulletinPolicy
  attr_reader :current_user, :bulletin

  def initialize(current_user, bulletin)
    @current_user = current_user
    @bulletin = bulletin
  end

  def show?
    if bulletin.published?
      true
    elsif current_user
      current_user.admin? || current_user == bulletin.user
    else
      false
    end
  end

  def author?
    current_user == bulletin.user
  end
end
