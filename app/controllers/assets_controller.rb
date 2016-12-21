class AssetsController < ApplicationController
    load_and_authorize_resource class: 'Context::Asset'

    def index
        @assets = Context::Asset.paginate(page: params[:page], per_page: params[:per_page])
        @assets = @assets.search_by_uri(params[:uri]) if params[:name]
      end

    def create
        @asset = Context::Asset.new(asset_params)
        respond_to do |format|
            if @asset.save
                #   format.html { redirect_to @asset, notice: 'asset was successfully created.' }
                format.json { render :show, status: :created }
            else
                #   format.html { render :new }
                format.json { render json: @asset.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def update
        respond_to do |format|
            if @asset.update(asset_params)
                #   format.html { redirect_to @asset, notice: 'asset was successfully updated.' }
                format.json { render :show, status: :ok, location: @asset }
            else
                #   format.html { render :edit }
                format.json { render json: @asset.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @asset.destroy
        respond_to do |format|
            format.json { render :show }
        end
    end

    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
        params.require(:asset).permit(:uri)
  end
  end
