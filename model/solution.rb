# coding: utf-8
#
# model for 'solution' table
# generated 2015-08-18 12:12:38 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# COLUMN_NAME                   | DATA_TYPE           | NULL?    | KEY      | DEFAULT           | EXTRA
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# left_suggestion_id            | int(11)             | false    | MUL      |                   |
# right_suggestion_id           | int(11)             | true     | MUL      |                   |
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
#
class Solution < Sequel::Model(:solution)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :suggestion, key: :left_suggestion_id
  many_to_one :suggestion, key: :right_suggestion_id

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence :left_suggestion_id
  end
end
