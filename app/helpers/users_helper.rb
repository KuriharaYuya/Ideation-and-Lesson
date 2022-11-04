module UsersHelper
  def reject_other_user_to_access_user_edit_page
    redirect_to request.fullpath.chomp('/edit') unless current_user == @user
  end

  def profile_initial_img
    'https://static.vecteezy.com/system/resources/thumbnails/006/017/592/small/ui-profile-icon-vector.jpg'
  end
end
