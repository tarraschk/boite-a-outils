class DashboardsController < ApplicationController
  def dashboard
    @children = current_person.children
    @parent   = current_person.parent
  end
end