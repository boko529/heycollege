class BookmarksController < ApplicationController
    before_action :authenticate_user!

  def create
    @lecture = Lecture.find(params[:lecture_id])
    bookmark = @lecture.bookmarks.new(user_id: current_user.id)
    if bookmark.save
      redirect_to request.referer
      flash[:notice] = "ブックマークに追加しました"
    else
      redirect_to request.referer
    end
  end

  def destroy
    @lecture = Lecture.find(params[:lecture_id])
    bookmark = @lecture.bookmarks.find_by(user_id: current_user.id)
    if bookmark.present?
        bookmark.destroy
        flash[:notice] = "ブックマークを外しました"
        redirect_to request.referer
    else
        redirect_to request.referer
    end
  end

  def index
    @bookmarks = Bookmark.where(user_id: current_user.id)
  end
end
