#coding: utf-8
#
# model for 'suggestions' table
# generated 2015-10-22 14:35:10 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+------------+--------------------
# COLUMN_NAME                   | DATA_TYPE           | NULL? | KEY | DEFAULT | EXTRA
# ------------------------------+---------------------+----------+----------+------------+--------------------
# id                            | int(11)             | false    | PRI      |            | auto_increment
# question_id                   | int(11)             | false    | MUL      |            | 
# text                          | varchar(2000)       | false    |          |            | 
# order                         | int(11)             | true     |          |            | 
# medium_id                     | int(11)             | true     | MUL      |            | 
# position                      | enum('L','R')       | true     |          |            | 
# ------------------------------+---------------------+----------+----------+------------+--------------------
#
class Suggestions < Sequel::Model(:suggestions)

  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :medias
  many_to_one :questions
  one_to_many :answers, :key=>:left_suggestion_id
  one_to_many :answers, :key=>:right_suggestion_id
  one_to_many :solutions, :key=>:left_suggestion_id
  one_to_many :solutions, :key=>:right_suggestion_id

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:question_id, :text]
  end
end
