class DashboardsController < SignedInController
  def dashboard
    if user_signed_in?
      @children = current_person.children.to_a | current_person.recruitees.to_a
      @parent   = current_person.parent
    end
  end
end