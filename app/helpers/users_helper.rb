module UsersHelper
  def reject_other_user_to_access_user_edit_page
    redirect_to request.fullpath.chomp('/edit') unless current_user == @userend
  end
end
