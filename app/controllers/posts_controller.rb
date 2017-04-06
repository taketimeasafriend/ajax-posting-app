class PostsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]

    def index
        @posts = Post.order('id DESC').all # 新贴文放前面
    end

    def create
        @post = Post.new(post_params)
        @post.user = current_user
        @post.save

        #redirect_to posts_path
    end

    def destroy
        @post = current_user.posts.find(params[:id]) # 只能删除自己的贴文
        @post.destroy

        #render :js => "alert('ok');"
    end



    def like
      @post = Post.find(params[:id])
      unless @post.find_like(current_user)  # 如果已经按讚过了，就略过不再新增
        Like.create( :user => current_user, :post => @post)
      end
      #redirect_to posts_path
    end
    def unlike
      @post = Post.find(params[:id])
      like = @post.find_like(current_user)
      like.destroy
      #redirect_to posts_path
      render "like"
    end

    def favorite
      @post = Post.find(params[:id])
      unless @post.find_favorite(current_user)  # 如果已经收藏过了，就略过不再新增
        Favorite.create( :user => current_user, :post => @post)
      end
      #redirect_to posts_path
    end
    def unfavorite
      @post = Post.find(params[:id])
      favorite = @post.find_favorite(current_user)
      favorite.destroy
      #redirect_to posts_path
      render "favorite"
    end


  protected
    def post_params
        params.require(:post).permit(:content)
     end
end
