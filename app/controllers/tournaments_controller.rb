class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @registered = (!@tournament.inscriptions.find_by(:user_id => current_user.id).nil?)
    if not @registered
      @inscription = Inscription.new(:tournament_id=> @tournament.id)
    else
      @inscription = @tournament.inscriptions.find_by(:user_id => current_user.id)
    end
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(
        :name => tournament_params[:name],
        :user_id => current_user.id,
        :number_players => tournament_params[:number_players],
        :prize => tournament_params[:prize],
        :entrance_fee => tournament_params[:entrance_fee],
        :date => tournament_params[:date]
    )
    if(tournament_params[:general_mode]=="0")
      @tournament.rounds = tournament_params[:rounds]
      @tournament.mode = 0
    else
      @tournament.rounds = 0
      @tournament.mode = tournament_params[:mode]
    end

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: ([Tournament.model_name.human, (t "succesfully_created") ].join(" "))}
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :number_players, :prize, :entrance_fee, :user_id, :general_mode, :rounds, :date, :mode)
    end
end
