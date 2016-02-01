module Tools
  class DoorToDoorFormController < ToolsController

    def person
      filtered_params = params.require(:person).permit(:recruiter_id, :email, :phone, :mobile, :first_name, :last_name, :contacted, :mandat, :support_level, :tags, home_address_attributes: [:address1, :address2, :address3, :zip, :city])
      cookies[:recruiter_id] = params[:person]['recruiter_id']
      if params['wants_to_join_a_comittee']
        filtered_params[:tags] = %w(a_contacter comite_membre)
      end
      Person.skip_callbacks = true
      person = Person.create(filtered_params)
      if person.errors.any?
        flash[:danger] = person.errors
      else
        flash[:notice] = 'Soutien enregistré avec succès'
      end
    rescue => e
      Rails.logger.error e
      flash[:danger] = "Une erreur s'est produite"
    ensure
      Person.skip_callbacks = false
      redirect_to :back
    end
  end
end