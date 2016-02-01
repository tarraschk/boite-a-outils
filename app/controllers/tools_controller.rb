class ToolsController < ApplicationController
  def door_to_door_sign_up
    @person = Person.new
    @person.build_home_address
    @committees = Committee.pluck(:id, :name, :slug)
    render
  end
end