#coding: utf-8
#
# model for 'sessions' table
# generated 2015-10-22 14:35:10 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+------------+--------------------
# COLUMN_NAME                   | DATA_TYPE           | NULL? | KEY | DEFAULT | EXTRA
# ------------------------------+---------------------+----------+----------+------------+--------------------
# id                            | int(11)             | false    | PRI      |            | auto_increment
# quiz_id                       | int(11)             | false    | MUL      |            | 
# user_id                       | varchar(8)          | false    | UNI      |            | 
# user_type                     | varchar(45)         | false    |          |            | 
# created_at                    | datetime            | false    |          |            | 
# updated_at                    | datetime            | true     |          |            | 
# score                         | float               | false    |          |            | 
# ------------------------------+---------------------+----------+----------+------------+--------------------
#
class Sessions < Sequel::Model(:sessions)

  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :quizs
  one_to_many :answers

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:quiz_id, :user_id, :user_type, :created_at, :score]
  end
end
