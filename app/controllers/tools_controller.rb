class ToolsController < ApplicationController
  helper_method :tools_controller?
  def tools_controller?
    true
  end

  def door_to_door_sign_up
    @person = Person.new
    @person.build_home_address
    @committees = Committee.pluck(:id, :name, :slug)
    render
  end
end