module HomeHelper
  
  def display_department_message
    d = Department.find(current_user_department_id) rescue nil
    d ? d.message : ""
  end
  
end
