require 'uri'
require 'net/http'

class API::ExternalReader
  DEFAULT_SENDER = ''.freeze
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment
  attr_accessor :url, :password, :sender, :cli, :serial_connection

  def self.start_with_check(options)
    instance = new(options)
    if instance.check
      instance.cli.say('System-Check erfolgreich')
      instance.perform
    else
      instance.cli.say('System-Check fehlgeschlagen')
    end
  end

  def perform
    loop do
      begin
        evaluate_output(serial_adapter.read(10))
        sleep 0.3
      rescue RubySerial::Error => e
        return log_send_error("Schnittstelle: #{e.message}")
      end
    end
  end

  def check
    send_data(0, 'System-Check')
  end

  protected

  def log_raw(line)
    Rails.logger.info(line)
    cli.say(line.inspect)
  end

  def send_data(time, hint)
    params = { api_time_entry: { time: time, hint: hint, password: password, sender: sender } }
    begin
      http = Net::HTTP.new(http_url.host, http_url.port)
      http.use_ssl = (http_url.scheme == 'https')
      response = http.post(http_url.path, params.to_query)
      response = JSON.parse(response.body)

      return true if response['success']

      log_send_error(response['error'])
    rescue JSON::ParserError => e
      log_send_error(e.message)
      Rails.logger.error(e.inspect)
    rescue Errno::ECONNREFUSED => e
      log_send_error(e.message)
      Rails.logger.error(e.inspect)
    rescue Net::ReadTimeout => e
      log_send_error(e.message)
      Rails.logger.error(e.inspect)
    end
    false
  end

  def log_send_error(message)
    cli.say("Fehler: #{message}")
  end

  def http_url
    @http_url ||= URI.parse("#{url}/api/time_entries")
  end

  def evaluate_with_log_line(line)
    log_start = evaluate_line(line) ? 'valid:  ' : 'invalid:'
    log_raw(log_start + ' ' + line)
  end

  def serial_adapter
    @serial_adapter ||= Serial.new(serial_connection)
  end

  def evaluate_output(string)
    @current_line ||= ''
    @current_line += string
    while (result = @current_line.match(line_regexp))
      evaluate_with_log_line(result[1])
      @current_line = result[2]
    end
  end
end
