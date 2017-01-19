class AddPaperclipImageSupport < ActiveRecord::Migration[5.0]
    def up
        add_attachment :services, :logo
        add_attachment :screenshots, :image
        remove_column	:screenshots,	:data, :binary, null: false
        remove_column	:screenshots,	:mime_type, :string, null: false
    end

    def down
        remove_attachment :services, :logo
        remove_attachment :screenshots, :image
        add_column	:screenshots,	:data, :binary, null: false
        add_column	:screenshots,	:mime_type, :string, null: false
    end
end
