class ArticlePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && user == article.user
  end

  def destroy?
    user.present? && user == article.user
  end

  private

  def article
    record
  end
end
