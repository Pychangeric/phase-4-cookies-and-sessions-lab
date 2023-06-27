class ArticlesController < ApplicationController
  before_action :set_page_views, only: [:show]

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    if @page_views < 3
      article = Article.find(params[:id])
      render json: article
    else
      render json: { error: 'Maximum page views reached. Please subscribe to continue.' }, status: :unauthorized
    end
  end

  private

  def set_page_views
    session[:page_views] ||= 0
    session[:page_views] += 1
    @page_views = session[:page_views]
  end
end
