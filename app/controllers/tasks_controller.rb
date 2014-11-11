class TasksController < ApplicationController

  # GET /tasks
  # GET /tasks.json
  def index
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def character_upload
  end

  def validate_heroclass
    uploaded_io = params[:csv]
    task = HeroclassTask.new(uploaded_io)
    @text = task.validate
    render "character_upload"
  end
end
