# -*- coding: utf-8 -*-
# Module contenant plusieurs fonction générique pour les autres modules, classes etc...

module Outils
  # Fonction qui lance un fail et log cette erreur
  def raise_err(err, msg)
    LOGGER.error err.message
    fail msg
  end
end