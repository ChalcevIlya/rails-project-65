# frozen_string_literal: true

class BulletinPolicy
  attr_reader :current_user, :bulletin

  def initialize(current_user, bulletin)
    @current_user = current_user
    @bulletin = bulletin
  end

  def show?
    bulletin.published? || author? || current_user&.admin?
  end

  def author?
    current_user == bulletin.user
  end
end
