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
      VapebotDB::create_facts_table(db)
      puts "Facts table created.".green
      VapebotDB::create_users_table(db)
      puts "Users table created.".green
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
end



