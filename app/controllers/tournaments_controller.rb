class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :start]
  load_and_authorize_resource

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    a = (@tournament.inscriptions.find_by(:user_id => current_user.id).nil? and @tournament[:status]==0)
    @registrable = current_user.nil? ? false : a
    if @registrable
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
        :number_players => tournament_params[:number_players],
        :prize => tournament_params[:prize],
        :entrance_fee => tournament_params[:entrance_fee],
        :date => tournament_params[:date],
        :board_size => tournament_params[:board_size],
        :user_id => current_user.id
    )
    if tournament_params[:general_mode]=="0"
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
      format.html { redirect_to tournaments_url, notice: ([Tournament.model_name.human, (t "succesfully_destroyed")].join(" ")) }
      format.json { head :no_content }
    end
  end

  def start
    success = true
    errors = []
    if @tournament.mode ==0
      selector = RoundSelector.new(@tournament.rounds, @tournament.users.to_a, @tournament.board_size)
      round_matches = selector.select_all_rounds
      round_matches.zip (1..round_matches.count).each do |round, round_number|
        round.each do |match|
          user_attributes = {}
          match.each do |user|
            user_attributes[user[:id]] = {:user_id => user[:id]}
          end

          match_parameters = {
              :n_players => match.count,
              :round => round_number,
              :user_matches_attributes => user_attributes
          }
          new_match = Match.new_with_child(match_parameters, true)
          unless new_match[:success]
            errors.push(new_match[:errors])
          end
        end
      end
    end
    if success
      @tournament.status=1
      @tournament.save
    end
    respond_to do |format|
      if success
        format.html { redirect_to @tournament, notice: 'Tournament was successfully started.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        errors.each do |error|
          flash_message(:error, error)
        end
        format.html { redirect_to @tournament }
        format.json { render json: error, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :number_players, :prize, :entrance_fee, :user_id, :general_mode, :rounds, :date, :mode, :board_size)
    end
end
