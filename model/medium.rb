# coding: utf-8
#
# model for 'medium' table
# generated 2015-08-18 12:12:38 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# COLUMN_NAME                   | DATA_TYPE           | NULL?    | KEY      | DEFAULT           | EXTRA
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# id                            | int(11)             | false    | PRI      |                   |
# created_at                    | datetime            | true     |          |                   |
# content_type                  | varchar(100)        | false    |          |                   |
# uri                           | varchar(2000)       | false    |          |                   |
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
#
class Medium < Sequel::Model(:medium)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  one_to_many :question
  one_to_many :suggestion

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:content_type, :uri]
  end
end
