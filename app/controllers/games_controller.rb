require 'benchmark/ips'
require 'benchmark/ipsa'

class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @games = Game.all
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def pdfkit
    @game = Game.first

    respond_to do |format|
      format.pdf do
        report = PdfReport.new(@game)
        
        send_data report.to_pdf, filename: "nalaz", disposition: 'inline',
          type: 'application/pdf'
      end
    end
  end

  def weasyprint
    @game = Game.first
    
    # respond_to do |format|
    #   format.pdf do
    #     report = OrderPrinter.report(@game)
        
    #     send_data report.pdf.read, filename: "report", disposition: 'inline',
    #       type: 'application/pdf'
    #   end
    # end

    Benchmark.ipsa do |x| 
      x.report("weasyprint") do 
        weasyprint = OrderPrinter.report(@game)
        weasyprint.pdf.read
      end
      x.report("pdfkit") do 
        pdfkit = PdfReport.new(@game)
        pdfkit.to_pdf
      end
      x.report("rails_pdf") do 
        rails_pdf = RailsPDF.template("index/index.pug.erb").locals(game: @game)
        rails_pdf.render { |data| data }
      end

      # x.compare!
    end

  end

  def rails_pdf
    RailsPDF.template("index/index.pug.erb").locals(game: Game.first).render do |data|
      send_data(data, type: 'application/pdf', disposition: 'inline', filename: 'report.pdf')
    end
  end

  def download_project
    RailsPDF.template("report3/invoice.pug.erb").locals(project: Project.first).render do |data|
      send_data(data, type: 'application/pdf', disposition: 'inline', filename: 'report.pdf')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:title, :genre, :platform)
    end
end
