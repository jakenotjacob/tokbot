require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "sequel"
require 'colorize'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  Dir.mkdir "data" unless Dir.exists? "data"
  task :create, :table do |t, args|
    db = Sequel.sqlite('data/vapebot.db')
    if !File.exists? 'data/vapebot.db'
      puts "Vapebot database created.".green
    end
    if args.any?
      eval "VapebotDB::create_#{args[:table]}_table(db)"
      puts "Table #{args[:table]} created.".green
    else
      %i(facts users batteries).each do |n|
        unless db.table_exists? n
          eval "VapebotDB::create_#{n.to_s}_table db"
          puts "#{n.to_s} table created.".green
        end
      end
    end
  end
end

module VapebotDB
  def self.create_facts_table(db)
    db.create_table :facts do
      primary_key :id
      String :name, unique: true, null: false
      String :definition, unique: true, null: false
    end
    puts "Facts table created.".green
  end

  def self.create_users_table(db)
     db.create_table :users do
       primary_key :id
       String :name, unique: true, null: false
       String :pin
       TrueClass :admin, default: false
     end
  end

  def self.create_batteries_table(db)
    db.create_table :batteries do
      primary_key :id
      String :abbr,               null: false, unique: true
      String :maker,              null: false
      String :name,               unique: true, null: false
      String :capacity,           null: false
      String :max_discharge,      null: false
      String :nominal_voltage,    null: false
      String :charged_voltage,    null: false
      String :discharged_voltage, null: false
      String :spec_sheet
      String :wrap_color
    end
  end
end



