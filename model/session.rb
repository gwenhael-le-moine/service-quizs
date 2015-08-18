# coding: utf-8
#
# model for 'session' table
# generated 2015-08-18 12:12:38 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# COLUMN_NAME                   | DATA_TYPE                      | NULL?    | KEY      | DEFAULT           | EXTRA
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# id                            | int(11)                        | false    | PRI      |                   |
# publication_id                | int(11)                        | false    | MUL      |                   |
# user_id                       | varchar(8)                     | false    |           |                   |
# create_at                     | datetime                       | false    |          |                   |
# update_at                     | datetime                       | true     |          |                   |
# score                         | float                          | false    |          |                   |
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
#
class Session < Sequel::Model(:session)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :publication
  one_to_many :answer

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:publication_id, :user_id, :create_at, :score]
    validates_unique :user_id
  end
end
