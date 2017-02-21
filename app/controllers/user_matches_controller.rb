class UserMatchesController < ApplicationController
  before_action :set_user_match, only: [:show, :update, :destroy]

  # GET /user_matches
  # GET /user_matches.json
  def index
    @user_matches = UserMatch.all
  end

  # GET /user_matches/1
  # GET /user_matches/1.json
  def show
  end

  # POST /user_matches
  # POST /user_matches.json
  def create
    @user_match = UserMatch.new(user_match_params)

    respond_to do |format|
      if @user_match.save
        format.html { redirect_to @user_match, notice: 'User match was successfully created.' }
        format.json { render :show, status: :created, location: @user_match }
      else
        format.html { render :new }
        format.json { render json: @user_match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_matches/1
  # PATCH/PUT /user_matches/1.json
  def update
    respond_to do |format|
      if @user_match.update(user_match_params)
        @user_match.match.validate_match()
        format.html { redirect_to back_or_default, notice: 'User match was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_match }
      else
        format.html { redirect_to back_or_default }
        format.json { render json: @user_match.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_matches/1
  # DELETE /user_matches/1.json
  def destroy
    @user_match.destroy
    respond_to do |format|
      format.html { redirect_to user_matches_url, notice: 'User match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_match
    @user_match = UserMatch.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_match_params
    params.require(:user_match).permit(:user_id, :match_id, :vp, :tournament_point, :victory_position, :validated)
  end
end
