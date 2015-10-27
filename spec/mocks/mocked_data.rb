# -*- coding: utf-8 -*-
MOCKED_DATA = {
  user: 'erasme',
  is_logged: true,
  uid: 'VAA60000',
  login: 'erasme',
  sexe: 'M',
  nom: 'Levallois',
  prenom: 'Pierre-Gilles',
  date_naissance: '1970-02-06',
  adresse: '1 rue Sans Nom Propre',
  code_postal: '69000',
  ville: 'Lyon',
  bloque: nil,
  id_jointure_aaf: nil,
  avatar: '',
  roles_max_priority_etab_actif: 3,
  user_detailed: {
    'id' => 1,
    'id_sconet' => nil,
    'login' => 'erasme',
    'id_jointure_aaf' => nil,
    'nom' => 'Levallois',
    'prenom' => 'Pierre-Gilles',
    'sexe' => 'M',
    'id_ent' => 'VAA60000',
    'date_naissance' => '1970-02-06',
    'adresse' => '1 rue Sans Nom Propre',
    'code_postal' => '69000',
    'ville' => 'Lyon',
    'avatar' => '',
    'full_name' => 'Levallois Pierre-gilles',
    'profil_actif' => {
      'profil_id' => 'ENS',
      'etablissement_nom' => 'ERASME',
      'etablissement_code_uai' => '0699990Z',
      'profil_nom' => 'Enseignant',
      'profil_code_national' => 'National_ENS',
      'etablissement_id' => 1,
      'actif' => true,
      'bloque' => nil
    },
    'profils' => [
      {
        'profil_id' => 'ENS',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'profil_nom' => 'Enseignant',
        'profil_code_national' => 'National_ENS',
        'etablissement_id' => 1,
        'actif' => true,
        'bloque' => nil
      },
      {
        'profil_id' => 'ELV',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'profil_nom' => 'Elève',
        'profil_code_national' => 'National_ELV',
        'etablissement_id' => 1,
        'actif' => false,
        'bloque' => nil
      }
    ],
    'roles' => [
      {
        'role_id' => 'ADM_ETB',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'etablissement_id' => 1,
        'priority' => 2,
        'libelle' => "Administrateur d'établissement"
      },
      {
        'role_id' => 'ELV_ETB',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'etablissement_id' => 1,
        'priority' => 0,
        'libelle' => 'Elève'
      },
      {
        'role_id' => 'PROF_ETB',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'etablissement_id' => 1,
        'priority' => 1,
        'libelle' => 'Professeur'
      },
      {
        'role_id' => 'TECH',
        'etablissement_nom' => 'ERASME',
        'etablissement_code_uai' => '0699990Z',
        'etablissement_id' => 1,
        'priority' => 3,
        'libelle' => 'Administrateur technique'
      }
    ],
    'emails' => [ ],
    'roles_max_priority_etab_actif' => 3,
    'etablissements' => [
      {
        'id' => 1,
        'nom' => 'ERASME',
        'code_uai' => '0699990Z',
        'profils' => [
          {
            'profil_id' => 'ELV',
            'user_id' => 1,
            'etablissement_id' => 1,
            'bloque' => nil,
            'actif' => false
          },
          {
            'profil_id' => 'ENS',
            'user_id' => 1,
            'etablissement_id' => 1,
            'bloque' => nil,
            'actif' => true
          }
        ],
        'roles' => [
          {
            'role_id' => 'ADM_ETB',
            'etablissement_nom' => 'ERASME',
            'etablissement_code_uai' => '0699990Z',
            'etablissement_id' => 1,
            'priority' => 2,
            'libelle' => "Administrateur d'établissement"
          },
          {
            'role_id' => 'ELV_ETB',
            'etablissement_nom' => 'ERASME',
            'etablissement_code_uai' => '0699990Z',
            'etablissement_id' => 1,
            'priority' => 0,
            'libelle' => 'Elève'
          },
          {
            'role_id' => 'PROF_ETB',
            'etablissement_nom' => 'ERASME',
            'etablissement_code_uai' => '0699990Z',
            'etablissement_id' => 1,
            'priority' => 1,
            'libelle' => 'Professeur'
          },
          {
            'role_id' => 'TECH',
            'etablissement_nom' => 'ERASME',
            'etablissement_code_uai' => '0699990Z',
            'etablissement_id' => 1,
            'priority' => 3,
            'libelle' => 'Administrateur technique'
          }
        ]
      }
    ],
    'classes' => [
      {
        'etablissement_code' => '0690078K',
        'classe_libelle' => '6B',
        'etablissement_nom' => "CLG-VAL D'ARGENT",
        'matiere_enseignee_id' => '003700',
        'matiere_libelle' => 'AIDE ET ACCOMPAGNEMENT TRAVAIL PERSONNEL',
        'classe_id' => 1,
        'etablissement_id' => 1348,
        'prof_principal' => 'N'
      },
      {
        'etablissement_code' => '0690078K',
        'classe_libelle' => '5A',
        'etablissement_nom' => "CLG-VAL D'ARGENT",
        'matiere_enseignee_id' => '003700',
        'matiere_libelle' => 'AIDE ET ACCOMPAGNEMENT TRAVAIL PERSONNEL',
        'classe_id' => 5,
        'etablissement_id' => 1348,
        'prof_principal' => 'N'
      }
    ],
    'telephones' => [ ],
    'groupes_eleves' => [
      {
        'etablissement_code' => '0699990Z',
        'groupe_id' => 609,
        'groupe_libelle' => 'GROUPE 1 BACASABLE',
        'etablissement_nom' => 'ERASME',
        'etablissement_id' => 1
      },
      {
        'etablissement_code' => '0699990Z',
        'groupe_id' => 610,
        'groupe_libelle' => 'GROUPE 2 BACASABLE',
        'etablissement_nom' => 'ERASME',
        'etablissement_id' => 1
      }
    ],
    'groupes_libres' => [ ],
    'parents' => [ ],
    'enfants' => [ ],
    'relations_eleves' => [ ],
    'relations_adultes' => [ ]
  }
}

