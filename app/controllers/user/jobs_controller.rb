class User::JobsController < ApplicationController

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:notice] = "#{@job.job_title} was created!"
      redirect_to jobs_path
    else
      flash[:error] = "#{@job.errors.full_messages.join(", ")}"
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    job = Job.find(params[:id])
    if job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    job = Job.find(params[:id])
    job.delete
    session[:most_recent_job_id] = Job.last.id
    redirect_to jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:name, :quantity, :price)
    #allows this info to come through with name, quantity, and price, only with job params. that's all we'll accept in our html.
  end
end
