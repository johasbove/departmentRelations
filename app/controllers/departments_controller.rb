class DepartmentsController < ApplicationController
  def index
  end

  def upload
    Department.assign_hierarchy_by_file(params[:file])

    redirect_to root_url, notice: 'Jerarquía guardada.'
  end

  def print
    @departments = Department.all
    respond_to do |format|
      format.xlsx {render xlsx: 'print', filename: 'departments_hierarchy.xlsx'}
    end
  end
end
