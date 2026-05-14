class CreateAgentArchiveTables < ActiveRecord::Migration[8.1]
  def change
    create_table :agents do |t|
      t.string :codename, null: false
      t.integer :level, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :agents, :codename, unique: true
    add_check_constraint :agents, "level >= 1 AND level <= 10", name: "level_between_1_and_10"

    create_table :skills do |t|
      t.string :name, null: false
      t.string :category

      t.timestamps
    end

    add_index :skills, :name, unique: true

    create_table :missions do |t|
      t.string :title, null: false
      t.string :status, null: false
      t.references :agent, null: false, foreign_key: true

      t.timestamps
    end

    add_check_constraint :missions,
                         "status IN ('assigned', 'in_progress', 'completed')",
                         name: "status_is_known_mission_status"

    create_table :agent_skills do |t|
      t.references :agent, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end

    add_index :agent_skills, [ :agent_id, :skill_id ], unique: true
  end
end