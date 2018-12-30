class Department < ApplicationRecord
  require 'roo'

  has_many :children, class_name: 'Department', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Department', optional: true

  scope :main, -> { where(parent_id: nil) }

  def self.assign_hierarchy_by_file(file)
    xlsx = Roo::Spreadsheet.open(file.path)
    column_number = xlsx.sheet(0).last_column - 1
    xlsx.each_with_index do |row, index|
      next if index == 0
      find_or_create_hierarchy_branch(row)
    end
  end

  def self.find_or_create_hierarchy_branch hierarchy_branch
    parent = nil
    hierarchy_branch.map do |department_name|
      next if (!parent.nil? && department_name == parent.name)
      department = Department.find_or_create_by({
        name: department_name,
        parent_id: parent && parent.id
      })
      parent = department
    end
  end
end
