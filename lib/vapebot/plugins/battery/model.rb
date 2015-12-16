DB = Sequel.connect("sqlite://data/vapebot.db")
class BatteryDB < Sequel::Model(:batteries)
  def basics
    [full_name, "Wrap color: #{wrap_color.capitalize}", capacity, voltages, max_discharge, spec_sheet].join(" ║ ")
  end

  def full_name
    [maker, name].join(" ")
  end

  def voltages
    [discharged_voltage, nominal_voltage, charged_voltage].join("/")
  end

  def self.list
    BatteryDB.all.collect{|b| b.abbr}
  end

end
