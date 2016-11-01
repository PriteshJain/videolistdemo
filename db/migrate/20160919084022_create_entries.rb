class CreateEntries < ActiveRecord::Migration[5.0]
  def change
  	enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :entries do |t|
    	t.string :title , length: 1000
      t.string :description , length: 1000
      t.attachment :video
      t.hstore :video_meta
      t.string :tags
      t.references :user
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
