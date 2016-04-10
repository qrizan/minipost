class PostsController < ApplicationController
	before_action :find_post, only: [:show, :edit, :update, :destroy]

	def index
		if params[:category].blank?
			@posts = Post.all.order("created_at DESC")
		else
			@category_id = Category.find_by(name: params[:category]).id
			@posts = Post.where(:category_id => @category_id).order("created_at DESC")
		end
	end

	def new
		@post = current_user.posts.build
		@categories = Category.all.map{ |c| [c.name, c.id] }
	end

	def show
		
	end

	def create
		@post = @post = current_user.posts.build(post_params)
		@post.category_id = params[:category_id]

		if @post.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	def edit
		@categories = Category.all.map{ |c| [c.name, c.id] }
	end

	def update
		@post.category_id = params[:category_id]
		if @post.update(post_params)
			redirect_to post_path(@post)
		else
			render 'edit'
		end		
	end

	def destroy
		@post.destroy
		redirect_to root_path
	end

	private

		def post_params
			params.require(:post).permit(:title, :body, :category_id)
		end

		def find_post
			@post = Post.find(params[:id])
		end
end
