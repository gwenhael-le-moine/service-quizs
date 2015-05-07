require 'laclasse/helpers/authentication'
require 'laclasse/cross_app/sender'

# puts 'loading api/....'
# require __dir__('...')

# Point d'entrée des APi du suivi
class Api < Grape::API
  format :json
  rescue_from :all

  helpers Laclasse::Helpers::Authentication

  before do
    error!( '401 Unauthorized', 401 ) unless logged?
    current_user_ent
  end

  # Montage des toutes les api REST Grape
  # resource(:annuaire) { mount ..... }

  add_swagger_documentation
end
