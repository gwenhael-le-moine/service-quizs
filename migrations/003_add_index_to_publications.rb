Sequel.migration do
  change do
  	alter_table(:publications) do
  		add_column :index_publication, Integer
  	end
  end
end
