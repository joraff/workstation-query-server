#!/usr/bin/env ruby -wKU

require "rubygems"
require "active_record"

ActiveRecord::Base.establish_connection(
    :adapter => "mysql",
    :host => "server",
    :username => "username",
    :password => "password",
    :database => "equipment"
)

class Workstation < ActiveRecord::Base
  def building
    Building.find(self.building_id).name
  end
  
  def department
    Department.find(self.department_id).name
  end
  
  def to_hash
    h = { :name => self.macname,
          :macname => self.macname,
          :winname => self.winname,
          :asset_tag => self.asset_tag,
          :mac_address => self.mac_address,
          :ld_name => self.ld_name,
          :ld_category => self.ld_category,
          :department => Department.find(self.department_id).name,
          :building => Building.find(self.building_id).name,
          :room =>self.room,
          :workflow => self.workflow_id,  
          :torrent => self.torrent_name }
    h
  end
end

class Department < ActiveRecord::Base
end

class Building < ActiveRecord::Base
end