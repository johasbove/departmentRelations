class Department < ApplicationRecord
  require 'roo'

  has_many :children, class_name: 'Department', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Department', optional: true

  scope :main, -> { where(parent_id: nil) }

  def self.assign_hierarchy_by_file(file)
    xlsx = Roo::Spreadsheet.open(file.path)
    column_number = xlsx.sheet(0).last_column - 1
    beginning_time = Time.now

    xlsx.each_with_index do |row, index|
      next if index == 0
      find_or_create_hierarchy_branch(row)
    end

    end_time = Time.now
    seconds = end_time - beginning_time
    puts "TimeOriginal: #{seconds}"


  end

  def self.find_or_create_hierarchy_branch hierarchy_branch
    parent = nil
    # levels_for_cache = 3
    # node_cache = initialize_node_cache(levels_for_cache)

    hierarchy_branch.map.with_index do |department_name, index|
      next if (!parent.nil? && department_name == parent.name)
      # next if (index <= levels_for_cache - 1 && node_cache["level_#{index}"].include?(department_name))
      department = Department.find_or_create_by({
        name: department_name,
        parent_id: parent && parent.id
      })
      # node_cache["level_#{index}"] << department_name if index <= levels_for_cache - 1
      parent = department
    end
  end

  def self.initialize_node_cache levels
    node_cache = {}
    (0..levels-1).each { |level| node_cache["level_#{level}"] = [] }
    node_cache
  end
end
