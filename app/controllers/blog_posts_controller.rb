class BlogPostsController < ApplicationController
  
  def index
    @blog_posts = BlogPost.find(:all, :order => 'created_at desc')
  end
  
  def show
    @blog_post = BlogPost.find(params[:id])
  end
  
  def edit
    @blog_post = params[:id] ? BlogPost.find(params[:id]) : BlogPost.new
  end

  def new
    @blog_post = BlogPost.new
    render :action => 'edit'
  end

  def create
    @blog_post = BlogPost.new(params[:blog_post])
    
    if @blog_post.save
      redirect_to @blog_post
    else 
      render :action => 'edit'
    end
  end

end