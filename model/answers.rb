#coding: utf-8
#
# model for 'answers' table
# generated 2015-11-13 17:10:28 +0100 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+------------+--------------------
# COLUMN_NAME                   | DATA_TYPE           | NULL? | KEY | DEFAULT | EXTRA
# ------------------------------+---------------------+----------+----------+------------+--------------------
# id                            | int(11)             | false    | PRI      |            | 
# session_id                    | int(11)             | false    | MUL      |            | 
# left_suggestion_id            | int(11)             | false    | MUL      |            | 
# right_suggestion_id           | int(11)             | true     | MUL      |            | 
# created_at                    | datetime            | true     |          |            | 
# ------------------------------+---------------------+----------+----------+------------+--------------------
#
class Answers < Sequel::Model(:answers)

  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :suggestions, :key=>:left_suggestion_id
  many_to_one :sessions, :key=>:session_id
  many_to_one :suggestions, :key=>:right_suggestion_id

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:session_id, :left_suggestion_id]
  end
end
