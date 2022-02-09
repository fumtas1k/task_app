module Admin::LabelsHelper
  def choose_label_new_or_edit
    if %w[ new create ].include?(action_name)
      admin_labels_path
    elsif %w[ edit update ].include?(action_name)
      admin_label_path(@label)
    end
  end
end
