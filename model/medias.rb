# coding: utf-8
#
# model for 'medias' table
# generated 2016-02-05 10:36:07 +0100 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+------------+--------------------
# COLUMN_NAME                   | DATA_TYPE           | NULL? | KEY | DEFAULT | EXTRA
# ------------------------------+---------------------+----------+----------+------------+--------------------
# id                            | int(11)             | false    | PRI      |            | auto_increment
# created_at                    | datetime            | true     |          |            |
# name                          | varchar(250)        | true     |          |            |
# content_type                  | varchar(100)        | false    |          |            |
# uri                           | varchar(2000)       | false    |          |            |
# questions_id                  | int(11)             | true     | MUL      |            |
# suggestions_id                | int(11)             | true     | MUL      |            |
# ------------------------------+---------------------+----------+----------+------------+--------------------
#
class Medias < Sequel::Model(:medias)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :questions
  many_to_one :suggestions

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:content_type, :uri]
  end
end