SAVE_BLOGS = [
  {
    id: nil,
    name: 'Nouveau Blog Etablissement',
    type: 'ETB',
    rgptId: '0699990Z',
    owner: 'VAA60000',
    url: 'erasme-new',
    flux: nil,
    add: false,
    action: 'add',
    active: true
  },
  {
    id: 0,
    name: 'Nouveau Blog Etablissement',
    type: 'ETB',
    rgptId: '0699990Z',
    owner: 'VAA60000',
    url: 'erasme-new',
    flux: nil,
    add: false,
    action: 'subcribe',
    active: true
  },
  {
    id: 0,
    name: 'Mon Blog Etablissement',
    type: 'ETB',
    rgptId: '0699990Z',
    owner: 'VAA60000',
    url: 'erasme-new',
    flux: nil,
    add: false,
    action: 'update',
    active: true
  },
  {
    id: 0,
    name: 'Mon Blog Etablissement',
    type: 'ETB',
    rgptId: '0699990Z',
    owner: 'VAA60000',
    url: 'erasme-new',
    flux: nil,
    add: false,
    action: 'unsubcribe',
    active: true
  },
  {
    id: 0,
    name: 'Mon Blog Etablissement',
    type: 'ETB',
    rgptId: '0699990Z',
    owner: 'VAA60000',
    url: 'erasme-new',
    flux: nil,
    add: false,
    action: 'delete',
    active: true
  },
  {
    id: nil,
    name: 'Erreur sur la creation',
    type: 'ETB',
    rgptId: '0699990Z',
    owner: 'VAA60000',
    url: nil,
    flux: nil,
    add: false,
    action: 'add',
    active: true
  },
  {
    id: nil,
    name: 'Blog qui n existe pas',
    type: 'ETB',
    rgptId: '0699990Z',
    owner: 'VAA60000',
    url: 'unknown',
    flux: nil,
    add: false,
    action: 'delete',
    active: true
  }
]
