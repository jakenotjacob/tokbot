require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "sequel"
require 'colorize'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  task :create do
    if File.exists? 'data/vapebot.db'
      puts "Database already exists.".red
      abort
    end
    db = Sequel.sqlite('data/vapebot.db')
    puts "Vapebot database created.".green
    VapebotDB::create_facts_table(db)
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
end



