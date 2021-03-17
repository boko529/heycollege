class BookmarksController < ApplicationController
    before_action :authenticate_user!

  def create
    @lecture = Lecture.find(params[:lecture_id])
    bookmark = @lecture.bookmarks.new(user_id: current_user.id)
    bookmark.save
    # 非同期通信後でページ遷移(redirect_to)があるとうまくいかない(turbolinksをoffにしている場合)
    # flash[:notice] = "ブックマークに追加しました"
    # redirect_to lecture_path(@lecture)
  end
  
  def destroy
    @lecture = Lecture.find(params[:lecture_id])
    bookmark = @lecture.bookmarks.find_by(user_id: current_user.id)
    bookmark.destroy
    # 非同期通信後でページ遷移(redirect_to)があるとうまくいかない(turbolinksをoffにしている場合)
    # flash[:notice] = "ブックマークを外しました"
    # redirect_to lecture_path(@lecture)
  end

  def index
    @bookmarks = Bookmark.where(user_id: current_user.id)
  end
end
