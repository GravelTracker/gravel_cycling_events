# frozen_string_literal: true

module ApplicationHelper
  BOT_STATUS_COLOR_CLASSES = {
    'offline': 'secondary',
    'error': 'danger',
    'success': 'success'
  }.with_indifferent_access.freeze

  def bot_status_color
    BOT_STATUS_COLOR_CLASSES.fetch(@bot_status) { BOT_STATUS_COLOR_CLASSES['offline'] }
  end
end
