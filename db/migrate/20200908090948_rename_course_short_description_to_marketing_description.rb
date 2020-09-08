class RenameCourseShortDescriptionToMarketingDescription < ActiveRecord::Migration[6.0]
  def change
    rename_column :courses, :marketing_description, :marketing_description
  end
end
