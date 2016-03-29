class DashboardsController < SignedInController
  def dashboard
    if user_signed_in?
      @children = current_person.children.activated
      @parent   = current_person.parent
    end
  end
end