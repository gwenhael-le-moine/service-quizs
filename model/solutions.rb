# coding: utf-8
#
# model for 'solutions' table
# generated 2015-10-29 14:31:40 +0100 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+------------+--------------------
# COLUMN_NAME                   | DATA_TYPE           | NULL? | KEY | DEFAULT | EXTRA
# ------------------------------+---------------------+----------+----------+------------+--------------------
# id                            | int(11)             | false    | PRI      |            |
# left_suggestion_id            | int(11)             | false    | MUL      |            |
# right_suggestion_id           | int(11)             | true     | MUL      |            |
# ------------------------------+---------------------+----------+----------+------------+--------------------
#
class Solutions < Sequel::Model(:solutions)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :suggestions, key: :left_suggestion_id
  many_to_one :suggestions, key: :right_suggestion_id

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:left_suggestion_id]
  end
end
