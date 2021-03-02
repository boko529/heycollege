class BookmarksController < ApplicationController
    before_action :authenticate_user!

  def create
    @lecture = Lecture.find(params[:lecture_id])
    bookmark = @lecture.bookmarks.new(user_id: current_user.id)
    if bookmark.save
      redirect_to lecture_path(bookmark.lecture_id)
      flash[:notice] = "ブックマークに追加しました"
    else
      redirect_to lecture_path(bookmark.lecture_id)
    end
  end

  def destroy
    @lecture = Lecture.find(params[:lecture_id])
    bookmark = @lecture.bookmarks.find_by(user_id: current_user.id)
    if bookmark.present?
        bookmark.destroy
        flash[:notice] = "ブックマークを外しました"
        redirect_to lecture_path(bookmark.lecture_id)
    else
      redirect_to lecture_path(bookmark.lecture_id)
    end
  end

  def index
    @bookmarks = Bookmark.where(user_id: current_user.id)
  end
end
