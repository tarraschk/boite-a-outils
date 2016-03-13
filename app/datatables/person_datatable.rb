class PersonDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :link_to

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Person.id Person.first_name Person.last_name Person.email Person.tags Person.created_at)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Person.first_name Person.last_name Person.email Person.tags Person.created_at)
  end

  private

  def data
    records.map do |record|
      [
        record.id,
        record.first_name,
        record.last_name,
        record.email,
        record.created_at.strftime('%d/%m/%Y %H:%M'),
        record.nation_builder_error,
        button_for_sync
      ]
    end
  end

  def button_for_sync
    %q(
      <button class='send_to_nation_builder_button'>
        Synchroniser
      </button>
    ).html_safe
  end

  def get_raw_records
    Person.where(people_id: nil).order(:id)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
