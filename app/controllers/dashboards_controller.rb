class DashboardsController < ApplicationController
  before_action
  def dashboard
    @children = current_person.children
    @parent   = current_person.parent
  end
end