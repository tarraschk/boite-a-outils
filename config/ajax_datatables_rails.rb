AjaxDatatablesRails.configure do |config|
  # available options for db_adapter are: :pg, :mysql2, :sqlite3
  # config.db_adapter = :pg

  # available options for paginator are: :simple_paginator, :kaminari, :will_paginate
  config.paginator = :will_paginate
end
