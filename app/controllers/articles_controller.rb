class ArticlesController < ApplicationController
    def index
        @articles = Article.all
    end

    def show
        @article =  Article.find(params[:id])
    end

    def new
        @article = Article.new
    end

    def edit
        @article =  Article.find(params[:id])
    end

    def create
        @article = Article.new(article_params)

        if @article.save
            flash[:notice] = 'Published article'
            redirect_to articles_path
        else
            render action: :new, status: :unprocessable_entity
        end
    end

    def update
        @article =  Article.find(params[:id])
        if @article.update(article_params)
            redirect_to articles_path
        else
            render action: :edit
        end
    end
    
    def destroy
        @article =  Article.find(params[:id])

        if @article.destroy
            redirect_to articles_path
        else
            render action: :edit
        end
    end

    private

    def article_params
        params.require(:article).permit(:title, :content, :cover)
    end
end