class BlogPostsController < ApplicationController
  
  before_filter :admin_authorized?, :only => [:edit, :new, :update, :create]
  
  def index
    @blog_posts = BlogPost.find(:all, :order => 'created_at desc')
    
    respond_to do |format|
      format.html
      format.xml
    end
  end
  
  def show
    @blog_post = BlogPost.find(params[:id])
    fix_sloppy_urls(@blog_post)
  end
  
  def edit
    @blog_post = params[:id] ? BlogPost.find(params[:id]) : BlogPost.new
  end

  def new
    @blog_post = BlogPost.new
    render :action => 'edit'
  end
  
  def update
    @blog_post = BlogPost.find(params[:id])
    
    @blog_post.update_attributes params[:blog_post]
    @blog_post.save
    
    redirect_to @blog_post
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
