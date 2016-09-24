module TrainingLogHelper
  def checked?(params, data_type, option)
    params['training_log'] && params['training_log'][data_type] && params['training_log'][data_type]['option'] == option
  end

  def field_value(params, data_type, option)
    return "" unless params['training_log'] && params['training_log'][data_type]
    params['training_log'][data_type][option]
  end

  def accordion_handle(data_type)
    data_type.tr(' ', '_')
  end
end
