module Rapidfire
  class SurveysController < Rapidfire::ApplicationController
    before_action :authenticate_administrator!, except: :index

    def index
      @surveys = if defined?(Kaminari)
        Survey.page(params[:page])
      else
        Survey.all
      end
    end

    def new
      @survey = Survey.new
    end

    def create
      @survey = Survey.new(survey_params)
      puts "I am saving survey"
      if @survey.save
        respond_to do |format|
          format.html { redirect_to surveys_path }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.js
        end
      end
    end

    def edit
      @survey = Survey.find_by_api_id(params[:api_id])
    end

    def update
      @survey = Survey.find_by_api_id(params[:api_id])
      if @survey.update(survey_params)
        respond_to do |format|
          format.html { redirect_to surveys_path }
          format.js
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.js
        end
      end
    end

    def destroy
      @survey = Survey.find_by_api_id(params[:api_id])
      @survey.destroy

      respond_to do |format|
        format.html { redirect_to surveys_path }
        format.js
      end
    end

    def results
      @survey = Survey.find_by_api_id(params[:api_id])
      @survey_results =
        SurveyResults.new(survey: @survey).extract

      respond_to do |format|
        format.json { render json: @survey_results, root: false }
        format.html
        format.js
      end
    end

    private

    def survey_params
      params.require(:survey).permit(:name, :introduction, :location_id, :api_id, :after_survey_content, :survey_api_id)
    end
  end
end
