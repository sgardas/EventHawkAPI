class ReviewsController < ApplicationController
  before_action :authenticate_user
  before_action :set_review, only: [:show, :update]

  # GET /reviews/1
  def show
    render :json => @review.to_json(:except => :_id), status: :ok
  end

  # POST /reviews
  def create
    @review = Review.new(review_params)
    @review.review_id = generate_guid

    if @review.save
      render :json => @review.to_json(:except => :_id), status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      render :json => @review.to_json(:except => :_id), status: :accepted
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:review_id])
    end

    # Only allow a trusted parameter "white list" through.
    def review_params
      params.require(:review).permit(:host_prep, :matched_desc, :would_ret, :reviewer_id)
    end

    def generate_guid
      SecureRandom.hex(10)
    end
end
