class AddAttachmentToCats < ActiveRecord::Migration
  def change
    add_attachment :cats, :profile
  end
end
